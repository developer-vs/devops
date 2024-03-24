#!/bin/bash

# Define file paths
backend_file="backend.tf"
ansible_dir="../ansible"
terraform_dir="../terraform"

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Check if backend file exists
[ -f "$backend_file" ] || handle_error "$backend_file not found."

# Extract bucket name from backend.tf
bucket_name=$(grep -E 'bucket[[:space:]]+= "[^"]+"' "$backend_file" | awk -F '"' '{print $2}')

# Print the extracted bucket name for verification
echo "Bucket Name: $bucket_name"

# Check if the bucket already exists
echo "Checking if the required bucket $bucket_name exists..."
aws s3api head-bucket --bucket "$bucket_name" >/dev/null 2>&1 || handle_error "Bucket $bucket_name does not exist or you do not have permission to access it."

# Run Terraform
echo "Running Terraform..."
cd "$terraform_dir" || handle_error "Failed to change directory to $terraform_dir."
terraform init || handle_error "Terraform initialization failed."
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
        sleep 10
    fi
done

# Wait until SSH key file is created
echo "Waiting for SSH key file to be created..."
while [ ! -f "jenkins-server.pem" ]; do
    echo "SSH key file not found. Waiting..."
    sleep 5
done
echo "SSH key file created."

# Output the web address of the Jenkins server
terraform output web-address-jenkins-server | sed 's/"//g' > "$ansible_dir/instance_ip.txt"

# Output the Jenkins server IP address
echo "Jenkins server IP address:"
cat "$ansible_dir/instance_ip.txt"

# Define the path for the hosts.ini file
hosts_file="$ansible_dir/hosts.ini"

# Ensure hosts.ini exists and add instance IP address
if [ ! -f "$hosts_file" ]; then
    touch "$hosts_file" || handle_error "Failed to create $hosts_file."
fi
echo "[ec2]" >> "$hosts_file" || handle_error "Failed to update $hosts_file."
instance_ip=$(sed 's/"//g' "$ansible_dir/instance_ip.txt")
echo "$instance_ip" >> "$hosts_file" || handle_error "Failed to update $hosts_file."

echo "Terraform initialization completed."

