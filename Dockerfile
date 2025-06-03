FROM php:8.1-apache

# Installer dépendances système & PHP
RUN apt-get update && apt-get install -y \
    unzip zip curl git libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql gd zip \
    && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Apache config
RUN a2enmod rewrite
ENV PORT=8080
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Récupérer la dernière version de HumHub
WORKDIR /var/www/html
RUN curl -L https://www.humhub.org/en/download/package/humhub-1.16.4.zip -o humhub.zip \
    && unzip humhub.zip -d humhub \
    && mv humhub/* . && rm -rf humhub humhub.zip

# Installer les dépendances PHP
RUN composer install --no-dev --optimize-autoloader --working-dir=protected

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/protected/runtime \
    && chmod -R 755 /var/www/html/uploads
