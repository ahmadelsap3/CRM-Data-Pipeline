#!/usr/bin/env python3
"""
Snowflake Database Setup Script
This script creates the necessary database, schemas, and warehouse for the ELT-Engine project
"""

import snowflake.connector
import sys
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv('airflow/secrets.env')

def setup_snowflake():
    """Set up Snowflake database, schemas, and warehouse"""
    
    print("🔧 Connecting to Snowflake...")
    
    try:
        # Connect to Snowflake
        conn = snowflake.connector.connect(
            user=os.getenv('SNOWFLAKE_USER'),
            password=os.getenv('SNOWFLAKE_PASSWORD'),
            account=os.getenv('SNOWFLAKE_ACCOUNT'),
            role='ACCOUNTADMIN'
        )
        
        cursor = conn.cursor()
        print("✅ Connected to Snowflake successfully!")
        
        # Create database
        print("\n📊 Creating database SALES_DW...")
        cursor.execute("CREATE DATABASE IF NOT EXISTS SALES_DW")
        print("✅ Database SALES_DW created/verified")
        
        # Use the database
        cursor.execute("USE DATABASE SALES_DW")
        
        # Create schemas
        print("\n📁 Creating schemas for Medallion Architecture...")
        
        cursor.execute("CREATE SCHEMA IF NOT EXISTS RAW_DATA")
        print("  ✅ RAW_DATA schema (Bronze layer) created")
        
        cursor.execute("CREATE SCHEMA IF NOT EXISTS SILVER")
        print("  ✅ SILVER schema (Silver layer) created")
        
        cursor.execute("CREATE SCHEMA IF NOT EXISTS GOLD")
        print("  ✅ GOLD schema (Gold layer) created")
        
        # Create warehouse
        print("\n⚙️  Creating warehouse COMPUTE_WH...")
        cursor.execute("""
            CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
            WITH WAREHOUSE_SIZE = 'X-SMALL'
            AUTO_SUSPEND = 60
            AUTO_RESUME = TRUE
            INITIALLY_SUSPENDED = TRUE
        """)
        print("✅ Warehouse COMPUTE_WH created/verified")
        
        # Grant permissions
        print("\n🔐 Granting permissions...")
        cursor.execute("GRANT ALL ON SCHEMA RAW_DATA TO ROLE ACCOUNTADMIN")
        cursor.execute("GRANT ALL ON SCHEMA SILVER TO ROLE ACCOUNTADMIN")
        cursor.execute("GRANT ALL ON SCHEMA GOLD TO ROLE ACCOUNTADMIN")
        cursor.execute("GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ACCOUNTADMIN")
        print("✅ Permissions granted")
        
        # Verify setup
        print("\n🔍 Verifying setup...")
        cursor.execute("SHOW SCHEMAS")
        schemas = cursor.fetchall()
        schema_names = [s[1] for s in schemas]
        
        required_schemas = ['RAW_DATA', 'SILVER', 'GOLD']
        for schema in required_schemas:
            if schema in schema_names:
                print(f"  ✅ {schema} schema exists")
            else:
                print(f"  ❌ {schema} schema NOT found")
        
        cursor.execute("SHOW WAREHOUSES")
        warehouses = cursor.fetchall()
        warehouse_names = [w[0] for w in warehouses]
        
        if 'COMPUTE_WH' in warehouse_names:
            print(f"  ✅ COMPUTE_WH warehouse exists")
        else:
            print(f"  ❌ COMPUTE_WH warehouse NOT found")
        
        cursor.close()
        conn.close()
        
        print("\n" + "="*60)
        print("✅ Snowflake setup completed successfully!")
        print("="*60)
        print("\n📋 Configuration Summary:")
        print(f"  Database: SALES_DW")
        print(f"  Schemas: RAW_DATA, SILVER, GOLD")
        print(f"  Warehouse: COMPUTE_WH")
        print(f"  Account: {os.getenv('SNOWFLAKE_ACCOUNT')}")
        print(f"  User: {os.getenv('SNOWFLAKE_USER')}")
        print("\n🚀 Next step: Run './airflow/start.sh' to start the pipeline!")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        print("\nPlease check:")
        print("  1. Your Snowflake credentials in airflow/secrets.env")
        print("  2. Your network connection")
        print("  3. Your Snowflake account is active")
        return False

if __name__ == "__main__":
    success = setup_snowflake()
    sys.exit(0 if success else 1)
