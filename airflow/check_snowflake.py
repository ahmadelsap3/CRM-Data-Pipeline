
import os
import snowflake.connector
from dotenv import load_dotenv

load_dotenv("secrets.env")

def check_snowflake_setup():
    try:
        conn = snowflake.connector.connect(
            user=os.getenv("SNOWFLAKE_USER"),
            password=os.getenv("SNOWFLAKE_PASSWORD"),
            account=os.getenv("SNOWFLAKE_ACCOUNT"),
            warehouse=os.getenv("SNOWFLAKE_WAREHOUSE"),
            role='ACCOUNTADMIN'
        )
        cur = conn.cursor()
        
        print("✅ Connected to Snowflake")
        
        # Check Database
        cur.execute("SHOW DATABASES LIKE 'SALES_DW'")
        if cur.fetchone():
            print("✅ Database SALES_DW exists")
        else:
            print("❌ Database SALES_DW does NOT exist")
            print("Attempting to create...")
            cur.execute("CREATE DATABASE IF NOT EXISTS SALES_DW")
            print("✅ Database SALES_DW created")

        cur.execute("USE DATABASE SALES_DW")

        # Check Schemas
        schemas = ['RAW_DATA', 'SILVER', 'GOLD']
        for schema in schemas:
            cur.execute(f"SHOW SCHEMAS LIKE '{schema}'")
            if cur.fetchone():
                print(f"✅ Schema {schema} exists")
            else:
                print(f"❌ Schema {schema} does NOT exist")
                print(f"Attempting to create {schema}...")
                cur.execute(f"CREATE SCHEMA IF NOT EXISTS {schema}")
                print(f"✅ Schema {schema} created")

    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    check_snowflake_setup()
