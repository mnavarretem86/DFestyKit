FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ---------------------------
# INSTALAR DEPENDENCIAS
# ---------------------------
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

# ---------------------------
# DESCARGAR WORDPRESS
# ---------------------------
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress/* /var/www/html/ && \
    rm -rf latest.zip wordpress

# ---------------------------
# BORRAR PÁGINA POR DEFECTO DE APACHE
# ---------------------------
RUN rm -f /var/www/html/index.html

# ---------------------------
# ACTIVAR MÓDULOS NECESARIOS DE APACHE
# ---------------------------
RUN a2enmod rewrite
RUN a2enmod dir
RUN a2enmod mime

# PERMITIR .htaccess Y URLs BONITAS
RUN sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

# ---------------------------
# PERMISOS CORRECTOS
# ---------------------------
RUN chown -R www-data:www-data /var/www/html

# ---------------------------
# COPIAR SCRIPT DE INICIO
# ---------------------------
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
