FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    libzip-dev \
    zip \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd zip

# Instalar Redis
RUN pecl install redis && docker-php-ext-enable redis

# Composer (copiado desde imagen oficial)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Directorio de trabajo
WORKDIR /var/www

# Copiar composer.json y composer.lock desde backend (si existe)
COPY backend/composer*.json ./

# Instalar dependencias SIN ejecutar scripts post-install
RUN composer install --optimize-autoloader --no-interaction --prefer-dist --no-scripts

# Copiar todo el backend dentro del contenedor y asignar propietario en la copia
COPY --chown=www-data:www-data backend/ .

# Limpiar cache de bootstrap ANTES de ejecutar scripts
RUN rm -rf bootstrap/cache/*.php

# Ahora ejecutar los scripts de Composer (ahora que artisan ya existe)
RUN composer run-script post-autoload-dump --no-interaction || true

# Regenerar autoload limpio
RUN composer dump-autoload --optimize

# Limpiar configuraciones de Laravel
RUN php artisan config:clear || true && \
    php artisan cache:clear || true && \
    php artisan route:clear || true && \
    php artisan view:clear || true

# Ajustar permisos adicionales si hace falta (opcional)
RUN chmod -R 755 /var/www/storage /var/www/bootstrap/cache || true

EXPOSE 8000

# Comando por defecto
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]