#!/bin/sh
# This script initializes config files and required directories for Dockerized WordPress + Nginx

set -e

echo "[init-configs] Starting initialization..."

# Create required base directories
echo "[init-configs] Creating base directories..."
mkdir -p /files/cache /files/wordpress /files/mysql /files/redis

# Ensure required Nginx temp subdirectories exist
echo "[init-configs] Creating Nginx temp cache directories..."
mkdir -p /files/cache/{client_temp,proxy_temp,fastcgi_temp}

# Copy nginx.conf if not already present
if [ ! -f /files/nginx.conf ]; then
    echo "[init-configs] Copying nginx.conf to /files..."
    cp /config/nginx.conf /files/nginx.conf
fi

# Copy nginx.conf.template if not already present
if [ ! -f /files/nginx.conf.template ]; then
    echo "[init-configs] Copying nginx.conf.template to /files..."
    cp /config/nginx.conf.template /files/nginx.conf.template
fi

# Copy PHP custom config if not already present
if [ ! -f /files/99-custom.ini ]; then
    echo "[init-configs] Copying 99-custom.ini to /files..."
    cp /config/99-custom.ini /files/99-custom.ini
fi

# Set permissions for WordPress directory (now using unified UID 101)
echo "[init-configs] Setting permissions for WordPress directory..."
chown -R 101:101 /files/wordpress || true
chmod -R 755 /files/wordpress || true

# Set permissions for Nginx cache (both nginx and PHP-FPM use UID 101)
echo "[init-configs] Setting permissions for Nginx cache directories..."
chown -R 101:101 /files/cache || true
chmod -R 755 /files/cache || true

echo "[init-configs] Initialization complete!"
