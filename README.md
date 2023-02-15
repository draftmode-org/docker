# docker

## nginx
#### build stages
- production

#### build args
- IMAGE_TAG=1.23.3-alpine

#### included extensions
- bash
- nano

#### location presets
cause most of the location directives are common we provide a couple of this common location directives.

e.g. /location/assets-doc.conf
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

        include /etc/nginx/location/assets.conf;
        include /etc/nginx/location/assets-doc.conf;
        include /etc/nginx/location/assets-media.conf;
        include /etc/nginx/location/assets-video.conf;
        include /etc/nginx/location/assets-html.conf;
    }
```
#### command to build an image
```
./build.sh nginx [TAG] [USE_BUILD_STAGE] (OPTIONS...)
```
## php
* php is configured within FPM
* every image start PHP-FPM as root

#### build stages
- production
- xdebug

#### build args
- IMAGE_TAG=8.1.12-fpm-alpine3.16
- YAML_VERSION=2.2.2
- XDEBUG_VERSION=3.1.6

#### included extensions
- freetype
- libpng, libjpeg-turbo
- libzip
- libmcrypt
- libxml2
- curl
- bzip2
- yaml
- bash
- nano

#### included php extensions
- opcache
- pdo pdo_mysql
- intl

#### local stage is on top of production stage and includes
- git
- xdebug
- composer

#### command to build an image
```
./build.sh php [TAG] [USE_BUILD_STAGE] (OPTIONS...)
```
## node
#### build stages
- production

#### build args
- NODE_IMAGE_TAG=16.17.1-alpine

#### command to build an image
```
./build.sh vue [TAG] [USE_BUILD_STAGE] (OPTIONS...)
```

## mariadb
_notice: mariadb not done_

#### command to build an image
```
./build.sh mariadb [TAG] [USE_BUILD_STAGE] (OPTIONS...)
```

## usage
```
./build.sh [DOCKER_FOLDER] [TAG] [USE_BUILD_STAGE] (OPTIONS...)
```