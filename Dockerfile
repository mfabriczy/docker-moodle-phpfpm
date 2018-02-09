FROM php:7.0.24-fpm

RUN mkdir /var/moodledata \
&& mkdir /var/moodle_behat_output \
&& chmod 777 /var/moodledata

RUN apt-get update && apt-get install -y libpq-dev libicu-dev zlib1g-dev libpng-dev libxml2-dev php-soap \
    && docker-php-ext-configure pgsql \
    && docker-php-ext-install pgsql pdo_pgsql zip gd soap \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && rm -rf /var/lib/apt/lists/*

RUN pecl install xdebug \
&& docker-php-ext-enable xdebug

# We'll need generate a locale which is necessary for PHPUnit
RUN echo "en_AU.UTF-8 UTF-8" >> /etc/locale.gen \
&& apt-get update && apt-get install -y locales

RUN apt-get clean

# Set the WORKDIR to execute commands within the moodle directory. Used with the Moodle install_database.php
# script from the host machine and for Moodle scripts, e.g. purge caches, etc.
WORKDIR /usr/share/nginx/html/moodle
