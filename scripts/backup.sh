#!/bin/bash

# backup.sh

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
BACKUP_DIR="/path/to/backup"
APP_NAME="my-app"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
DB_NAME="my_database"
DB_USER="db_user"
DB_PASSWORD="db_password"
LOG_FILE="/var/log/${APP_NAME}_backup.log"
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

log "Starting backup for ${APP_NAME}..."

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Backup application files
log "Backing up application files..."
tar -czf ${BACKUP_DIR}/${APP_NAME}_files_${TIMESTAMP}.tar.gz /path/to/your/app

# Backup database
log "Backing up database..."
mysqldump -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql

log "Backup completed successfully!"
notify_slack "Backup for ${APP_NAME} completed successfully!"
