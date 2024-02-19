#!/bin/bash

set -e

# Define the filename for the hosts.ini file
hosts_file="../ansible/hosts.ini"

# Check if hosts.ini exists, create it if not
if [ ! -f "$hosts_file" ]; then
    touch "$hosts_file"
fi

# Check if [all] section exists in hosts.ini
if ! grep -q "\[all\]" "$hosts_file"; then
    echo "[all]" >> "$hosts_file"
fi

# Add instance IP address to hosts.ini
echo "$1" >> "$hosts_file"

