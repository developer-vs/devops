#!/bin/bash

set -e

# Destroy Terraform resources
echo "Destroying Terraform resources..."
terraform destroy -auto-approve || { echo "Terraform destroy failed."; exit 1; }

# Clean up Terraform-related files
echo "Removing Terraform files and state files..."
rm -rf *.tfvars *.tfstate* .terraform .terraform.lock.hcl tfplan terraform.tfplan

# Define the path to the Ansible directory
ansible_dir="../ansible"

# Change directory to the Ansible directory
echo "Changing directory to Ansible directory..."
cd "$ansible_dir" || { echo "Failed to change directory to Ansible directory."; exit 1; }

# Clean up Ansible-related files
echo "Removing Ansible-related files..."
rm -f hosts.ini instance_ip.txt

echo "Cleanup completed successfully."

