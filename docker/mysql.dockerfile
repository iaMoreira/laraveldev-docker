FROM mysql:5.7
ADD ./docker/config/mysql-config.sql /
ENV MYSQL_ROOT_PASSWORD: myrootpass MYSQL_DATABASE: laravel MYSQL_USER: laravel MYSQL_PASSWORD: secret
RUN mysql -u root -p${MYSQL_ROOT_PASSWORD} "CREATE DATABASE laravel;"
RUN mysql -u root -p${MYSQL_ROOT_PASSWORD} "GRANT ALL ON laravel.* to 'laravel'@'localhost' IDENTIFIED BY 'secret';"
RUN mysql -u root -p${MYSQL_ROOT_PASSWORD} "FLUSH PRIVILEGES;"
