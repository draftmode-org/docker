# Docker - Nginx

## build args
- IMAGE_TAG=1.23.3-alpine
- BUILD_TAG_PREFIX<br>
Is used to TAG the built image, actually set: _webfux/nginx_

Changelog:
- 12.03.2023
  - Tag: 1.0.0
  - Size: 48 MB

## included extensions
- bash
- nano
- openssl

#### shared (location directives)
Most of the location directives are common. folder /shared provides a couple of this common location patterns.

e.g. /etc/nginx/shared/assets-doc.conf
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
        listen 80;
        listen 443;

        server_name www.dev.webfux.io;

        error_log  /var/log/nginx/www.error.log;
        access_log /var/log/nginx/www.access.log;

        root /var/www/html;

        include /etc/nginx/shared/assets-doc.conf;
    }
```
### How to (FAQ)
Get for most common questions answers 
#### Forward all HTTP to HTTPS
```
    server {
      listen 80 default_server;
      return 301 https://$host$request_uri;
    }
```

#### Config template with environment vars
example
```
# /etc/nginx/templates/default.conf.template
server {
    listen       80;
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
  listen       80;
  server_name  www.example.io;
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
