-- ========================================
-- RLS: company_users permite ler próprio registro
-- Necessário para as policies de companies_nfse, company_customers, etc.
-- funcionarem (a subquery usa company_users)
-- ========================================

-- Garante que RLS está habilitado
ALTER TABLE company.company_users ENABLE ROW LEVEL SECURITY;

-- Permitir que usuário autenticado leia seu próprio registro em company_users
DROP POLICY IF EXISTS "users_read_own_company_user" ON company.company_users;
CREATE POLICY "users_read_own_company_user"
ON company.company_users
FOR SELECT
TO authenticated
USING (auth_user_id = auth.uid());
