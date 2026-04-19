-- ============================================================================
-- Restore: public.rpc_get_company_profile_app
-- ----------------------------------------------------------------------------
-- Restaura a RPC para o estado anterior estável:
-- - Retorna snapshot de api.vw_company_by_id
-- - Inclui user_companies
-- - Inclui accounting_offices (contact_email, contact_phone, contact_whatsapp) por tenant_id
-- - Sem variáveis em cláusulas SQL (evita erro 42P01 no editor)
-- - Reaplica fn_can_access_company com caminho APP (evita ACCESS_DENIED na view)
-- ============================================================================

create or replace function public.fn_can_access_company(p_company_id uuid)
returns boolean
language sql
security definer
set search_path = company, iam, public
set row_security = off
as $$
  select exists (
    select 1
      from company.companies c
     where c.id = p_company_id
       and (
         c.tenant_id in (select * from public.fn_my_tenant_ids())
         or
         exists (
           select 1
             from company.company_users cu
             join company.company_user_companies cuc
               on cuc.user_id = cu.id
             join company.company_user_roles cur
               on cur.user_id = cu.id
            where cu.auth_user_id = auth.uid()
              and cuc.company_id = c.id
              and lower(cu.status) = 'active'
              and lower(cuc.status) = 'active'
              and cur.role_id = any(array[
                'f49828e1-7748-4a92-8b7e-ef26560e469f'::uuid, -- APP_ONLY
                '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'::uuid  -- WEB_APP
              ])
         )
       )
  );
$$;

revoke all on function public.fn_can_access_company(uuid) from public;
grant execute on function public.fn_can_access_company(uuid) to authenticated;

create or replace function public.rpc_list_company_certificates_access(p_company_id uuid)
returns table(
  id uuid,
  name text,
  type text,
  user_login text,
  expiration_date timestamp,
  active boolean,
  certificate_url text,
  effective_date timestamp,
  created_at timestamptz,
  company_certificate_access_id uuid
)
language plpgsql
security definer
set search_path = company_private, company, iam, public
set row_security = off
as $$
begin
  if p_company_id is null or auth.uid() is null then
    return;
  end if;

  return query
  select
    ca.id,
    ca.name,
    ca.type,
    ca.user_login,
    ca.expiration_date,
    ca.active,
    ca.certificate_url,
    ca.effective_date,
    ca.created_at,
    cca.id as company_certificate_access_id
  from company_private.company_certificates_access cca
  join company_private.certificates_access ca on ca.id = cca.certificate_access_id
  where cca.company_id = p_company_id
    and (
      exists (
        select 1
          from company.companies c
         where c.id = p_company_id
           and c.tenant_id in (select * from public.fn_my_tenant_ids())
      )
      or exists (
        select 1
          from company.company_users cu
          join company.company_user_companies cuc
            on cuc.user_id = cu.id
          join company.company_user_roles cur
            on cur.user_id = cu.id
         where cu.auth_user_id = auth.uid()
           and cuc.company_id = p_company_id
           and lower(cu.status) = 'active'
           and lower(cuc.status) = 'active'
           and cur.role_id = any(array[
             'f49828e1-7748-4a92-8b7e-ef26560e469f'::uuid, -- APP_ONLY
             '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'::uuid  -- WEB_APP
           ])
      )
    )
  order by ca.created_at desc;
end;
$$;

revoke all on function public.rpc_list_company_certificates_access(uuid) from public;
grant execute on function public.rpc_list_company_certificates_access(uuid) to authenticated;

drop function if exists public.rpc_get_company_profile_app(uuid);

create or replace function public.rpc_get_company_profile_app(
  p_company_id uuid default null
)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, company, api
as $rpc$
begin

  if auth.uid() is null then
    raise exception 'not authenticated'
      using errcode = '42501';
  end if;

  return (
    with selected_company as (
      select c.id as company_id
        from company.company_users cu
        join company.company_user_companies cuc
          on cuc.user_id = cu.id
        join company.companies c
          on c.id = cuc.company_id
       where cu.auth_user_id = auth.uid()
         and lower(cu.status) = 'active'
         and lower(cuc.status) = 'active'
         and lower(c.status::text) = 'active'
         and (p_company_id is null or c.id = p_company_id)
         and exists (
           select 1
             from company.company_user_roles cur
            where cur.user_id = cu.id
              and cur.role_id = any(array[
                'f49828e1-7748-4a92-8b7e-ef26560e469f'::uuid, -- APP_ONLY
                '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'::uuid  -- WEB_APP
              ])
         )
       order by
         case when p_company_id is not null and c.id = p_company_id then 0 else 1 end,
         cuc.created_at asc,
         c.id asc
       limit 1
    ),
    company_profile as (
      select row_to_json(v)::jsonb as profile
        from api.vw_company_by_id v
        join selected_company sc on sc.company_id = v.id
       limit 1
    ),
    accounting_office as (
      select (
        select jsonb_build_object(
          'contact_email', ao.contact_email,
          'contact_phone', ao.contact_phone,
          'contact_whatsapp', ao.contact_whatsapp
        )
        from iam.accounting_offices ao
        join company.companies c on c.tenant_id = ao.tenant_id
        join selected_company sc on sc.company_id = c.id
        order by ao.created_at desc
        limit 1
      ) as office
    ),
    user_companies as (
      select coalesce(
        jsonb_agg(
          jsonb_build_object(
            'company_id',      sub.company_id,
            'company_user_id', sub.company_user_id,
            'business_name',   sub.business_name
          )
          order by sub.business_name
        ),
        '[]'::jsonb
      ) as companies
      from (
        select distinct on (c.id)
          c.id as company_id,
          cu.id as company_user_id,
          c.business_name
          from company.company_users cu
          join company.company_user_roles cur
            on cur.user_id = cu.id
          join company.company_user_companies cuc
            on cuc.user_id = cu.id
          join company.companies c
            on c.id = cuc.company_id
         where cu.auth_user_id = auth.uid()
           and lower(cu.status) = 'active'
           and cur.role_id = any(array[
             'f49828e1-7748-4a92-8b7e-ef26560e469f'::uuid, -- APP_ONLY
             '1aec8165-ee39-428b-8e6b-13b6a26cdb9b'::uuid  -- WEB_APP
           ])
           and lower(cuc.status) = 'active'
           and lower(c.status::text) = 'active'
         order by c.id, c.business_name
      ) sub
    )
    select cp.profile || jsonb_build_object(
      'user_companies', uc.companies,
      'accounting_offices', ao.office
    )
      from company_profile cp
      cross join user_companies uc
      cross join accounting_office ao
  );

end;
$rpc$;

revoke all on function public.rpc_get_company_profile_app(uuid) from public;
revoke all on function public.rpc_get_company_profile_app(uuid) from anon;
grant execute on function public.rpc_get_company_profile_app(uuid) to authenticated;
