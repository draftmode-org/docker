#!/bin/bash
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [[ -n ${PHP_COMPOSER_INSTALL_ARGUMENTS} ]];then
  echo_notice "[NOTICE] ${0}: composer install..."
  # shellcheck disable=SC2034
  COMPOSER_ALLOW_SUPERUSER=1
  EXPORT COMPOSER_ALLOW_SUPERUSER
  composer install "$PHP_COMPOSER_INSTALL_ARGUMENTS"
  echo_notice "[NOTICE] ${0}: composer install completed"
else
  echo_notice "[NOTICE] ${0}: no composer install, ENV PHP_COMPOSER_INSTALL_ARGUMENTS not set"
fi

