-- =============================================
-- SILVER LAYER
-- Purpose: Clean and strongly typed data
-- =============================================

CREATE SCHEMA IF NOT EXISTS silver;

CREATE TABLE IF NOT EXISTS silver.manufacturing_jobs (
    job_id TEXT PRIMARY KEY,
    machine_id TEXT NOT NULL,
    operation_type TEXT NOT NULL,
    material_used NUMERIC,
    processing_time INTEGER,
    energy_consumption NUMERIC,
    machine_availability INTEGER,
    scheduled_start TIMESTAMP,
    scheduled_end TIMESTAMP,
    actual_start TIMESTAMP,
    actual_end TIMESTAMP,
    job_status TEXT NOT NULL,
    optimization_category TEXT,
    source_file TEXT,
    ingested_at TIMESTAMP,
    transformed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);