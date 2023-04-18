log_notice() {
    entrypoint_log "notice" "$@"
}
log_error() {
    entrypoint_log "error" "$@"
}
log_warning() {
    entrypoint_log "warning" "$@"
}
entrypoint_log() {
    if [ -z "${PHP_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        STATUS="$1"
        shift
        DATETIME=$(date +"%Y/%m/%d %T")
        echo "$DATETIME [${STATUS}] $0: $*"
    fi
}