#!/bin/bash
set -e

# shellcheck disable=SC2166
if [ "$1" = "nginx" -o "$1" = "nginx-debug" ]; then
  FIND_FOLDER="/docker-entrypoint.d"
  # shellcheck disable=SC2162
  # shellcheck disable=SC2034
  if /usr/bin/find "$FIND_FOLDER/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
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
    entrypoint_log "$0: Configuration complete; ready for start up"
  else
    entrypoint_log "$0: No files found in /docker-entrypoint.d/, skipping configuration"
  fi
fi

exec "$@"