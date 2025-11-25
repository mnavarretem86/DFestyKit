#!/bin/bash

# Iniciar MariaDB
service mariadb start

# Crear base de datos y usuario
mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress;"
mysql -u root -e "CREATE USER IF NOT EXISTS 'wpuser'@'localhost' IDENTIFIED BY 'wppass';"
mysql -u root -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Iniciar Apache
apachectl -D FOREGROUND