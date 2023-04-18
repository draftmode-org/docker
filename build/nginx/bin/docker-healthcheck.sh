#!/bin/bash
set -e

BIN_DIR=${PHP_BIN_DIR:="/usr/local/bin"}
FIND_FOLDER="${BIN_DIR}/docker-healthcheck.d"
# shellcheck disable=SC2162
# shellcheck disable=SC2034
if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
  log_notice "${FIND_FOLDER} is not empty, will attempt to perform healthcheck(s)"
  log_notice "Looking for shell scripts in ${FIND_FOLDER}"
  find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r f; do
    case "$f" in
      *.sh)
        if [ -x "$f" ]; then
          if ( $f === 0 ); then
            log_notice "Healthcheck $f, successful";
          else
            log_error "$0: [ERROR] Healthcheck $f, failure";
            exit 1
          fi
        else
          log_warning "Ignoring $f, not executable";
        fi
      ;;
      *)
        log_warning "Ignoring $f"
      ;;
    esac
  done
  log_notice "Healthcheck complete"
fi
exit 0