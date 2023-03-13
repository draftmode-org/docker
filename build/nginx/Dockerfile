ARG IMAGE_TAG

FROM nginx:${IMAGE_TAG}

ENV APK_ADD \
    bash \
    nano \
    openssl
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
