ARG IMAGE_NAME
ARG IMAGE_TAG

# ##############################################
# dev
#
FROM ${IMAGE_NAME}:${IMAGE_TAG} as dev
ENV WORK_DIR=/var/html/www
ENV TZ=Europe/Vienna

WORKDIR $WORK_DIR

# ##############################################
# production
#
FROM ${IMAGE_NAME}:${IMAGE_TAG} as production
ENV WORK_DIR=/var/html/www
ENV NGINX_TEMPLATES=/etc/nginx/templates
ENV TZ=Europe/Vienna

WORKDIR $WORK_DIR

# copy source (in docker-compose /build/context: ./webserver)
COPY ./public $WORK_DIR
# copy nginx directive (in docker-compose /build/context: ./webserver)
COPY ./.deploy/templates $NGINX_TEMPLATES