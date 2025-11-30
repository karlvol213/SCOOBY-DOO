FROM php:8.2-apache

# Enable Apache rewrite module
RUN a2enmod rewrite

# Install required PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Set Apache document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html

# Copy project files to Apache folder
COPY . /var/www/html/

# Set correct permissions for Apache
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Configure Apache
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf

# Expose port 80
# Expose default port
EXPOSE 80

# Use the PORT environment variable if provided by the platform (e.g. Railway).
# At container start we replace Apache's Listen directive with the runtime PORT
# then start the foreground process.
CMD ["/bin/bash", "-lc", "PORT_ENV=\${PORT:-80}; sed -ri \"s/Listen [0-9]+/Listen ${PORT_ENV}/g\" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf; apache2-foreground"]