#!/bin/sh
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

BIN_DIR=${PHP_BIN_DIR:="/usr/local/bin"}
FIND_FOLDER="${BIN_DIR}/docker-healthcheck.d"
if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
  entrypoint_log "$0: [NOTICE] ${FIND_FOLDER} is not empty, will attempt to perform healthcheck(s)"
  entrypoint_log "$0: [NOTICE] Looking for shell scripts in ${FIND_FOLDER}"
  find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r f; do
    case "$f" in
      *.sh)
        if [ -x "$f" ]; then
          if ( $f === 0 ); then
            entrypoint_log "$0: [NOTICE] Healthcheck $f, successful";
          else
            entrypoint_log "$0: [ERROR] Healthcheck $f, failure";
            exit 1
          fi
        else
          entrypoint_log "$0: [WARNING] Ignoring $f, not executable";
        fi
      ;;
      *)
        entrypoint_log "$0: [WARNING] Ignoring $f"
      ;;
    esac
  done
  entrypoint_log "$0: [NOTICE] Healthcheck complete"
fi
exit 0