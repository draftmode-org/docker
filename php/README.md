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
- acl (required for setfacl)
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

#### xdebug stage additional includes
- git
- xdebug
- composer
