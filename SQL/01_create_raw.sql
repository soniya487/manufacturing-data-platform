-- =============================================
-- RAW LAYER
-- Purpose: Preserve source manufacturing data
-- with minimal transformation.
-- =============================================

CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.manufacturing_jobs (
    job_id TEXT,
    machine_id TEXT,
    operation_type TEXT,
    material_used TEXT,
    processing_time TEXT,
    energy_consumption TEXT,
    machine_availability TEXT,
    scheduled_start TEXT,
    scheduled_end TEXT,
    actual_start TEXT,
    actual_end TEXT,
    job_status TEXT,
    optimization_category TEXT,
    source_file TEXT,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

