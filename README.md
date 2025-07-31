# Enterprise WordPress Stack for Dokploy

Production-ready WordPress deployment optimized for high-traffic sites with 1M+ articles, featuring Nginx, PHP 8.4-FPM, MySQL 8.4, and Redis caching.

## Stack Components

- **WordPress**: Latest with PHP 8.4-FPM
- **Nginx**: High-performance web server with FastCGI cache
- **MySQL 8.4**: Optimized for large databases
- **Redis 7**: Object and page caching
- **Cron**: Dedicated container for WordPress scheduled tasks

## Features

### Performance Optimizations
- FastCGI page caching with intelligent cache bypass rules
- Redis object caching for database query optimization
- PHP-FPM tuned for high concurrency (100 max children)
- MySQL configured for 2GB+ buffer pool and optimized for large datasets
- Nginx worker processes with 4096 connections each
- Static asset caching with 365-day expiration
- Gzip compression for all text-based content

### Security Features
- Rate limiting on login attempts (5 req/sec)
- API rate limiting (50 req/sec)
- Security headers (X-Frame-Options, X-Content-Type-Options, etc.)
- Blocked access to sensitive files (xmlrpc.php, wp-config.php, hidden files)
- Forced SSL for admin area
- File editing disabled in admin panel

### High Availability
- Health checks for all services
- Automatic container restart on failure
- Persistent volumes for WordPress files and databases
- Redis persistence with AOF and RDB snapshots

## Deployment on Dokploy

### Prerequisites
1. Dokploy instance running
2. Git repository with this code
3. Domain name configured

### Deployment Steps

1. **Fork/Clone this repository**

2. **Create Docker Compose Project in Dokploy**
   - Go to Projects → Create New Project
   - Select "Docker Compose"
   - Choose "Git Repository"
   - Enter your repository URL

3. **Configure Environment Variables**
   
   **Option A: Use Default Values (Quick Start)**
   - The stack now includes working default values
   - Deploy immediately without configuration
   - ⚠️ **IMPORTANT**: Change passwords before production use!
   
   **Option B: Copy from .env.example**
   - Copy `.env.example` to `.env`
   - Modify passwords and settings
   - Upload to Dokploy environment variables
   
   **Option C: Manual Configuration**
   In Dokploy project settings, add these environment variables:
   
   ```env
   # MySQL Configuration
   MYSQL_ROOT_PASSWORD=<generate-strong-password>
   DB_USER=wordpress_user
   DB_PASSWORD=<generate-strong-password>
   DB_NAME=wordpress_production
   
   # Redis Configuration
   REDIS_PASSWORD=<generate-strong-password>
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
   ```

4. **Deploy the Stack**
   - Click "Deploy" in Dokploy
   - Wait for all services to become healthy

5. **Configure Domain**
   - Go to Domains tab in your project
   - Add your domain
   - Service: `nginx`
   - Port: `80`
   - Enable SSL (Let's Encrypt)

6. **Complete WordPress Installation**
   - Visit your domain
   - Follow WordPress setup wizard
   - Use the database credentials from your environment variables

## Post-Installation

### Essential Plugins for 1M+ Articles

1. **Redis Object Cache** (by Till Krüss)
   - Install from WordPress admin
   - Enable object cache in plugin settings

2. **Query Monitor** (for development/staging only)
   - Helps identify slow queries and bottlenecks

3. **WP Rocket** or **W3 Total Cache**
   - Additional caching layer
   - CDN integration

4. **Yoast SEO** or **RankMath**
   - SEO optimization for large content sites

### Performance Tuning

1. **Enable Redis Cache**
   ```bash
   wp plugin install redis-cache --activate
   wp redis enable
   ```

2. **Optimize Database Tables**
   ```bash
   wp db optimize
   ```

3. **Configure Permalinks**
   - Settings → Permalinks → Post name

4. **Set up CDN** (recommended)
   - Configure CloudFlare or similar CDN
   - Update WordPress to serve media from CDN

## Monitoring

### Check Service Health
- MySQL: `http://your-domain/wp-admin/` (database connection)
- Redis: Check Redis Object Cache plugin status
- Nginx: `http://your-domain/nginx-health`
- PHP-FPM: Check WordPress site responsiveness

### View Logs
In Dokploy, check logs for each service:
- nginx: Access and error logs
- wordpress: PHP errors
- mysql: Slow query log
- redis: Operation logs

## Scaling Recommendations

### For 10M+ Articles
1. Implement Elasticsearch for search
2. Use dedicated MySQL read replicas
3. Implement full-page caching with Varnish
4. Consider horizontal scaling with load balancer

### Database Maintenance
```bash
# Regular optimization (monthly)
wp db optimize

# Clean up revisions
wp post delete $(wp post list --post_type='revision' --format=ids) --force

# Clean up transients
wp transient delete --expired
```

## Backup Strategy

1. **Database Backups**
   - Configure automated MySQL dumps
   - Store in external object storage

2. **File Backups**
   - Backup `/wordpress` volume
   - Include uploads and themes

3. **Redis Backups**
   - Redis automatically saves snapshots
   - Located in `/redis_data` volume

## Troubleshooting

### High Memory Usage
- Reduce `pm.max_children` in php-fpm.conf
- Lower MySQL `innodb_buffer_pool_size`
- Adjust Redis `maxmemory` setting

### Slow Queries
- Enable slow query log in MySQL
- Use Query Monitor plugin
- Add database indexes as needed

### Cache Issues
- Clear Redis cache: `wp redis flush`
- Clear Nginx cache: Restart nginx container
- Check cache headers: `curl -I your-domain.com`

## Security Checklist

- [ ] Change all default passwords
- [ ] Enable 2FA for WordPress admin
- [ ] Regular security updates
- [ ] Configure backup retention
- [ ] Monitor access logs
- [ ] Set up fail2ban (optional)

## Support

For issues specific to this stack:
1. Check container logs in Dokploy
2. Verify environment variables
3. Ensure sufficient server resources

For Dokploy-specific issues:
- [Dokploy Documentation](https://docs.dokploy.com)
- [Dokploy GitHub](https://github.com/dokploy/dokploy)