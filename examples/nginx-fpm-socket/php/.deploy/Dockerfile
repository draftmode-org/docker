ARG IMAGE_NAME
ARG IMAGE_TAG

# ##############################################
# dev
#
FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as dev
ARG APP_ENV=dev
ENV APP_ENV=${APP_ENV}
ENV TZ=Europe/Vienna

ENV COMPOSER_CACHE_DIR=/var/app/.cache/composer
ENV COMPOSER_INSTALL_ARGUMENTS=" --no-interaction --prefer-dist"
RUN mv /usr/local/bin/docker-entrypoint.t/99-unix-socket-user.sh /usr/local/bin/docker-entrypoint.d/99-unix-socket-user.sh \
 && mv /usr/local/bin/docker-entrypoint.t/99-php-composer-install.sh /usr/local/bin/docker-entrypoint.d/99-php-composer-install.sh

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

# ##############################################
# build-stage
#
FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as build-stage
WORKDIR /var/app
COPY composer.* symfony.* ./

ENV COMPOSER_CACHE_DIR=/var/app/.cache/composer
ENV COMPOSER_INSTALL_ARGUMENTS="--no-interaction --prefer-dist --no-dev --no-scripts --no-progress"
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install $COMPOSER_INSTALL_ARGUMENTS

# ##############################################
# test-stage
#
FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as test-stage
ENV WORK_DIR=/var/app
WORKDIR $WORK_DIR

COPY --from=build-stage $WORK_DIR/vendor/ ./vendor
COPY ./public ./public
COPY ./src ./src
COPY ./tests ./tests
COPY phpunit.xml.dist .

# ##############################################
# production
#
FROM ${IMAGE_NAME}:${IMAGE_TAG} as production
ENV WORK_DIR=/var/app
ENV TZ=Europe/Vienna
WORKDIR $WORK_DIR

COPY --from=build-stage $WORK_DIR/vendor/ ./vendor
COPY ./public ./public
COPY ./src ./src

# run 99-unix-socket-user
RUN /usr/local/bin/docker-entrypoint.t/99-unix-socket-user.sh

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]