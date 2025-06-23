FROM debian:bookworm

COPY bashrc /root/.bashrc

WORKDIR /php
RUN apt-get update && apt-get upgrade -y && apt-get install nginx php8.2-fpm php-pear php8.2-dev unixodbc-dev software-properties-common -y && \
    (add-apt-repository ppa:ondrej/php -y || true) && pecl config-set php_ini /etc/php/8.2/fpm/php.ini && pecl install sqlsrv pdo_sqlsrv && \
    printf "\nextension=sqlsrv.so\nextension=pdo_sqlsrv.so" >> /etc/php/8.2/fpm/php.ini && \
    /php/odbc.sh
COPY default /etc/nginx/sites-available/default

CMD ["/php/service.sh"]
