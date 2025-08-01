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

echo "Config files initialization complete!"