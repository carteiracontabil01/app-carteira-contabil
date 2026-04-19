-- =====================================================================
-- RPC: public.get_company_shared_documents_paginated
--
-- Retorna lista paginada de pastas e documentos COMPARTILHADOS
-- de uma empresa para usuários do app.
-- =====================================================================

create or replace function public.get_company_shared_documents_paginated(
  p_company_id uuid,
  p_parent_id uuid default null,
  p_page integer default 1,
  p_page_size integer default 20,
  p_search text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public, company
set row_security = off
as $$
declare
  v_offset integer;
  v_total integer;
  v_total_pages integer;
  v_data jsonb;
  v_auth_uid uuid := (select auth.uid());
begin
  if v_auth_uid is null then
    raise exception 'Não autenticado.'
      using errcode = 'invalid_authorization_specification';
  end if;

  if not exists (
    select 1
    from company.company_users cu
    join company.company_user_companies cuc on cuc.user_id = cu.id
    where cu.auth_user_id = v_auth_uid
      and cuc.company_id = p_company_id
      and lower(cuc.status) = 'active'
  ) then
    raise exception 'Acesso negado: usuário não vinculado a esta empresa.'
      using errcode = 'insufficient_privilege';
  end if;

  v_offset := (greatest(p_page, 1) - 1) * greatest(p_page_size, 1);

  select count(*)
    into v_total
  from company.company_document_nodes n
  where n.company_id = p_company_id
    and n.visibility = 'SHARED'
    and (
      (p_parent_id is null and n.parent_id is null)
      or
      (p_parent_id is not null and n.parent_id = p_parent_id)
    )
    and (
      p_search is null
      or trim(p_search) = ''
      or n.name ilike '%' || trim(p_search) || '%'
    );

  v_total_pages := ceil(v_total::numeric / greatest(p_page_size, 1)::numeric);

  select coalesce(jsonb_agg(row_to_json(q)::jsonb order by q.node_type, q.name), '[]'::jsonb)
    into v_data
  from (
    select
      n.id,
      n.company_id,
      n.company_cnpj,
      n.parent_id,
      n.node_type::text as node_type,
      n.name,
      n.document_type,
      n.expiration_date,
      n.visibility::text as visibility,
      n.is_system,
      n.sort_order,
      n.storage_bucket,
      n.storage_key,
      n.mime_type,
      n.file_size_bytes,
      n.checksum,
      n.created_at,
      n.created_by,
      n.updated_at,
      n.updated_by
    from company.company_document_nodes n
    where n.company_id = p_company_id
      and n.visibility = 'SHARED'
      and (
        (p_parent_id is null and n.parent_id is null)
        or
        (p_parent_id is not null and n.parent_id = p_parent_id)
      )
      and (
        p_search is null
        or trim(p_search) = ''
        or n.name ilike '%' || trim(p_search) || '%'
      )
    order by n.node_type, n.name
    limit greatest(p_page_size, 1)
    offset v_offset
  ) q;

  return jsonb_build_object(
    'data', v_data,
    'total', v_total,
    'page', p_page,
    'page_size', p_page_size,
    'total_pages', v_total_pages,
    'has_next', p_page < v_total_pages,
    'has_previous', p_page > 1,
    'total_folders', (
      select count(*)
      from company.company_document_nodes
      where company_id = p_company_id
        and node_type = 'FOLDER'
        and visibility = 'SHARED'
    ),
    'total_files', (
      select count(*)
      from company.company_document_nodes
      where company_id = p_company_id
        and node_type = 'FILE'
        and visibility = 'SHARED'
    )
  );
end;
$$;

revoke all on function public.get_company_shared_documents_paginated(uuid, uuid, integer, integer, text) from public;
grant execute on function public.get_company_shared_documents_paginated(uuid, uuid, integer, integer, text) to authenticated;

comment on function public.get_company_shared_documents_paginated(uuid, uuid, integer, integer, text) is
'Lista paginada de documentos SHARED de uma empresa para o app. Requer vínculo ACTIVE em company.company_user_companies.';
