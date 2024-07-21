FROM php:7.4-fpm-alpine
ENV APP_ROOT /var/www/app
WORKDIR $APP_ROOT

# install packages
RUN apk update && \
    apk upgrade && \
    apk add --update --no-cache \
    autoconf \
    bash \
    build-base \
    curl-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    make \
    mysql-dev \
    mysql-client \
    openssl \
    sudo \
    vim \
    redis \
    yaml-dev \
    zlib-dev

RUN docker-php-ext-install pdo_mysql soap

# PHP
RUN addgroup -S nginx
RUN adduser -S nginx -G nginx
RUN mkdir /var/run/php-fpm
RUN rm -f /usr/local/etc/php-fpm.conf.default
RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf
RUN rm -f /usr/local/etc/php-fpm.d/www.conf.default.conf
COPY php/php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php/php.ini /usr/local/etc/php/php.ini
COPY php/www.conf /usr/local/etc/php-fpm.d/www.conf

RUN pecl install redis

# composer install
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.2.6 --install-dir=/usr/bin
RUN mv /usr/bin/composer.phar /usr/bin/composer

CMD ["/usr/local/sbin/php-fpm", "-F"]