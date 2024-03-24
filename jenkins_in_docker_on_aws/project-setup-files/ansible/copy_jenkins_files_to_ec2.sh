#!/bin/bash

# Set the SSH key path
ssh_key="../terraform/jenkins-server.pem"

# Set the instance IP address
instance_ip=$(sed 's/"//g' instance_ip.txt)

# Rsync command to copy files
rsync -avz -e "ssh -i $ssh_key" \
    ../../../../../../docker/jenkins_home/jobs/ \
    "ubuntu@$instance_ip:/home/ubuntu/jenkins_data/jobs"
    
# Check if Rsync was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully to remote host."
else
    echo "Failed to copy file to remote host."
    exit 1
fi
    
# Rsync command to copy files
rsync -avz -e "ssh -i $ssh_key" \
    ../../../../../../docker/jenkins_home/credentials.xml \
    "ubuntu@$instance_ip:/home/ubuntu/jenkins_data/"

# Check if Rsync was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully to remote host."
else
    echo "Failed to copy file to remote host."
    exit 1
fi

# Rsync command to copy id_ed25519 file only
rsync -avz -e "ssh -i $ssh_key" \
    ../../../../../../docker/jenkins_home/.ssh/id_ed25519 \
    "ubuntu@$instance_ip:/home/ubuntu/jenkins_data/.ssh/"

# Check if Rsync was successful
if [ $? -eq 0 ]; then
    echo "File copied successfully to remote host."
else
    echo "Failed to copy file to remote host."
    exit 1
fi

