-- Replace `YOUR_PROJECT` with your GCP project id before running.

CREATE SCHEMA IF NOT EXISTS `YOUR_PROJECT.factory_dashboard_security`;

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_security.user_company_security` (
  user_email STRING,
  company_id STRING,
  role_name STRING,
  is_active BOOL
);

INSERT INTO `YOUR_PROJECT.factory_dashboard_security.user_company_security`
  (user_email, company_id, role_name, is_active)
VALUES
  ('admin@example.com', 'C001', 'Admin', TRUE),
  ('viewer.company1@example.com', 'C001', 'Viewer', TRUE),
  ('viewer.company2@example.com', 'C002', 'Viewer', TRUE),
  ('viewer.company3@example.com', 'C003', 'Viewer', TRUE);

