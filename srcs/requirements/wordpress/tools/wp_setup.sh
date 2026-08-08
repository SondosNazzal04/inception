#!/bin/bash
set -e

# Create runtime directory for PHP-FPM
mkdir -p /run/php

cd /var/www/wordpress

# Read passwords from docker secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
PORT="${DB_PORT:-3306}"
WP_PORT="${WP_PORT:-9000}"

# 1. Automatically find the www.conf file, regardless of OS or PHP version
WWW_CONF=$(find /etc -name "www.conf" 2>/dev/null | head -n 1)

# 2. Update the listen port dynamically (handles varying spaces)
if [ -n "$WWW_CONF" ]; then
    sed -i "s|^listen[[:space:]]*=.*|listen = 0.0.0.0:${WP_PORT}|g" "$WWW_CONF"
    echo "PHP-FPM configured to listen on port ${WP_PORT}"
else
    echo "Error: www.conf not found!"
fi

# Dynamically update PHP-FPM listen port in www.conf
# sed -i "s/listen = .*/listen = 0.0.0.0:${WP_PORT}/" /etc/php/*/fpm/pool.d/www.conf 2>/dev/null \
#     || sed -i "s/listen = .*/listen = 0.0.0.0:${WP_PORT}/" /etc/php-fpm.d/www.conf 2>/dev/null

# 1. WAIT FOR MARIADB TO BE READY
echo "Waiting for MariaDB to start..."
until mariadb-admin ping -h"mariadb" -P"${PORT}" -u"${DB_USER}" -p"${DB_PASSWORD}" --silent; do
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
        --dbhost=mariadb:${PORT} \
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