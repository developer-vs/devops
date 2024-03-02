#!/bin/bash

set -e

# Define the path to the Terraform directory
tf_dir="../terraform"

# Define the path to the Ansible directory
ansible_dir="../ansible"

# Check if Terraform directory exists
if [ ! -d "$tf_dir" ]; then
    echo "Terraform directory not found: $tf_dir"
    exit 1
fi

# Check if Ansible directory exists
if [ ! -d "$ansible_dir" ]; then
    echo "Ansible directory not found: $ansible_dir"
    exit 1
fi

# Change directory to the Terraform directory
cd "$tf_dir"

# Get the instance ID from Terraform state file
instance_id=$(terraform state show 'aws_instance.ubuntu_img_2204[0]' | grep "id" | head -n 1 | awk -F '["]' '{print $2}')

# Wait for the instance to be running
echo "Waiting for the instance to be running..."
while true; do
    instance_state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[*].Instances[*].State.Name' --output text)
    if [ "$instance_state" = "running" ]; then
        echo "Instance is running."
        break
    else
        echo "Instance is not yet running. Waiting..."
        sleep 10 # Wait for 10 seconds before checking again
    fi
done

# Wait until SSH key file is created
echo "Waiting for SSH key file to be created..."
while [ ! -f "simple_webpage.pem" ]; do
    echo "SSH key file not found. Waiting..."
    sleep 5
done
echo "SSH key file created."

sleep 5 # it will fix the error: "Failed to connect to the host via ssh"

# Run Ansible playbook if Terraform apply succeeded
echo "Starting Ansible playbook..."
cd "$ansible_dir"
ansible-playbook ./apache_setup.yml

