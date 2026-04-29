#!/bin/bash
# Jenkins Setup Script
# Automates Jenkins installation and initial configuration

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}Jenkins Setup for DevOps Project${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Start Jenkins
echo "Starting Jenkins container..."
docker-compose -f docker-compose.jenkins.yml up -d

echo ""
echo "Waiting for Jenkins to start..."
sleep 30

# Get initial admin password
echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Jenkins Initial Setup${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Jenkins is running at: http://localhost:8080"
echo ""
echo "Initial Admin Password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
echo ""

echo -e "${YELLOW}=========================================${NC}"
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "${YELLOW}=========================================${NC}"
echo "1. Open http://localhost:8080 in your browser"
echo "2. Use the password above to unlock Jenkins"
echo "3. Install suggested plugins"
echo "4. Create your admin user"
echo "5. Install additional plugins:"
echo "   - Docker Pipeline"
echo "   - GitHub Integration"
echo "   - Blue Ocean (optional)"
echo ""
echo -e "${GREEN}Happy CI/CD! 🚀${NC}"
