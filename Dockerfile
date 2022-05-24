FROM php:8.1.4-fpm
LABEL maintainer="contact@oliviermariejoseph.fr"

ENV PHP_SECURITY_CHECHER_VERSION=1.2.0

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	git\
	nano \
	unzip \
	vim \
	zip \
	wget \
	&& rm -rf /var/lib/apt/lists/*

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
	install-php-extensions imagick gd  xdebug  pdo_mysql pdo_pgsql zip redis exif memcached mcrypt intl apcu opcache  msmtp

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

# Symfony tool
RUN wget https://get.symfony.com/cli/installer -O - | bash && \
	mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Security checker tool
RUN curl -L https://github.com/fabpot/local-php-security-checker/releases/download/v${PHP_SECURITY_CHECHER_VERSION}/local-php-security-checker_${PHP_SECURITY_CHECHER_VERSION}_linux_$(dpkg --print-architecture) --output /usr/local/bin/local-php-security-checker && \
	chmod +x /usr/local/bin/local-php-security-checker

# Xdebug (disabled by default, but installed if required)
# RUN pecl install xdebug-3.0.3 && docker-php-ext-enable xdebug

COPY msmtprc /etc/msmtprc
RUN chmod 600 /etc/msmtprc

# ADD xdebug.ini /usr/local/etc/php/conf.d/
ADD php.ini /usr/local/etc/php/conf.d/



WORKDIR /var/www

EXPOSE 9000