#!/bin/bash

# Simple script to generate actual configuration files from templates
# using variables defined in a .env file.

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Hardcoded paths relative to the server directory
ENV_FILE=".env"
PROMETHEUS_TEMPLATE="services/monitoring/prometheus.yaml.template"

# Ensure script is run from the server directory
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${RED}Error: Cannot find $ENV_FILE.${NC}"
    echo "Make sure you are running this script from inside the 'server' directory"
    echo "and that you have created your .env file."
    exit 1
fi

echo -e "${YELLOW}Loading environment variables from '$ENV_FILE'...${NC}"
# Source the env file, ignoring lines starting with #
set -a
source <(grep -v '^#' "$ENV_FILE" | grep -v '^$')
set +a

# Function to process a template file
process_template() {
    local template_file="$1"
    local target_file="${template_file%.template}"

    echo -e "${YELLOW}Processing template: $template_file${NC}"

    if [ ! -f "$template_file" ]; then
        echo -e "${RED}Warning: Template file '$template_file' not found. Skipping.${NC}"
        return
    fi

    # Read the template, substitute variables, and write to target
    envsubst < "$template_file" > "$target_file"

    echo -e "${GREEN}Generated: $target_file${NC}"
}

echo -e "\n${YELLOW}Generating configurations...${NC}"
process_template "$PROMETHEUS_TEMPLATE"

echo -e "\n${GREEN}Configuration generation complete!${NC}"