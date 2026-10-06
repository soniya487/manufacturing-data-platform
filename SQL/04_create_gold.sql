-- =============================================
-- GOLD LAYER
-- Purpose: Analytics-ready star schema
-- Grain: One row per manufacturing job
-- =============================================

CREATE SCHEMA IF NOT EXISTS gold;


-- =============================================
-- MACHINE DIMENSION
-- =============================================

CREATE TABLE IF NOT EXISTS gold.dim_machine (
    machine_key SERIAL PRIMARY KEY,
    machine_id TEXT UNIQUE NOT NULL
);


-- =============================================
-- OPERATION DIMENSION
-- =============================================

CREATE TABLE IF NOT EXISTS gold.dim_operation (
    operation_key SERIAL PRIMARY KEY,
    operation_type TEXT UNIQUE NOT NULL
);


-- =============================================
-- OPTIMIZATION DIMENSION
-- =============================================

CREATE TABLE IF NOT EXISTS gold.dim_optimization (
    optimization_key SERIAL PRIMARY KEY,
    optimization_category TEXT UNIQUE NOT NULL
);


-- =============================================
-- MANUFACTURING FACT TABLE
-- Grain: One row = one manufacturing job
-- =============================================

CREATE TABLE IF NOT EXISTS gold.fact_manufacturing_job (
    job_id TEXT PRIMARY KEY,

    machine_key INTEGER NOT NULL,
    operation_key INTEGER NOT NULL,
    optimization_key INTEGER NOT NULL,

    material_used NUMERIC,
    processing_time INTEGER,
    energy_consumption NUMERIC,
    machine_availability INTEGER,

    job_status TEXT,

    scheduled_start TIMESTAMP,
    scheduled_end TIMESTAMP,
    actual_start TIMESTAMP,
    actual_end TIMESTAMP,

    FOREIGN KEY (machine_key)
        REFERENCES gold.dim_machine(machine_key),

    FOREIGN KEY (operation_key)
        REFERENCES gold.dim_operation(operation_key),

    FOREIGN KEY (optimization_key)
        REFERENCES gold.dim_optimization(optimization_key)
);

