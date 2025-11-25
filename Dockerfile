FROM ubuntu:22.04

# Variables
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar paquetes
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
    rm -rf wordpress latest.zip

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html

# Inicializar base de datos MariaDB
RUN service mariadb start && \
    mysql -u root -e "CREATE DATABASE wordpress;" && \
    mysql -u root -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'wppass';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';" && \
    mysql -u root -e "FLUSH PRIVILEGES;"

# Exponer port 80
EXPOSE 80

# Script de inicio
CMD service mariadb start && apachectl -D FOREGROUND
