#!/bin/sh
# Ensure nginx cache directories exist with proper permissions
mkdir -p /var/cache/nginx/client_temp
mkdir -p /var/cache/nginx/fastcgi_temp
mkdir -p /var/cache/nginx/proxy_temp
mkdir -p /var/cache/nginx/scgi_temp
mkdir -p /var/cache/nginx/uwsgi_temp
chmod -R 777 /var/cache/nginx

# Call the original nginx entrypoint
exec /docker-entrypoint.sh nginx -g "daemon off;"