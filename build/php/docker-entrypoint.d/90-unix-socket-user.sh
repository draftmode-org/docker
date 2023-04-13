#!/bin/bash
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

PHP_FPM_LISTEN_GROUP=${PHP_FPM_LISTEN_GROUP:="socket"}
PHP_FPM_LISTEN_GROUP_ID=${PHP_FPM_LISTEN_GROUP_ID:=3000}
echo_notice "[NOTICE] ${0}: create GROUP (${PHP_FPM_LISTEN_GROUP} ${PHP_FPM_LISTEN_GROUP_ID}) for shared socket access"
# shellcheck disable=SC2046
[ $(getent group ${PHP_FPM_LISTEN_GROUP}) ] || addgroup -g ${PHP_FPM_LISTEN_GROUP_ID} -S ${PHP_FPM_LISTEN_GROUP}

echo_notice "[NOTICE] ${0}: add user ($(whoami)) to group ${PHP_FPM_LISTEN_GROUP}"
adduser "$(whoami)" ${PHP_FPM_LISTEN_GROUP}
