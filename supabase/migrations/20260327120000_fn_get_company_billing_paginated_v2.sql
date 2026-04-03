-- ========================================
-- Function: fn_get_company_billing_paginated_v2
-- ========================================
-- Billing / NFS-e autorizadas paginadas (tela Minhas NFS-e).
-- Opcional: p_company_user_id valida acesso via company_user_companies.
-- ========================================

CREATE OR REPLACE FUNCTION public.fn_get_company_billing_paginated_v2(
  p_company_id uuid,
  p_page integer DEFAULT 1,
  p_page_size integer DEFAULT 10,
  p_customer_id uuid DEFAULT NULL,
  p_fiscal_document_type text DEFAULT NULL,
  p_status text DEFAULT NULL,
  p_start_date text DEFAULT NULL,
  p_end_date text DEFAULT NULL,
  p_company_user_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = company, public
AS $$
DECLARE
  v_offset integer;
  v_total_count integer;
  v_total_pages integer;
  v_has_next boolean;
  v_has_previous boolean;
  v_data jsonb;
  v_has_access boolean := true;
BEGIN
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
        'data', '[]'::jsonb,
        'pagination', jsonb_build_object(
          'total_items', 0,
          'page', p_page,
          'page_size', p_page_size,
          'total_pages', 0,
          'has_next', false,
          'has_previous', false
        )
      );
    END IF;
  END IF;

  v_offset := (GREATEST(p_page, 1) - 1) * GREATEST(p_page_size, 1);

  SELECT COUNT(*)::integer INTO v_total_count
  FROM company.companies_nfse cn
  WHERE cn.company_id = p_company_id
    AND cn.status = 'AUTHORIZED'
    AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id)
    AND (p_fiscal_document_type IS NULL OR cn.type::text = p_fiscal_document_type)
    AND (p_status IS NULL OR cn.status = p_status)
    AND (p_start_date IS NULL OR cn.emission_date::text >= p_start_date)
    AND (p_end_date IS NULL OR cn.emission_date::text <= p_end_date);

  IF p_page_size <= 0 THEN
    v_total_pages := 0;
  ELSE
    v_total_pages := CEIL(v_total_count::numeric / p_page_size::numeric)::integer;
  END IF;

  v_has_next := v_total_pages > 0 AND p_page < v_total_pages;
  v_has_previous := p_page > 1;

  SELECT jsonb_agg(row_data)
  INTO v_data
  FROM (
    SELECT jsonb_build_object(
      'id', cn.id,
      'created_at', cn.created_at,
      'company_id', cn.company_id,
      'customer_id', cn.customer_id,
      'cnpj', cn.cnpj,
      'nfse_number', cn.nfse_number,
      'verified_code', cn.verified_code,
      'emission_date', cn.emission_date,
      'status', cn.status,
      'type', cn.type,
      'origin', cn.origin,
      'ref_number', cn.ref_number,
      'rps_number', cn.rps_number,
      'rps_serie', cn.rps_serie,
      'rps_type', cn.rps_type,
      'nfse_value', cn.nfse_value::numeric,
      'billing_value', cn.nfse_value::numeric,
      'nfse_url', cn.nfse_url,
      'nfse_focus_url', cn.nfse_focus_url,
      'xml_url', cn.xml_url,
      'xml_focus_url', cn.xml_focus_url,
      'danfse_url', cn.danfse_url,
      'danfse_focus_url', cn.danfse_focus_url,
      'xml_cancel_url', cn.xml_cancel_url,
      'xml_cancel_focus_url', cn.xml_cancel_focus_url,
      'has_nfse_available', (cn.nfse_url IS NOT NULL OR cn.nfse_focus_url IS NOT NULL),
      'has_xml_available', (cn.xml_url IS NOT NULL OR cn.xml_focus_url IS NOT NULL),
      'has_danfse_available', (cn.danfse_url IS NOT NULL OR cn.danfse_focus_url IS NOT NULL),
      'customer', CASE
        WHEN cc.id IS NOT NULL THEN jsonb_build_object(
          'id', cc.id,
          'cnpj', cc.cnpj,
          'cpf', cc.cpf,
          'legal_name', cc.legal_name,
          'business_name', cc.business_name,
          'business_email', cc.business_email,
          'business_phone_number', cc.business_phone_number
        )
        ELSE NULL
      END,
      'customer_business_name', COALESCE(cc.business_name, cc.legal_name, '---'),
      'parameters', CASE
        WHEN cnp.id IS NOT NULL THEN jsonb_build_object(
          'id', cnp.id,
          'service_description', cnp.service_description,
          'service_value', cnp.service_value,
          'gross_value', cnp.gross_value,
          'deductions_value', cnp.deductions_value,
          'net_value', cnp.net_value,
          'value_iss', COALESCE(cnp.value_iss, 0),
          'value_inss', COALESCE(cnp.value_inss, 0),
          'value_irrf', COALESCE(cnp.value_irrf, 0),
          'value_csll', COALESCE(cnp.value_csll, 0),
          'value_cofins', COALESCE(cnp.value_cofins, 0),
          'value_pis', COALESCE(cnp.value_pis, 0),
          'aliquot_iss', cnp.aliquot_iss,
          'aliquot_inss', cnp.aliquot_inss,
          'aliquot_irrf', cnp.aliquot_irrf,
          'aliquot_csll', cnp.aliquot_csll,
          'aliquot_cofins', cnp.aliquot_cofins,
          'aliquot_pis', cnp.aliquot_pis,
          'iss_retention', cnp.iss_retention,
          'inss_retention', cnp.inss_retention,
          'irrf_retention', cnp.irrf_retention,
          'csll_retention', cnp.csll_retention,
          'cofins_retention', cnp.cofins_retention,
          'pis_retention', cnp.pis_retention,
          'dynamic_fields', COALESCE(cnp.dynamic_fields, '[]'::jsonb),
          'observation', cnp.observation
        )
        ELSE jsonb_build_object(
          'value_iss', 0,
          'value_inss', 0,
          'value_irrf', 0,
          'value_csll', 0,
          'value_cofins', 0,
          'value_pis', 0,
          'dynamic_fields', '[]'::jsonb
        )
      END,
      'total_tax_value', COALESCE(cnp.deductions_value, 0),
      'net_value', COALESCE(cnp.net_value, cn.nfse_value::numeric),
      'created_by', cn.created_by,
      'updated_at', cn.updated_at,
      'updated_by', cn.updated_by
    ) AS row_data
    FROM company.companies_nfse cn
    LEFT JOIN company.company_customers cc ON cc.id = cn.customer_id
    LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
    WHERE cn.company_id = p_company_id
      AND cn.status = 'AUTHORIZED'
      AND (p_customer_id IS NULL OR cn.customer_id = p_customer_id)
      AND (p_fiscal_document_type IS NULL OR cn.type::text = p_fiscal_document_type)
      AND (p_status IS NULL OR cn.status = p_status)
      AND (p_start_date IS NULL OR cn.emission_date::text >= p_start_date)
      AND (p_end_date IS NULL OR cn.emission_date::text <= p_end_date)
    ORDER BY cn.emission_date DESC
    LIMIT GREATEST(p_page_size, 1)
    OFFSET v_offset
  ) sub;

  RETURN jsonb_build_object(
    'data', COALESCE(v_data, '[]'::jsonb),
    'pagination', jsonb_build_object(
      'total_items', v_total_count,
      'page', p_page,
      'page_size', p_page_size,
      'total_pages', v_total_pages,
      'has_next', v_has_next,
      'has_previous', v_has_previous
    )
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.fn_get_company_billing_paginated_v2(
  uuid, integer, integer, uuid, text, text, text, text, uuid
) TO authenticated;

GRANT EXECUTE ON FUNCTION public.fn_get_company_billing_paginated_v2(
  uuid, integer, integer, uuid, text, text, text, text, uuid
) TO service_role;

COMMENT ON FUNCTION public.fn_get_company_billing_paginated_v2(
  uuid, integer, integer, uuid, text, text, text, text, uuid
) IS
'App carteira: NFS-e autorizadas paginadas; p_company_user_id opcional. Não altera fn_get_company_billing_paginated.';
