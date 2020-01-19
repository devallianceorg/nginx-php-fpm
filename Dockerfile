FROM php:7.2.15-fpm-alpine3.9
LABEL Maintainer="Matias Flores <matius77@gmail.com>" \
      Description="Contenedor con Nginx 1.12 & PHP-FPM 7.2.15 basado en Linux Alpine 3.9."

# iconv & gd
RUN apk --no-cache add \
        freetype-dev \
        libjpeg-turbo-dev \
 	libpng-dev \
        libmcrypt-dev \
  && docker-php-ext-install -j$(nproc) iconv \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd 

# Dependencias PHP 
RUN docker-php-ext-install bcmath mbstring mysqli pdo pdo_mysql

# Otros Packages
RUN apk --no-cache add \
	nginx \
	supervisor \
	curl \
	openssl \
	wget \
	git

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

RUN composer --version
