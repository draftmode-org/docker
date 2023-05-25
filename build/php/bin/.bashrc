log_notice() {
    log_log "notice" "$@"
}
log_error() {
    log_log "error" "$@"
    exit 1
}
log_warning() {
    log_log "warning" "$@"
}
log_log() {
    if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
        STATUS="$1"
        shift
        DATETIME=$(date +"%Y/%m/%d %T")
        echo "$DATETIME [${STATUS}] $0: $*"
    fi
}

function_exists() {
  [[ "$(declare -Ff "$1")" ]];
}