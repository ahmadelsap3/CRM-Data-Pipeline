#!/bin/bash

# Snowflake Setup Instructions
# Since we can't run Python directly, follow these steps:

echo "🔧 Snowflake Setup Instructions"
echo "================================"
echo ""
echo "Please follow these steps to set up your Snowflake database:"
echo ""
echo "1. Open your web browser and go to:"
echo "   https://app.snowflake.com/"
echo ""
echo "2. Log in with your credentials:"
echo "   Account: VUNQPKE-HZB55929"
echo "   Username: AHMEDELSAP3"
echo "   Password: [REDACTED]"
echo ""
echo "3. Click on 'Worksheets' in the left sidebar"
echo ""
echo "4. Click '+ Worksheet' to create a new worksheet"
echo ""
echo "5. Copy and paste the following SQL commands:"
echo ""
echo "-----------------------------------------------------------"
cat << 'EOF'
-- Snowflake Database Setup for ELT-Engine

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS SALES_DW;

-- Step 2: Use the database
USE DATABASE SALES_DW;

-- Step 3: Create schemas for the Medallion Architecture
CREATE SCHEMA IF NOT EXISTS RAW_DATA;    -- Bronze layer
CREATE SCHEMA IF NOT EXISTS SILVER;      -- Silver layer  
CREATE SCHEMA IF NOT EXISTS GOLD;        -- Gold layer

-- Step 4: Create warehouse (if not exists)
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
  WITH WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Step 5: Grant permissions
GRANT ALL ON SCHEMA RAW_DATA TO ROLE ACCOUNTADMIN;
GRANT ALL ON SCHEMA SILVER TO ROLE ACCOUNTADMIN;
GRANT ALL ON SCHEMA GOLD TO ROLE ACCOUNTADMIN;
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE ACCOUNTADMIN;

-- Step 6: Verify setup
SHOW SCHEMAS;
SHOW WAREHOUSES;

-- You should see:
-- - SALES_DW database
-- - RAW_DATA, SILVER, GOLD schemas
-- - COMPUTE_WH warehouse
EOF
echo "-----------------------------------------------------------"
echo ""
echo "6. Click 'Run All' (or press Ctrl+Enter) to execute"
echo ""
echo "7. Verify you see success messages for all commands"
echo ""
echo "8. Once complete, return here and run:"
echo "   cd airflow && ./start.sh"
echo ""
echo "✅ Your secrets.env is already configured with your credentials!"
echo ""
