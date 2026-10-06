import pandas as pd


def load_raw_data(connection):
    file_path = "Data1/hybrid_manufacturing_categorical.csv"
    source_file = "hybrid_manufacturing_categorical.csv"

    df = pd.read_csv(file_path)

    print(f"Source file loaded successfully: {len(df)} rows")

    cursor = connection.cursor()

    cursor.execute("SELECT COUNT(*) FROM raw.manufacturing_jobs;")
    row_count = cursor.fetchone()[0]

    print(f"Current rows in raw table: {row_count}")

    cursor.execute(
        """
        SELECT COUNT(*)
        FROM raw.manufacturing_jobs
        WHERE source_file = %s;
        """,
        (source_file,)
    )

    existing_source_rows = cursor.fetchone()[0]

    if existing_source_rows > 0:
        print(
            f"Source file already loaded: "
            f"{existing_source_rows} rows found. Skipping ingestion."
        )

    else:
        insert_query = """
        INSERT INTO raw.manufacturing_jobs (
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
            source_file
        )
        VALUES (
            %s, %s, %s, %s, %s, %s, %s,
            %s, %s, %s, %s, %s, %s, %s
        );
        """

        for _, row in df.iterrows():
            cursor.execute(
                insert_query,
                (
                    row["Job_ID"],
                    row["Machine_ID"],
                    row["Operation_Type"],
                    row["Material_Used"],
                    row["Processing_Time"],
                    row["Energy_Consumption"],
                    row["Machine_Availability"],
                    row["Scheduled_Start"],
                    row["Scheduled_End"],
                    None if pd.isna(row["Actual_Start"]) else row["Actual_Start"],
                    None if pd.isna(row["Actual_End"]) else row["Actual_End"],
                    row["Job_Status"],
                    row["Optimization_Category"],
                    source_file
                )
            )

        connection.commit()

        print(
            f"Successfully loaded {len(df)} rows "
            f"into raw.manufacturing_jobs"
        )

    cursor.close()