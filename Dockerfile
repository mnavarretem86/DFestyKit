FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    php-curl \
    php-xml \
    php-gd \
    php-mbstring \
    php-zip \
    php-soap \
    php-intl \
    mariadb-server \
    wget \
    unzip

# Descargar WordPress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress/* /var/www/html/ && \
    rm -rf latest.zip wordpress

# Borrar página por defecto
RUN rm -f /var/www/html/index.html

# Activar módulos necesarios
RUN a2enmod rewrite
RUN a2enmod dir
RUN a2enmod mime

# Permitir .htaccess
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# Crear .htaccess con FORCE HTTPS
RUN echo "<IfModule mod_rewrite.c>" > /var/www/html/.htaccess && \
    echo "RewriteEngine On" >> /var/www/html/.htaccess && \
    echo "RewriteCond %{HTTPS} !=on" >> /var/www/html/.htaccess && \
    echo "RewriteRule ^ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]" >> /var/www/html/.htaccess && \
    echo "</IfModule>" >> /var/www/html/.htaccess

RUN chown -R www-data:www-data /var/www/html

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]