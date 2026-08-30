#!/bin/bash

set -e

cd /var/www/laravel-app

git pull origin main

composer install --no-dev --optimize-autoloader

php artisan migrate --force

php artisan optimize:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

sudo systemctl reload php8.3-fpm
sudo systemctl reload nginx

echo "Deployment completed successfully."
