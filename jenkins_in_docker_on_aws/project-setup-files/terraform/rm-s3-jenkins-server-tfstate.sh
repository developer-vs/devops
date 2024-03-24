#!/bin/bash

# Define the path to the backend.tf file
backend_file="backend.tf"

# Check if backend file exists
if [ ! -f "$backend_file" ]; then
    echo "Error: $backend_file not found."
    exit 1
fi

# Extract bucket name and key from backend.tf
bucket_name=$(grep -E 'bucket[[:space:]]+= "[^"]+"' backend.tf | awk -F '"' '{print $2}')
state_key=$(grep -E 'key[[:space:]]+= "[^"]+"' backend.tf | awk -F '"' '{print $2}')

# Print the extracted bucket name and key value for verification
echo "Bucket Name: $bucket_name"
echo "Key Value: $state_key"

# Check if bucket name is provided
if [ -z "$bucket_name" ]; then
    echo "Bucket name is not provided."
    exit 1
fi

# Check if state key is provided
if [ -z "$state_key" ]; then
    echo "State key is not provided."
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

# Check if the S3 bucket is empty
echo "Checking if the S3 bucket is empty..."
remaining_objects=$(aws s3 ls "s3://$bucket_name")
if [ -z "$remaining_objects" ]; then
    echo "Bucket is empty."
else
    echo "Bucket is not empty. Remaining objects:"
    echo "$remaining_objects"
fi

