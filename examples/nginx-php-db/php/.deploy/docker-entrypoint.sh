#!/bin/bash
shopt -s lastpipe

if [ "$1" = "php-fpm" ]; then
  BIN_DIR=${PHP_BIN_DIR:="/usr/local/bin"}
  FIND_FOLDER="${BIN_DIR}/docker-entrypoint.d"
  if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    log_notice "${FIND_FOLDER} is not empty, will attempt to perform configuration"
    find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r file; do
      case "$file" in
        *.envsh)
          if [ -x "$file" ]; then
              log_notice "Sourcing $file";
              source "$file"
          else
              log_warning "Ignoring $file, not executable";
          fi
        ;;
        *.sh)
          if [ -x "$file" ]; then
            log_notice "Launching $file";
            "$file"
          else
            log_warning "Ignoring $file, not executable";
          fi
        ;;
        *)
          log_warning "Ignoring $file"
        ;;
      esac
    done
    log_notice "Configuration complete; ready for start up"
  else
    log_notice "No configuration files found in ${FIND_FOLDER}, configuration complete"
  fi
fi

exec docker-php-entrypoint "$@"

