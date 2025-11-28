#!/bin/bash

# ELT-Engine Quick Start Script
# This script helps you set up and run the project

set -e  # Exit on error

echo "🚀 ELT-Engine Setup Script"
echo "=========================="
echo ""

# Check if we're in the right directory
if [ ! -f "docker-compose.yaml" ]; then
    echo "❌ Error: docker-compose.yaml not found!"
    echo "Please run this script from the airflow directory:"
    echo "cd /home/ahmed-elsaba/.gemini/antigravity/scratch/ELT-Engine/airflow"
    exit 1
fi

# Check if secrets.env exists
if [ ! -f "secrets.env" ]; then
    echo "❌ Error: secrets.env not found!"
    echo "Please create secrets.env with your Snowflake credentials first."
    echo "See SETUP_GUIDE.md for instructions."
    exit 1
fi

# Check if Snowflake credentials are configured
if grep -q "your_snowflake_username" secrets.env; then
    echo "⚠️  Warning: secrets.env contains placeholder values!"
    echo "Please update secrets.env with your actual Snowflake credentials."
    echo ""
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "📋 Step 1: Setting up environment..."
# Set the Airflow UID
echo "AIRFLOW_UID=$(id -u)" > .env
echo "✅ Created .env file with AIRFLOW_UID=$(id -u)"

echo ""
echo "📋 Step 2: Creating required directories..."
mkdir -p logs plugins config
chmod -R 777 logs
echo "✅ Directories created"

echo ""
echo "🐳 Step 3: Building Docker images..."
docker compose build
echo "✅ Docker images built"

echo ""
echo "🗄️  Step 4: Initializing Airflow database..."
docker compose up airflow-init
echo "✅ Airflow initialized"

echo ""
echo "🚀 Step 5: Starting all services..."
docker compose up -d
echo "✅ All services started"

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

echo ""
echo "✅ Setup Complete!"
echo ""
echo "📊 Access Airflow Web UI at: http://localhost:8080"
echo "   Username: admin"
echo "   Password: admin"
echo ""
echo "📝 Next steps:"
echo "   1. Open http://localhost:8080 in your browser"
echo "   2. Enable the 'sales_pipeline' DAG"
echo "   3. Trigger a manual run"
echo "   4. Monitor the pipeline execution"
echo ""
echo "🛑 To stop the services, run:"
echo "   docker compose down"
echo ""
echo "📖 For more details, see SETUP_GUIDE.md"
