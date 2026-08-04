# Phase 1: Base OS and Packages
FROM debian:bookworm

# Install PHP, PHP-FPM, the MySQL extension, and curl to download WP-CLI
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Download WP-CLI and make it executable
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Phase 3: PHP Configuration
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Phase 2: Initialization Script
COPY tools/wp_setup.sh /usr/local/bin/wp_setup.sh
RUN chmod +x /usr/local/bin/wp_setup.sh

# Document the FastCGI port
EXPOSE 9000

# Execute the setup script on startup
ENTRYPOINT ["/usr/local/bin/wp_setup.sh"]

# Phase 4: Main Event Loop (PID 1)
CMD ["/usr/sbin/php-fpm8.2", "-F"]