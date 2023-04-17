#!/bin/bash
set -e

CMD_NAME=${0##*/}
echo_notice() {
  echo_message "[NOTICE] $@"
}
echo_error() {
  echo_message "[ERROR] $@"
}
echo_message() {
  if [[ $QUIET_MODE -ne 1 ]]; then
      echo "[$(date +"%Y-%m-%d %T")] $CMD_NAME: $@" 1>&2;
  fi
}

exit_help() {
    if [[ -n ${1} ]];then
      echo_error ${1}
      echo
    fi
    echo "Usage: $CMD_NAME host:port [-s] [-t timeout] [-- command args]"
    echo
    echo "   -h HOST | --host=HOST                Host or IP under test"
    echo "   -p PORT | --port=PORT                TCP port under test"
    echo "                                        Alternatively, you specify the host and port as host:port"
    echo "    -s | --strict                       Only execute subcommand if the test succeeds"
    echo "    -q | --quiet                        Don't output any status messages"
    echo "    -t TIMEOUT | --timeout=TIMEOUT      Timeout in seconds, zero for no timeout"
    echo "    -- COMMAND ARGS                     execute command with args after the test finishes"
    exit 1
}

wait_for_host() {
  if [[ $TIMEOUT_SECONDS -gt 0 ]]; then
    echo_notice "waiting $TIMEOUT_SECONDS seconds for $SEARCH_HOST:$SEARCH_PORT"
  else
    echo_notice "waiting for $SEARCH_HOST:$SEARCH_PORT without a timeout"
  fi
  TRACE_START=$(date +%s)
  while :
  do
    nc -z $SEARCH_HOST $SEARCH_PORT
    RESULT=$?
    if [[ $RESULT -eq 0 ]]; then
      TRACE_END=$(date +%s)
      echo_notice "$SEARCH_HOST:$SEARCH_PORT is available after $((TRACE_END - TRACE_START)) seconds"
      break
    fi
    sleep 1
  done
  return $RESULT
}

wait_for_wrapper() {
  # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
  if [[ $QUIET_MODE -eq 1 ]]; then
    timeout $BUSY_TIME_FLAG $TIMEOUT_SECONDS $0 --quiet --child --host=$SEARCH_HOST --port=$SEARCH_PORT --timeout=$TIMEOUT_SECONDS &
  else
    timeout $BUSY_TIME_FLAG $TIMEOUT_SECONDS $0 --child --host=$SEARCH_HOST --port=$SEARCH_PORT --timeout=$TIMEOUT_SECONDS &
  fi
  PROCESS_ID=$!
  trap "kill -INT -$PROCESS_ID" INT
  wait $PROCESS_ID
  RESULT=$?
  if [[ $RESULT -ne 0 ]]; then
    echo_error "timeout occurred after waiting $TIMEOUT_SECONDS seconds for $SEARCH_HOST:$SEARCH_PORT"
  fi
  return $RESULT
}

# process arguments
while [[ $# -gt 0 ]]
do
  case "$1" in
    *:* )
      SEARCH_HOST_PORT=(${1//:/ })
      SEARCH_HOST=${SEARCH_HOST_PORT[0]}
      SEARCH_PORT=${SEARCH_HOST_PORT[1]}
      shift 1
    ;;
    --child)
      CHILD_MODE=1
      shift 1
    ;;
    -q | --quiet)
      QUIET_MODE=1
      shift 1
    ;;
    -s | --strict)
      STRICT_MODE=1
      shift 1
    ;;
    -h)
      SEARCH_HOST="$2"
      if [[ $SEARCH_HOST == "" ]]; then break; fi
      shift 2
    ;;
    --host=*)
      SEARCH_HOST="${1#*=}"
      shift 1
    ;;
    -p)
      SEARCH_PORT="$2"
      if [[ $SEARCH_PORT == "" ]]; then break; fi
      shift 2
    ;;
    --port=*)
      SEARCH_PORT="${1#*=}"
      shift 1
    ;;
    -t)
      TIMEOUT_SECONDS="$2"
      if [[ $TIMEOUT_SECONDS == "" ]]; then break; fi
      shift 2
    ;;
    --timeout=*)
      TIMEOUT_SECONDS="${1#*=}"
      shift 1
    ;;
    --)
      shift
      POST_CLI_COMMAND=("$@")
      break
    ;;
    --help)
      exit_help
    ;;
    *)
      exit_help "Unknown argument: $1"
    ;;
  esac
done

if [[ "$SEARCH_HOST" == "" || "$SEARCH_PORT" == "" ]]; then
  echo_error "you need to provide a host and port to test."
  usage
fi

TIMEOUT_SECONDS=${TIMEOUT_SECONDS:-15}
CHILD_MODE=${CHILD_MODE:-0}
STRICT_MODE=${STRICT_MODE:-0}
QUIET_MODE=${QUIET_MODE:-0}

BUSY_TIME_FLAG=""
if timeout &>/dev/stdout | grep -q -e '-t '; then
  BUSY_TIME_FLAG="-t"
fi

if [[ $CHILD_MODE -gt 0 ]]; then
  wait_for_host
  RESULT=$?
  exit $RESULT
else
  if [[ $TIMEOUT_SECONDS -gt 0 ]]; then
    wait_for_wrapper
    RESULT=$?
  else
    wait_for_host
    RESULT=$?
  fi
fi

if [[ $POST_CLI_COMMAND != "" ]]; then
  if [[ $RESULT -ne 0 && $STRICT_MODE -eq 1 ]]; then
      echo_error "strict mode, refusing to execute subprocess"
      exit $RESULT
  fi
  exec "${POST_CLI_COMMAND[@]}"
else
  exit $RESULT
fi
