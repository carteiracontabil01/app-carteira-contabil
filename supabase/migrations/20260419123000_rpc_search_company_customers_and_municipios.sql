-- ============================================================================
-- RPCs de apoio para emissao de NFS-e (APP)
-- - search_company_customers: busca tomadores por nome/cpf/cnpj
-- - fn_search_municipios: autocomplete de municipio por nome
-- ============================================================================

create or replace function public.search_company_customers(
  p_company_id uuid,
  p_query text,
  p_limit integer default 10
)
returns jsonb
language sql
security definer
stable
as $$
  select coalesce(
    jsonb_agg(
      jsonb_build_object(
        'id', cc.id,
        'company_id', cc.company_id,
        'cpf', cc.cpf,
        'cnpj', cc.cnpj,
        'legal_name', cc.legal_name,
        'business_name', cc.business_name,
        'business_contact_name', cc.business_contact_name,
        'business_email', cc.business_email,
        'business_phone_number', cc.business_phone_number,
        'municipal_registration', cc.municipal_registration,
        'address_id', cc.address_id,
        'created_at', cc.created_at,
        'updated_at', cc.updated_at,
        'updated_by', cc.updated_by,
        'address', (
          select jsonb_build_object(
            'id', a.id,
            'address', a.address,
            'number', a.number,
            'complement', a.complement,
            'neighborhood', a.neighborhood,
            'zip_code', a.zip_code,
            'state', a.state,
            'city', a.city,
            'municipality_id', a.municipality_id,
            'created_at', a.created_at,
            'updated_at', a.updated_at,
            'municipality', (
              select to_jsonb(m)
                from ref.municipios m
               where m.id = a.municipality_id
               limit 1
            )
          )
            from company.addresses a
           where a.id = cc.address_id
           limit 1
        )
      )
      order by cc.created_at desc
    ),
    '[]'::jsonb
  )
    from company.company_customers cc
   where cc.company_id = p_company_id
     and (
       p_query is null
       or p_query = ''
       or cc.cpf ilike '%' || p_query || '%'
       or cc.cnpj ilike '%' || p_query || '%'
       or cc.legal_name ilike '%' || p_query || '%'
       or cc.business_name ilike '%' || p_query || '%'
     )
   limit p_limit;
$$;

comment on function public.search_company_customers(uuid, text, integer) is
'Busca tomadores por nome, razao social, CPF ou CNPJ para a empresa informada.';

grant execute on function public.search_company_customers(uuid, text, integer) to authenticated;

create or replace function public.fn_search_municipios(
  p_search text,
  p_limit int default 20
)
returns table (
  id uuid,
  ibge_code int,
  name text,
  uf char(2)
)
language sql
stable
security definer
as $$
  select
    m.id,
    m.ibge_code,
    m.name,
    m.uf
  from ref.municipios m
  where
    p_search is null
    or p_search = ''
    or unaccent(lower(m.name)) ilike unaccent(lower(p_search)) || '%'
    or unaccent(lower(m.name)) ilike '%' || unaccent(lower(p_search)) || '%'
  order by
    case when unaccent(lower(m.name)) ilike unaccent(lower(p_search)) || '%' then 0 else 1 end,
    m.name asc
  limit p_limit;
$$;

grant execute on function public.fn_search_municipios(text, int) to authenticated;
