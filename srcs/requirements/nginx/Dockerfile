# base of the os of the container
FROM debian:bookworm
# installing neccesary packages
RUN apt-get update && apt-get install -y nginx openssl

#------------------------------------------------

# copying the script to the container and running it 
COPY tools/nginx_start.sh /usr/local/bin/nginx_start.sh
RUN chmod +x /usr/local/bin/nginx_start.sh

#------------------------------------------------

# copy the configuration file and use the one that we made
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# makes sure that this script must run every time that the container starts
ENTRYPOINT ["/usr/local/bin/nginx_start.sh"]

# forbids
CMD ["nginx", "-g", "daemon off;"]