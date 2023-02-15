#!/bin/bash
set -eo pipefail
shopt -s nullglob
source /usr/local/bin/docker-entrypoint.sh

initialize() {
    mysql_check_config "mariadbd"
    docker_setup_env "mariadbd"
}

exists_database() {
  showDatabase=$(docker_process_sql --database=mysql -e "SHOW DATABASES LIKE '${1}'")
  [[ "${showDatabase}" =~ ${1} ]]
}
