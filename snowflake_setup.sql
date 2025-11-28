-- Snowflake Database Setup Script
-- Run these commands in your Snowflake worksheet after logging in

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS SALES_DW;

-- Step 2: Use the database
USE DATABASE SALES_DW;

-- Step 3: Create schemas for the Medallion Architecture
CREATE SCHEMA IF NOT EXISTS RAW_DATA;    -- Bronze layer (raw ingested data)
CREATE SCHEMA IF NOT EXISTS SILVER;      -- Silver layer (cleansed data)
CREATE SCHEMA IF NOT EXISTS GOLD;        -- Gold layer (dimensional model)

-- Step 4: Create a warehouse if you don't have one
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
  WITH WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- Step 5: Grant permissions (adjust role as needed)
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

-- Note: After running this, update your secrets.env file with:
-- SNOWFLAKE_DATABASE=SALES_DW
-- SNOWFLAKE_SCHEMA=RAW_DATA
-- SNOWFLAKE_WAREHOUSE=COMPUTE_WH
