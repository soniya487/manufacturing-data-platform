-- =============================================
-- RAW → SILVER TRANSFORMATION
-- Purpose:
-- Convert raw text fields into proper data types
-- and load validated manufacturing records.
-- =============================================

INSERT INTO silver.manufacturing_jobs (
    job_id,
    machine_id,
    operation_type,
    material_used,
    processing_time,
    energy_consumption,
    machine_availability,
    scheduled_start,
    scheduled_end,
    actual_start,
    actual_end,
    job_status,
    optimization_category,
    source_file,
    ingested_at
)
SELECT
    job_id,
    machine_id,
    operation_type,
    material_used::NUMERIC,
    processing_time::INTEGER,
    energy_consumption::NUMERIC,
    machine_availability::INTEGER,
    scheduled_start::TIMESTAMP,
    scheduled_end::TIMESTAMP,
    actual_start::TIMESTAMP,
    actual_end::TIMESTAMP,
    job_status,
    optimization_category,
    source_file,
    ingested_at
FROM raw.manufacturing_jobs

ON CONFLICT (job_id) DO NOTHING;