#!/bin/sh

entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}
FIND_FOLDER="/docker-healthcheck.d"
if /usr/bin/find "${FIND_FOLDER}/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    entrypoint_log "$0: [NOTICE] ${FIND_FOLDER} is not empty, will attempt to perform healthcheck(s)"
    entrypoint_log "$0: [NOTICE] Looking for shell scripts in ${FIND_FOLDER}"
    find "${FIND_FOLDER}/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    entrypoint_log "$0: [NOTICE] Healthcheck $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    entrypoint_log "$0: [WARNING] Ignoring $f, not executable";
                fi
                ;;
            *.log);;
            *) entrypoint_log "$0: [WARNING] Ignoring $f";;
        esac
    done
    entrypoint_log "$0: [NOTICE] Healthcheck complete"
fi