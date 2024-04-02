#!/bin/bash

# Extract bucket name from main.tf
bucket_name=$(grep -E 'resource "aws_s3_bucket"' main.tf -A 2 | grep "bucket =" | awk -F '"' '{print $2}')

# Check if the bucket already exists
echo "Checking if the bucket $bucket_name already exists..."
if aws s3api head-bucket --bucket "$bucket_name" 2>/dev/null; then
    echo "Bucket already exists. Skipping creation."
    exit 0
fi

# Run terraform init
echo "Initializing Terraform..."
terraform init

# Check if terraform init was successful
if [ $? -ne 0 ]; then
    echo "Terraform init failed. Please check and resolve any errors."
    exit 1
fi

# Run terraform apply for main.tf
echo "Applying main.tf..."
terraform plan -out=terraform.tfplan
terraform apply "terraform.tfplan"

# Check if backend.tf exists
echo "Waiting for backend.tf file to be created..."
timeout=300  # Timeout set to 5 minutes (300 seconds)
while [ ! -f "backend.tf" ]; do
    sleep 5
    timeout=$((timeout - 5))
    if [ $timeout -le 0 ]; then
        echo "Timed out waiting for backend.tf file."
        exit 1
    fi
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

