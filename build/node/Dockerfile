ARG IMAGE_TAG

FROM node:${IMAGE_TAG}

# for php:8.1.12-fpm-apline3.16
# deticated updates to fix vulnerabilities
# - openssl
# - curl
ENV APK_ADD \
    openssl \
    curl

RUN apk update \
    && apk upgrade --available \
# cleaning
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*

ARG NPM_VERSION
RUN npm install -g npm@$NPM_VERSION
