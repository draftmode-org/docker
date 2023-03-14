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

entrypoint_log "$0: add user ($(whoami)) to group ${SOCKET_GROUP_NAME}"
adduser "$(whoami)" ${SOCKET_GROUP_NAME}
