#!/bin/bash

# Create a directory to store the certificates if it doesn't exist
mkdir -p /etc/nginx/ssl

# Check if the certificate already exists to avoid recreating it every time the container restarts
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Generating self-signed SSL certificate..."
    
    # Generate the certificate and key without a password prompt (-nodes)
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=JO/ST=Amman/L=Amman/O=42/OU=Student/CN=snazzal.42.fr"
    
    echo "SSL certificate generated successfully!"
fi

# Execute the primary command passed to the container (which will be our NGINX daemon command later)
exec "$@"