FROM php:8.2-fpm

# Argumentos de construcción
ARG user=nutrichef
ARG uid=1000

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip

# Limpiar cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Obtener Composer desde la imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /var/www

# Copiar archivos del proyecto
COPY backend/ /var/www/

# IMPORTANTE: Instalar dependencias de Composer
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Generar el archivo .env si no existe (copiar desde .env.example)
RUN if [ ! -f .env ]; then cp .env.example .env; fi

# Generar la clave de la aplicación
RUN php artisan key:generate --force

# Dar permisos correctos DESPUÉS de instalar dependencias
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

# Exponer puerto 8000
EXPOSE 8000

# Ejecutar como www-data
USER www-data

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]