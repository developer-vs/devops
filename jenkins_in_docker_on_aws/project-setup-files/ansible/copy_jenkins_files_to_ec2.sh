#!/bin/bash

# Set the SSH key path
ssh_key="../terraform/jenkins-server.pem"

# Set the instance IP address
instance_ip=$(sed 's/"//g' instance_ip.txt)

# Define the jenkins_home directory
jenkins_home_dir="../../../../../../../docker/jenkins_home/"

# Rsync command to copy jobs directory
rsync -avz -e "ssh -i $ssh_key" \
    "${jenkins_home_dir}jobs/" \
    "ubuntu@$instance_ip:/home/ubuntu/jenkins_data/jobs"
    
# Check if Rsync was successful
if [ $? -eq 0 ]; then
    echo "Jobs directory copied successfully to remote host."
else
    echo "Failed to copy jobs directory to remote host."
    exit 1
fi
    
# Rsync command to copy credentials.xml file
rsync -avz -e "ssh -i $ssh_key" \
    "${jenkins_home_dir}credentials.xml" \
    "ubuntu@$instance_ip:/home/ubuntu/jenkins_data/"

# Check if Rsync was successful
if [ $? -eq 0 ]; then
    echo "credentials.xml file copied successfully to remote host."
else
    echo "Failed to copy credentials.xml file to remote host."
    exit 1
fi

# Rsync command to copy id_ed25519 file
rsync -avz -e "ssh -i $ssh_key" \
    "${jenkins_home_dir}.ssh/id_ed25519" \
    "ubuntu@$instance_ip:/home/ubuntu/jenkins_data/.ssh/"

# Check if Rsync was successful
if [ $? -eq 0 ]; then
    echo "id_ed25519 file copied successfully to remote host."
else
    echo "Failed to copy id_ed25519 file to remote host."
    exit 1
fi

