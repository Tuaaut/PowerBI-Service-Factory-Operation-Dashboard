# Sustainability / Energy & Environment Mock Data

## Start Here

For current project status, completed Power BI work, known issues, and next steps, read:

- `Factory_Operation_Dashboard_Progress_Log.md`

Source reference: `IMG_4224.PNG` energy factory dashboard.

This is the first implemented pillar for the factory operation dashboard MVP. The mock data is designed for Power BI dashboard development and BigQuery warehouse testing.

The data supports multi-company testing through `company_id`, so we can validate company-level Row Level Security in Power BI.

## Extracted KPIs

1. Energy usage today, kWh
2. Energy cost today, THB
3. Cumulative monthly energy usage, kWh
4. Energy intensity, kWh per unit
5. Carbon emissions today, kgCO2e
6. Cumulative monthly carbon emissions, kgCO2e
7. Energy cost share by energy type
8. Energy usage by equipment or machine
9. Daily/hourly energy usage trend
10. Actual vs target comparison
11. Energy and equipment alerts
12. Energy conservation project progress and expected savings

## Mock Tables

- `dim_company.csv`: tenant/company dimension
- `dim_factory.csv`: factory dimension
- `dim_equipment.csv`: equipment dimension
- `energy_daily.csv`: daily KPI fact table
- `energy_hourly.csv`: hourly usage trend fact table
- `energy_equipment_daily.csv`: equipment-level daily usage
- `energy_cost_by_type.csv`: cost split by energy type
- `energy_alerts.csv`: latest alerts
- `energy_projects.csv`: energy saving initiatives
- `energy_targets.csv`: monthly/yearly targets

## Multi-Company Test Design

The mock data includes company context so access control can be tested.

Core tenant field:

- `company_id`

Expected test behavior:

- Company A user sees only Company A factories, equipment, energy usage, cost, carbon, alerts, and projects.
- Company B user sees only Company B data.
- Admin/developer can validate combined data in BigQuery before applying Power BI RLS.

Related BigQuery security table:

- `factory_dashboard_security.user_company_security`

## Dashboard Page Scope

The first Power BI page should cover:

1. Energy usage today
2. Energy cost today
3. Month-to-date energy usage
4. Energy intensity
5. Carbon emissions today
6. Month-to-date carbon emissions
7. Energy cost by type
8. Energy usage by equipment
9. Daily/hourly trend
10. Actual vs target
11. Active alerts
12. Energy-saving project progress

## Suggested Power BI Measures

- `Total Energy kWh = SUM(energy_daily[energy_kwh])`
- `Total Energy Cost = SUM(energy_daily[energy_cost_thb])`
- `Carbon kgCO2e = SUM(energy_daily[carbon_kgco2e])`
- `Energy Intensity = DIVIDE(SUM(energy_daily[energy_kwh]), SUM(energy_daily[production_units]))`
- `Cost per kWh = DIVIDE(SUM(energy_daily[energy_cost_thb]), SUM(energy_daily[energy_kwh]))`
- `Carbon per Unit = DIVIDE(SUM(energy_daily[carbon_kgco2e]), SUM(energy_daily[production_units]))`
- `Target Variance % = DIVIDE([Actual] - [Target], [Target])`

## Recommended Next Step

Connect Power BI to the BigQuery mart layer, build the Sustainability / Energy dashboard page first, then test RLS by switching between sample company users.
