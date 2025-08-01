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
```

## Dokploy Deployment

1. **Create Application**: In Dokploy, create a new "Docker Compose" application
2. **Configure Source**: Use Git or upload files
3. **Set Compose Path**: `./docker-compose.yml`
4. **Add Environment Variables**: Add all required variables in Dokploy's environment section
5. **Upload Config Files**: 
   - In Dokploy's file manager for your app, upload:
     - `config/nginx.conf` → Save as `nginx.conf` in the files directory
     - `config/uploads.ini` → Save as `uploads.ini` in the files directory
6. **Deploy**: Click deploy and wait for services to start

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

1. **Cache Issues**: Clear Nginx cache by restarting the nginx service
2. **Upload Limits**: Adjust values in `uploads.ini`
3. **Redis Connection**: Ensure REDIS_PASSWORD matches in both WordPress and Redis service
4. **Database Connection**: Verify DB_HOST is set to 'mysql' (service name)

## Requirements

- Dokploy platform
- External `dokploy-network` created
- Domain configured in Dokploy for the nginx service