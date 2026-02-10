#!/bin/bash

# DevOps Microservices Project - Test Runner
# This script runs all tests for both services

set -e  # Exit on error

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Running All Tests${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Function to run tests for a service
run_service_tests() {
    local service_name=$1
    local service_path=$2
    
    echo -e "${YELLOW}Testing ${service_name}...${NC}"
    cd "${service_path}"
    
    # Se não houver venv, cria. Se houver, usa.
    if [ ! -d "venv" ]; then
        echo -e "${BLUE}Criando ambiente virtual...${NC}"
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    
    # PASSO CRUCIAL: Garante que as dependências (como 'six' e Flask correto) estejam lá
    echo "Instalando/Atualizando dependências para ${service_name}..."
    pip install --upgrade pip
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    else
        # Caso o arquivo não exista, instala o básico para não quebrar
        pip install pytest pytest-cov Flask<2.4 Werkzeug<3.0 six
    fi
    
    echo "Running pytest for ${service_name}..."
    pytest test_app.py -v --cov=app --cov-report=term --cov-report=html --junitxml=test-results.xml
    
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓${NC} ${service_name} tests passed!"
    else
        echo -e "${RED}✗${NC} ${service_name} tests failed!"
    fi
    
    deactivate
    cd - > /dev/null
    
    return $exit_code
}
# Run Service A tests
service_a_result=0
run_service_tests "Service A" "microservices/service-a" || service_a_result=$?

echo ""

# Run Service B tests
service_b_result=0
run_service_tests "Service B" "microservices/service-b" || service_b_result=$?

echo ""
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Test Results Summary${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

if [ $service_a_result -eq 0 ]; then
    echo -e "Service A: ${GREEN}PASSED ✓${NC}"
else
    echo -e "Service A: ${RED}FAILED ✗${NC}"
fi

if [ $service_b_result -eq 0 ]; then
    echo -e "Service B: ${GREEN}PASSED ✓${NC}"
else
    echo -e "Service B: ${RED}FAILED ✗${NC}"
fi

echo ""
echo "Coverage reports available at:"
echo "  - microservices/service-a/htmlcov/index.html"
echo "  - microservices/service-b/htmlcov/index.html"
echo ""

# Exit with error if any tests failed
if [ $service_a_result -ne 0 ] || [ $service_b_result -ne 0 ]; then
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed! 🎉${NC}"
    exit 0
fi
