#!/bin/bash

# --- Color Definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Welcome to VM Info Script!${NC}"

# --- Check and display number of CPU cores ---
CORES=$(nproc)
echo -e "${BLUE}Number of CPU cores: ${YELLOW}$CORES${NC}"

# --- Show total amount of RAM ---
RAM=$(free -h | awk '/Mem:/ {print $2}')
echo -e "${BLUE}Total RAM: ${YELLOW}$RAM${NC}"

# --- Display available disk space ---
DISK_SPACE=$(df -h | awk '$6=="/" {print $4}')
echo -e "${BLUE}Available disk space on root: ${YELLOW}$DISK_SPACE${NC}"


# --- List top 3 processes using the most CPU ---
echo -e "${BLUE}Top 3 CPU-consuming processes:${NC}"
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -3 | awk '{printf "%-6s %-8s %-10s %s\n", $1, $2, $3, substr($4, 1, 50)}' | sed 's/^/    /'

# --- Check if the user is root ---
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Warning: You are running this script as root. Proceed with caution!${NC}"
fi

# --- CPU Usage Loop ---
while true; do
  read -r -p "Do you want to see current CPU usage? (y/N): " response
  case "$response" in
    [yY]*)
      while true; do
        echo -e "${BLUE}CPU Usage (press Ctrl+C to stop):${NC}"
        top -bn1 | grep "Cpu(s)" | sed "s/.*: //" | awk '{print "User: " $1 "%, System: " $3 "%, Idle: " $5"%"}'
        sleep 5
      done
      ;;
    *)
      echo -e "${GREEN}Goodbye! Keep rocking, DevCloud Ninjas!${NC}"
      exit 0
      ;;
  esac
done

echo -e "${GREEN}Script finished. Keep rocking, DevCloud Ninjas!${NC}"