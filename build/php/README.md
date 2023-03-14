# PHP Base images
* php is configured within FPM using SOCKET
* every image start PHP-FPM as root
```
ENV PHP_FPM_LISTEN="/sockets/php.socket"
```

### build stages
- production
- xdebug

### build args
- IMAGE_TAG=8.1.12-fpm-alpine3.16
- YAML_VERSION=2.2.2
- XDEBUG_VERSION=3.1.6

### included extensions
- acl (required for setfacl)
- icu-libs
- freetype
- libpng, libjpeg-turbo
- zlib, libzip
- libmcrypt
- libxml2
- curl
- bzip2
- yaml
- bash
- nano
- linux-headers

### included php extensions
- opcache
- pdo pdo_mysql
- intl
- gd
- bz2 zip
- curl
- xml

### xdebug stage additional includes
- git
- xdebug
- composer

### configuration arguments (php / fpm) ####
The Dockerfile set a couple of arguments to configure PHP and FPM.

- conf.d/zzz_200_opcache.ini 
  - ENV PHP_OPCACHE_REVALIDATE_FREQUENCY="0"
  - ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"
  - ENV PHP_OPCACHE_ENABLE="1"
  - ENV PHP_OPCACHE_MEMORY_CONSUMPTION="64"
  - ENV PHP_OPCACHE_MAX_ACCELERATED_FILES="2000"
  - ENV PHP_OPCACHE_PRELOAD="/app/config/preload.php"<br>
   or
  - ENV PHP_OPCACHE_PRELOAD=""
- conf.d/zzz_201_php.ini
  - ENV PHP_POST_MAX_SIZE="16M"
  - ENV PHP_UPLOAD_MAX_FILESIZE="16M"
  - ENV PHP_MAX_EXECUTION_TIME="90"
  - ENV PHP_REALPATH_CACHE_TTL="120"
- php-fpm.d/zzz_100_global.conf
  - ENV PHP_FPM_LOG_LEVEL="notice"
  - ENV PHP_FPM_EMERGENCY_RESTART_THRESHOLD="10"
  - ENV PHP_FPM_EMERGENCY_RESTART_INTERVAL="10s"
  - ENV PHP_FPM_PROCESS_CONTROL_TIMEOUT="20s"
- php-fpm.d/zzz_200_www.conf
  - ENV PHP_FPM_USER="www-data"
  - PHP_FPM_GROUP="www-data"
- php-fpm.d/zzz_200_www_listen.conf
  - ENV PHP_FPM_LISTEN="/sockets/php.socket"
- php-fpm.d/zzz_200_www_log.conf
  - ENV PHP_FPM_LOG="%R - %t \"%m %r%Q%q\" %s len=%l %f dur=%{mili}dms mem=%{kilo}Mk cpu=%C%%"
- php-fpm.d/zzz_200_www_pm.conf
  - ENV PHP_FPM_PM="dynamic"
  - ENV PHP_FPM_MAX_CHILDREN="5"
  - ENV PHP_FPM_START_SERVERS="2"
  - ENV PHP_FPM_MIN_SPARE_SERVERS="1"
  - ENV PHP_FPM_MAX_SPARE_SERVERS="2"
  - ENV PHP_FPM_MAX_REQUESTS="1000"
