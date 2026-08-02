#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Initialize the data directory if it's empty (first run)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    # Initialize the database structure
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Start the server temporarily to configure it
    mysqld_safe --user=mysql &
    # Wait for the server to be ready
    until mysqladmin ping >/dev/null 2>&1; do
        sleep 1
    done

    echo "Configuring database users..."
    
    # Secure the installation and set up WordPress users
    # Read secrets from environment variables (passed by docker-compose)
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
    mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';"
    mysql -e "FLUSH PRIVILEGES;"

    echo "Shutting down temporary server..."
    # Gracefully shut down the temporary server
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    
    echo "Database setup completed successfully."
fi

# Execute the main command (mariadbd)
exec "$@"