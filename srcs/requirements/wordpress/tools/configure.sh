#!/bin/bash

# Ensure the PHP-FPM runtime directory exists
mkdir -p /run/php

# Download and install WP-CLI (WordPress command-line tool)
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Wait until MariaDB is ready to accept connections
until mysqladmin ping -h mariadb -u root -p$MYSQL_ROOT_PASSWORD --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# Navigate to the WordPress root directory
cd /var/www/html

# Install WordPress only if it's not already configured
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Configuring wp-config.php..."
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="$WP_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    # Create an additional WordPress user
    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --allow-root
fi

# Set full permissions on WordPress files (temporary; consider stricter permissions for production)
chmod -R 777 /var/www/html

# Start PHP-FPM in the foreground (no daemon mode)

php-fpm7.4 -F
# tail -f /dev/null
