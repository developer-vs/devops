#!/bin/bash

set -e

# Define the path to the Terraform directory
tf_dir=../terraform

# Define the path to the Ansible directory
ansible_dir="../ansible"

# Change directory to the Ansible directory
cd "$ansible_dir" || exit 1  # Exit if cd fails

# Run Ansible playbook
echo "Starting Ansible playbook..."
ansible-playbook ./remove_known_hosts_record.yml

# Change directory to the Terraform directory
cd "$tf_dir" || exit 1  # Exit if cd fails

# Run terraform destroy only if state files exist
if [ -f terraform.tfstate ]; then
    terraform destroy -auto-approve || true
fi

# Clean up Terraform-related files
rm -f terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
rm -rf .terraform/

