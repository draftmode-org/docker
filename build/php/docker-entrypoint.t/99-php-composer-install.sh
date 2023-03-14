#!/bin/sh
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [[ -n "${COMPOSER_INSTALL_ARGUMENTS}" ]]; then
  entrypoint_log "$0: Installing composer dependencies..."
  entrypoint_log "$0: composer install ${COMPOSER_INSTALL_ARGUMENTS}"
  composer install ${COMPOSER_INSTALL_ARGUMENTS}
else
  entrypoint_log "$0: Installing no Composer, ENV COMPOSER_INSTALL_ARGUMENTS not set"
fi