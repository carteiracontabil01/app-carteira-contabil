-- ========================================
-- Function: fn_get_company_billing_dashboard_v2
-- ========================================
-- Versão que suporta a estrutura com company_user_companies.
-- Mantém a mesma assinatura e retorno da v1; opcionalmente valida acesso
-- via company_user_companies quando p_company_user_id é informado.
--
-- Parâmetros:
-- - p_company_id: UUID da empresa
-- - p_start_date: Data de início ('YYYY-MM-DD')
-- - p_end_date: Data de fim ('YYYY-MM-DD')
-- - p_customer_id: UUID do cliente/tomador (opcional)
-- - p_company_user_id: UUID do company_user (opcional). Se informado, exige
--   vínculo ativo em company_user_companies para p_company_id.
-- ========================================

CREATE OR REPLACE FUNCTION public.fn_get_company_billing_dashboard_v2(
  p_company_id uuid,
  p_start_date text,
  p_end_date text,
  p_customer_id uuid DEFAULT NULL,
  p_company_user_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = company, public
AS $$
DECLARE
  v_result jsonb;
  v_total_documents integer;
  v_total_billing numeric;
  v_total_taxes numeric;
  v_total_net_value numeric;
  v_average_ticket numeric;
  v_top_customers jsonb;
  v_tax_breakdown jsonb;
  v_has_access boolean;
  v_previous_billing numeric := 0;
  v_prev_start date;
  v_prev_end date;
  v_period_days integer;
  v_chart_data jsonb;
BEGIN
  -- ========================================
  -- 0. (Opcional) Validar acesso via company_user_companies
  -- ========================================
  IF p_company_user_id IS NOT NULL THEN
    SELECT EXISTS (
      SELECT 1
      FROM company.company_user_companies cuc
      WHERE cuc.user_id = p_company_user_id
        AND cuc.company_id = p_company_id
        AND LOWER(cuc.status) = 'active'
    ) INTO v_has_access;

    IF NOT v_has_access THEN
      RETURN jsonb_build_object(
        'totalBilling', 0,
        'previousBilling', 0,
        'totalTaxes', 0,
        'totalNetValue', 0,
        'totalDocuments', 0,
        'averageTicket', 0,
        'topCustomers', '[]'::jsonb,
        'taxBreakdown', jsonb_build_object(
          'iss', 0, 'inss', 0, 'irrf', 0, 'csll', 0, 'cofins', 0, 'pis', 0, 'outras_retencoes', 0
        ),
        'chart_data', '[]'::jsonb
      );
    END IF;
  END IF;

  -- ========================================
  -- 1. Calcular totais gerais
  -- ========================================
  SELECT
    COUNT(*)::integer,
    COALESCE(SUM(cnp.service_value), 0),
    COALESCE(SUM(cnp.deductions_value), 0),
    COALESCE(SUM(cnp.net_value), 0)
  INTO
    v_total_documents,
    v_total_billing,
    v_total_taxes,
    v_total_net_value
  FROM company.companies_nfse cn
  LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
  WHERE cn.company_id = p_company_id
    AND cn.status = 'AUTHORIZED'
    AND cn.emission_date::date >= p_start_date::date
    AND cn.emission_date::date <= p_end_date::date
    AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id);

  IF v_total_documents > 0 THEN
    v_average_ticket := v_total_billing / v_total_documents;
  ELSE
    v_average_ticket := 0;
  END IF;

  -- ========================================
  -- 1b. Período anterior (mesma duração, para cálculo de crescimento)
  -- ========================================
  v_prev_end := p_start_date::date - 1;
  v_period_days := p_end_date::date - p_start_date::date + 1;
  v_prev_start := v_prev_end - v_period_days + 1;

  SELECT COALESCE(SUM(cnp.service_value), 0)
  INTO v_previous_billing
  FROM company.companies_nfse cn
  LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
  WHERE cn.company_id = p_company_id
    AND cn.status = 'AUTHORIZED'
    AND cn.emission_date::date >= v_prev_start
    AND cn.emission_date::date <= v_prev_end
    AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id);

  -- ========================================
  -- 2. Top 5 clientes por quantidade de documentos
  -- ========================================
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'customer_name', customer_business_name,
        'document_count', doc_count,
        'total_value', total_value
      )
      ORDER BY doc_count DESC
    ),
    '[]'::jsonb
  )
  INTO v_top_customers
  FROM (
    SELECT
      COALESCE(cc.business_name, cc.legal_name, 'Sem nome') AS customer_business_name,
      COUNT(*) AS doc_count,
      COALESCE(SUM(cnp.service_value), 0) AS total_value
    FROM company.companies_nfse cn
    LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
    LEFT JOIN company.company_customers cc ON cc.id = cn.customer_id
    WHERE cn.company_id = p_company_id
      AND cn.status = 'AUTHORIZED'
      AND cn.emission_date::date >= p_start_date::date
      AND cn.emission_date::date <= p_end_date::date
      AND cn.customer_id IS NOT NULL
      AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id)
    GROUP BY cc.business_name, cc.legal_name
    ORDER BY doc_count DESC
    LIMIT 5
  ) sub;

  -- ========================================
  -- 3. Breakdown de impostos
  -- ========================================
  SELECT jsonb_build_object(
    'iss', COALESCE(SUM(cnp.value_iss), 0),
    'inss', COALESCE(SUM(cnp.value_inss), 0),
    'irrf', COALESCE(SUM(cnp.value_irrf), 0),
    'csll', COALESCE(SUM(cnp.value_csll), 0),
    'cofins', COALESCE(SUM(cnp.value_cofins), 0),
    'pis', COALESCE(SUM(cnp.value_pis), 0),
    'outras_retencoes',
      COALESCE(SUM(
        CASE
          WHEN cnp.dynamic_fields IS NULL OR jsonb_typeof(cnp.dynamic_fields) <> 'array' THEN 0
          ELSE (
            SELECT
              CASE
                WHEN COALESCE(
                  (
                    SELECT (f->>'value')::boolean
                    FROM jsonb_array_elements(cnp.dynamic_fields) f
                    WHERE f->>'field' = 'outras_retencoes_retention'
                    LIMIT 1
                  ),
                  false
                ) THEN COALESCE(
                  (
                    SELECT (v->>'value')::numeric
                    FROM jsonb_array_elements(cnp.dynamic_fields) v
                    WHERE v->>'field' = 'outras_retencoes'
                    LIMIT 1
                  ),
                  0
                )
                ELSE 0
              END
          )
        END
      ), 0)
  )
  INTO v_tax_breakdown
  FROM company.companies_nfse cn
  LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
  WHERE cn.company_id = p_company_id
    AND cn.status = 'AUTHORIZED'
    AND cn.emission_date::date >= p_start_date::date
    AND cn.emission_date::date <= p_end_date::date
    AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id);

  -- ========================================
  -- 3b. Últimos 6 meses para gráfico (chart_data)
  -- ========================================
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'month', abbr,
        'value', COALESCE(billing, 0)
      )
      ORDER BY month_start
    ),
    '[]'::jsonb
  ) INTO v_chart_data
  FROM (
    SELECT
      (date_trunc('month', p_end_date::date) - (n || ' months')::interval)::date AS month_start,
      CASE (EXTRACT(MONTH FROM (date_trunc('month', p_end_date::date) - (n || ' months')::interval)))::integer
        WHEN 1 THEN 'Jan' WHEN 2 THEN 'Fev' WHEN 3 THEN 'Mar' WHEN 4 THEN 'Abr'
        WHEN 5 THEN 'Mai' WHEN 6 THEN 'Jun' WHEN 7 THEN 'Jul' WHEN 8 THEN 'Ago'
        WHEN 9 THEN 'Set' WHEN 10 THEN 'Out' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Dez'
      END AS abbr,
      (
        SELECT COALESCE(SUM(cnp.service_value), 0)
        FROM company.companies_nfse cn
        LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
        WHERE cn.company_id = p_company_id
          AND cn.status = 'AUTHORIZED'
          AND cn.emission_date::date >= (date_trunc('month', p_end_date::date) - (n || ' months')::interval)::date
          AND cn.emission_date::date < (date_trunc('month', p_end_date::date) - (n || ' months')::interval)::date + interval '1 month'
          AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id)
      ) AS billing
    FROM generate_series(5, 0, -1) AS n
  ) sub;

  -- ========================================
  -- 4. Montar resultado (inclui previousBilling e chart_data)
  -- ========================================
  v_result := jsonb_build_object(
    'totalBilling', v_total_billing,
    'previousBilling', v_previous_billing,
    'totalTaxes', v_total_taxes,
    'totalNetValue', v_total_net_value,
    'totalDocuments', v_total_documents,
    'averageTicket', v_average_ticket,
    'topCustomers', v_top_customers,
    'taxBreakdown', v_tax_breakdown,
    'chart_data', v_chart_data
  );

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fn_get_company_billing_dashboard_v2(uuid, text, text, uuid, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_get_company_billing_dashboard_v2(uuid, text, text, uuid, uuid) TO service_role;

COMMENT ON FUNCTION public.fn_get_company_billing_dashboard_v2(uuid, text, text, uuid, uuid) IS
'Dashboard de faturamento por empresa. Suporta estrutura com company_user_companies. Opcional: p_company_user_id para validar acesso via company_user_companies. Retorno igual à v1.';
