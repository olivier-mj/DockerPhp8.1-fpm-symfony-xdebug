FROM php:8.0-fpm
LABEL maintainer="contact@oliviermariejoseph.fr"

RUN apt-get update && apt-get install -y \
      wget \
      git \
      imagemagick \
      nano

RUN apt-get update && apt-get install -y libzip-dev libicu-dev && docker-php-ext-install pdo zip intl opcache

# Support de apcu
RUN pecl install apcu && docker-php-ext-enable apcu

# Support de redis
RUN pecl install redis && docker-php-ext-enable redis

# Support de MySQL 
RUN docker-php-ext-install mysqli pdo_mysql

# Imagick
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && pecl install imagemagick && docker-php-ext-enable imagemagick

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Symfony tool
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
  mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Xdebug (disabled by default, but installed if required)
 RUN pecl install xdebug-3.0.3 && docker-php-ext-enable xdebug
 ADD xdebug.ini /usr/local/etc/php/conf.d/

WORKDIR /var/www

EXPOSE 9000