-- =============================================
-- SILVER → GOLD LOAD
-- Purpose: Populate dimensions and fact table
-- =============================================


-- 1. LOAD MACHINE DIMENSION

INSERT INTO gold.dim_machine (machine_id)
SELECT DISTINCT machine_id
FROM silver.manufacturing_jobs
ON CONFLICT (machine_id) DO NOTHING;


-- 2. LOAD OPERATION DIMENSION

INSERT INTO gold.dim_operation (operation_type)
SELECT DISTINCT operation_type
FROM silver.manufacturing_jobs
ON CONFLICT (operation_type) DO NOTHING;


-- 3. LOAD OPTIMIZATION DIMENSION

INSERT INTO gold.dim_optimization (optimization_category)
SELECT DISTINCT optimization_category
FROM silver.manufacturing_jobs
WHERE optimization_category IS NOT NULL
ON CONFLICT (optimization_category) DO NOTHING;


-- 4. LOAD MANUFACTURING FACT TABLE

INSERT INTO gold.fact_manufacturing_job (
    job_id,
    machine_key,
    operation_key,
    optimization_key,
    material_used,
    processing_time,
    energy_consumption,
    machine_availability,
    job_status,
    scheduled_start,
    scheduled_end,
    actual_start,
    actual_end
)
SELECT
    s.job_id,
    m.machine_key,
    o.operation_key,
    opt.optimization_key,
    s.material_used,
    s.processing_time,
    s.energy_consumption,
    s.machine_availability,
    s.job_status,
    s.scheduled_start,
    s.scheduled_end,
    s.actual_start,
    s.actual_end
FROM silver.manufacturing_jobs s

JOIN gold.dim_machine m
    ON s.machine_id = m.machine_id

JOIN gold.dim_operation o
    ON s.operation_type = o.operation_type

JOIN gold.dim_optimization opt
    ON s.optimization_category = opt.optimization_category

ON CONFLICT (job_id) DO NOTHING;