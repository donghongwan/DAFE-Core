#!/bin/bash

# migrate.sh

set -e  # Exit immediately if a command exits with a non-zero status

# Configuration
DB_NAME="my_database"
DB_USER="db_user"
DB_PASSWORD="db_password"
MIGRATION_TOOL="sequelize"  # Change to your migration tool (e.g., knex)
LOG_FILE="/var/log/${DB_NAME}_migrate.log"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/your/slack/webhook"

# Function to send notifications to Slack
notify_slack() {
    local message="$1curl -X POST -H 'Content-type: application/json' --data "{\"text\":\"${message}\"}" ${SLACK_WEBHOOK_URL}
}

# Logging function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" | tee -a ${LOG_FILE}
}

log "Starting database migration for ${DB_NAME}..."

# Run migrations
if [ "${MIGRATION_TOOL}" == "sequelize" ]; then
    npx sequelize-cli db:migrate --env production
elif [ "${MIGRATION_TOOL}" == "knex" ]; then
    npx knex migrate:latest --env production
else
    log "Unsupported migration tool: ${MIGRATION_TOOL}"
    notify_slack "Migration failed: Unsupported migration tool: ${MIGRATION_TOOL}"
    exit 1
fi

log "Database migration completed successfully!"
notify_slack "Database migration for ${DB_NAME} completed successfully!"
