ARG IMAGE_TAG

FROM nginx:${IMAGE_TAG}

ENV APK_ADD \
    bash \
    nano \
    openssl \
    tzdata
#
# update, install and upgrade
#
RUN apk add --update --no-cache ${APK_ADD} \
    && apk upgrade --available

#
# copy shared location examples
#
RUN mkdir -p /etc/nginx/shared
COPY shared/*.conf /etc/nginx/shared

#
# COPY docker-entrypoint.templates
#
COPY docker-entrypoint.t /docker-entrypoint.t
RUN chmod +x -R /docker-entrypoint.t
