#!/bin/bash

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}Getting public IP address...${NC}"
echo

FULL_INFO=$(curl -s "https://ipinfo.io/$PUBLIC_IP/json")

echo -e "${WHITE}Public IP:${NC} ${GREEN}$(echo "$FULL_INFO" | jq -r '.ip // "N/A"')${NC}"
echo -e "${WHITE}Hostname:${NC} ${YELLOW}$(echo "$FULL_INFO" | jq -r '.hostname // "N/A"')${NC}"
echo -e "${WHITE}City:${NC} ${BLUE}$(echo "$FULL_INFO" | jq -r '.city // "N/A"')${NC}"
echo -e "${WHITE}Region:${NC} ${BLUE}$(echo "$FULL_INFO" | jq -r '.region // "N/A"')${NC}"
echo -e "${WHITE}Country:${NC} ${MAGENTA}$(echo "$FULL_INFO" | jq -r '.country // "N/A"')${NC}"
echo -e "${WHITE}Location:${NC} ${CYAN}$(echo "$FULL_INFO" | jq -r '.loc // "N/A"')${NC}"
echo -e "${WHITE}Organization:${NC} ${YELLOW}$(echo "$FULL_INFO" | jq -r '.org // "N/A"')${NC}"
echo -e "${WHITE}Postal Code:${NC} ${BLUE}$(echo "$FULL_INFO" | jq -r '.postal // "N/A"')${NC}"
echo -e "${WHITE}Timezone:${NC} ${RED}$(echo "$FULL_INFO" | jq -r '.timezone // "N/A"')${NC}"
