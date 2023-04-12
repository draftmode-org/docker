#!/bin/bash
set -e

CMD_NAME=${0}
QUIET_MODE=${QUIET_MODE:-0}

echo_notice() {
  echo_message "[NOTICE] $CMD_NAME $@"
}
echo_error() {
  echo_message "[ERROR] $CMD_NAME $@"
}
echo_message() {
  if [[ $QUIET_MODE -ne 1 ]]; then
      echo "$@" 1>&2;
  fi
}

PHP_FPM_LISTEN_GROUP=${PHP_FPM_LISTEN_GROUP:="socket"}
PHP_FPM_LISTEN_GROUP_ID=${PHP_FPM_LISTEN_GROUP_ID:=3000}
echo_notice "create GROUP (${PHP_FPM_LISTEN_GROUP} ${PHP_FPM_LISTEN_GROUP_ID}) for shared socket access"
[ $(getent group ${PHP_FPM_LISTEN_GROUP}) ] || addgroup -g ${PHP_FPM_LISTEN_GROUP_ID} -S ${PHP_FPM_LISTEN_GROUP}

echo_notice "add user ($(whoami)) to group ${PHP_FPM_LISTEN_GROUP}"
adduser "$(whoami)" ${PHP_FPM_LISTEN_GROUP}
