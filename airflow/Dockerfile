FROM apache/airflow:2.9.0

# RUN pip install dbt-snowflake==1.8.3 dbt-core==1.8.3 "click>=8.0,<8.2"


USER root
RUN apt-get update && apt-get install -y git && apt-get clean

USER airflow
