ARG IMAGE_TAG

FROM nginx:${IMAGE_TAG}

ENV APK_ADD \
    bash \
    nano \
    openssl

RUN apk add --update --no-cache ${APK_ADD} \
    && apk upgrade --available

ENV ENV_CONFIG_ROOT_FOLDER=/etc/nginx

RUN mkdir -p ${ENV_CONFIG_ROOT_FOLDER}/conf.d
COPY conf/location/*.conf ${ENV_CONFIG_ROOT_FOLDER}/location/
