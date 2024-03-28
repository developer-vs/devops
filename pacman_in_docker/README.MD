# Docker Compose Deployment for Pacman and MongoDB

## Pre-Requisites

1. **To start the services**:
   ```bash
   docker compose -f docker-compose-deployment-pacman-and-mongo.yaml up -d

2. To stop the services: 
   ```bash
   docker compose -f docker-compose-deployment-pacman-and-mongo.yaml down

3. To destroy the services and associated volumes:
   ```bash
   docker compose -f docker-compose-deployment-pacman-and-mongo.yaml down --volumes --remove-orphans


   --volumes: removes the volumes associated with the services.
   --remove-orphans: removes any containers for services not defined in the Docker Compose file. This ensures a complete cleanup.
   

# Project Summary 

It sets up two services, nodejs-app and mongo, and connects them to a bridge network named pacman-network. 
Here's a summary of the setup:

## The `nodejs-app` service:

- Builds an image from the Dockerfile in the current context.
- Specifies the image name as `pacman:v2`.
- Maps port 8080 of the container to port 8080 on the host.
- Sets environment variables for MongoDB connection parameters.
- Connects to the `pacman-network` bridge network.
- Restarts the container unless stopped.

## The `mongo` service:

- Uses the official MongoDB image version 4.0.4.
- Exposes port 27017 for MongoDB connections.
- Mounts host directories for MongoDB data and initialization script.
- Connects to the `pacman-network` bridge network.
- Restarts the container unless stopped.

## The `pacman-network` network:

- Uses the bridge driver.
