#!/bin/bash

set -e

DB_PASS=$(cat /run/secrets/db_password)
DB_ROOT_PASS=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "No existing database found, initializing..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Start MariaDB temporarily without networking
    mysqld_safe --datadir=/var/lib/mysql --skip-networking &

    # Wait until MariaDB is ready
    until mysqladmin ping --silent; do
        sleep 1
    done

    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

    # Shut down temporary server
    mysqladmin -u root -p"${DB_ROOT_PASS}" shutdown
else
    echo "Existing database found, skipping initialization."
fi

# Start MariaDB in the foreground
exec mysqld_safe --datadir=/var/lib/mysql