
import sys
import os

# Add the parent directory to sys.path to allow importing Scripts
sys.path.append('/opt/airflow/dags')

from Scripts.ingest_data import ingest_data
from Scripts.snowflake_utilz import snowFlaek_connection, close_connection, postgres_connection
from dotenv import load_dotenv
import logging

# Setup logging
logging.basicConfig(level=logging.INFO)

load_dotenv("/opt/airflow/secrets.env")

crm_path = "/opt/airflow/Source/source_crm"
erp_path = "/opt/airflow/Source/source_erp"

def snowflake_credentials():
    return {
        'user': os.getenv("SNOWFLAKE_USER"),
        'password': os.getenv("SNOWFLAKE_PASSWORD"),
        'account': os.getenv("SNOWFLAKE_ACCOUNT"),
        'warehouse': os.getenv("SNOWFLAKE_WAREHOUSE"),
        'database': os.getenv("SNOWFLAKE_DATABASE"),
        'schema': os.getenv("SNOWFLAKE_SCHEMA"),
    }

def postgres_credentials():
    return {
        'host': os.getenv("POSTGRES_HOST"),
        'db_name': os.getenv("POSTGRES_DB"),
        'user': os.getenv("POSTGRES_USER"),
        'password': os.getenv("POSTGRES_PASSWORD"),
    }

def ingest_crm_data():
    logging.info("Starting CRM Data Ingestion...")
    snowflake_cred = snowflake_credentials()
    Snow_conn, Snow_engine = snowFlaek_connection(**snowflake_cred)

    postgres_cred = postgres_credentials()
    Post_conn, Post_engine = postgres_connection(**postgres_cred)

    crm_cus = os.path.join(crm_path, "cust_info.csv")
    ingest_data(crm_cus, "crm_cust_info", Snow_conn, Snow_engine, Post_conn)

    crm_pro = os.path.join(crm_path, "prd_info.csv")
    ingest_data(crm_pro, "crm_prd_info", Snow_conn, Snow_engine, Post_conn)

    crm_sales = os.path.join(crm_path, "sales_details.csv")
    ingest_data(crm_sales, "crm_sales_details", Snow_conn, Snow_engine, Post_conn)

    close_connection(Snow_conn, Snow_engine)
    close_connection(Post_conn, Post_engine)
    logging.info("CRM Data Ingestion Complete.")

def ingest_erp_data():
    logging.info("Starting ERP Data Ingestion...")
    snowflake_cred = snowflake_credentials()
    Snow_conn, Snow_engine = snowFlaek_connection(**snowflake_cred)

    postgres_cred = postgres_credentials()
    Post_conn, Post_engine = postgres_connection(**postgres_cred)
    
    erp_cus = os.path.join(erp_path, "CUST_AZ12.csv")
    ingest_data(erp_cus, "erp_cust_az12", Snow_conn, Snow_engine, Post_conn)

    erp_loc = os.path.join(erp_path, "LOC_A101.csv")
    ingest_data(erp_loc, "erp_loc_a101", Snow_conn, Snow_engine, Post_conn)

    erp_px = os.path.join(erp_path, "PX_CAT_G1V2.csv")
    ingest_data(erp_px, "erp_px_cat_g1v2", Snow_conn, Snow_engine, Post_conn)

    close_connection(Snow_conn, Snow_engine)
    close_connection(Post_conn, Post_engine)
    logging.info("ERP Data Ingestion Complete.")

if __name__ == "__main__":
    ingest_crm_data()
    ingest_erp_data()
