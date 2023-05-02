#!/bin/bash
set -eo pipefail
shopt -s nullglob
source "$BIN_DIR/.sql.helper.sh"

DATABASE=${1}
if [ -z "$DATABASE" ]; then
  log_error 'argument <database> missing'
fi

if database_exists ${DATABASE}; then
  log_notice "database already exists, no further transaction"
  exit 0
fi

createDatabase="CREATE DATABASE IF NOT EXISTS \`$DATABASE\`;"
docker_process_sql --database=mysql <<-EOSQL
  ${createDatabase}
EOSQL
if database_exists ${DATABASE}; then
  log_notice "create database ${DATABASE} successful"
else
  log_error "create database ${DATABASE} failure"
  exit 1
fi
