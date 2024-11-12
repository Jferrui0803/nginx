#!/bin/bash

# 1. Actualizar repositorios, instalar Nginx, instalar git para traer el repositorio
apt update
apt install -y nginx git vsftpd

# Verificar que Nginx esté funcionando
sudo systemctl status nginx

# 2. Crear la carpeta del sitio web
sudo mkdir -p /var/www/mipagweb/html

# Clonar el repositorio de ejemplo en la carpeta del sitio web
git clone https://github.com/cloudacademy/static-website-example /var/www/mipagweb/html

# Asignar permisos adecuados
sudo chown -R www-data:www-data /var/www/
sudo chmod -R 775 /var/www/


# 3. Configurar Nginx para servir el sitio web
# Crear archivo de configuración del sitio en sites-available
sudo cp /vagrant/mipagweb /etc/nginx/sites-available/

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/mipagweb /etc/nginx/sites-enabled/

# Crear usuario jferrui
sudo adduser jferrui
echo "jferrui:jferrui" | sudo chpasswd

# Crea la carpeta (aunque debería estar creada al crear el usuario)
sudo mkdir -p /home/jferrui/ftp
sudo chown jferrui:jferrui /home/jferrui/ftp
sudo chmod 775 /home/jferrui/ftp

# Crear los certificados de seguridad
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt -subj "/C=ES/ST=Granada/L=Granada/O=Global Security/OU=IES ZAIDIN VERGELES/CN=extreme-sports.test"

# Subir el archivo de configuración de vsftpd
sudo cp -v /vagrant/vsftpd.conf /etc/vsftpd.conf

# Reiniciar el servicio de vsftpd
sudo systemctl start  vsftpd

# Agregar el usuario jferrui al grupo www-data
sudo usermod -aG www-data jferrui

# Crear la nueva carpeta de la página web
sudo mkdir -p /var/www/Extreme-Sports/html/

# Asignar permisos
sudo chown -R www-data:www-data /var/www/Extreme-Sports    #dar permisos a /var/www para hacer la transferecia en Filezilla
sudo chmod -R 775 /var/www/Extreme-Sports/

# Copiar archivo de configuración desde /vagrant a /etc/nginx/sites-available
sudo cp /vagrant/Extreme-Sports /etc/nginx/sites-available/

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/Extreme-Sports /etc/nginx/sites-enabled/

# Verificar la configuración de Nginx antes de reiniciar
sudo nginx -t

# Reiniciar Nginx para aplicar los cambios
sudo systemctl restart nginx

# Verificar que Nginx esté funcionando
sudo systemctl status nginx

