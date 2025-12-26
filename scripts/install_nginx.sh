#!/bin/bash

# Script de instalación automática de Nginx
# Proyecto: Servicios de Red e Internet
# Autora: Lucía

echo "--- Iniciando instalación de Nginx ---"

# 1. Actualizar repositorios
echo "Actualizando lista de paquetes..."
sudo apt update

# 2. Instalar Nginx y herramientas de Apache (para htpasswd)
echo "Instalando Nginx y apache2-utils..."
sudo apt install nginx apache2-utils -y

# 3. Comprobar estado
echo "Verificando servicio..."
systemctl status nginx --no-pager

echo "--- Instalación completada ---"
