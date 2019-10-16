FROM eboraas/apache-php:stretch
MAINTAINER Ian Andrade Moreira
# utils
RUN apt-get update && apt-get -y install git nano curl php-mcrypt php-json php-mbstring php-zip php-dom && apt-get -y autoremove && apt-get clean && rm -r /var/lib/apt/lists/*

RUN /usr/sbin/a2enmod rewrite
COPY ./docker/config/apache2.conf /etc/apache2/

ADD ./docker/config/000-laraveldev.conf /etc/apache2/sites-available/
ADD ./docker/config/001-laraveldev-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-laraveldev 001-laraveldev-ssl

RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer
RUN /usr/local/bin/composer create-project laravel/laravel /var/www/laravel --prefer-dist
RUN /bin/chown www-data:www-data -R /var/www/laravel/storage /var/www/laravel/bootstrap/cache
COPY ./docker/phpMyAdmin /var/www/phpMyAdmin
ENTRYPOINT service apache2 restart && /bin/bash
EXPOSE 80
EXPOSE 443
