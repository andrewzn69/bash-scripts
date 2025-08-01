#!/bin/bash

set -e

# color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# check if ip address is provided
if [ $# -eq 0 ]; then
	echo -e "${RED}Error: Please provide an IP address${NC}"
	echo -e "${WHITE}Usage: $0 <IP_ADDRESS>${NC}"
	echo -e "${WHITE}Example: $0 8.8.8.8${NC}"
	exit 1
fi

IP_ADDRESS="$1"

# validate ip address format
if ! [[ $IP_ADDRESS =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo -e "${RED}Error: '$IP_ADDRESS' is not a valid IP address format${NC}"
	echo -e "${WHITE}Please provide a valid IPv4 address (e.g., 8.8.8.8)${NC}"
	exit 1
fi

# validate each octet is between 0-255
IFS='.' read -ra OCTETS <<< "$IP_ADDRESS"
for octet in "${OCTETS[@]}"; do
	if [ "$octet" -gt 255 ] || [ "$octet" -lt 0 ]; then
		echo -e "${RED}Error: '$IP_ADDRESS' is not a valid IP address${NC}"
		echo -e "${WHITE}Each part must be between 0-255${NC}"
		exit 1
	fi
done

# check if ip is private/local
if [[ $IP_ADDRESS =~ ^192\.168\. ]] || [[ $IP_ADDRESS =~ ^10\. ]] || [[ $IP_ADDRESS =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]] || [[ $IP_ADDRESS =~ ^127\. ]] || [[ $IP_ADDRESS =~ ^169\.254\. ]]; then
	echo -e "${RED}Error: '$IP_ADDRESS' is a private/local IP address${NC}"
	echo -e "${WHITE}Private IP ranges: 192.168.x.x, 10.x.x.x, 172.16-31.x.x, 127.x.x.x, 169.254.x.x${NC}"
	echo -e "${WHITE}Please provide a public IP address${NC}"
	exit 1
fi

echo -e "${CYAN}Getting information for IP: ${WHITE}$IP_ADDRESS${NC}"
echo

FULL_INFO=$(curl -s "https://ipinfo.io/$IP_ADDRESS/json")

echo -e "${WHITE}IP Address:${NC} ${GREEN}$(echo "$FULL_INFO" | jq -r '.ip // "N/A"')${NC}"
echo -e "${WHITE}Hostname:${NC} ${YELLOW}$(echo "$FULL_INFO" | jq -r '.hostname // "N/A"')${NC}"
echo -e "${WHITE}City:${NC} ${BLUE}$(echo "$FULL_INFO" | jq -r '.city // "N/A"')${NC}"
echo -e "${WHITE}Region:${NC} ${BLUE}$(echo "$FULL_INFO" | jq -r '.region // "N/A"')${NC}"
echo -e "${WHITE}Country:${NC} ${MAGENTA}$(echo "$FULL_INFO" | jq -r '.country // "N/A"')${NC}"
echo -e "${WHITE}Location:${NC} ${CYAN}$(echo "$FULL_INFO" | jq -r '.loc // "N/A"')${NC}"
echo -e "${WHITE}Organization:${NC} ${YELLOW}$(echo "$FULL_INFO" | jq -r '.org // "N/A"')${NC}"
echo -e "${WHITE}Postal Code:${NC} ${BLUE}$(echo "$FULL_INFO" | jq -r '.postal // "N/A"')${NC}"
echo -e "${WHITE}Timezone:${NC} ${RED}$(echo "$FULL_INFO" | jq -r '.timezone // "N/A"')${NC}"
