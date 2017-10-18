FROM php:7.1-fpm

MAINTAINER j0nnybrav079

ARG remoteIp

RUN apt-get update \
    && apt-get install -y \
        curl \
        git \
        unzip \
        libpq-dev \
        libzip-dev \
        libicu-dev \
        libpng12-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libmagickwand-6.q16-dev \
        --no-install-recommends \
    && docker-php-ext-install \
        bcmath \
        intl \
        json \
        opcache \
        pdo \
        pdo_pgsql \
        pdo_mysql \
        pgsql \
        sockets \
        zip \
    && pecl install xdebug \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_host=$remoteIp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
        && pecl install imagick \
        && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && pecl install apcu \
       && pecl install apcu_bc-1.0.3 \
       && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
       && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
        && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
        && php -r "unlink('composer-setup.php');" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*