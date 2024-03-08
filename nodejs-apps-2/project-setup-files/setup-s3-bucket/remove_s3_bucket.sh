#!/bin/bash

# Define the path to the backend.tf file
backend_file="main.tf"

# Check if backend file exists
if [ ! -f "$backend_file" ]; then
    echo "Error: $backend_file not found."
    exit 1
fi

# Extract bucket name and key from main.tf
bucket_name=$(grep -E 'resource "aws_s3_bucket" "nodejs_apps_bucket"' main.tf -A 2 | grep "bucket =" | awk -F '"' '{print $2}')
state_key=$(grep -E 'key[[:space:]]+= "setup_s3/terraform.tfstate"' main.tf | awk -F '"' '{print $2}')

# Print the extracted bucket name and key value for verification
echo "Bucket Name: $bucket_name"
echo "Key Value: $state_key"

# Check if bucket name is not empty
if [ -n "$bucket_name" ]; then

    # Run AWS CLI command and store the output in a variable
    aws_output=$(aws s3api list-object-versions --bucket $bucket_name)

    # Extract VersionIds using grep and cut
    version_ids=$(echo "$aws_output" | grep -o '"VersionId": "[^"]*' | cut -d '"' -f 4)

    # Print and delete all VersionIds
	for version_id in $version_ids; do
    	echo "Removing VersionId: $version_id"
    	aws s3api delete-object --bucket $bucket_name --key $state_key --version-id $version_id
	done

	# Check if the S3 bucket is empty
	echo "Checking if the S3 bucket is empty..."
	remaining_objects=$(aws s3 ls "s3://$bucket_name")
	if [ -z "$remaining_objects" ]; then
  		echo "Bucket is empty."
	else
  		echo "Bucket is not empty. Remaining objects:"
  		echo "$remaining_objects"
	fi

	# Delete the S3 bucket
	echo "Deleting the S3 bucket..."
	# aws s3api delete-bucket --bucket $bucket_name

	# echo "Bucket deleted successfully."
	
else
    echo "Bucket name is empty. Nothing to delete."
fi

# Remove backend.tf, Terraform configuration files, and state files
echo "Removing backend.tf, Terraform files, and state files..."
rm -rf backend.tf *.tfvars *.tfstate* .terraform .terraform.lock.hcl terraform.tfplan

