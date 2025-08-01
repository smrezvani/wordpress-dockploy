# WordPress Dokploy - Simplified Setup

A simplified, high-performance WordPress deployment stack for Dokploy using standard Docker images.

## Features

- **Standard Docker Images**: No custom builds required
- **PHP 8.4 FPM** with WordPress
- **Nginx** as reverse proxy with FastCGI caching
- **MySQL 8.4** database
- **Redis** for object caching
- **Dokploy-optimized** volume mounting

## Architecture

```
nginx:stable (80) -> wordpress:php8.4-fpm (9000)
                  -> mysql:8.4 (3306)
                  -> redis:latest (6379)
```

## Configuration Files

Following Dokploy best practices, configuration files are mounted from the `../files/` directory:

- `../files/nginx.conf` - Nginx configuration
- `../files/uploads.ini` - PHP settings
- `../files/wordpress/` - WordPress files
- `../files/mysql/` - MySQL data
- `../files/redis/` - Redis data
- `../files/cache/` - Nginx cache

## Environment Variables

Create a `.env` file with:

```env
# Database
DB_NAME=wordpress
DB_USER=wordpress
DB_PASSWORD=your_secure_password
DB_ROOT_PASSWORD=your_root_password

# Redis
REDIS_PASSWORD=your_redis_password

# WordPress
WORDPRESS_DEBUG=0
WORDPRESS_SITE_HOST=yourdomain.com
```

## Dokploy Deployment

1. **Create Application**: In Dokploy, create a new "Docker Compose" application
2. **Configure Source**: Use Git or upload files
3. **Set Compose Path**: `./docker-compose.yml`
4. **Add Environment Variables**: Add all required variables in Dokploy's environment section
5. **Deploy**: Click deploy - the init-configs service will automatically copy config files on first run

### Important Notes:
- The `init-configs` service automatically copies `nginx.conf` and `uploads.ini` from the `config/` directory to the `files/` directory on first deployment
- If you need to update these config files later, you can either:
  - Update them directly in Dokploy's file manager (`files/nginx.conf` and `files/uploads.ini`)
  - Or update them in the repository and manually copy them to the files directory

## File Structure

```
wordpress-dokploy/
├── docker-compose.yml
├── config/
│   ├── nginx.conf
│   └── uploads.ini
├── .env.example
└── README.md
```

## Performance Features

- **FastCGI Cache**: 60-minute cache for dynamic content
- **Static File Cache**: 365-day cache for assets
- **Gzip Compression**: Level 6 compression
- **Redis Object Cache**: In-memory caching
- **OPcache**: PHP bytecode caching

## Security

- Security headers (X-Frame-Options, X-Content-Type-Options, XSS-Protection)
- Blocked access to sensitive files
- SSL enforcement for admin areas
- File editing disabled in WordPress admin

## Volume Management

All data is persisted in Dokploy's `../files/` directory structure:
- WordPress files, uploads, themes, and plugins
- MySQL database
- Redis cache data
- Nginx cache

## Troubleshooting

1. **nginx.conf mount error**: If you see "not a directory" error, it means the config files weren't copied. The init-configs service should handle this automatically, but if not:
   - SSH into your Dokploy server
   - Navigate to your app's files directory
   - Manually create the files: `nginx.conf` and `uploads.ini`
   - Copy content from the `config/` directory in the repository
2. **Cache Issues**: Clear Nginx cache by restarting the nginx service
3. **Upload Limits**: Adjust values in `uploads.ini`
4. **Redis Connection**: Ensure REDIS_PASSWORD matches in both WordPress and Redis service
5. **Database Connection**: Verify DB_HOST is set to 'mysql' (service name)

## Requirements

- Dokploy platform
- External `dokploy-network` created
- Domain configured in Dokploy for the nginx service