# 🚀 Quick Start Guide

## Current Status: ✅ Configuration Files Created

The project is now configured and ready to run! Here's what has been set up:

### ✅ Completed Steps:
1. ✅ Project cloned and adapted for Ahmed Elsaba & Karim Yasser
2. ✅ Configuration files created (`secrets.env`, `profiles.yml`)
3. ✅ Snowflake setup script created (`snowflake_setup.sql`)
4. ✅ Quick start script created (`airflow/start.sh`)
5. ✅ `.gitignore` updated to exclude sensitive files

---

## 📋 Before You Start

### You Need:
1. **Snowflake Account** (Free trial: https://signup.snowflake.com/)
   - Sign up for a free trial account
   - Note down your account identifier, username, and password

2. **Docker Running** ✅ (Already installed and verified)

---

## 🎯 Next Steps

### Option A: If You Have Snowflake Credentials

1. **Update Snowflake Credentials**
   ```bash
   # Edit the secrets.env file
   nano /home/ahmed-elsaba/.gemini/antigravity/scratch/ELT-Engine/airflow/secrets.env
   ```
   
   Replace these values:
   - `SNOWFLAKE_USER` → Your Snowflake username
   - `SNOWFLAKE_PASSWORD` → Your Snowflake password
   - `SNOWFLAKE_ACCOUNT` → Your account identifier (e.g., `abc12345.us-east-1`)

2. **Run Snowflake Setup**
   - Log in to Snowflake web UI
   - Open a new worksheet
   - Copy and paste the contents of `snowflake_setup.sql`
   - Execute the script

3. **Start the Project**
   ```bash
   cd /home/ahmed-elsaba/.gemini/antigravity/scratch/ELT-Engine/airflow
   ./start.sh
   ```

4. **Access Airflow**
   - Open: http://localhost:8080
   - Login: `admin` / `admin`
   - Enable and run the `sales_pipeline` DAG

### Option B: If You Don't Have Snowflake Yet

1. **Sign up for Snowflake**
   - Go to: https://signup.snowflake.com/
   - Choose "Standard" edition (free trial)
   - Select a cloud provider (AWS/Azure/GCP)
   - Complete registration

2. **Get Your Credentials**
   After signup, note:
   - Account identifier (in your Snowflake URL)
   - Username (what you signed up with)
   - Password (what you created)

3. **Then follow Option A above**

---

## 📁 Project Structure

```
ELT-Engine/
├── airflow/
│   ├── dags/
│   │   └── pipeline.py          # Main Airflow DAG
│   ├── dbt/
│   │   ├── sales/               # DBT project
│   │   └── profiles.yml         # DBT Snowflake config ✅
│   ├── Source/
│   │   ├── source_crm/          # CRM data (CSV files)
│   │   └── source_erp/          # ERP data (CSV files)
│   ├── docker-compose.yaml      # Docker services config
│   ├── Dockerfile               # Custom Airflow image
│   ├── secrets.env              # Snowflake credentials ✅
│   └── start.sh                 # Quick start script ✅
├── snowflake_setup.sql          # Snowflake initialization ✅
├── SETUP_GUIDE.md               # Detailed setup guide ✅
├── CHANGES_SUMMARY.md           # Project adaptation notes
└── README.md                    # Project overview
```

---

## 🔧 Useful Commands

```bash
# Start the project
cd airflow && ./start.sh

# Stop all services
cd airflow && docker compose down

# View logs
cd airflow && docker compose logs -f

# Restart a specific service
cd airflow && docker compose restart airflow-scheduler

# Remove everything (including data)
cd airflow && docker compose down -v
```

---

## 📊 What the Pipeline Does

1. **Extract**: Reads CSV files from `Source/` directory
   - CRM: customers, products, sales
   - ERP: customers, locations, product categories

2. **Load**: Ingests data into Snowflake `RAW_DATA` schema

3. **Transform**: Uses DBT to create:
   - **Silver Layer**: Cleansed and standardized data
   - **Gold Layer**: Dimensional model (star schema)
     - `dim_customer`
     - `dim_product`
     - `dim_date`
     - `fact_sales`

4. **Test**: Validates data quality at each layer

---

## 🎓 For Your ITI EDA Project

### Deliverables Checklist:
- [ ] Snowflake data warehouse with Medallion architecture
- [ ] Automated ELT pipeline using Airflow
- [ ] Data quality tests
- [ ] Power BI dashboard (connect to Snowflake)
- [ ] Documentation (README, setup guide)
- [ ] GitHub repository

### Power BI Connection:
After the pipeline runs successfully:
1. Open Power BI Desktop
2. Get Data → Snowflake
3. Enter your Snowflake account details
4. Select `SALES_DW` database → `GOLD` schema
5. Load the dimensional tables
6. Create your dashboard!

---

## 🆘 Troubleshooting

### "Port 8080 already in use"
```bash
# Find and kill the process using port 8080
sudo lsof -i :8080
sudo kill -9 <PID>
```

### "Permission denied" errors
```bash
cd airflow
chmod -R 777 logs
```

### "Snowflake connection failed"
- Check your credentials in `secrets.env`
- Verify your Snowflake account is active
- Check your network connection

---

## 📞 Need Help?

1. Check `SETUP_GUIDE.md` for detailed instructions
2. Review `CHANGES_SUMMARY.md` for project modifications
3. Check Airflow logs: `docker compose logs airflow-scheduler`
4. Check task logs in Airflow UI

---

**Ready to start? Run: `cd airflow && ./start.sh`** 🚀
