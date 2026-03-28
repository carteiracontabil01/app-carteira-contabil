-- ========================================
-- Atualiza validate_login para o novo modelo de tabelas.
-- company_users não tem mais company_id; a relação é via company_user_companies.
-- ========================================

CREATE OR REPLACE FUNCTION public.validate_login(p_auth_user_id uuid)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = company, public
AS $$
DECLARE
  v_company_user_id uuid;
  v_company_id uuid;
  v_company_name text;
  v_app_role_ids uuid[] := ARRAY[
    'f49828e1-7748-4a92-8b7e-ef26560e469f',  -- APP_ONLY (Usuário Aplicativo)
    '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'   -- WEB_APP (Usuario Web e Aplicativo)
  ];
BEGIN
  -- Busca company_user com role APP_ONLY ou WEB_APP, status active em user, company_user_companies e company
  SELECT cu.id, cuc.company_id, c.business_name
  INTO v_company_user_id, v_company_id, v_company_name
  FROM company.company_users cu
  INNER JOIN company.company_user_roles cur ON cur.user_id = cu.id
  INNER JOIN company.company_user_companies cuc ON cuc.user_id = cu.id
  INNER JOIN company.companies c ON c.id = cuc.company_id
  WHERE cu.auth_user_id = p_auth_user_id
    AND LOWER(cu.status) = 'active'
    AND cur.role_id = ANY(v_app_role_ids)
    AND LOWER(cuc.status) = 'active'
    AND LOWER(c.status::text) = 'active'
  LIMIT 1;

  -- Se não encontrou, retorna erro
  IF v_company_user_id IS NULL THEN
    RETURN jsonb_build_object(
      'success', false,
      'error', 'Usuário sem permissão para acessar o aplicativo. Verifique se possui perfil de acesso ao app e se sua conta e empresa estão ativas.'
    );
  END IF;

  -- Sucesso: retorna os IDs e o nome da empresa
  RETURN jsonb_build_object(
    'success', true,
    'company_user_id', v_company_user_id,
    'company_id', v_company_id,
    'company_name', COALESCE(v_company_name, '')
  );
END;
$$;

-- Garantir que a função seja executável pelos roles
GRANT EXECUTE ON FUNCTION public.validate_login(uuid) TO anon;
GRANT EXECUTE ON FUNCTION public.validate_login(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.validate_login(uuid) TO service_role;

COMMENT ON FUNCTION public.validate_login(uuid) IS 'Valida se o usuário autenticado tem permissão para acessar o app. Retorna company_user_id, company_id e company_name (business_name) para uso na home.';
