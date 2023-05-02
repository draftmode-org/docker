ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG}
ENV TZ=Europe/Vienna

RUN mv $BIN_DIR/docker-healthcheck.t/innodb_initialized.sh $BIN_DIR/docker-healthcheck.d
# docker-healthcheck
HEALTHCHECK --interval=5s --timeout=1s CMD $BIN_DIR/docker-healthcheck || exit 1
