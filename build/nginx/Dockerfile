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
# docker-entrypoint
# docker-healthcheck
# .bashrc
#
COPY bin/docker-entrypoint.sh $PHP_BIN_DIR/docker-entrypoint.sh
COPY bin/docker-healthcheck.sh /docker-healthcheck
COPY docker-entrypoint.t /docker-entrypoint.t
COPY docker-healthcheck.t /docker-healthcheck.t
COPY bin/.bashrc /.bashrc
COPY location.t /etc/nginx/location.t

RUN mkdir -p /docker-healthcheck.d \
 && mkdir -p /docker-entrypoint.d \
 && chmod +x /.bashrc \
 && chmod +x /docker-entrypoint.sh \
 && chmod +x /docker-healthcheck \
 && chmod +x -R /docker-entrypoint.t \
 && chmod +x -R /docker-healthcheck.t

ENV BASH_ENV=/.bashrc

ENV NGINX_CONF_FILE="/etc/nginx/nginx.conf"
ENV NGINX_SOCKET_GROUP="socket"
ENV NGINX_SOCKET_GROUP_ID=3000
