# ELT-Engine Setup Guide
## Step-by-Step Instructions for Running the Project Locally

This guide will walk you through setting up and running the ELT-Engine project on your local machine.

---

## 📋 Prerequisites

Before starting, ensure you have the following installed:

1. **Docker** and **Docker Compose**
   - Check: `docker --version` and `docker-compose --version`
   - Install from: https://docs.docker.com/get-docker/

2. **Snowflake Account**
   - You need a Snowflake account with credentials
   - Free trial available at: https://signup.snowflake.com/

3. **Git** (already installed)
   - Check: `git --version`

---

## 🚀 Setup Steps

### Step 1: Create Snowflake Configuration File

We need to create a `secrets.env` file with your Snowflake credentials.

**Location:** `/home/ahmed-elsaba/.gemini/antigravity/scratch/ELT-Engine/airflow/secrets.env`

**Required Contents:**
```env
# Snowflake Configuration
SNOWFLAKE_USER=your_snowflake_username
SNOWFLAKE_PASSWORD=your_snowflake_password
SNOWFLAKE_ACCOUNT=your_account_identifier
SNOWFLAKE_WAREHOUSE=your_warehouse_name
SNOWFLAKE_DATABASE=your_database_name
SNOWFLAKE_SCHEMA=your_schema_name

# PostgreSQL Configuration (for Airflow metadata - already configured in docker-compose)
POSTGRES_HOST=postgres
POSTGRES_DB=airflow
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
```

**How to get Snowflake credentials:**
1. Log in to your Snowflake account
2. Account identifier: Found in your Snowflake URL (e.g., `abc12345.us-east-1`)
3. Create a warehouse if you don't have one: `CREATE WAREHOUSE my_warehouse;`
4. Create a database: `CREATE DATABASE sales_dw;`
5. Create a schema: `CREATE SCHEMA raw_data;`

---

### Step 2: Create DBT Profiles Configuration

DBT needs a profiles file to connect to Snowflake.

**Location:** `/home/ahmed-elsaba/.gemini/antigravity/scratch/ELT-Engine/airflow/dbt/profiles.yml`

**Required Contents:**
```yaml
sales:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"
      user: "{{ env_var('SNOWFLAKE_USER') }}"
      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"
      role: ACCOUNTADMIN
      database: "{{ env_var('SNOWFLAKE_DATABASE') }}"
      warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"
      schema: "{{ env_var('SNOWFLAKE_SCHEMA') }}"
      threads: 4
      client_session_keep_alive: False
```

---

### Step 3: Set Up Snowflake Database Schema

Before running the pipeline, you need to create the necessary schemas in Snowflake.

**Run these commands in Snowflake:**
```sql
-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS sales_dw;

-- Use the database
USE DATABASE sales_dw;

-- Create schemas for the Medallion Architecture
CREATE SCHEMA IF NOT EXISTS raw_data;    -- Bronze layer
CREATE SCHEMA IF NOT EXISTS silver;      -- Silver layer
CREATE SCHEMA IF NOT EXISTS gold;        -- Gold layer

-- Grant permissions (adjust role as needed)
GRANT ALL ON SCHEMA raw_data TO ROLE ACCOUNTADMIN;
GRANT ALL ON SCHEMA silver TO ROLE ACCOUNTADMIN;
GRANT ALL ON SCHEMA gold TO ROLE ACCOUNTADMIN;
```

---

### Step 4: Build and Start Docker Containers

Navigate to the airflow directory and start the services.

```bash
cd /home/ahmed-elsaba/.gemini/antigravity/scratch/ELT-Engine/airflow

# Set the Airflow UID (required for permissions)
echo -e "AIRFLOW_UID=$(id -u)" > .env

# Build the Docker images
docker-compose build

# Initialize Airflow database and create admin user
docker-compose up airflow-init

# Start all services
docker-compose up -d
```

**Services that will start:**
- Airflow Webserver (UI) - http://localhost:8080
- Airflow Scheduler
- Airflow Worker
- PostgreSQL (metadata database)
- Redis (message broker)

---

### Step 5: Access Airflow Web UI

1. Open your browser and go to: **http://localhost:8080**
2. Login credentials:
   - **Username:** `admin`
   - **Password:** `admin`

---

### Step 6: Enable and Run the DAG

1. In the Airflow UI, find the DAG named **`sales_pipeline`**
2. Toggle the switch to **enable** the DAG
3. Click the **Play** button to trigger a manual run
4. Monitor the progress in the Graph or Grid view

**The pipeline will:**
- Test Snowflake connection
- Ingest CRM data (customers, products, sales)
- Ingest ERP data (customers, locations, product categories)
- Test DBT connection
- Transform data through Silver layer (cleansed data)
- Test data quality in Silver layer
- Transform data through Gold layer (dimensional model)
- Test data quality in Gold layer

---

### Step 7: Verify Data in Snowflake

After the pipeline runs successfully, check your Snowflake database:

```sql
-- Check raw data
USE SCHEMA raw_data;
SHOW TABLES;

-- Check silver layer
USE SCHEMA silver;
SHOW TABLES;

-- Check gold layer (dimensional model)
USE SCHEMA gold;
SHOW TABLES;

-- Sample query
SELECT * FROM gold.dim_customer LIMIT 10;
SELECT * FROM gold.fact_sales LIMIT 10;
```

---

## 🔍 Troubleshooting

### Issue: Docker containers won't start
**Solution:** 
- Check if ports 8080, 5432, 6379 are available
- Run: `docker-compose logs` to see error messages

### Issue: Snowflake connection fails
**Solution:**
- Verify your credentials in `secrets.env`
- Check your Snowflake account is active
- Ensure your IP is whitelisted in Snowflake (if network policies are enabled)

### Issue: DBT models fail
**Solution:**
- Check `profiles.yml` is correctly configured
- Verify schemas exist in Snowflake
- Check DBT logs: `docker-compose logs airflow-worker`

### Issue: Permission denied errors
**Solution:**
- Run: `chmod -R 777 logs/` in the airflow directory
- Ensure AIRFLOW_UID is set correctly

---

## 📊 Project Architecture

```
Bronze Layer (raw_data schema)
    ↓
Silver Layer (silver schema) - Cleansed & Standardized
    ↓
Gold Layer (gold schema) - Dimensional Model
    ├── dim_customer
    ├── dim_product
    ├── dim_date
    └── fact_sales
```

---

## 🛑 Stopping the Project

```bash
# Stop all containers
docker-compose down

# Stop and remove volumes (WARNING: This deletes all data)
docker-compose down -v
```

---

## 📝 Next Steps

1. ✅ Set up Snowflake credentials
2. ✅ Create DBT profiles
3. ✅ Start Docker containers
4. ✅ Run the pipeline
5. ✅ Verify data in Snowflake
6. 📊 Create Power BI dashboard (connect to Snowflake)
7. 🚀 Push to GitHub

---

## 📞 Support

If you encounter issues:
1. Check the logs: `docker-compose logs [service-name]`
2. Review Airflow task logs in the UI
3. Verify Snowflake connectivity
4. Check the `CHANGES_SUMMARY.md` for project modifications

---

**Good luck with your EDA project at ITI! 🎓**
