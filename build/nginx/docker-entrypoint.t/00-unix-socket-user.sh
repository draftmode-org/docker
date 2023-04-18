#!/bin/bash
set -e

NGINX_CONFIG_FILE=${NGINX_CONF_FILE:="/etc/nginx/nginx.conf"}
if [ ! -f $NGINX_CONFIG_FILE ]; then
  log_error "unable to read $NGINX_CONFIG_FILE to get NGINX user"
  exit 1
fi
CONTENT=$(cat $NGINX_CONFIG_FILE)
NGINX_USER_NAME=$(echo "${CONTENT}" | awk '/^user/{sub(/;/," "); print $2;exit}')
if [ -z "$NGINX_USER_NAME" ]; then
  log_error "unable to get user from $NGINX_CONFIG_FILE"
  exit 1
fi

NGINX_SOCKET_GROUP=${NGINX_SOCKET_GROUP:=socket}
NGINX_SOCKET_GROUP_ID=${NGINX_SOCKET_GROUP_ID:=3000}
log_notice "create GROUP (${NGINX_SOCKET_GROUP} ${NGINX_SOCKET_GROUP_ID}) for shared socket access"
# shellcheck disable=SC2046
[ $(getent group ${NGINX_SOCKET_GROUP}) ] || addgroup -g ${NGINX_SOCKET_GROUP_ID} -S ${NGINX_SOCKET_GROUP}

log_notice "add user (${NGINX_USER_NAME}) to group ${NGINX_SOCKET_GROUP}"
adduser "${NGINX_USER_NAME}" ${NGINX_SOCKET_GROUP}