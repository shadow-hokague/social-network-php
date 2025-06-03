FROM php:8.1-apache

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    libicu-dev \
    libmcrypt-dev \
    libpq-dev \
    libxslt-dev \
    libldap2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libssh2-1-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip intl

# Activer mod_rewrite
RUN a2enmod rewrite

# Copier les fichiers de l'application
COPY . /var/www/html/

# Définir les permissions
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Exposer le port 80
EXPOSE 80
