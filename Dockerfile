FROM php:7.0.3-fpm

ENV DEBIAN_FRONTEND noninteractive
COPY config/custom.ini /usr/local/etc/php/conf.d/

RUN apt-get clean && apt-get update && apt-get install -y zlib1g-dev libicu-dev libpq-dev libfreetype6 wget gdebi libmagickwand-dev libmagickcore-dev imagemagick \
    --no-install-recommends \
    && docker-php-ext-install opcache \
    && docker-php-ext-install intl \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install zip \
    ## APCu
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    # Image Magick
    && pecl install imagick \
    #&& docker-php-ext-enable imagick
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini

RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug
RUN echo 'zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so"' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_port=9001' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_connect_back=0' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_autostart=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_handler=dbgb' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_host=172.254.254.254' >> /usr/local/etc/php/php.ini

RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
RUN gdebi --n wkhtmltox-0.12.2.1_linux-jessie-amd64.deb

RUN mkdir -p /var/log/php-app
RUN chown www-data:www-data /var/log/php-app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


