#!/bin/sh
set -e

entrypoint_log() {
    if [ -z "${FPM_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$1" = "php-fpm" ]; then
    # set default for BIN folder
    if [[ -z "${BIN_DIR}" ]]; then
      BIN_DIR="/usr/local/bin"
    fi;
    FIND_FOLDER="${BIN_DIR}/docker-entrypoint.d"
    if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
        entrypoint_log "$0: ${FIND_FOLDER} is not empty, will attempt to perform configuration"
        entrypoint_log "$0: Looking for shell scripts in ${FIND_FOLDER}"
        find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r f; do
            case "$f" in
                *.envsh)
                    if [ -x "$f" ]; then
                        entrypoint_log "$0: Sourcing $f";
                        . "$f"
                    else
                        # warn on shell scripts without exec bit
                        entrypoint_log "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *.sh)
                    if [ -x "$f" ]; then
                        entrypoint_log "$0: Launching $f";
                        "$f"
                    else
                        # warn on shell scripts without exec bit
                        entrypoint_log "$0: Ignoring $f, not executable";
                    fi
                    ;;
                *) entrypoint_log "$0: Ignoring $f";;
            esac
        done

        entrypoint_log "$0: Configuration complete; ready for start up"
    else
        entrypoint_log "$0: No files found in ${FIND_FOLDER}, skipping configuration"
    fi
fi

exec docker-php-entrypoint "$@"
# exec "$@"