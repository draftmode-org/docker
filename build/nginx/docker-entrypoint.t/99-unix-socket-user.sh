#!/bin/sh
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

SOCKET_GROUP_NAME="socket"
SOCKET_GROUP_ID=3000;
entrypoint_log "$0: create GROUP (${SOCKET_GROUP_NAME}) for shared socket access, if not exists"
[ $(getent group ${SOCKET_GROUP_NAME}) ] || addgroup -g ${SOCKET_GROUP_ID} -S ${SOCKET_GROUP_NAME}

# /etc/nginx/nginx.conf
NGINX_WORKER_USER_NAME="nginx"
entrypoint_log "$0: add user (${NGINX_WORKER_USER_NAME}) to group ${SOCKET_GROUP_NAME}"
adduser "${NGINX_WORKER_USER_NAME}" ${SOCKET_GROUP_NAME}
