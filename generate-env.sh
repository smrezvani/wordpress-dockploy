#!/bin/bash

# Generate secure random passwords
generate_password() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
}

# Create .env file with generated passwords
cat > .env <<EOF
# MySQL Configuration
MYSQL_ROOT_PASSWORD=$(generate_password)
DB_USER=wordpress_user
DB_PASSWORD=$(generate_password)
DB_NAME=wordpress_production

# Redis Configuration  
REDIS_PASSWORD=$(generate_password)
REDIS_MAX_MEMORY=2gb

# WordPress Configuration
TABLE_PREFIX=wp_
WP_DEBUG=false
WP_MEMORY_LIMIT=512M
WP_MAX_MEMORY_LIMIT=1024M
FORCE_SSL_ADMIN=true

# Performance Settings
WP_POST_REVISIONS=5
AUTOSAVE_INTERVAL=300
EMPTY_TRASH_DAYS=30

# PHP Configuration
PHP_MEMORY_LIMIT=512M
PHP_MAX_EXECUTION_TIME=300
PHP_MAX_INPUT_VARS=5000

# WordPress Salts (auto-generated)
WORDPRESS_AUTH_KEY=$(generate_password)
WORDPRESS_SECURE_AUTH_KEY=$(generate_password)
WORDPRESS_LOGGED_IN_KEY=$(generate_password)
WORDPRESS_NONCE_KEY=$(generate_password)
WORDPRESS_AUTH_SALT=$(generate_password)
WORDPRESS_SECURE_AUTH_SALT=$(generate_password)
WORDPRESS_LOGGED_IN_SALT=$(generate_password)
WORDPRESS_NONCE_SALT=$(generate_password)
EOF

echo "✅ .env file generated with secure passwords!"
echo "📋 Copy the contents to Dokploy's environment variables"
echo ""
cat .env