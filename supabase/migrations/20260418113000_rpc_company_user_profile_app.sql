-- ============================================================================
-- RPCs: public.rpc_get_company_user_profile_app / rpc_update_company_user_profile_app
-- ----------------------------------------------------------------------------
-- Objetivo:
-- - Retornar o snapshot do company_user logado para uso no app mobile.
-- - Permitir atualização controlada (nome, telefone, foto) pelo próprio usuário.
-- ============================================================================

create or replace function public.rpc_get_company_user_profile_app(
  p_company_user_id uuid default null
)
returns jsonb
language sql
stable
security definer
set search_path = public, company
as $$
with app_roles as (
  select unnest(array[
    'f49828e1-7748-4a92-8b7e-ef26560e469f'::uuid, -- APP_ONLY
    '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'::uuid  -- WEB_APP
  ]) as role_id
),
target_user as (
  select
    cu.id,
    cu.name,
    cu.email,
    cu.phone,
    cu.profile_img_url,
    cu.status,
    cu.auth_user_id
  from company.company_users cu
  join company.company_user_roles cur
    on cur.user_id = cu.id
  join app_roles ar
    on ar.role_id = cur.role_id
  join company.company_user_companies cuc
    on cuc.user_id = cu.id
  join company.companies c
    on c.id = cuc.company_id
  where cu.auth_user_id = auth.uid()
    and lower(cu.status) = 'active'
    and lower(cuc.status) = 'active'
    and lower(c.status::text) = 'active'
    and (p_company_user_id is null or cu.id = p_company_user_id)
  order by cu.created_at asc
  limit 1
),
target_company as (
  select cuc.company_id, c.cnpj
  from company.company_user_companies cuc
  join company.companies c
    on c.id = cuc.company_id
  join target_user tu
    on tu.id = cuc.user_id
  where lower(cuc.status) = 'active'
    and lower(c.status::text) = 'active'
  order by cuc.created_at asc
  limit 1
)
select
  jsonb_build_object(
    'id', tu.id,
    'name', tu.name,
    'email', tu.email,
    'phone', tu.phone,
    'profile_img_url', tu.profile_img_url,
    'status', tu.status,
    'auth_user_id', tu.auth_user_id,
    'company_id', tc.company_id,
    'company_cnpj', tc.cnpj
  )
from target_user tu
left join target_company tc
  on true;
$$;

revoke all on function public.rpc_get_company_user_profile_app(uuid) from public;
revoke all on function public.rpc_get_company_user_profile_app(uuid) from anon;
grant execute on function public.rpc_get_company_user_profile_app(uuid) to authenticated;

comment on function public.rpc_get_company_user_profile_app(uuid) is
'Retorna os dados do company_user logado (nome, email, telefone e foto) para uso no app.';

create or replace function public.rpc_update_company_user_profile_app(
  p_company_user_id uuid,
  p_name text,
  p_phone text default null,
  p_profile_img_url text default null
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = public, company
as $$
declare
  v_auth_user_id uuid := auth.uid();
begin
  if v_auth_user_id is null then
    raise exception 'not authenticated'
      using errcode = '42501';
  end if;

  if p_company_user_id is null then
    raise exception 'company_user_id is required'
      using errcode = '22023';
  end if;

  if not exists (
    select 1
      from company.company_users cu
      join company.company_user_companies cuc
        on cuc.user_id = cu.id
      join company.companies c
        on c.id = cuc.company_id
     where cu.id = p_company_user_id
       and cu.auth_user_id = v_auth_user_id
       and lower(cu.status) = 'active'
       and lower(cuc.status) = 'active'
       and lower(c.status::text) = 'active'
  ) then
    raise exception 'forbidden'
      using errcode = '42501';
  end if;

  update company.company_users cu
     set name = coalesce(nullif(trim(p_name), ''), cu.name),
         phone = nullif(trim(coalesce(p_phone, '')), ''),
         profile_img_url = nullif(trim(coalesce(p_profile_img_url, '')), ''),
         updated_at = timezone('utc', now()),
         updated_by = v_auth_user_id
   where cu.id = p_company_user_id;

  return public.rpc_get_company_user_profile_app(p_company_user_id);
end;
$$;

revoke all on function public.rpc_update_company_user_profile_app(uuid, text, text, text) from public;
revoke all on function public.rpc_update_company_user_profile_app(uuid, text, text, text) from anon;
grant execute on function public.rpc_update_company_user_profile_app(uuid, text, text, text) to authenticated;

comment on function public.rpc_update_company_user_profile_app(uuid, text, text, text) is
'Atualiza dados do company_user logado (nome, telefone e foto) e retorna o snapshot atualizado.';
