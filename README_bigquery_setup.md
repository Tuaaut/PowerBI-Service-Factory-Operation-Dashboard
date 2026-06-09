# BigQuery Setup Plan

Recommended next step: build the warehouse first, then connect Power BI to the `mart` layer.

Current status: BigQuery setup has been created for the factory operation dashboard MVP, focused on the Sustainability / Energy & Environment pillar.

Project used:

- `retail-bigquery-project-webapp`

Location:

- `asia-southeast1`

## Dataset Layout

- `raw`: direct CSV-loaded tables
- `mart`: Power BI-ready views/tables
- `security`: user-to-company access mapping

Example datasets:

- `factory_dashboard_raw`
- `factory_dashboard_mart`
- `factory_dashboard_security`

Implemented datasets:

- `factory_dashboard_raw`
- `factory_dashboard_mart`
- `factory_dashboard_security`

## Load Order

1. Create datasets
2. Create raw tables using `sql/01_create_raw_tables.sql`
3. Load CSV files from `mock_data`
4. Create security table using `sql/02_create_security_tables.sql`
5. Create mart views using `sql/03_create_mart_views.sql`
6. Connect Power BI to mart views

Local setup files:

- `bigquery/sql/01_create_raw_tables.sql`
- `bigquery/sql/02_create_security_tables.sql`
- `bigquery/sql/03_create_mart_views.sql`
- `bigquery/load/bq_load_commands.sh`

Source mock data folder:

- `mock_data/`

## Power BI Should Use

- `mart_energy_daily`
- `mart_energy_hourly`
- `mart_energy_equipment_daily`
- `mart_energy_cost_by_type`
- `mart_energy_alerts`
- `mart_energy_projects`
- `dim_company`
- `dim_factory`
- `dim_equipment`
- `user_company_security`

Recommended connection behavior:

- Use Import Mode for the MVP.
- Connect Power BI to mart views/tables, not raw tables.
- Keep raw tables available for audit and future transformation.
- Keep customer users away from direct BigQuery access.

## Multi-Company / RLS Design

Every relevant fact/dimension table includes company context through `company_id`.

Security table:

- `factory_dashboard_security.user_company_security`

Purpose:

- Map user email to allowed `company_id`.
- Enable Power BI Row Level Security.
- Test company-level access, such as Company A users seeing only Company A.

Suggested Power BI RLS expression:

``` dax
[user_email] = USERPRINCIPALNAME()
```

Then use model relationships so the filtered company security table limits visible company data.

## Transformation Principle

Keep these in BigQuery:

- Joining company/factory/equipment names
- Type cleanup
- Standard KPI columns
- Carbon and energy intensity calculations if reusable
- Mart-level tables/views

Keep these in Power BI:

- Dynamic measures
- Period comparison
- Visual-level calculations
- RLS role expression
- Dashboard interactivity

## Next Power BI Work

1. Connect to BigQuery project `retail-bigquery-project-webapp`.
2. Select `factory_dashboard_mart` tables/views.
3. Include `factory_dashboard_security.user_company_security`.
4. Build model relationships.
5. Create KPI measures for energy, carbon, cost, intensity, targets, alerts, and projects.
6. Configure RLS and test sample company access.
