FROM php:7.1.0-fpm

ENV DEBIAN_FRONTEND noninteractive

COPY config/custom.ini /usr/local/etc/php/conf.d/
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/php-fpm.conf /usr/local/etc/php/php-fpm.conf

RUN apt-get clean && apt-get update && apt-get install -y zlib1g-dev libicu-dev libpq-dev libfreetype6 wget gdebi libmagickwand-dev libmagickcore-dev imagemagick python-pip python-dev supervisor \
    --no-install-recommends --fix-missing \
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

RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
RUN gdebi --n wkhtmltox-0.12.2.1_linux-jessie-amd64.deb

# Install new relic
RUN mkdir -p /opt/newrelic
WORKDIR /opt/newrelic
RUN wget -r -nd --no-parent -Alinux.tar.gz \
    http://download.newrelic.com/php_agent/release/ >/dev/null 2>&1 \
    && tar -xzf newrelic-php*.tar.gz --strip=1
ENV NR_INSTALL_SILENT true
ENV NR_INSTALL_PHPLIST /usr/local/bin/
RUN bash newrelic-install install
WORKDIR /
RUN pip install newrelic-plugin-agent
RUN mkdir -p /var/log/newrelic
RUN mkdir -p /var/run/newrelic

# disable New Relic by default (allows enable by ENV VAR at runtime)
#RUN mv /usr/local/etc/php/conf.d/newrelic.ini /usr/local/etc/php/conf.d/newrelic.ini.dist

RUN mkdir -p /var/log/php-app
RUN chown www-data:www-data /var/log/php-app

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

#this is done to kill the initial run of php-fpm
#from the inherited docker container
CMD ["killall", "-9", "php-fpm"]

CMD ["/usr/bin/supervisord", "-n"]