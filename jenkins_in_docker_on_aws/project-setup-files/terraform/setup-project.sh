#!/bin/bash

# Define the path to the backend.tf file
backend_file="backend.tf"

# Check if backend file exists
if [ ! -f "$backend_file" ]; then
    echo "Error: $backend_file not found."
    exit 1
fi

# Extract bucket name from backend.tf
bucket_name=$(grep -E 'bucket[[:space:]]+= "[^"]+"' "$backend_file" | awk -F '"' '{print $2}')

# Print the extracted bucket name for verification
echo "Bucket Name: $bucket_name"

# Check if the bucket already exists
echo "Checking if the required bucket $bucket_name exists..."
if aws s3api head-bucket --bucket "$bucket_name" 2>/dev/null; then
    echo "Bucket exists."
else
    echo "Bucket $bucket_name does not exist or you do not have permission to access it."
    exit 1
fi

# Run Terraform
echo "Running Terraform..."
terraform init || { echo "Terraform initialization failed."; exit 1; }
terraform apply -auto-approve -no-color || { echo "Terraform apply failed. Rolling back changes..."; terraform destroy -auto-approve -no-color; exit 1; }

# Get the instance ID from Terraform state file
instance_id=$(terraform state show 'aws_instance.jenkins-server' | grep "id" | head -n 1 | awk -F '["]' '{print $2}')

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
while [ ! -f "jenkins-server.pem" ]; do
    echo "SSH key file not found. Waiting..."
    sleep 5
done
echo "SSH key file created."

# Fix SSH connection error by waiting for few seconds
sleep 5

# Output the web address of the Jenkins server
terraform output web-address-jenkins-server | sed 's/"//g' > ../ansible/instance_ip.txt

# Output the Jenkins server IP address
echo "Jenkins server IP address:"
cat ../ansible/instance_ip.txt

echo "Terraform initialization completed."

