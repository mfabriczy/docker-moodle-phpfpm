FROM php:7.1-fpm-alpine

RUN mkdir /var/moodledata \
&& mkdir /var/moodle_behat_output \
&& chmod 777 /var/moodledata

RUN apk update && apk add --no-cache postgresql-dev icu-dev zlib-dev libpng-dev libxml2-dev libxslt-dev \
    $PHPIZE_DEPS \
    && docker-php-ext-configure pgsql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pgsql pdo_pgsql zip gd soap xmlrpc opcache xsl intl exif

RUN pecl install xdebug-2.6.1 redis-4.2.0 \
&& docker-php-ext-enable xdebug redis \
&& rm -r /tmp/pear

RUN echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level = 512" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port = 9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host = host.docker.internal " >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Set the WORKDIR to execute commands within the moodle directory. Used with the Moodle install_database.php
# script from the host machine and for Moodle scripts, e.g. purge caches, etc.
WORKDIR /usr/share/nginx/html/moodle