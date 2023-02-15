# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# production-stage
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
ARG IMAGE_TAG

FROM php:${IMAGE_TAG} as production

ARG YAML_VERSION

ENV BUILD_DEPS \
    $PHPIZE_DEPS \
    icu-dev \
    freetype-dev \
    libpng-dev libjpeg-turbo-dev \
    libzip-dev \
    libmcrypt-dev \
    libxml2-dev \
    curl-dev \
    bzip2-dev \
    yaml-dev

ENV APK_ADD \
    icu-libs \
    freetype \
    libpng libjpeg-turbo \
    zlib libzip \
    yaml \
    bash \
    nano

ENV PECL_INSTALL \
    yaml-${YAML_VERSION}

ENV PHP_EXT_ENABLE \
    yaml

ENV PHP_EXT_CONFIG \
    gd --with-freetype --with-jpeg

ENV PHP_EXT_INSTALL \
    opcache \
    pdo pdo_mysql \
    intl \
    gd \
    bz2 zip \
    curl \
    xml

RUN apk --no-cache --virtual .build-deps add ${BUILD_DEPS} \
    && apk add --update --no-cache ${APK_ADD} \
    && apk upgrade --available \
    && pecl install ${PECL_INSTALL} \
    && docker-php-ext-enable ${PHP_EXT_ENABLE} \
    && docker-php-ext-configure ${PHP_EXT_CONFIG} \
    && docker-php-ext-install ${PHP_EXT_INSTALL} \
# cleaning
    && apk del --purge .build-deps \
    && apk add --update dumb-init fcgi \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

#
# copy liveness script to image and change permissions
#
# COPY "./scripts/liveness_probe.sh" "/usr/local/bin/"
# RUN chmod -R 755 "/usr/local/bin/liveness_probe.sh"

#
# configure PHP
#
ENV PHP_FPM_INI_DIR="/usr/local/etc/php-fpm.d"
# php-conf/[opcache] defaults
ENV PHP_OPCACHE_REVALIDATE_FREQUENCY="0"
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0"
# php-conf/[opcache] production
ENV PHP_OPCACHE_ENABLE="1"
ENV PHP_OPCACHE_MEMORY_CONSUMPTION="64"
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES="2000"
ENV PHP_OPCACHE_PRELOAD="/app/config/preload.php"
# php-conf/[PHP] defaults
ENV PHP_POST_MAX_SIZE="16M"
ENV PHP_UPLOAD_MAX_FILESIZE="16M"
# php-conf/[PHP] production
ENV PHP_MAX_EXECUTION_TIME="90"
ENV PHP_REALPATH_CACHE_TTL="120"
# fpm-conf/[global] default
ENV PHP_FPM_LOG_LEVEL="notice"
ENV PHP_FPM_EMERGENCY_RESTART_THRESHOLD="10"
ENV PHP_FPM_EMERGENCY_RESTART_INTERVAL="10s"
ENV PHP_FPM_PROCESS_CONTROL_TIMEOUT="20s"
# fpm-conf/[www]
ENV PHP_FPM_USER="www-data"
ENV PHP_FPM_PM="dynamic"
ENV PHP_FPM_MAX_CHILDREN="5"
ENV PHP_FPM_START_SERVERS="2"
ENV PHP_FPM_MIN_SPARE_SERVERS="1"
ENV PHP_FPM_MAX_SPARE_SERVERS="2"
ENV PHP_FPM_MAX_REQUESTS="1000"

#
# add the configuration files
#
COPY php-conf/*.ini $PHP_INI_DIR/conf.d/
ENV PHP_FPM_INI_DIR="/usr/local/etc/php-fpm.d"
COPY fpm-conf/*.conf ${PHP_FPM_INI_DIR}/

CMD [ "php-fpm", "--allow-to-run-as-root" ]

# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# debug-stage
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
ENV APK_ADD \
    git

FROM production as xdebug

ARG XDEBUG_VERSION

#
# https://xdebug.org/docs/upgrade_guide#Step-Debugging
# export XDEBUG_SESSION=xdebug_is_great
#
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && apk add --update --no-cache ${APK_ADD} \
# setup xdebug
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug \
# install composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# cleaning
    && rm -rf /tmp/* \
    && apk del -f .build-deps

RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#
# configure local PHP
#
# php-conf/[opcache] local overwrites
ENV PHP_OPCACHE_ENABLE="0"
ENV PHP_OPCACHE_MEMORY_CONSUMPTION="256"
ENV PHP_OPCACHE_MAX_ACCELERATED_FILES="2000"
ENV PHP_OPCACHE_PRELOAD=""
# php-conf/[PHP] local overwrites
ENV PHP_MAX_EXECUTION_TIME="3600"
ENV PHP_REALPATH_CACHE_TTL="600"

#
# add the configuration files
#
COPY php-conf/*.ini $PHP_INI_DIR/conf.d/
ENV PHP_FPM_INI_DIR="/usr/local/etc/php-fpm.d"
COPY fpm-conf/*.conf ${PHP_FPM_INI_DIR}/

CMD [ "php-fpm", "--allow-to-run-as-root" ]