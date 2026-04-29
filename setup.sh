#!/bin/bash

# DevOps Microservices Project - Quick Setup Script
# This script automates the initial setup of the project

set -e  # Exit on error

echo "========================================="
echo "DevOps Microservices - Quick Setup"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check prerequisites
echo "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Python 3 found: $(python3 --version)"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Docker found: $(docker --version)"

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Docker Compose found: $(docker-compose --version)"

echo ""
echo "========================================="
echo "Step 1: Setting up Service A"
echo "========================================="

cd microservices/service-a

echo "Creating virtual environment for Service A..."
python3 -m venv venv

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo -e "${GREEN}✓${NC} Service A setup complete!"

deactivate
cd ../..

echo ""
echo "========================================="
echo "Step 2: Setting up Service B"
echo "========================================="

cd microservices/service-b

echo "Creating virtual environment for Service B..."
python3 -m venv venv

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo -e "${GREEN}✓${NC} Service B setup complete!"

deactivate
cd ../..

echo ""
echo "========================================="
echo "Step 3: Building Docker Images"
echo "========================================="

echo "Building Service A image..."
docker build -t service-a:latest ./microservices/service-a

echo "Building Service B image..."
docker build -t service-b:latest ./microservices/service-b

echo -e "${GREEN}✓${NC} Docker images built successfully!"

echo ""
echo "========================================="
echo "Step 4: Starting Services"
echo "========================================="

echo "Starting all services with Docker Compose..."
docker-compose up -d

echo "Waiting for services to be healthy..."
sleep 10

echo ""
echo "========================================="
echo "Step 5: Health Checks"
echo "========================================="

echo "Checking Service A..."
if curl -f http://localhost:8001/health &> /dev/null; then
    echo -e "${GREEN}✓${NC} Service A is healthy!"
else
    echo -e "${YELLOW}⚠${NC} Service A is not responding yet"
fi

echo "Checking Service B..."
if curl -f http://localhost:8002/health &> /dev/null; then
    echo -e "${GREEN}✓${NC} Service B is healthy!"
else
    echo -e "${YELLOW}⚠${NC} Service B is not responding yet"
fi

echo "Checking Jaeger..."
if curl -f http://localhost:16686 &> /dev/null; then
    echo -e "${GREEN}✓${NC} Jaeger is running!"
else
    echo -e "${YELLOW}⚠${NC} Jaeger is not responding yet"
fi

echo ""
echo "========================================="
echo "✅ Setup Complete!"
echo "========================================="
echo ""
echo "Your services are now running:"
echo ""
echo "  📦 Service A (User API):    http://localhost:8001"
echo "  📦 Service B (Product API): http://localhost:8002"
echo "  📊 Jaeger UI:               http://localhost:16686"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""
echo "To stop services:"
echo "  docker-compose down"
echo ""
echo "To run tests:"
echo "  cd microservices/service-a && source venv/bin/activate && pytest test_app.py -v"
echo "  cd microservices/service-b && source venv/bin/activate && pytest test_app.py -v"
echo ""
echo "Happy coding! 🚀"
