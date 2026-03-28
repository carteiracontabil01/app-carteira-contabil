-- ========================================
-- Function: fn_get_company_nfse_list
-- ========================================
-- Retorna a lista de NFS-e da empresa no período (para tela Minhas NFS-e).
-- Respeita company_user_companies se p_company_user_id for informado.
-- ========================================

CREATE OR REPLACE FUNCTION public.fn_get_company_nfse_list(
  p_company_id uuid,
  p_start_date text,
  p_end_date text,
  p_company_user_id uuid DEFAULT NULL
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = company, public
AS $$
DECLARE
  v_has_access boolean := true;
  v_result jsonb;
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
      RETURN '[]'::jsonb;
    END IF;
  END IF;

  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'id', cn.id,
        'numero', 'NFS-e ' || SUBSTRING(cn.id::text, 1, 8),
        'cliente', COALESCE(cc.business_name, cc.legal_name, 'Cliente'),
        'servico', 'NFS-e',
        'valor', COALESCE(cnp.service_value, 0),
        'data', cn.emission_date::date,
        'status', cn.status
      )
      ORDER BY cn.emission_date DESC
    ),
    '[]'::jsonb
  ) INTO v_result
  FROM company.companies_nfse cn
  LEFT JOIN company.companies_nfse_parameters cnp ON cnp.nfse_id = cn.id
  LEFT JOIN company.company_customers cc ON cc.id = cn.customer_id
  WHERE cn.company_id = p_company_id
    AND cn.status = 'AUTHORIZED'
    AND cn.emission_date::date >= p_start_date::date
    AND cn.emission_date::date <= p_end_date::date;

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.fn_get_company_nfse_list(uuid, text, text, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_get_company_nfse_list(uuid, text, text, uuid) TO service_role;

COMMENT ON FUNCTION public.fn_get_company_nfse_list(uuid, text, text, uuid) IS
'Lista NFS-e da empresa no período para a tela Minhas NFS-e. Opcional: p_company_user_id para validar acesso via company_user_companies.';
