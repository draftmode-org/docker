#!/bin/bash
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$1" = "php-fpm" ]; then
  BIN_DIR=${PHP_BIN_DIR:="/usr/local/bin"}
  FIND_FOLDER="${BIN_DIR}/docker-entrypoint.d"
  if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    entrypoint_log "$0: [NOTICE] ${FIND_FOLDER} is not empty, will attempt to perform configuration"
    entrypoint_log "$0: [NOTICE] Looking for shell scripts in ${FIND_FOLDER}"
    find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r f; do
      case "$f" in
        *.envsh)
          if [ -x "$f" ]; then
              entrypoint_log "$0: [NOTICE] Sourcing $f";
              . "$f"
          else
              entrypoint_log "$0: [WARNING] Ignoring $f, not executable";
          fi
        ;;
        *.sh)
          if [ -x "$f" ]; then
            entrypoint_log "$0: [NOTICE] Launching $f";
            "$f"
          else
            entrypoint_log "$0: [WARNING] Ignoring $f, not executable";
          fi
        ;;
        *)
          entrypoint_log "$0: [WARNING] Ignoring $f"
        ;;
      esac
    done
    entrypoint_log "$0: [NOTICE] Configuration complete; ready for start up"
  else
    entrypoint_log "$0: [NOTICE] No files found in ${FIND_FOLDER}, configuration complete"
  fi
fi

exec docker-php-entrypoint "$@"