#!/bin/bash

set -e

DB_PASS=$(cat /run/secrets/db_password)
DB_ROOT_PASS=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "No existing database found, initializing..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Start MariaDB temporarily without networking
    mariadbd-safe --datadir=/var/lib/mysql --skip-networking &

    # Wait until MariaDB is ready
    until mariadb-admin ping --silent; do
        sleep 1
    done

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

-- Grant access across the Docker network (for WordPress container)
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';

-- Grant access locally inside the MariaDB container (for evaluation CLI tests)
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';

FLUSH PRIVILEGES;
EOF

    # Shut down temporary server
    mariadb-admin -u root -p"${DB_ROOT_PASS}" shutdown
else
    echo "Existing database found, skipping initialization."
fi

# Start MariaDB in the foreground
# exec mysqld_safe --datadir=/var/lib/mysql
exec "$@"
