#!/bin/bash
set -e
entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}
# ################################################################
# ENV PHP_FPM_LISTEN has to be set
# ################################################################
if [[ ${PHP_FPM_LISTEN} ]]; then
  REQUEST_METHOD=GET
  SCRIPT_NAME=/ping
  export REQUEST_METHOD
  export SCRIPT_NAME
  # shellcheck disable=SC2086
  cgi-fcgi -bind -connect ${PHP_FPM_LISTEN} &> /dev/null
else
  entrypoint_log "[ERROR] ${0}: ENV PHP_FPM_LISTEN not set"
  exit 1
fi
