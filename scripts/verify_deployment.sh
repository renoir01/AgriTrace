#!/bin/bash
# AgriTrace Deployment Verification Script
# This script checks the health and status of all AgriTrace deployment components

# Text formatting
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Environment selection
if [ "$1" == "prod" ] || [ "$1" == "production" ]; then
  ENV="Production"
  FRONTEND_URL="http://agritrace-prod.centralus.azurecontainer.io"
  API_URL="http://agritrace-prod-api.centralus.azurecontainer.io:8000"
elif [ "$1" == "staging" ] || [ "$1" == "dev" ]; then
  ENV="Staging"
  FRONTEND_URL="http://agritrace-staging.centralus.azurecontainer.io"
  API_URL="http://agritrace-staging-api.centralus.azurecontainer.io:8000"
else
  echo -e "${YELLOW}Usage: $0 [prod|staging]${NC}"
  echo -e "Example: $0 prod"
  exit 1
fi

echo -e "${BOLD}AgriTrace $ENV Deployment Verification${NC}"
echo "========================================"
echo "Timestamp: $(date)"
echo ""

# Function to check endpoint health
check_endpoint() {
  local url=$1
  local name=$2
  local expected_status=${3:-200}
  
  echo -n "Checking $name... "
  
  # Use curl to check the endpoint
  status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
  
  if [ "$status_code" == "$expected_status" ]; then
    echo -e "${GREEN}OK ($status_code)${NC}"
    return 0
  else
    echo -e "${RED}FAILED ($status_code)${NC}"
    return 1
  fi
}

# Check frontend endpoints
echo -e "\n${BOLD}Frontend Checks:${NC}"
check_endpoint "$FRONTEND_URL" "Frontend main page"
check_endpoint "$FRONTEND_URL/health" "Frontend health endpoint"

# Check backend API endpoints
echo -e "\n${BOLD}Backend API Checks:${NC}"
check_endpoint "$API_URL/api/health/" "API health endpoint"
check_endpoint "$API_URL/api/ready/" "API readiness probe"
check_endpoint "$API_URL/api/live/" "API liveness probe"
check_endpoint "$API_URL/swagger/" "API documentation"
check_endpoint "$API_URL/admin/" "Admin panel" 302

# Check API functionality (basic)
echo -e "\n${BOLD}API Functionality Checks:${NC}"
echo -n "Checking API farms endpoint... "
farms_response=$(curl -s "$API_URL/api/farms/")
if [[ $farms_response == *"results"* ]]; then
  echo -e "${GREEN}OK (API returned results)${NC}"
else
  echo -e "${RED}FAILED (API did not return expected format)${NC}"
fi

# Summary
echo -e "\n${BOLD}Deployment Verification Summary:${NC}"
echo "Environment: $ENV"
echo "Frontend URL: $FRONTEND_URL"
echo "API URL: $API_URL"
echo "Timestamp: $(date)"
echo ""
echo "For detailed monitoring, visit the Azure Monitor dashboard."
