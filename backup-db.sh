#!/usr/bin/env bash
set -Eeuo pipefail

cd /var/www/laravel-app

BACKUP_DIR="/var/backups/laravel-app"
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
BACKUP_FILE="$BACKUP_DIR/laravel_app_$TIMESTAMP.sql.gz"
TEMP_FILE="$BACKUP_DIR/laravel_app_$TIMESTAMP.sql"

DB_DATABASE="$(grep '^DB_DATABASE=' .env | cut -d '=' -f2-)"

echo "Creating database backup..."

mysqldump \
  --single-transaction \
  --no-tablespaces \
  --routines \
  --triggers \
  "$DB_DATABASE" > "$TEMP_FILE"

gzip "$TEMP_FILE"

chmod 600 "$BACKUP_FILE"

echo "Database backup created successfully:"
echo "$BACKUP_FILE"

echo "Removing backups older than 7 days..."
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +7 -delete
