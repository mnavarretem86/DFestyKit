#!/bin/bash

# Iniciar MariaDB
service mariadb start

# Crear base de datos y usuario si no existen
mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -u root -e "CREATE USER IF NOT EXISTS 'wpuser'@'localhost' IDENTIFIED BY 'wppass';"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Añadir configuraciones HTTPS al wp-config.php
echo "define('WP_HOME', 'https://dfestykit.onrender.com');" >> /var/www/html/wp-config.php
echo "define('WP_SITEURL', 'https://dfestykit.onrender.com');" >> /var/www/html/wp-config.php
echo "define('FORCE_SSL_ADMIN', true);" >> /var/www/html/wp-config.php

# Iniciar Apache
apachectl -D FOREGROUND