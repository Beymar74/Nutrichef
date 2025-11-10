FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Instalar Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Obtener Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Exponer puerto
EXPOSE 8000

# Comando por defecto
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]