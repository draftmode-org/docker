#!/bin/bash
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}
PHP_COMPOSER_INSTALL_ARGUMENTS="--no-interaction --prefer-dist"
if [[ -n ${PHP_COMPOSER_INSTALL_ARGUMENTS} ]];then
  entrypoint_log "[NOTICE] ${0}: composer install..."
  # shellcheck disable=SC2086
  composer install ${PHP_COMPOSER_INSTALL_ARGUMENTS}
  entrypoint_log "[NOTICE] ${0}: composer install completed"
else
  entrypoint_log "[NOTICE] ${0}: no composer install, ENV PHP_COMPOSER_INSTALL_ARGUMENTS not set"
fi

