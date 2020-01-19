FROM alpine:3.6
LABEL Maintainer="Matias Flores <matius77@gmail.com>" \
      Description="Contenedor con Nginx & PHP-FPM 7.1 basado en Linux Alpine."

# Install packages
RUN apk --no-cache add php7 \
	php7-fpm \
	php7-pdo \
	php7-pdo_mysql \
	php7-intl \
	php7-xml \
	php7-xmlwriter \
	php7-xmlreader \
	php7-common \
	php7-tokenizer \
	php7-json \
	php7-openssl \
	php7-curl \
    	php7-zlib \
	php7-phar \
	php7-dom \
	php7-ctype \
	php7-mcrypt \
    	php7-mbstring \
	php7-fileinfo \
	php7-gd \
	php7-pcntl \
	php7-posix \
	php7-session \
	php7-iconv \
	nginx \
	supervisor \
	curl \
	openssl \
	wget \
	git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
        --install-dir=/usr/local/bin \
        --filename=composer
