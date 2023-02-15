#!/bin/bash
set -eo pipefail
shopt -s nullglob
source /usr/local/bin/patch-helper.sh

DATABASE=${1}
if [ -z "$DATABASE" ]; then
  mysql_error $'argument <database> missing'
fi

mysql_note "initialize: create database ${DATABASE}"
initialize
if exists_database ${DATABASE}; then
  mysql_note "database already exists, no further transaction"
  exit 0
fi

# If container is started as root user, restart as dedicated mysql user
if [ "$(id -u)" = "0" ]; then
  mysql_note "switching to dedicated user mysql"
  exec gosu mysql "patch-db.sh" "$@"
fi

createDatabase="CREATE DATABASE IF NOT EXISTS \`$DATABASE\`;"
docker_process_sql --database=mysql <<-EOSQL
  ${createDatabase}
EOSQL
if exists_database ${DATABASE}; then
  mysql_note "create database ${DATABASE} successful"
else
 mysql_error "create database ${DATABASE} failure"
fi
