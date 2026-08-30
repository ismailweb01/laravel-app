#!/usr/bin/env bash
set -Eeuo pipefail

cd /var/www/laravel-app

echo "=== Starting deployment ==="

php artisan down || true

# Bring Laravel back online even if deployment fails
trap 'php artisan up || true' EXIT

echo "=== Pulling latest code ==="
git pull --ff-only origin main

echo "=== Installing PHP dependencies ==="
composer install \
  --no-dev \
  --prefer-dist \
  --no-interaction \
  --optimize-autoloader

echo "=== Installing frontend dependencies ==="
npm ci

echo "=== Building frontend ==="
npm run build

echo "=== Backing up database ==="
./backup-db.sh

echo "=== Running migrations ==="
php artisan migrate --force

echo "=== Optimizing Laravel ==="
php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

php artisan up
trap - EXIT

echo "=== Deployment completed successfully ==="
