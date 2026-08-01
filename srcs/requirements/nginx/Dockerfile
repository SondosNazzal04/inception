FROM debian:bookworm

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/nginx_start.sh"]

CMD ["nginx", "-g", "daemon off;"]