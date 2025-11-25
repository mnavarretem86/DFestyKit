FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias
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

# Eliminar la página por defecto de Apache
RUN rm -f /var/www/html/index.html

# Permisos correctos
RUN chown -R www-data:www-data /var/www/html

# Copiar script de inicio
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
