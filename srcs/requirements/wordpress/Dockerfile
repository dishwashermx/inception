# Base image
FROM debian:bullseye

# Install PHP (FPM & MySQL extension), curl for wp-cli, unzip for WordPress zip files, and mariadb-client to ping/check the database
RUN apt-get update && apt-get install -y \
    php php-fpm php-mysql curl unzip mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ✅ Make sure this version matches your installed PHP version.
# ⚠ You are using php7.4 (as Bullseye comes with it by default), so adjust the path accordingly
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Prepare the web root and set permissions
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

# Copy in the WordPress setup script and make it executable
COPY tools/configure.sh /configure.sh
RUN chmod +x /configure.sh

# Set working directory for WP installation
WORKDIR /var/www/html

# Expose the PHP-FPM port
EXPOSE 9000

# Start script which downloads and configures WordPress
ENTRYPOINT ["/configure.sh"]
