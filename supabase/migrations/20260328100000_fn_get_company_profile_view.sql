-- Retorna uma linha de api.vw_company_by_id como JSONB, com checagem de acesso via company_user_companies.
-- Remove segredos (ex.: token Focus) antes de enviar ao app — ver bloco "sanitized" abaixo.

CREATE OR REPLACE FUNCTION public.fn_get_company_profile_view(
  p_company_id uuid,
  p_company_user_id uuid
)
RETURNS jsonb
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = api, company, public
AS $$
  WITH base AS (
    SELECT row_to_json(t)::jsonb AS j
    FROM api.vw_company_by_id t
    WHERE t.id = p_company_id
      AND EXISTS (
        SELECT 1
        FROM company.company_user_companies cuc
        WHERE cuc.user_id = p_company_user_id
          AND cuc.company_id = p_company_id
          AND LOWER(cuc.status) = 'active'
      )
    LIMIT 1
  )
  SELECT CASE
    WHEN base.j IS NULL THEN NULL::jsonb
    WHEN jsonb_typeof(base.j -> 'focus_integration') = 'object' THEN
      jsonb_set(
        base.j,
        '{focus_integration}'::text[],
        (base.j -> 'focus_integration') - 'token_focus_company'::text
      )
    ELSE base.j
  END
  FROM base;
$$;

GRANT EXECUTE ON FUNCTION public.fn_get_company_profile_view(uuid, uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.fn_get_company_profile_view(uuid, uuid) TO service_role;

COMMENT ON FUNCTION public.fn_get_company_profile_view(uuid, uuid) IS
'Snapshot JSON de api.vw_company_by_id para a empresa (vínculo ativo). focus_integration sem token_focus_company.';
