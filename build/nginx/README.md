# Docker - Nginx

## build args
- IMAGE_TAG=1.23.3-alpine
- BUILD_TAG_PREFIX<br>
Is used to TAG the built image, actually set: _webfux/nginx_

## included extensions
- bash
- nano
- openssl
- tzdata

## docker-entrypoint.t
This folder provides a collection of usefully scripts.<br>
To use our examples, move/copy the files to /docker-entrypoint.d folder.
```
# Dockerfile

RUN cp /docker-entrypoint.t/00-unix-socket-user.sh /docker-entrypoint.d 
```
### 00-unix-socket-user.sh
Adds a new usergroup "socket" and attaches the nginx.conf based user to this group.<br>
It´s mandatory to share access between PHP-FPM and NGINX by sockets.<br>
```
ENV NGINX_CONF_FILE="/etc/nginx/nginx.conf"
ENV NGINX_SOCKET_GROUP="socket"
ENV NGINX_SOCKET_GROUP_ID=3000
```
## docker-healthcheck
The docker-healthcheck script is identically to /docker-entrypoint.sh logic.<br>
It does:
1. find all files in /user/local/bin/docker-healthcheck.d/
  2. execute all *.sh files<br>

Usage:
```
# Dockerfile
HEALTHCHECK --interval=5s --timeout=1s CMD /docker-healthcheck || exit 1
```
```
# docker-compose.yml
# !! docker-compose.yml verion 3.9 required !!
    depends_on:
      app:
        condition: service_healthy
```
## docker-healthcheck.t
This folder provides a collection of usefully scripts.<br>
To use our examples, move/copy the files to /docker-healthcheck.d folder.
```
# Dockerfile

RUN cp /docker-healthcheck.t/00-ping.sh /docker-healthcheck.d 
```
## location.t
Most of the location directives are common. folder /location.t provides a couple of this common location patterns.

e.g. /etc/nginx/location.t/assets-doc.conf
```
    ###############################################################
    # serve static files (images,js) directly
    location ~* ^.+.(txt|md|doc|docx|pdf|xls|xlsx)$ {
        access_log      off;
        expires 30d;
    }
```

example for an included /conf.d/*.conf
```
    server {
        listen [::]:80;
        listen 80;

        server_name www.dev.webfux.io;

        error_log  /var/log/nginx/www.error.log;
        access_log /var/log/nginx/www.access.log;

        root /var/www/html;

        include /etc/nginx/location.t/assets-doc.conf;
    }
```
### How to (FAQ)
Get for most common questions answers 
#### Forward all HTTP to HTTPS
```
    server {
      listen 80 default_server;
      listen [::]:80 default_server;
      return 301 https://$host$request_uri;
    }
```

#### Config template with environment vars
example
```
# /etc/nginx/templates/default.conf.template
server {
    listen 80;
    listen [::]:80;
    server_name  ${NGINX_SERVER};
}
```
docker-compose.yml
```
services:
  webserver:
    environment:
      NGINX_SERVER: www.example.io
```
On startup, the nginx entrypoint script scans this directory for files with *.template suffix by default, and it runs envsubst. The envsubst parse the template using the shell interpolation and replaces shell variables with values from environment variables. It outputs to a file in /etc/nginx/conf.d/.

result
```
# /etc/nginx/templates/default.conf
  server {
    listen 80;
    listen [::]:80;
    server_name  www.example.io;
  }
```
#### Protect undefined server_names
Based on our example above we´ve created a server_name directive only for "www.example.io". But, if any other DNS resolves to the same NGINX you will protect unknown/-defined server_name(s). To do this, just add the next lines on top.
```
  server {
    listen [::]:80 default_server;
    listen 80 default_server;
    return 403;
  }
```
for 80, 443
```
  server {
    listen 80 default_server;
    listen [::]:80 default_server;
    listen 443 default_server;
    listen [::]:443 default_server;
    
    # ssl keys for default server
    #
    #
        
    return 403;
  }
```
#### Cross Origin issue
example:
We have subdomains for 
- frontend (e.g. www.webfux.io)
- backend (e.g. api.webfux.io)

Frontend wants to connect to api.webfux.io **=> "Cross Origin" problem**<br>

how to solve:
```
  location ~ ^/index\.php(/|$) {
    # cross origin section
    # allow cross origin for all http_origins from same DOMAIN
    set $cors "";
    if ($http_origin ~* (.*\.${APP_DOMAIN})) {
      set $cors "true";
    }
    if ($cors = "true") {
      add_header 'Access-Control-Allow-Origin' "$http_origin";
      add_header 'Access-Control-Allow-Credentials' 'true';
    }
```
#### set timezone
1. get Region + Citiy
```
# get all avalibale regions
ls /usr/share/zoneinfo -la

# list avalible cities inside a region
ls /usr/share/zoneinfo/Europe -la
```
2. set ENV in Dockerfile
```
ENV TZ=Europe/Vienna
```
#### Using Healthcheck
In general, we recommend adding you healthcheck CALL inside the Dockerfile.<br>
The healthcheck has to verify if you running container supports everything for you application.
```
# Dockerfile

HEALTHCHECK --interval=5s --timeout=1s CMD /docker-healthcheck || exit 1
```
```
# docker-compose.yml
# !! docker-compose.yml verion 3.9 required !!

    depends_on:
      app:
        condition: service_healthy
```

   