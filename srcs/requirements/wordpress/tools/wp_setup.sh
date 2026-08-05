#!/bin/bash
set -e

# Create runtime directory for PHP-FPM
mkdir -p /run/php

cd /var/www/wordpress

# Read passwords from docker secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# 1. WAIT FOR MARIADB TO BE READY
echo "Waiting for MariaDB to start..."
until mariadb-admin ping -h"mariadb" -u"${DB_USER}" -p"${DB_PASSWORD}" --silent; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is up and running!"

# 2. CONFIGURE AND INSTALL WORDPRESS
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress core files..."
    wp core download --allow-root --force

    echo "Configuring database connection..."
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=mariadb:3306 \
        --allow-root

    echo "Installing WordPress core..."
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception WordPress" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

    echo "Creating secondary user..."
    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root
fi

# Set proper permissions so NGINX can read the files
chown -R www-data:www-data /var/www/wordpress

# Execute PID 1 process (PHP-FPM)
exec "$@"