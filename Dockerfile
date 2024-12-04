# Dockerfile for PHP 8.2
FROM php:8.2-fpm

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libonig-dev libpng-dev libxml2-dev libzip-dev zip unzip curl git vim \
	default-mysql-client mariadb-client

RUN docker-php-ext-install mysqli pdo pdo_mysql zip gd mbstring

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mysql --version && mysqldump --version

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

RUN cd ~ && git clone https://github.com/modmore/Gitify.git && cd Gitify && composer install --no-dev && chmod +x bin/gitify && cd -

# Install Gitify
RUN echo "alias gitify=/root/Gitify/bin/gitify" >> /root/.bashrc

RUN echo "date.timezone=Asia/Bangkok" >> /usr/local/etc/php/conf.d/datetime.ini

# Set working directory
WORKDIR /var/www/html

VOLUME /var/www/html

RUN usermod -u 1000 www-data

RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 9000

CMD [ "php-fpm" ]
