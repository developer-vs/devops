#!/bin/bash

set -euo pipefail  # Enable strict mode

# Define the absolute path for the hosts.ini file
hosts_file="$(dirname "$0")/../ansible/hosts.ini"

# Check if hosts.ini exists, create it if not
if [ ! -f "$hosts_file" ]; then
    touch "$hosts_file" || { echo "Error: Failed to create $hosts_file."; exit 1; }
fi

# Check if [all] section exists in hosts.ini
if ! grep -q "\[ec2\]" "$hosts_file"; then
    echo "[ec2]" >> "$hosts_file" || { echo "Error: Failed to update $hosts_file."; exit 1; }
fi

# Add instance IP address to hosts.ini
echo "$1" >> "$hosts_file" || { echo "Error: Failed to update $hosts_file."; exit 1; }

