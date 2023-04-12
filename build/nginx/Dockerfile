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
# COPY docker-entrypoint.d
#
COPY docker-entrypoint.d /docker-entrypoint.d
RUN chmod +x -R /docker-entrypoint.d

ENV NGINX_CONF_FILE="/etc/nginx/nginx.conf"
ENV NGINX_SOCKET_GROUP="socket"
ENV NGINX_SOCKET_GROUP_ID=3000
