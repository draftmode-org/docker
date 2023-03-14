#!/bin/sh
set -e
# ################################################################
# ENV PHP_FPM_LISTEN has to be set
# ################################################################
if [[ ${PHP_FPM_LISTEN} ]]; then
  if env -i REQUEST_METHOD=GET SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping cgi-fcgi -bind -connect ${PHP_FPM_LISTEN}; then
	  exit 0
  fi
fi
exit 1
