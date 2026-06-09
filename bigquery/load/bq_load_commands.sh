#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   PROJECT_ID=your-gcp-project ./bigquery/load/bq_load_commands.sh

PROJECT_ID="${PROJECT_ID:?Set PROJECT_ID first}"
RAW_DATASET="factory_dashboard_raw"
ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
MOCK_DIR="$ROOT_DIR/mock_data"

bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.dim_company" "$MOCK_DIR/dim_company.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.dim_factory" "$MOCK_DIR/dim_factory.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.dim_equipment" "$MOCK_DIR/dim_equipment.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_daily" "$MOCK_DIR/energy_daily.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_hourly" "$MOCK_DIR/energy_hourly.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_equipment_daily" "$MOCK_DIR/energy_equipment_daily.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_cost_by_type" "$MOCK_DIR/energy_cost_by_type.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_alerts" "$MOCK_DIR/energy_alerts.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_projects" "$MOCK_DIR/energy_projects.csv"
bq load --source_format=CSV --skip_leading_rows=1 --replace "$PROJECT_ID:$RAW_DATASET.energy_targets" "$MOCK_DIR/energy_targets.csv"

