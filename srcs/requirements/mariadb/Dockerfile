# base of the os of the container
FROM debian:bookworm

# installing neccesary packages
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*

# copy the configuration file and use the one that we made
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# copying the script to the container and running it 
COPY tools/db_setup.sh /usr/local/bin/db_setup.sh
RUN chmod +x /usr/local/bin/db_setup.sh

RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld

EXPOSE 3306

# Run the setup script on startup
ENTRYPOINT ["/usr/local/bin/db_setup.sh"]

# Run MariaDB in the foreground
# CMD ["mariadbd", "--user=mysql"]