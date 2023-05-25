
ARG IMAGE_NAME
ARG IMAGE_TAG

FROM ${IMAGE_NAME}:${IMAGE_TAG}

RUN apt-get update \
  && apt-get upgrade --assume-yes

# implement using timezone as ENV
RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql && mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql

ENV BIN_DIR="/usr/local/bin"
COPY bin $BIN_DIR
COPY docker-healthcheck.t $BIN_DIR/docker-healthcheck.t

RUN mkdir -p $BIN_DIR/docker-healthcheck.d \
 && chmod +x $BIN_DIR/*.sh \
 && mv $BIN_DIR/create-user.sh $BIN_DIR/create-user \
 && mv $BIN_DIR/.bashrc /.bashrc \
 && mv $BIN_DIR/docker-healthcheck.sh $BIN_DIR/docker-healthcheck \
 && chmod +x -R $BIN_DIR/docker-healthcheck.t

ENV BASH_ENV=/.bashrc