ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG}-xdebug as dev
ARG APP_ENV=dev
ENV APP_ENV=${APP_ENV}

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

FROM ${IMAGE_NAME}:${IMAGE_TAG} as production

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]