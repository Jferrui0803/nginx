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
sudo chown -R www-data:www-data /var/www/mipagweb/html
sudo chmod -R 755 /var/www/mipagweb

# 3. Configurar Nginx para servir el sitio web
# Crear archivo de configuración del sitio en sites-available
sudo bash -c 'cat > /etc/nginx/sites-available/mipagweb <<EOF
server {
    listen 80;
    listen [::]:80;
    root /var/www/mipagweb/html;
    index index.html index.htm index.nginx-debian.html;
    server_name www.jferrui.test;
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF'

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/mipagweb /etc/nginx/sites-enabled/

# Crear usuario jferrui
sudo adduser jferrui
echo "jferrui:jferrui" | sudo chpasswd

# Crea la carpeta (aunque debería estar creada al crear el usuario)
sudo mkdir /home/jferrui/ftp

# Permisos para la carpeta
sudo chown vagrant:vagrant /home/jferrui/ftp
sudo chmod 755 /home/jferrui/ftp

# Crear los certificados de seguridad
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/certs/vsftpd.crt

# Agregar el usuario jferrui al grupo www-data
sudo usermod -aG www-data jferrui

# Crear la nueva carpeta de la página web
sudo mkdir -p /var/www/Extreme-Sports

# Asignar permisos
sudo chown www-data:www-data /var/www/Extreme-Sports
sudo chmod 775 /var/www/Extreme-Sports

# Crear enlace simbólico en sites-enabled
sudo ln -s /etc/nginx/sites-available/Extreme-Sports /etc/nginx/sites-enabled/

# Reiniciar Nginx para aplicar los cambios
sudo systemctl restart nginx
# Si da un error de 404 FORBIDDEN ejecutar el siguiente comando
