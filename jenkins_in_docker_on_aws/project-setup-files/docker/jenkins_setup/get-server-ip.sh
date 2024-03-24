#!/bin/bash

# Fetch the IP address
#SERVER_IP=$(hostname -i)
#export SERVER_IP

# Export the IP address as an environment variable and update SERVER_IP in casc.yml
SERVER_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
export SERVER_IP # only use for ec2

# Your additional commands here, if any
#echo "Local Server IP is: $SERVER_IP"
echo "Public Server IP is: $SERVER_IP"

# Start Jenkins using the default entrypoint script
exec /usr/local/bin/jenkins.sh
