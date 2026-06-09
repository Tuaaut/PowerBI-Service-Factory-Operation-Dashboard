-- Replace `YOUR_PROJECT` with your GCP project id before running.

CREATE SCHEMA IF NOT EXISTS `YOUR_PROJECT.factory_dashboard_raw`;

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.dim_company` (
  company_id STRING,
  company_name STRING,
  industry STRING,
  country STRING
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.dim_factory` (
  factory_id STRING,
  company_id STRING,
  factory_name STRING,
  province STRING,
  timezone STRING
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.dim_equipment` (
  equipment_id STRING,
  factory_id STRING,
  equipment_name STRING,
  equipment_category STRING,
  criticality STRING
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_daily` (
  date DATE,
  company_id STRING,
  factory_id STRING,
  production_units INT64,
  energy_kwh FLOAT64,
  energy_cost_thb FLOAT64,
  carbon_kgco2e FLOAT64,
  energy_intensity_kwh_per_unit FLOAT64,
  target_energy_kwh FLOAT64,
  target_energy_intensity FLOAT64,
  target_carbon_kgco2e FLOAT64
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_hourly` (
  datetime DATETIME,
  company_id STRING,
  factory_id STRING,
  energy_kwh FLOAT64,
  forecast_kwh FLOAT64
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_equipment_daily` (
  date DATE,
  company_id STRING,
  factory_id STRING,
  equipment_id STRING,
  energy_kwh FLOAT64,
  share_pct FLOAT64,
  status STRING
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_cost_by_type` (
  date DATE,
  company_id STRING,
  factory_id STRING,
  energy_type STRING,
  cost_thb FLOAT64,
  share_pct FLOAT64
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_alerts` (
  alert_id STRING,
  datetime DATETIME,
  company_id STRING,
  factory_id STRING,
  equipment_id STRING,
  severity STRING,
  alert_type STRING,
  message STRING,
  current_value FLOAT64,
  threshold_value FLOAT64,
  status STRING
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_projects` (
  project_id STRING,
  company_id STRING,
  factory_id STRING,
  project_name STRING,
  status STRING,
  progress_pct FLOAT64,
  expected_annual_saving_thb FLOAT64,
  start_date DATE,
  target_finish_date DATE
);

CREATE OR REPLACE TABLE `YOUR_PROJECT.factory_dashboard_raw.energy_targets` (
  period STRING,
  company_id STRING,
  factory_id STRING,
  target_energy_reduction_pct FLOAT64,
  target_energy_intensity FLOAT64,
  target_monthly_energy_kwh FLOAT64,
  target_monthly_carbon_kgco2e FLOAT64,
  target_monthly_cost_thb FLOAT64
);

