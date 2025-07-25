FROM debian:bookworm

COPY bashrc /root/.bashrc

WORKDIR /php
RUN apt-get update && apt-get upgrade -y && apt-get install nginx php8.2-fpm php-pear php8.2-dev vim -y
COPY default /etc/nginx/sites-available/default

CMD ["/php/service.sh"]
