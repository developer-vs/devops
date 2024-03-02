#!/bin/bash

# Run terraform init
echo "Initializing Terraform..."
terraform init

# Run terraform apply for main.tf
echo "Applying main.tf..."
terraform apply -auto-approve

# Check if backend.tf exists
echo "Waiting for backend.tf file to be created..."
while [ ! -f "backend.tf" ]; do
    echo "backend.tf file not found. Waiting..."
    sleep 5
done

echo "backend.tf found. Initializing Terraform with backend configuration..."
# Initialize Terraform with backend configuration if backend.tf exists
# Automatically respond with "yes" when prompted
echo "yes" | terraform init

# Check if terraform init was successful
if [ $? -ne 0 ]; then
    echo "Terraform init failed. Please check and resolve any errors."
    exit 1
fi

echo "Terraform initialization completed."

