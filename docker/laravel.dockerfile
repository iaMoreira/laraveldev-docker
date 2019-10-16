FROM  php:7.2-apache
LABEL maintainer="Ian Andrade Moreira"
LABEL version="1.0"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install git nano curl zip unzip  && apt-get -y autoremove && apt-get clean && rm -r /var/lib/apt/lists/*
RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN /usr/sbin/a2enmod rewrite
ADD ./docker/config/000-laravel.conf /etc/apache2/sites-available/
ADD ./docker/config/001-laravel-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-laravel 001-laravel-ssl
RUN curl -sS https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer && \
  chmod +x /usr/local/bin/composer

RUN /usr/local/bin/composer create-project laravel/laravel /var/www/laravel --prefer-dist
RUN /bin/chown www-data:www-data -R /var/www/laravel/storage /var/www/laravel/bootstrap/cache
COPY ./docker/config/.env /var/www/laravel/
RUN service apache2 restart
WORKDIR /var/www/laravel
EXPOSE 80

