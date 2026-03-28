-- ========================================
-- Lista TODAS as empresas do usuário para troca de empresa no app.
-- Mesmos critérios do validate_login, mas sem LIMIT: uma linha por empresa (DISTINCT).
-- Retorna company_id, company_user_id e business_name para cada vínculo ativo.
-- ========================================

CREATE OR REPLACE FUNCTION public.get_user_companies(p_auth_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = company, public
AS $$
DECLARE
  v_app_role_ids uuid[] := ARRAY[
    'f49828e1-7748-4a92-8b7e-ef26560e469f',
    '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'
  ];
  v_result jsonb;
BEGIN
  -- Uma linha por empresa (DISTINCT ON c.id) para não duplicar se o usuário tiver mais de um role
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'company_id', sub.company_id,
        'company_user_id', sub.company_user_id,
        'business_name', sub.business_name
      )
      ORDER BY sub.business_name
    ),
    '[]'::jsonb
  ) INTO v_result
  FROM (
    SELECT DISTINCT ON (c.id)
      c.id AS company_id,
      cu.id AS company_user_id,
      c.business_name
    FROM company.company_users cu
    INNER JOIN company.company_user_roles cur ON cur.user_id = cu.id
    INNER JOIN company.company_user_companies cuc ON cuc.user_id = cu.id
    INNER JOIN company.companies c ON c.id = cuc.company_id
    WHERE cu.auth_user_id = p_auth_user_id
      AND LOWER(cu.status) = 'active'
      AND cur.role_id = ANY(v_app_role_ids)
      AND LOWER(cuc.status) = 'active'
      AND LOWER(c.status::text) = 'active'
    ORDER BY c.id, c.business_name
  ) sub;

  RETURN v_result;
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_user_companies(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_user_companies(uuid) TO service_role;

COMMENT ON FUNCTION public.get_user_companies(uuid) IS 'Lista empresas que o usuário pode acessar no app (para troca de empresa).';
