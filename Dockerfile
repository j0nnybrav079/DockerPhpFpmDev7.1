FROM php:7.1-fpm

# Get repository and install wget and vim
RUN apt-get update && apt-get install --no-install-recommends -y \
        curl \
        git \
        unzip \
        vim \
        wget

# Add PostgreSQL repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
      apt-key add -

# Install PHP extensions deps
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        freetds-dev \
        g++ \
        libaio-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmagickwand-6.q16-dev \
        libmcrypt-dev \
        libmemcached-dev \
        libpng12-dev \
        libssl-dev \
        libxml2-dev \
        openssl \
        postgresql-server-dev-9.5 \
        unixodbc-dev \
        zlib1g-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu \
    && pecl install sqlsrv-4.1.6.1 \
    && pecl install pdo_sqlsrv-4.1.6.1 \
    && pecl install redis \
    && pecl install memcached \
    && docker-php-ext-install \
        bcmath \
        ftp \
        gd \
        iconv \
        intl \
        json \
        mbstring \
        mcrypt \
        mysqli \
        opcache \
        pcntl \
        pgsql \
        pdo_pgsql \
        pdo_mysql \
        pdo_dblib \
        soap \
        sockets \
        zip \
    && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 \
    && pecl install xdebug \
        && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_host=$remoteIp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
        && pecl install imagick \
        && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && docker-php-ext-enable \
        sqlsrv \
        pdo_sqlsrv \
        redis \
        memcached \
        opcache

# Install APCu and APC backward compatibility
RUN pecl install apcu \
    && pecl install apcu_bc-1.0.3 \
    && docker-php-ext-enable apcu --ini-name 10-docker-php-ext-apcu.ini \
    && docker-php-ext-enable apc --ini-name 20-docker-php-ext-apc.ini

# Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar -O /usr/local/bin/phpunit \
    && chmod +x /usr/local/bin/phpunit

# Clean repository
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*