#!/bin/bash
PHP_FPM_LISTEN_GROUP=${PHP_FPM_LISTEN_GROUP:="socket"}
PHP_FPM_LISTEN_GROUP_ID=${PHP_FPM_LISTEN_GROUP_ID:=3000}
log_notice "create GROUP (${PHP_FPM_LISTEN_GROUP} ${PHP_FPM_LISTEN_GROUP_ID}) for shared socket access"
# shellcheck disable=SC2046
[ $(getent group ${PHP_FPM_LISTEN_GROUP}) ] || addgroup -g ${PHP_FPM_LISTEN_GROUP_ID} -S ${PHP_FPM_LISTEN_GROUP}

log_notice "add user ($(whoami)) to group ${PHP_FPM_LISTEN_GROUP}"
adduser "$(whoami)" ${PHP_FPM_LISTEN_GROUP}
