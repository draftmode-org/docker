#!/bin/bash
set -eo pipefail
shopt -s nullglob
source docker-entrypoint.sh

initialize() {
    mysql_check_config "mariadbd"
    docker_setup_env "mariadbd"
}
database_exists() {
  showDatabase=$(docker_process_sql --database=mysql -e "SHOW DATABASES LIKE '${1}'")
  [[ "${showDatabase}" =~ ${1} ]]
}

# If container/command is started/executed as root user, restart as dedicated mysql user
if [ "$(id -u)" = "0" ]; then
  log_notice "switching to dedicated user mysql"
  exec gosu mysql "$0" "$@"
fi

initialize