-- Replace `YOUR_PROJECT` with your GCP project id before running.

CREATE SCHEMA IF NOT EXISTS `YOUR_PROJECT.factory_dashboard_mart`;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.dim_company` AS
SELECT * FROM `YOUR_PROJECT.factory_dashboard_raw.dim_company`;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.dim_factory` AS
SELECT * FROM `YOUR_PROJECT.factory_dashboard_raw.dim_factory`;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.dim_equipment` AS
SELECT * FROM `YOUR_PROJECT.factory_dashboard_raw.dim_equipment`;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.user_company_security` AS
SELECT *
FROM `YOUR_PROJECT.factory_dashboard_security.user_company_security`
WHERE is_active = TRUE;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_daily` AS
SELECT
  d.date,
  FORMAT_DATE('%Y-%m', d.date) AS year_month,
  d.company_id,
  c.company_name,
  d.factory_id,
  f.factory_name,
  f.province,
  d.production_units,
  d.energy_kwh,
  d.energy_cost_thb,
  d.carbon_kgco2e,
  SAFE_DIVIDE(d.energy_kwh, d.production_units) AS energy_intensity_kwh_per_unit,
  SAFE_DIVIDE(d.energy_cost_thb, d.energy_kwh) AS cost_per_kwh,
  SAFE_DIVIDE(d.carbon_kgco2e, d.production_units) AS carbon_kgco2e_per_unit,
  d.target_energy_kwh,
  d.target_energy_intensity,
  d.target_carbon_kgco2e,
  d.energy_kwh - d.target_energy_kwh AS energy_variance_kwh,
  SAFE_DIVIDE(d.energy_kwh - d.target_energy_kwh, d.target_energy_kwh) AS energy_variance_pct
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_daily` d
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_company` c
  ON d.company_id = c.company_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_factory` f
  ON d.factory_id = f.factory_id;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_hourly` AS
SELECT
  h.datetime,
  DATE(h.datetime) AS date,
  EXTRACT(HOUR FROM h.datetime) AS hour_of_day,
  h.company_id,
  c.company_name,
  h.factory_id,
  f.factory_name,
  h.energy_kwh,
  h.forecast_kwh,
  h.energy_kwh - h.forecast_kwh AS forecast_variance_kwh,
  SAFE_DIVIDE(h.energy_kwh - h.forecast_kwh, h.forecast_kwh) AS forecast_variance_pct
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_hourly` h
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_company` c
  ON h.company_id = c.company_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_factory` f
  ON h.factory_id = f.factory_id;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_equipment_daily` AS
SELECT
  e.date,
  e.company_id,
  c.company_name,
  e.factory_id,
  f.factory_name,
  e.equipment_id,
  q.equipment_name,
  q.equipment_category,
  q.criticality,
  e.energy_kwh,
  e.share_pct,
  e.status
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_equipment_daily` e
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_company` c
  ON e.company_id = c.company_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_factory` f
  ON e.factory_id = f.factory_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_equipment` q
  ON e.equipment_id = q.equipment_id;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_cost_by_type` AS
SELECT
  ct.date,
  ct.company_id,
  c.company_name,
  ct.factory_id,
  f.factory_name,
  ct.energy_type,
  ct.cost_thb,
  ct.share_pct
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_cost_by_type` ct
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_company` c
  ON ct.company_id = c.company_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_factory` f
  ON ct.factory_id = f.factory_id;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_alerts` AS
SELECT
  a.alert_id,
  a.datetime,
  DATE(a.datetime) AS date,
  a.company_id,
  c.company_name,
  a.factory_id,
  f.factory_name,
  a.equipment_id,
  q.equipment_name,
  q.equipment_category,
  a.severity,
  a.alert_type,
  a.message,
  a.current_value,
  a.threshold_value,
  a.status
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_alerts` a
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_company` c
  ON a.company_id = c.company_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_factory` f
  ON a.factory_id = f.factory_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_equipment` q
  ON a.equipment_id = q.equipment_id;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_projects` AS
SELECT
  p.project_id,
  p.company_id,
  c.company_name,
  p.factory_id,
  f.factory_name,
  p.project_name,
  p.status,
  p.progress_pct,
  p.expected_annual_saving_thb,
  p.start_date,
  p.target_finish_date
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_projects` p
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_company` c
  ON p.company_id = c.company_id
LEFT JOIN `YOUR_PROJECT.factory_dashboard_raw.dim_factory` f
  ON p.factory_id = f.factory_id;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.mart_energy_targets` AS
SELECT *
FROM `YOUR_PROJECT.factory_dashboard_raw.energy_targets`;

CREATE OR REPLACE VIEW `YOUR_PROJECT.factory_dashboard_mart.dim_date` AS
WITH fact_dates AS (
  SELECT date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_alerts`
  UNION ALL
  SELECT date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_cost_by_type`
  UNION ALL
  SELECT date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_daily`
  UNION ALL
  SELECT date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_equipment_daily`
  UNION ALL
  SELECT date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_hourly`
  UNION ALL
  SELECT start_date AS date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_projects`
  UNION ALL
  SELECT target_finish_date AS date
  FROM `YOUR_PROJECT.factory_dashboard_mart.mart_energy_projects`
),
bounds AS (
  SELECT
    MIN(date) AS min_date,
    MAX(date) AS max_date
  FROM fact_dates
  WHERE date IS NOT NULL
)
SELECT
  calendar_date AS date,
  EXTRACT(YEAR FROM calendar_date) AS year,
  EXTRACT(MONTH FROM calendar_date) AS month_number,
  FORMAT_DATE('%B', calendar_date) AS month_name,
  FORMAT_DATE('%Y-%m', calendar_date) AS year_month,
  CONCAT('Q', CAST(EXTRACT(QUARTER FROM calendar_date) AS STRING)) AS quarter,
  EXTRACT(DAY FROM calendar_date) AS day
FROM bounds,
UNNEST(GENERATE_DATE_ARRAY(min_date, max_date)) AS calendar_date;

