#!/bin/bash
set -e

entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if [ "$#" -lt 1 ]; then
  if [[ -n "${COMPOSER_ARGUMENTS}" ]]; then
    entrypoint_log "$0: [NOTICE] no ARGS given but ENV COMPOSER_ARGUMENTS is set"
    ARGUMENTS=( $COMPOSER_ARGUMENTS )
  else
    entrypoint_log "$0: [NOTICE] either ARGS nor ENV COMPOSER_ARGUMENTS is set"
    entrypoint_log "$0: [NOTICE] no php composer command will be executed"
    exit 0
  fi
else
  entrypoint_log "$0: [NOTICE] ARGS given, use them"
  ARGUMENTS=( "$@" )
fi

CMD=${ARGUMENTS[0]}
case ${CMD} in
  install|require|required-dev|update)
    ARGS=("${ARGUMENTS[@]:1}")
    CMD="$CMD $ARGS"
    ;;
  *)
    entrypoint_log "$0: [ERROR] first ARGUMENT has to be (install,required,required-dev,update), given $CMD"
    exit 9
    ;;
esac

if [[ -n "${CMD}" ]]; then
  entrypoint_log "$0: [NOTICE] run php composer with: $CMD"
  composer install ${CMD}
fi