FROM composer:2 AS composer

FROM php:8.2-fpm

# Arguments defined in docker-compose.yml
ARG user=www-data
ARG uid=1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mbstring exif pcntl bcmath gd

# Set working directory
COPY . /var/www/html

RUN composer install \
&& php artisan optimize

RUN chown -R www-data:www-data /var/www/html/storage

RUN chown -R www-data:www-data /var/www/html

RUN chown -R www-data:www-data /var/www/html/bootstrap/cache

RUN chmod -R 755 /var/www/html/storage

RUN chmod -R 777 /var/www/html

WORKDIR /var/www/html

USER www-data



