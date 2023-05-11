#!/bin/bash
set -ea

if [ "$1" = "php-fpm" ]; then
  BIN_DIR=${PHP_BIN_DIR:="/usr/local/bin"}
  FIND_FOLDER="${BIN_DIR}/docker-entrypoint.d"
  # shellcheck disable=SC2162
  # shellcheck disable=SC2034
  if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    log_notice "${FIND_FOLDER} is not empty, will attempt to perform configuration"
    log_notice "Looking for shell scripts in ${FIND_FOLDER}"
    find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r f; do
      case "$f" in
        *.envsh)
          if [ -x "$f" ]; then
              log_notice "Sourcing $f";
              # shellcheck disable=SC1090
              . "$f"
          else
              log_warning "Ignoring $f, not executable";
          fi
        ;;
        *.sh)
          if [ -x "$f" ]; then
            log_notice "Launching $f";
            "$f"
          else
            log_warning "Ignoring $f, not executable";
          fi
        ;;
        *)
          log_warning "Ignoring $f"
        ;;
      esac
    done
    log_notice "Configuration complete; ready for start up"
  else
    log_notice "No files found in ${FIND_FOLDER}, configuration complete"
  fi
fi

export LUKAS=abc
export MY_LUKAS=abc
. $FIND_FOLDER/00-source-secrets.envsh
# exec docker-php-entrypoint "$@"

if [ "${1#-}" != "$1" ]; then
  set -- php-fpm "$@"
fi
exec "$@"

