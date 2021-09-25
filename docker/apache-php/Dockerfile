FROM phpearth/php:7.3-apache

ARG PUID
ARG PGID

RUN apk update && \
    apk add curl npm yarn git openssh-client sqlite php7.3-sqlite3 php7.3-pdo_sqlite php7.3-gd php7.3-mysqli php7.3-pdo_mysql php7.3-intl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apk --no-cache add shadow

RUN /usr/sbin/usermod -u $PUID apache && /usr/sbin/groupmod -g $PGID apache && chown apache:apache /var/www

RUN npm install -g gulp

WORKDIR /var/www/localhost/htdocs

COPY default.conf /etc/apache2/conf.d/default.conf
COPY httpd.conf /etc/apache2/httpd.conf
