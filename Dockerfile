FROM php:8.2-fpm-alpine3.17

# install necessary alpine packages
RUN apk update && apk add --no-cache \
    zip \
    unzip \
    dos2unix \
    supervisor \
    libpng-dev \
    libzip-dev \
    freetype-dev \
    $PHPIZE_DEPS \
    libjpeg-turbo-dev \
    rabbitmq-c rabbitmq-c-dev \
    icu-dev \
    bash \
    git \
    aws-cli \
    jq

#RUN php -v

#RUN php -m

RUN apk add --no-cache linux-headers

# compile native PHP packages
RUN docker-php-ext-install \
    bcmath \
    gd \
    pcntl \
    mysqli \
    pdo_mysql \
    sockets

# configure packages
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-configure intl && docker-php-ext-install intl

# install additional packages from PECL
RUN pecl install amqp && docker-php-ext-enable amqp \
    && pecl install zip && docker-php-ext-enable zip \
    && pecl install igbinary && docker-php-ext-enable igbinary \
    && pecl install swoole && docker-php-ext-enable swoole 

RUN pecl install mongodb && docker-php-ext-enable mongodb 
    
RUN pecl install redis && docker-php-ext-enable redis

#RUN yes | pecl install redis && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --ansi --version --no-interaction

#RUN yes | pecl install mongodb && docker-php-ext-enable mongodb \
#    yes | pecl install redis && docker-php-ext-enable redis
RUN apk update && apk add --no-cache \
    nodejs \
    npm

RUN npm install -g serverless 
# install composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
#    && composer --ansi --version --no-interaction

WORKDIR /var/www/html/

# run supervisor
# CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

