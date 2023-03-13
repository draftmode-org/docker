ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG} as dev
ARG APP_ENV=dev
ENV APP_ENV=${APP_ENV}

FROM dev as production
# copy source (in docker-compose /build/context: ./webserver)
COPY public /var/html/www

# copy nginx directive (in docker-compose /build/context: ./webserver)
COPY .deploy/templates /etc/nginx/templates/