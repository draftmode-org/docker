#!/bin/bash
set -e

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

NGINX_CONFIG_FILE=${NGINX_CONF_FILE:="/etc/nginx/nginx.conf"}
if [ ! -f $NGINX_CONFIG_FILE ]; then
  entrypoint_log "[ERROR] ${0}: unable to read $NGINX_CONFIG_FILE to get NGINX user"
  exit 9
fi
CONTENT=$(cat $NGINX_CONFIG_FILE)
NGINX_USER_NAME=$(echo "${CONTENT}" | awk '/^user/{sub(/;/," "); print $2;exit}')
if [ -z "$NGINX_USER_NAME" ]; then
  entrypoint_log "[ERROR] ${0}: unable to get user from $NGINX_CONFIG_FILE"
fi

NGINX_SOCKET_GROUP=${NGINX_SOCKET_GROUP:=socket}
NGINX_SOCKET_GROUP_ID=${NGINX_SOCKET_GROUP_ID:=3000}
entrypoint_log "[NOTICE] ${0}: create GROUP (${NGINX_SOCKET_GROUP} ${NGINX_SOCKET_GROUP_ID}) for shared socket access"
# shellcheck disable=SC2046
[ $(getent group ${NGINX_SOCKET_GROUP}) ] || addgroup -g ${NGINX_SOCKET_GROUP_ID} -S ${NGINX_SOCKET_GROUP}

entrypoint_log "[NOTICE] ${0}: add user (${NGINX_USER_NAME}) to group ${NGINX_SOCKET_GROUP}"
adduser "${NGINX_USER_NAME}" ${NGINX_SOCKET_GROUP}