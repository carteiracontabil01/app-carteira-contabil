-- ============================================================================
-- RPC: public.rpc_update_company_photo_url_app
-- ----------------------------------------------------------------------------
-- Objetivo:
-- - Permitir que usuário APP_ONLY/WEB_APP atualize a foto (photo_url)
--   da empresa vinculada ao seu contexto no app mobile.
-- - Retornar o snapshot atualizado no mesmo formato de rpc_get_company_profile_app.
-- ============================================================================

create or replace function public.rpc_update_company_photo_url_app(
  p_company_id uuid,
  p_photo_url text default null
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = public, company, api
as $$
declare
  v_auth_user_id uuid := auth.uid();
  v_app_role_ids uuid[] := array[
    'f49828e1-7748-4a92-8b7e-ef26560e469f', -- APP_ONLY
    '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'  -- WEB_APP
  ];
begin
  if v_auth_user_id is null then
    raise exception 'not authenticated'
      using errcode = '42501';
  end if;

  if p_company_id is null then
    raise exception 'company_id is required'
      using errcode = '22023';
  end if;

  if not exists (
    select 1
      from company.company_users cu
      join company.company_user_roles cur
        on cur.user_id = cu.id
      join company.company_user_companies cuc
        on cuc.user_id = cu.id
      join company.companies c
        on c.id = cuc.company_id
     where cu.auth_user_id = v_auth_user_id
       and cur.role_id = any(v_app_role_ids)
       and lower(cu.status) = 'active'
       and lower(cuc.status) = 'active'
       and lower(c.status::text) = 'active'
       and c.id = p_company_id
  ) then
    raise exception 'forbidden'
      using errcode = '42501';
  end if;

  update company.companies c
     set photo_url = nullif(trim(coalesce(p_photo_url, '')), '')
   where c.id = p_company_id;

  return public.rpc_get_company_profile_app(p_company_id);
end;
$$;

revoke all on function public.rpc_update_company_photo_url_app(uuid, text) from public;
revoke all on function public.rpc_update_company_photo_url_app(uuid, text) from anon;
grant execute on function public.rpc_update_company_photo_url_app(uuid, text) to authenticated;

comment on function public.rpc_update_company_photo_url_app(uuid, text) is
'Atualiza o photo_url da company permitida ao usuário logado no app e retorna snapshot atualizado via rpc_get_company_profile_app.';
