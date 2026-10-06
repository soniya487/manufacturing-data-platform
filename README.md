# Manufacturing Data Platform

An end-to-end data engineering project that ingests manufacturing operations data, validates and transforms raw records, and models analytics-ready data using a Medallion-style Raw → Silver → Gold architecture.

The project uses Python and PostgreSQL to demonstrate ETL development, data quality validation, source-to-target reconciliation, dimensional modeling, idempotent data loading, and manufacturing KPI analytics.

## Architecture

```text
Manufacturing CSV
       |
       v
Python / Pandas Ingestion
       |
       v
PostgreSQL RAW
Source-preserving data
       |
       v
Data Quality & Transformation
       |
       v
PostgreSQL SILVER
Clean + strongly typed data
       |
       v
Dimensional Modeling
       |
       v
PostgreSQL GOLD
Star Schema
       |
       v
Manufacturing Analytics / KPIs
```

## Dataset

The pipeline processes 1,000 manufacturing job records containing:

- Machine and operation information
- Material usage
- Processing time
- Energy consumption
- Machine availability
- Scheduled and actual timestamps
- Job status
- Optimization category
DAtaset downloaded from Kaggle 

## Data Pipeline

### Raw Layer

The Raw layer preserves source data with minimal transformation.

Python is used to:

- Read the source CSV
- Connect securely to PostgreSQL using environment variables
- Load manufacturing records
- Convert missing timestamp values to SQL NULL
- Capture source-file and ingestion metadata
- Prevent duplicate ingestion of the same source file

### Silver Layer

The Silver layer converts source data into clean, strongly typed records.

Transformations include:

- Numeric type conversion
- Integer type conversion
- Timestamp conversion
- NULL preservation
- Primary-key enforcement
- Data-quality validation

Source-to-target reconciliation verifies that all 1,000 records successfully move from Raw to Silver.

### Gold Layer

The Gold layer implements an analytics-ready star schema.

The grain of the fact table is:

**One row = one manufacturing job**

Dimension tables:

- `dim_machine`
- `dim_operation`
- `dim_optimization`

Fact table:

- `fact_manufacturing_job`

Surrogate keys and foreign-key relationships are used to connect dimensions with manufacturing events.

## Data Quality

The pipeline includes validation for:

- Duplicate Job IDs
- Missing values
- Numeric field validity
- Timestamp fields
- Job-status distributions
- Raw/Silver/Gold row-count reconciliation

Failed manufacturing jobs contain missing actual start/end timestamps, which are preserved as SQL NULL values.

## Idempotency

Pipeline loads use conflict handling to prevent duplicate records when transformations are rerun.

Examples include:

```sql
ON CONFLICT (job_id) DO NOTHING;
```

and unique dimension-level conflict handling.

## Analytics

The Gold layer supports manufacturing analytics such as:

- Average energy consumption by machine
- Average processing time by operation
- Energy consumption by operation
- Performance by optimization category
- Job completion, delay, and failure rates
- Pipeline reconciliation

## Technologies

- Python
- SQL
- PostgreSQL
- Pandas
- psycopg2
- python-dotenv
- VS Code
- pgAdmin
- Git

## Project Structure

```text
manufacturing_data_platform/
│
├── Data1/
│   └── hybrid_manufacturing_categorical.csv
│
├── src/
│   ├── profile_source.py
│   ├── test_db_connection.py
│   └── load_raw_data.py
│
├── sql/
│   ├── 01_create_raw.sql
│   ├── 02_create_silver.sql
│   ├── 03_load_silver.sql
│   ├── 04_create_gold.sql
│   ├── 05_load_gold.sql
│   └── 06_analytics.sql
│
├── .gitignore
├── requirements.txt
└── README.md
```

## Key Engineering Concepts Demonstrated

- ETL pipeline development
- Raw → Silver → Gold architecture
- Data profiling
- Data quality validation
- Source-to-target reconciliation
- PostgreSQL data engineering
- Dimensional modeling
- Star schema design
- Fact and dimension tables
- Surrogate and business keys
- Foreign-key relationships
- Idempotent data loading
- Manufacturing analytics