-- =============================================
-- GOLD ANALYTICS / KPI QUERIES
-- =============================================


-- 1. MACHINE PERFORMANCE
-- Average energy consumption by machine

SELECT
    m.machine_id,
    COUNT(*) AS total_jobs,
    ROUND(AVG(f.energy_consumption), 2) AS avg_energy_consumption
FROM gold.fact_manufacturing_job f
JOIN gold.dim_machine m
    ON f.machine_key = m.machine_key
GROUP BY m.machine_id
ORDER BY avg_energy_consumption DESC;


-- 2. OPERATION PERFORMANCE
-- Processing time and energy consumption by operation

SELECT
    o.operation_type,
    COUNT(*) AS total_jobs,
    ROUND(AVG(f.processing_time), 2) AS avg_processing_time,
    ROUND(AVG(f.energy_consumption), 2) AS avg_energy_consumption
FROM gold.fact_manufacturing_job f
JOIN gold.dim_operation o
    ON f.operation_key = o.operation_key
GROUP BY o.operation_type
ORDER BY avg_processing_time DESC;


-- 3. OPTIMIZATION / EFFICIENCY ANALYSIS

SELECT
    opt.optimization_category,
    COUNT(*) AS total_jobs,
    ROUND(AVG(f.processing_time), 2) AS avg_processing_time,
    ROUND(AVG(f.energy_consumption), 2) AS avg_energy_consumption
FROM gold.fact_manufacturing_job f
JOIN gold.dim_optimization opt
    ON f.optimization_key = opt.optimization_key
GROUP BY opt.optimization_category
ORDER BY avg_processing_time DESC;


-- 4. JOB STATUS KPI

SELECT
    job_status,
    COUNT(*) AS total_jobs,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM gold.fact_manufacturing_job
GROUP BY job_status
ORDER BY total_jobs DESC;


-- 5. PIPELINE RECONCILIATION

SELECT
    (SELECT COUNT(*) FROM raw.manufacturing_jobs) AS raw_rows,
    (SELECT COUNT(*) FROM silver.manufacturing_jobs) AS silver_rows,
    (SELECT COUNT(*) FROM gold.fact_manufacturing_job) AS gold_fact_rows;