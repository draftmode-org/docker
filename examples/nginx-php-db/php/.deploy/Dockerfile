ARG IMAGE_NAME
ARG IMAGE_TAG

# ##############################################
# dev
#
FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as dev
ENV WORK_DIR=/var/app
ENV TZ=Europe/Vienna
WORKDIR $WORK_DIR

# docker-entrypoint
RUN cp $PHP_BIN_DIR/docker-entrypoint.t/00-unix-socket-user.sh $PHP_BIN_DIR/docker-entrypoint.d

# docker-healthcheck
# RUN cp $PHP_BIN_DIR/docker-healthcheck.t/00-fpm-socket.sh $PHP_BIN_DIR/docker-healthcheck.d
# HEALTHCHECK --interval=5s --timeout=1s CMD $PHP_BIN_DIR/docker-healthcheck || exit 1

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

# ##############################################
# build-stage
#
FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as build-stage
ENV WORK_DIR=/var/app
ENV TZ=Europe/Vienna
WORKDIR $WORK_DIR

COPY composer.* symfony.* ./

# ENV PHP_COMPOSER_CACHE_DIR=$WORK_DIR/.cache/composer
ENV PHP_COMPOSER_INSTALL_ARGUMENTS="--no-interaction --prefer-dist --no-dev --no-scripts --no-progress"
COPY .deploy/docker-entrypoint.d/100-php-composer-install.sh /etc/docker-entrypoint-d/


# ##############################################
# test-stage
#
FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as test-stage
ENV WORK_DIR=/var/app
ENV TZ=Europe/Vienna
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

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]