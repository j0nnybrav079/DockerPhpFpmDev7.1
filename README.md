# DockerPhpFpmDev7.1

This image offers the php 7.2-fpm-image including a bunch of helpful tools:
- curl 
- git 
- gd
- unzip 
- libpq-dev 
- libzip-dev 
- libicu-dev 
- libpng12-dev 
- libjpeg62-turbo-dev 
- libfreetype6-dev 
- libmagickwand-6.q16-dev 
- bcmath 
- intl 
- json 
- opcache 
- pdo 
- pdo_pgsql 
- pdo_mysql 
- pgsql 
- sockets 
- zip 
- xdebug 
- apcu 
- composer

Build information:
```bash
    $:docker build -t  dacoco/php_7-1_fpm_dev .
    $:docker push dacoco/php_7-1_fpm_dev
```  