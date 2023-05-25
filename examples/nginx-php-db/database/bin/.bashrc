log_notice() {
    log_log "notice" "$@"
}
log_error() {
    log_log "errors" "$@"
    kill -INT $$;
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

mysql_initialize() {
    if [ "$(id -u)" = "0" ]; then
        exec gosu mysql "$0" "$@"
    fi
    if ! function_exists "mysql_check_config"; then
        ENTRY_POINT_SOURCE="/usr/local/bin/docker-entrypoint.sh"
        if [ -f "$ENTRY_POINT_SOURCE" ]; then
            log_error "(method: mysql_initialize) $ENTRY_POINT_SOURCE is mandatory and does not exists"
        fi
        source /usr/local/bin/docker-entrypoint.sh
        mysql_check_config "mariadbd"
        docker_setup_env "mariadbd"
    fi
}

mysql_create_user() {
    if ! function_exists "docker_process_sql"; then
        log_error "(method: create_user) method docker_process_sql is mandatory and does not exists"
    fi
    if ! function_exists "docker_sql_escape_string_literal"; then
        log_error "(method: create_user) method docker_sql_escape_string_literal is mandatory and does not exists"
    fi
    if [ -f "$1" ]; then
        unset USERNAME
        unset PASSWORD=
        unset GRANT
        unset HOST
        unset DATABASE
        # shellcheck disable=SC1090
        . "$f"
        # protection
        if [ -z "$USERNAME" ]; then
          log_error "(method: create_user) missing argument --user (e.g. --user=max)"
          exit 1
        fi
        if [ -z "$PASSWORD" ]; then
          log_error "(method: create_user) missing argument --password (e.g. --password=max)"
          exit 1
        fi
        if [ -z "$GRANT" ]; then
          log_error "(method: create_user) missing argument --grant (e.g. --grant=application)"
        fi
        PASSWORD_ESCAPED=$( docker_sql_escape_string_literal "$PASSWORD" )
        docker_process_sql <<-EOSQL
          CREATE USER IF NOT EXISTS '$USERNAME'@'${HOST}' IDENTIFIED BY '$PASSWORD_ESCAPED';
          GRANT ${GRANT} ON ${DATABASE}.* TO '$USERNAME'@'${HOST}';
EOSQL
    else
        log_error "(method: create_user) file $f does not exists"
    fi
}