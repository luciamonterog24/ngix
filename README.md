# Proyecto de Implantación: Servidor Web Nginx

**Autora:** Lucía  
**Asignatura:** Servicios de Red e Internet  
**Curso:** 2024/2025  

---

## Índice de Contenidos

1. [Introducción](#introducción)  
2. [Comparativa: Nginx vs Apache](#comparativa-nginx-vs-apache)  
3. [Esquema de Red](#esquema-de-red)  
4. [Instalación y Puesta en Marcha](#instalación-y-puesta-en-marcha)  
5. [Casos Prácticos y Configuración](#casos-prácticos-y-configuración)  
6. [Referencias](#referencias)  

---

## Introducción

Este proyecto documenta la migración y despliegue de un **servidor web Nginx** para la empresa *Servicios Web RC, S.A.*.  
El objetivo es modernizar la infraestructura web, permitiendo:

- Alojamiento de múltiples sitios (**Virtual Hosting**).  
- Seguridad mediante **SSL/TLS**.  
- Control de acceso basado en **origen de red** y **autenticación de usuarios**.

---

## Comparativa: Nginx vs Apache

| Característica | Apache HTTP Server | Nginx |
| :--- | :--- | :--- |
| **Arquitectura** | Basada en procesos (bloqueante) | Orientada a eventos (asíncrona) |
| **Rendimiento** | Consume más RAM | Muy ligero y rápido |
| **Contenido estático** | Más lento | Sirve estáticos 2.5x más rápido |
| **Configuración** | Descentralizada (.htaccess) | Centralizada (nginx.conf) |

---

## Esquema de Red

El servidor (PC 03) tiene dos interfaces de red configuradas:

| Interfaz | Red | IP | Función |
| :--- | :--- | :--- | :--- |
| **enp0s3** | Interna | 192.168.3.10 | Gestión y clientes |
| **enp0s8** | Externa | DHCP (`10.0.3.x`) | Salida a Internet |

---

## Instalación y Puesta en Marcha

Instalación realizada en **Ubuntu 22.04**:

```bash
sudo apt update
sudo apt install nginx apache2-utils -y
```
## Verificación del Servicio

Verificar que Nginx está activo:

```bash
systemctl status nginx
```
## Casos Prácticos y Configuración

### A) Versión y Ficheros

* **Versión instalada:** `nginx version: nginx/1.18.0 (Ubuntu)`
* **Ficheros de configuración:** Se encuentran en la carpeta [conf](./conf).
* **Directorio web:** Las páginas HTML están en [html](./html). 

---

### B) Página Web por Defecto

Se ha personalizado la página que responde a `http://localhost`.
* **Archivo de configuración:** [000-default.conf](./conf/000-default.conf)
* **HTML:** [index.html](./html/default/index.html)
* **Contenido:** Se ha modificado el HTML para mostrar "Bienvenidos a Mi servidor web" y el nombre de la autora.

---

### C) Virtual Hosting

Se han configurado dos dominios compartiendo la misma IP.

**1. Sitio Público ([Ver HTML](./html/web1))**
* Configuración: [web1](./conf/web1)
* Código:
```nginx
server {
    listen 80;
    server_name www.web1.org;
    root /var/www/web1;
    index index.html;
}
```
**2. Sitio Interno ([Ver HTML](./html/web2))**
* Configuración: [web2](./conf/web2)
* Código:
```nginx
server {
    listen 80;
    server_name www.web2.org;
    root /var/www/web2;
    index index.html;
}
```

#### Web1 (Sitio Público)

Archivo: `/etc/nginx/sites-available/web1`

```nginx
server {
    listen 80;
    server_name www.web1.org;
    root /var/www/web1;
    index index.html;
}
```

#### Web2 (Sitio Interno)

Archivo: `/etc/nginx/sites-available/web2`

```nginx
server {
    listen 80;
    server_name www.web2.org;
    root /var/www/web2;
    index index.html;
}
```
### D) Control de Acceso por Red

Para `www.web2.org` solo accesible desde la red interna:

```nginx
location / {
    allow 192.168.3.0/24;
    deny all;
}
```
- Acceso permitido desde: `192.168.3.0/24`

- Acceso denegado (403) desde fuera

### E) Autenticación y Autorización

Carpeta [privado](./html/web1/privado) en web1 pide contraseña **solo si vienes de fuera**:
Configuración en [web1](./conf/web1):
```nginx
location /privado {
    satisfy any;
    allow 192.168.3.0/24;
    deny all;
    auth_basic "Zona privada";
    auth_basic_user_file /etc/nginx/.htpasswd;
}
```
- Usuario generado: `lucia`
### F) Seguridad SSL/TLS

Se ha habilitado HTTPS usando certificados ubicados en la carpeta [ssl](./ssl).

Configuración en [web1](./conf/web1):
```nginx
server {
    listen 443 ssl;
    server_name www.web1.org;
    ssl_certificate /etc/ssl/certs/web1.crt;
    ssl_certificate_key /etc/ssl/private/web1.key;
}
```
### Automatización

Se incluye un script de instalación automática:
* **Script:** [install_nginx.sh](./scripts/install_nginx.sh)

## Referencias

- [Documentación oficial de Nginx](https://nginx.org/en/docs/)  
- [DigitalOcean: Tutorial de instalación Nginx en Ubuntu 22.04](https://www.digitalocean.com/community/tutorials)  
- [Documentación de OpenSSL](https://www.openssl.org/docs/)  

