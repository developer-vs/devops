#!/bin/bash

set -e

# Define the path to the Terraform directory
tf_dir=../terraform

# Define the path to the Ansible directory
ansible_dir="../ansible"

# Change directory to the Ansible directory
cd "$ansible_dir" || exit 1  # Exit if cd fails

# Clean up Ansible-related files
echo "Removing Ansible-related files..."
rm -f hosts.ini
rm -f instance_ip.txt

# Change directory to the Terraform directory
cd "$tf_dir" || exit 1  # Exit if cd fails

terraform destroy -auto-approve || true

# Clean up Terraform-related files
echo "Removing Terraform-related files..."
rm -f terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl tfplan terraform.tfplan
rm -rf .terraform/

