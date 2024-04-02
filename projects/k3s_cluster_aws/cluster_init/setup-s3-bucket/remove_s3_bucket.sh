#!/bin/bash

set -e

# Define the path to the backend.tf file
backend_file="backend.tf"

# Check if backend file exists
if [ ! -f "$backend_file" ]; then
    echo "Error: $backend_file not found." >&2
    exit 1
fi

# Read Terraform configuration and extract bucket and key
read bucket_name state_key <<< $(awk '/bucket/{bucket=$3} /key/{key=$3} END{print bucket, key}' "$backend_file" | tr -d '"')

# Print the extracted bucket name and key value for verification
echo "Bucket Name: $bucket_name"
echo "Key Value: $state_key"

# Check if bucket name and state key are provided
if [ -z "$bucket_name" ] || [ -z "$state_key" ]; then
    echo "Error: Bucket name or state key is not provided." >&2
    exit 1
fi

# Retrieve object versions directly and extract VersionIds using --query option
version_ids=$(aws s3api list-object-versions --bucket "$bucket_name" --query 'Versions[*].[VersionId]' --output text)

# Check if there are any objects to delete
if [ -n "$version_ids" ]; then
    # Construct a JSON file containing the list of objects to delete
    delete_request="{\"Objects\": ["
    for version_id in $version_ids; do
        delete_request="$delete_request{\"Key\": \"$state_key\", \"VersionId\": \"$version_id\"},"
    done
    delete_request="${delete_request%,}"  # Remove the trailing comma
    delete_request="$delete_request], \"Quiet\": false}"

    # Delete objects using a single request
    aws s3api delete-objects --bucket "$bucket_name" --delete "$delete_request"

    # Check if there are any errors during deletion
    echo "Successfully removed all objects."
else
    echo "No objects to delete."
fi

# Delete the S3 bucket
read -r -p "Do you want to delete the S3 bucket $bucket_name? [y/N]: " choice
case "$choice" in
    [Yy]*)
        echo "Deleting the S3 bucket..."
        aws s3api delete-bucket --bucket "$bucket_name"
        
        # Remove backend.tf, Terraform configuration files, and state files
		echo "Removing backend.tf, Terraform files, and state files..."
		rm -rf *.tfvars *.tfstate* .terraform .terraform.lock.hcl terraform.tfplan

echo "Cleanup completed."
        ;;
    *)
        echo "Bucket deletion aborted."
        ;;
esac


