# Base image avec PHP, Apache et extensions nécessaires
FROM php:8.1-apache

# Installer les dépendances système + Composer
RUN apt-get update && apt-get install -y \
    unzip zip curl git libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev \
    && docker-php-ext-install pdo pdo_mysql gd zip \
    && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Activer mod_rewrite d'Apache
RUN a2enmod rewrite

# Définir le port pour Render (Render utilise $PORT)
ENV PORT=8080
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf

# Copier les fichiers HumHub dans l'image
WORKDIR /var/www/html

# Copier tout le contenu de HumHub dans l'image Docker
COPY . .

# Installer les dépendances via Composer
RUN composer install --no-dev --optimize-autoloader --working-dir=protected

# Appliquer les bons droits pour Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/protected/runtime \
    && chmod -R 755 /var/www/html/uploads

# Terminé !
