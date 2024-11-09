#!/bin/bash

# deploy.sh

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
APP_NAME="my-app"
REMOTE_USER="user"
REMOTE_HOST="your-server.com"
REMOTE_PATH="/path/to/your/app"
DOCKER_IMAGE="my-docker-repo/${APP_NAME}:latest"
LOG_FILE="/var/log/${APP_NAME}_deploy.log"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/your/slack/webhook"

# Function to send notifications to Slack
notify_slack() {
    local message="$1"
    curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"${message}\"}" ${SLACK_WEBHOOK_URL}
}

# Logging function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a ${LOG_FILE}
}

log "Starting deployment of ${APP_NAME}..."

# SSH into the server and perform deployment steps
ssh ${REMOTE_USER}@${REMOTE_HOST} << EOF
  set -e  # Exit immediately if a command exits with a non-zero status

  log() {
      echo "\$(date +"%Y-%m-%d %H:%M:%S") - \$1" >> ${REMOTE_PATH}/deploy.log
  }

  log "Pulling the latest Docker image..."
  docker pull ${DOCKER_IMAGE}

  log "Stopping the current container..."
  docker stop ${APP_NAME} || true  # Ignore if the container is not running

  log "Removing the current container..."
  docker rm ${APP_NAME} || true  # Ignore if the container is not running

  log "Starting the new container..."
  docker run -d --name ${APP_NAME} -p 80:3000 ${DOCKER_IMAGE}

  log "Deployment completed successfully!"
EOF

notify_slack "Deployment of ${APP_NAME} completed successfully!"
