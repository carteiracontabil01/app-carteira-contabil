-- ========================================
-- RLS Policies para fn_get_company_billing_dashboard
-- Permite que company_users (APP_ONLY/WEB_APP) leiam dados da própria empresa
-- ========================================

-- 1. company.companies_nfse
DROP POLICY IF EXISTS "company_users_read_own_company_nfse" ON company.companies_nfse;
CREATE POLICY "company_users_read_own_company_nfse"
ON company.companies_nfse
FOR SELECT
TO authenticated
USING (
  company_id IN (
    SELECT cu.company_id
    FROM company.company_users cu
    WHERE cu.auth_user_id = auth.uid()
      AND LOWER(cu.status) = 'active'
  )
);

-- 2. company.companies_nfse_parameters (acesso via nfse da mesma empresa)
DROP POLICY IF EXISTS "company_users_read_own_company_nfse_params" ON company.companies_nfse_parameters;
CREATE POLICY "company_users_read_own_company_nfse_params"
ON company.companies_nfse_parameters
FOR SELECT
TO authenticated
USING (
  nfse_id IN (
    SELECT cn.id
    FROM company.companies_nfse cn
    WHERE cn.company_id IN (
      SELECT cu.company_id
      FROM company.company_users cu
      WHERE cu.auth_user_id = auth.uid()
        AND LOWER(cu.status) = 'active'
    )
  )
);

-- 3. company.company_customers
DROP POLICY IF EXISTS "company_users_read_own_company_customers" ON company.company_customers;
CREATE POLICY "company_users_read_own_company_customers"
ON company.company_customers
FOR SELECT
TO authenticated
USING (
  company_id IN (
    SELECT cu.company_id
    FROM company.company_users cu
    WHERE cu.auth_user_id = auth.uid()
      AND LOWER(cu.status) = 'active'
  )
);
