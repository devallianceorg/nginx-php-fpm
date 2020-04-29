FROM microsoft/mssql-tools as mssql
FROM php:7.2-fpm-alpine
LABEL Maintainer="Matias Flores <matius77@gmail.com>" \
      Description="Contenedor con Nginx & PHP-FPM 7.2 basado en Linux Alpine"

COPY --from=mssql /opt/microsoft/ /opt/microsoft/
COPY --from=mssql /opt/mssql-tools/ /opt/mssql-tools/
COPY --from=mssql /usr/lib/libmsodbcsql-13.so /usr/lib/libmsodbcsql-13.so

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

# Driver ODBC
RUN set -ex; \
	docker-php-source extract; \
	{ \
		echo '# https://github.com/docker-library/php/issues/103#issuecomment-271413933'; \
		echo 'AC_DEFUN([PHP_ALWAYS_SHARED],[])dnl'; \
		echo; \
		cat /usr/src/php/ext/odbc/config.m4; \
	} > temp.m4; \
	mv temp.m4 /usr/src/php/ext/odbc/config.m4; \
	apk add --no-cache unixodbc-dev; \
	docker-php-ext-configure odbc --with-unixODBC=shared,/usr; \
	docker-php-ext-install odbc; \
	docker-php-source delete

# Driver sqlsrv
RUN set -xe \
    && apk add --no-cache libstdc++  \
    && apk add --no-cache --virtual .persistent-deps freetds unixodbc \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS unixodbc-dev freetds-dev \
    && docker-php-source extract \
    && docker-php-ext-install pdo_dblib \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable --ini-name 30-sqlsrv.ini sqlsrv \
    && docker-php-ext-enable --ini-name 35-pdo_sqlsrv.ini pdo_sqlsrv \
    && docker-php-source delete \
    && apk del .build-deps




