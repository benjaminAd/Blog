FROM php:8.1-fpm-alpine

# Install system dependencies

RUN apk add --update --no-cache \
    autoconf \
    bash \
    g++ \
    make \
    curl \
    git \
    postgresql-dev

# Install PHP extensions
RUN docker-php-ext-install \
    pdo_pgsql \
    bcmath \
    opcache

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Symfony CLI
RUN wget https://get.symfony.com/cli/installer -O - | bash && mv /root/.symfony5/bin/symfony /usr/local/bin/symfony

# Copy project files
COPY . /var/www
WORKDIR /var/www

# Install project dependencies
RUN composer install --optimize-autoloader

# Change ownership of project files to www-data
RUN chown -R www-data:www-data /var/www

# Run the PHP-FPM process as www-data user
USER www-data

# Start the PHP-FPM process
CMD ["php-fpm"]