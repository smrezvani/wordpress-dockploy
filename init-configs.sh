#!/bin/sh
# This script initializes config files if they don't exist in the files directory

# Create directories if they don't exist
mkdir -p /files/cache
mkdir -p /files/wordpress
mkdir -p /files/mysql
mkdir -p /files/redis

# Copy nginx.conf if it doesn't exist
if [ ! -f /files/nginx.conf ]; then
    echo "Copying nginx.conf to files directory..."
    cp /config/nginx.conf /files/nginx.conf
fi

# Copy 99-custom.ini if it doesn't exist
if [ ! -f /files/99-custom.ini ]; then
    echo "Copying 99-custom.ini to files directory..."
    cp /config/99-custom.ini /files/99-custom.ini
fi

# Set proper permissions for WordPress directory
chmod -R 755 /files/wordpress || true
chown -R 33:33 /files/wordpress || true  # www-data user

# Create required Nginx temp subdirectories
mkdir -p /files/cache/client_temp /files/cache/proxy_temp /files/cache/fastcgi_temp

# Set permissions for Nginx temp dirs (assuming 'nginx' UID is 101)
chmod -R 700 /files/cache
chown -R nginx:nginx /files/cache

echo "Config files initialization complete!"
