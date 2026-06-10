# Multi-Company Analytics SaaS -- Architecture Decisions

## Start Here For New Sessions

Before continuing dashboard work, read the current progress log:

- `Factory_Operation_Dashboard_Progress_Log.md`

That file records what has already been completed, where the PBIP project lives, which pages are built, known issues, and the next recommended steps. It should be treated as the handoff note for future Codex sessions.

## Project Goal

Build a multi-company analytics platform with:

-   BigQuery as the data warehouse
-   Power BI as the semantic layer and reporting layer
-   Multi-tenant security (one report, many companies)
-   Low initial cost
-   Future SaaS capability

------------------------------------------------------------------------

# Current Project Status

Completed so far:

-   Confirmed the MVP architecture: BigQuery warehouse first, Power BI semantic/report layer second.
-   Extracted the factory operation dashboard KPI pillars from the reference image.
-   Selected Sustainability / Energy & Environment as the first dashboard pillar to model.
-   Created mock sustainability/energy datasets for multi-company testing.
-   Created BigQuery raw, mart, and security dataset structure.
-   Loaded mock data into BigQuery project `retail-bigquery-project-webapp`.
-   Added company-level fields so Power BI Row Level Security can be tested by company.

Out of scope for this document:

-   Local machine setup attempts, VM setup, Windows setup, and Power BI Desktop installation attempts.

------------------------------------------------------------------------

# KPI Pillars Identified

The factory operation dashboard is planned around 8 KPI pillars:

1. Productivity
2. Quality
3. Cost
4. Delivery
5. Safety
6. People
7. Material
8. Sustainability

The first implemented data pillar is:

``` text
Sustainability / Energy & Environment
```

Reference focus:

-   Energy usage
-   Energy cost
-   Carbon footprint
-   Energy intensity
-   Equipment-level energy usage
-   Actual vs target tracking
-   Alerts
-   Energy-saving projects

------------------------------------------------------------------------

# Agreed Architecture (Phase 1 / MVP)

``` text
BigQuery
   ↓
Power BI Desktop (Development)
   ↓ Publish
Power BI Service
   ↓
Customers
```

## Why

-   Lowest startup cost
-   Fastest implementation
-   Leverages existing BigQuery skills
-   No Fabric capacity required initially

------------------------------------------------------------------------

# Data Architecture

Do NOT put all company data directly into one messy raw table.

Use:

``` text
raw_company_A
raw_company_B
raw_company_C
      ↓
staging
      ↓
reporting_mart
      ↓
Power BI
```

Recommended BigQuery layers:

``` text
raw/
staging/
mart/
```

Example:

``` text
raw_company_A.transactions
raw_company_B.transactions

stg_company_A.transactions_cleaned
stg_company_B.transactions_cleaned

mart.fact_sales_all_companies
mart.dim_customer
mart.dim_product
mart.user_company_security
```

Implemented BigQuery datasets:

``` text
factory_dashboard_raw
factory_dashboard_mart
factory_dashboard_security
```

Implemented mock source tables:

``` text
dim_company
dim_factory
dim_equipment
energy_daily
energy_hourly
energy_equipment_daily
energy_cost_by_type
energy_alerts
energy_projects
energy_targets
```

------------------------------------------------------------------------

# Multi-Tenant Design

Single Power BI semantic model.

Single Power BI report.

Many companies.

``` text
BigQuery
   ↓
Power BI Semantic Model
   ↓
RLS
   ↓
Company A Users
Company B Users
Company C Users
```

Benefits:

-   One dashboard to maintain
-   One semantic model
-   Easier governance
-   Easier onboarding

------------------------------------------------------------------------

# Security Design

Use Row Level Security (RLS) in Power BI.

Example mapping table:

``` text
user_email              company_id
----------------------------------
a@companyA.com          A
b@companyB.com          B
```

Users only see their own company.

Company A cannot see Company B data.

BigQuery should be locked down.

Customers should NOT access BigQuery directly.

Implemented security concept:

``` text
user_company_security
```

This table maps Power BI user email to `company_id`.

Recommended Power BI RLS filter pattern:

``` dax
[user_email] = USERPRINCIPALNAME()
```

The semantic model should relate `user_company_security[company_id]` to the company dimension or fact tables through `company_id`, so each user only sees their assigned company data.

------------------------------------------------------------------------

# Refresh Strategy

Preferred:

``` text
Company Raw Data
      ↓
Company-Specific Refresh
      ↓
Shared Reporting Mart
      ↓
Power BI Refresh
```

Different companies can have different refresh schedules.

Example:

-   Company A = Daily
-   Company B = Weekly
-   Company C = Manual

------------------------------------------------------------------------

# Import Mode vs DirectQuery

Decision:

Use Power BI Import Mode.

Reasons:

-   Lower BigQuery cost
-   Faster dashboards
-   Better user experience
-   More predictable performance

BigQuery is queried only during refresh.

User interactions do not trigger BigQuery queries.

------------------------------------------------------------------------

# Semantic Layer Decision

Decision:

``` text
BigQuery = Storage + ETL
Power BI = Semantic Layer
```

Power BI responsibilities:

-   DAX
-   Measures
-   KPIs
-   Time Intelligence
-   Business Logic

Warehouse responsibilities:

-   Standardize raw mock data
-   Join reusable dimension labels
-   Expose Power BI-ready mart views
-   Keep company/factory/equipment keys consistent
-   Prepare reusable sustainability metrics where they are stable across reports

------------------------------------------------------------------------

# Recommended Next Steps

1. Connect Power BI Desktop to BigQuery.
2. Import only the `factory_dashboard_mart` views/tables and the `factory_dashboard_security.user_company_security` table.
3. Build relationships around `company_id`, `factory_id`, `equipment_id`, and date fields.
4. Create DAX measures for dynamic dashboard behavior.
5. Configure Power BI RLS using `USERPRINCIPALNAME()`.
6. Build the first dashboard page for Sustainability / Energy & Environment.
7. Test RLS with Company A / Company B sample users.

------------------------------------------------------------------------

# User Roles

Developer/Admin:

-   Build reports
-   Build DAX
-   Publish updates
-   Manage security

Customer Users:

-   Viewer only
-   Use filters
-   Drill down
-   Export if allowed

Customers should NOT:

-   Edit reports
-   Create DAX
-   Modify visuals

------------------------------------------------------------------------

# Cost Decision

Current stage:

``` text
1 Admin
5 Viewers
```

Recommendation:

``` text
BigQuery
+
Power BI Pro
```

Reason:

Much cheaper than Fabric F2.

Approximate economics discussed:

-   Power BI Pro ≈ \$10/user/month
-   6 users ≈ \$60/month
-   BigQuery cost expected to be low

Fabric F2:

≈ \$321/month

Not economical at MVP scale.

------------------------------------------------------------------------

# Fabric Break-Even Logic

Approximation:

``` text
Fabric F2 ≈ $321/month
Power BI Pro ≈ $10/user/month
```

Break-even:

``` text
321 / 10 ≈ 32 users
```

General guideline:

-   Under 20 users → Power BI Pro
-   Around 30+ users → Evaluate Fabric
-   50+ users → Fabric may become attractive

Actual break-even depends on workload and capacity size.

------------------------------------------------------------------------

# Future SaaS Direction

Phase 1:

``` text
BigQuery
   ↓
Power BI Service
```

Phase 2:

``` text
BigQuery
   ↓
Power BI Embedded
   ↓
Customer Portal
```

Phase 3:

Add:

-   AI Assistant
-   Forecasting
-   Benchmarking
-   Alerts
-   Advanced Analytics

------------------------------------------------------------------------

# Key Principle

Do not optimize for Fabric now.

Optimize for:

1.  First customer
2.  Reusable semantic model
3.  Correct RLS
4.  Standardized reporting mart
5.  Low operating cost

If customer adoption grows, re-evaluate Fabric later.

------------------------------------------------------------------------

# Next Tasks

1.  Design BigQuery datasets
2.  Create raw/staging/mart architecture
3.  Create company security mapping table
4.  Build Power BI semantic model
5.  Implement RLS
6.  Publish MVP dashboard
7.  Test with first company
8.  Measure refresh performance and cost
9.  Reassess scaling strategy after customer adoption
