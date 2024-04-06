#!/bin/bash

# Set the SSH key path
ssh_key="../../.vagrant/machines/vg-pc/virtualbox/private_key"

# Check if the file exists
if [ ! -f "hosts.ini" ]; then
    echo "Error: hosts.ini file not found."
    exit 1
fi

# Extract IP addresses from the file
instance_ip=$(grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' hosts.ini)

# Define the jenkins_home directory
jenkins_home_dir="../backup-files/"

jenkins_home_remote_dir="/home/vagrant/jenkins_data/"

# Rsync command to copy jobs directory
rsync -avz -e "ssh -i $ssh_key" "${jenkins_home_dir}jobs/" "vagrant@$instance_ip:${jenkins_home_remote_dir}jobs" && \
    
# Rsync command to copy credentials.xml file
rsync -avz -e "ssh -i $ssh_key" "${jenkins_home_dir}credentials.xml" "vagrant@$instance_ip:${jenkins_home_remote_dir}" && \

# Rsync command to copy id_ed25519 file
rsync -avz -e "ssh -i $ssh_key" "${jenkins_home_dir}.ssh/id_ed25519" "vagrant@$instance_ip:${jenkins_home_remote_dir}.ssh/"

# Check if all rsync commands were successful
if [ $? -eq 0 ]; then
    echo "All files copied successfully to remote host."
else
    echo "Failed to copy files to remote host."
    exit 1
fi

