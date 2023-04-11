#!/bin/sh
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

NGINX_CONFIG_FILE=${NGINX_CONF_FILE:="/etc/nginx/nginx.conf"}
if [ ! -f $NGINX_CONFIG_FILE ]; then
  entrypoint_log "$0: [ERROR] unable to read $NGINX_CONFIG_FILE to get NGINX user"
  exit 9
fi
CONTENT=$(cat $NGINX_CONFIG_FILE)
NGINX_USER_NAME=$(echo "${CONTENT}" | awk '/^user/{sub(/;/," "); print $2;exit}')
if [ -z "$NGINX_USER_NAME" ]; then
  entrypoint_log "$0: [ERROR] unable to get user from $NGINX_CONFIG_FILE"
fi

SOCKET_GROUP_NAME=${SOCKET_GROUP_NAME:=socket}
SOCKET_GROUP_ID=${SOCKET_GROUP_ID:=3000}
entrypoint_log "$0: [NOTICE] create GROUP (${SOCKET_GROUP_NAME} ${SOCKET_GROUP_ID}) for shared socket access"
[ $(getent group ${SOCKET_GROUP_NAME}) ] || addgroup -g ${SOCKET_GROUP_ID} -S ${SOCKET_GROUP_NAME}

entrypoint_log "$0: [NOTICE] add user (${NGINX_USER_NAME}) to group ${SOCKET_GROUP_NAME}"
adduser "${NGINX_USER_NAME}" ${SOCKET_GROUP_NAME}