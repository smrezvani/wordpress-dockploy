FROM wordpress:php8.4-fpm

# Change www-data user and group to UID/GID 101 to match nginx
RUN usermod -u 101 www-data && \
    groupmod -g 101 www-data && \
    # Fix ownership of files that belonged to UID 33
    find / -user 33 -exec chown 101 {} \; 2>/dev/null || true && \
    find / -group 33 -exec chgrp 101 {} \; 2>/dev/null || true && \
    # Ensure WordPress directory has correct ownership
    chown -R www-data:www-data /var/www/html && \
    # Fix PHP-FPM to run as the new UID
    sed -i 's/user = www-data/user = www-data/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/group = www-data/group = www-data/g' /usr/local/etc/php-fpm.d/www.conf

# Create mu-plugins directory
RUN mkdir -p /var/www/html/wp-content/mu-plugins

# Copy domain validator plugin
COPY mu-plugins/domain-validator.php /var/www/html/wp-content/mu-plugins/

# Ensure correct ownership
RUN chown -R www-data:www-data /var/www/html/wp-content/mu-plugins

# Verify the change
RUN id www-data