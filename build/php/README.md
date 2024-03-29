# PHP Base images
* php is configured within FPM using SOCKET
* every image start PHP-FPM as root

## build stages
- production
- xdebug

## build args
- IMAGE_TAG=8.1.12-fpm-alpine3.16
- YAML_VERSION=2.2.2
- XDEBUG_VERSION=3.1.6

## included extensions
- acl (_required for **setfacl**_)
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
- tzdata

## included php extensions
- opcache
- pdo pdo_mysql
- intl
- gd
- bz2 zip
- curl
- xml

## xdebug stage additional includes
- git
- xdebug
- composer

## configuration arguments (php / fpm) ####
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
  - ENV PHP_FPM_LISTEN_GROUP="socket"<br>
    _**has to be identically to the NGINX_SOCKET_GROUP**_
  - ENV PHP_FPM_LISTEN_GROUP_ID=3000<br>
    _**has to be identically to the NGINX_SOCKET_GROUP_ID**_
- php-fpm.d/zzz_200_www_log.conf
  - ENV PHP_FPM_LOG="%R - %t \"%m %r%Q%q\" %s len=%l %f dur=%{mili}dms mem=%{kilo}Mk cpu=%C%%"
- php-fpm.d/zzz_200_www_pm.conf
  - ENV PHP_FPM_PM="dynamic"
  - ENV PHP_FPM_MAX_CHILDREN="5"
  - ENV PHP_FPM_START_SERVERS="2"
  - ENV PHP_FPM_MIN_SPARE_SERVERS="1"
  - ENV PHP_FPM_MAX_SPARE_SERVERS="2"
  - ENV PHP_FPM_MAX_REQUESTS="1000"

## docker-entrypoint
Our PHP base image provide his own docker-entrypoint. The used technic is close to the way NGINX works with /docker-entrypoint.d/ folder.<br>
The scripts located in $PHP_BIN_DIR/docker-entrypoint.d are only executed when
```
ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
```
The docker-entrypoint does:
1. find all files in $PHP_BIN_DIR/docker-entrypoint.d/
   1. source all *.envsh files
   2. execute all *.sh files
2. run ``exec docker-php-entrypoint "$@"``
## docker-entrypoint.t
This folder provides a collection of usefully scripts.<br>
To use our examples, move/copy the files to /docker-entrypoint.d folder.
```
# Dockerfile

RUN cp $PHP_BIN_DIR/docker-entrypoint.t/00-unix-socket-user.sh $PHP_BIN_DIR/docker-entrypoint.d 
```
### 00-unix-socket-user.sh
Adds a new usergroup "socket" and attaches ```$(whoami)``` user to this group.<br>
It´s mandatory to share access between PHP-FPM and NGINX by sockets.
```
ENV PHP_FPM_LISTEN_GROUP="socket"
ENV PHP_FPM_LISTEN_GROUP_ID=3000
```
It´s also mandatory to config FPM [www] section like next snipped, as it is already provided in docker-entrypoint.t/999-unix-socket-user.sh.
```
[www]
listen = ${PHP_FPM_LISTEN}
listen.group = ${PHP_FPM_LISTEN_GROUP}
listen.mode = 0660
```
## docker-healthcheck
Our PHP base image provide a docker-healthcheck script. The used technic is close to the way NGINX works with /docker-healthcheck.d/ folder.<br>
The docker-healthcheck does:
1. find all files in /user/local/bin/docker-healthcheck.d/
    2. execute all *.sh files<br>
 
Usage:
```
# Dockerfile
HEALTHCHECK --interval=5s --timeout=1s CMD $PHP_BIN_DIR/docker-healthcheck || exit 1
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

RUN cp $PHP_BIN_DIR/docker-healthcheck.t/00-fpm-socket.sh $PHP_BIN_DIR/docker-healthcheck.d 
```
### 00-fpm-socket.sh
Base on the EVN PHP_FPM_LISTEN a cgi-fcgi -bind -connect ${PHP_FPM_LISTEN} is tried.<br>

### How to (FAQ)
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

HEALTHCHECK --interval=5s --timeout=1s CMD $BIN_DIR/docker-healthcheck || exit 1
```
```
# docker-compose.yml
# !! docker-compose.yml verion 3.9 required !!

    depends_on:
      app:
        condition: service_healthy
```