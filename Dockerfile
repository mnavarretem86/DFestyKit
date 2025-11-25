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
    libapache2-mod-php \
    mariadb-server \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------
# DESCARGAR WORDPRESS
# ---------------------------
RUN rm -rf /var/www/html/* && \
    wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress/* /var/www/html/ && \
    rm -rf latest.zip wordpress

# ---------------------------
# SOLUCIÓN AL CONTENIDO MIXTO (HTTPS EN RENDER)
# ---------------------------
# Creamos un .htaccess inicial para que Apache reconozca el proxy SSL de Render.
# Esto fuerza a WordPress a generar URLs con HTTPS durante la instalación.
RUN echo '<IfModule mod_setenvif.c>' > /var/www/html/.htaccess && \
    echo '  SetEnvIf X-Forwarded-Proto "^https$" HTTPS=on' >> /var/www/html/.htaccess && \
    echo '</IfModule>' >> /var/www/html/.htaccess

# ---------------------------
# ACTIVAR MÓDULOS NECESARIOS DE APACHE
# ---------------------------
RUN a2enmod rewrite
RUN a2enmod dir
RUN a2enmod mime
RUN a2enmod headers

# PERMITIR .htaccess Y URLs BONITAS
# Es importante que esto se ejecute para que el .htaccess creado arriba funcione.
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