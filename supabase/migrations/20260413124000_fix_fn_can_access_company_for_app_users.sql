-- ============================================================================
-- Fix: public.fn_can_access_company
-- ----------------------------------------------------------------------------
-- Contexto:
-- - api.vw_company_by_id chama public.rpc_list_company_certificates_access(c.id)
-- - rpc_list_company_certificates_access valida acesso via public.fn_can_access_company
-- - A versão antiga de fn_can_access_company considerava apenas tenant membership
--   (fn_my_tenant_ids), causando ACCESS_DENIED para usuários do app vinculados por
--   company.company_user_companies.
--
-- Objetivo:
-- - Manter o acesso web (tenant-based)
-- - Adicionar acesso app (company_user_companies + company_user_roles + auth.uid())
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
         -- Caminho WEB (tenant-based)
         c.tenant_id in (select * from public.fn_my_tenant_ids())
         or
         -- Caminho APP (company_user-based)
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
