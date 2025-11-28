
import sys
sys.path.append('/opt/airflow/dags')

from Scripts.snowflake_utilz import postgres_connection, close_connection
from sqlalchemy import text
import os
from dotenv import load_dotenv

load_dotenv('/opt/airflow/secrets.env')

conn, engine = postgres_connection(
    os.getenv('POSTGRES_HOST'),
    os.getenv('POSTGRES_DB'),
    os.getenv('POSTGRES_USER'),
    os.getenv('POSTGRES_PASSWORD')
)

if conn:
    try:
        conn.execute(text('CREATE TABLE IF NOT EXISTS processed_files (file_name VARCHAR(255) PRIMARY KEY)'))
        print('✅ Table processed_files created')
    except Exception as e:
        print(f'❌ Error: {e}')
    finally:
        close_connection(conn, engine)
