import os
import psycopg2
from dotenv import load_dotenv
from load_raw_data import load_raw_data
load_dotenv()

def execute_sql_file(connection, file_path):
    print(f"Running {file_path}...")

    with open(file_path, "r") as file:
        sql = file.read()

    with connection.cursor() as cursor:
        cursor.execute(sql)

    connection.commit()

    print(f"Completed {file_path}")

print("Starting Manufacturing Data Pipeline...")

connection = psycopg2.connect(
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT"),
    database=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD")
)

print("Connected to PostgreSQL")

execute_sql_file(connection, "sql/01_create_raw.sql")
load_raw_data(connection)
execute_sql_file(connection, "sql/02_create_silver.sql")
execute_sql_file(connection, "sql/03_load_silver.sql")
execute_sql_file(connection, "sql/04_create_gold.sql")
execute_sql_file(connection, "sql/05_load_gold.sql")

cursor = connection.cursor()

cursor.execute("SELECT COUNT(*) FROM raw.manufacturing_jobs;")
raw_count = cursor.fetchone()[0]

cursor.execute("SELECT COUNT(*) FROM silver.manufacturing_jobs;")
silver_count = cursor.fetchone()[0]

cursor.execute("SELECT COUNT(*) FROM gold.fact_manufacturing_job;")
gold_count = cursor.fetchone()[0]

print("\nPipeline Validation")
print(f"RAW rows:    {raw_count}")
print(f"SILVER rows: {silver_count}")
print(f"GOLD rows:   {gold_count}")

cursor.close()
connection.close()

print("Connection closed")