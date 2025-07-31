# Optimized WordPress Stack for Dokploy

Enhanced WordPress deployment based on Dokploy's template with added Nginx reverse proxy, performance optimizations, and security hardening.

## Features

- **WordPress** with PHP 8.4-FPM (high performance)
- **MySQL 8.4** database
- **Nginx** with FastCGI caching
- **Security headers** and access restrictions
- **Performance optimizations** built-in
- **Simple configuration** - only 3 environment variables

## Quick Start

1. **Deploy in Dokploy**
   - Create new Docker Compose project
   - Use this repository

2. **Set Environment Variables**
   ```env
   WORDPRESS_DEBUG=0
   DB_NAME=wordpress
   DB_PASSWORD=your_secure_password_here
   ```

3. **Deploy** - That's it!

## Architecture

The stack uses PHP-FPM (FastCGI Process Manager) for better performance:
- **PHP-FPM** runs on port 9000 (internal)
- **Nginx** handles static files directly  
- **FastCGI** passes PHP requests to PHP-FPM
- **Caching** at both Nginx and PHP levels

## Important Configuration

In Dokploy's Domain settings, make sure to:
- Service: `nginx` (NOT `wordpress`)
- Port: `80`
- Container Port: `80`

## What's Improved

### Over Default Dokploy Template

1. **Nginx with PHP-FPM**
   - FastCGI caching for dynamic content
   - Static file caching (365 days)
   - Gzip compression
   - Security headers

2. **WordPress Optimizations**
   - Memory limits increased (512M/1024M)
   - File compression enabled
   - Smart revision limits
   - Security hardening

3. **Better Structure**
   - Cleaner file organization
   - Production-ready settings

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_NAME` | Required | WordPress database name |
| `DB_PASSWORD` | Required | MySQL root & WordPress password |
| `WORDPRESS_DEBUG` | `0` | Enable debug mode (1) or not (0) |

## File Structure

```
.
├── docker-compose.yml   # Main orchestration file
├── nginx.conf          # Nginx configuration
├── uploads.ini         # PHP upload settings
└── .env.example        # Example environment file
```

## Customization

### PHP Settings
Edit `uploads.ini` to adjust:
- Upload size limits
- Memory limits
- Execution time
- Input variables

### Nginx Settings
Edit `nginx.conf` to adjust:
- Caching rules
- Security headers
- Proxy settings

## Security Notes

- Change `DB_PASSWORD` to a strong password
- WordPress file editing is disabled by default
- SSL admin is enforced when using HTTPS
- Sensitive files are blocked by Nginx

## Support

Based on Dokploy's official WordPress template with enhancements for production use.