#!/bin/sh
# Wait a moment for cache-init to complete (safety measure)
sleep 2

# Ensure nginx cache directories exist with proper permissions (double-check)
for dir in client_temp fastcgi_temp proxy_temp scgi_temp uwsgi_temp; do
    if [ ! -d "/var/cache/nginx/$dir" ]; then
        mkdir -p "/var/cache/nginx/$dir"
        echo "Created missing directory: /var/cache/nginx/$dir"
    fi
done

# Set proper permissions
chmod -R 777 /var/cache/nginx
echo "Cache directories ready"

# Call the original nginx entrypoint
exec /docker-entrypoint.sh nginx -g "daemon off;"