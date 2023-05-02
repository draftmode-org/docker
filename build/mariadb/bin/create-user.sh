#!/bin/bash
set -eo pipefail
shopt -s nullglob
source "$BIN_DIR/.sql.helper.sh"

DATABASE=${1}
if [ -z "$DATABASE" ]; then
  log_error 'argument <database> missing'
fi

USER=${2}
if [ -z "$USER" ]; then
  log_error 'argument <user> missing'
fi


PASSWORD=${3}
if [ -z "$PASSWORD" ]; then
  log_error 'argument <password> missing'
fi

GRANT=${4}
if [ -z "$GRANT" ]; then
  log_error 'argument <grant> missing'
fi
case ${GRANT} in
  mig)
    GRANT="ALL"
    ;;
  app)
    GRANT="SELECT,UPDATE,INSERT,DELETE,EXECUTE"
    ;;
  ro)
    GRANT="SELECT"
    ;;
  *)
    log_error 'argument <grant>, allowed values (mig|app|ro)'
esac

if ! database_exists ${DATABASE}; then
  log_error "database ${DATABASE} does not exists, no further transaction"
fi

userPasswordEscaped=$( docker_sql_escape_string_literal "${PASSWORD}" )
createUser="CREATE USER IF NOT EXISTS '$USER'@'${MARIADB_ROOT_HOST}' IDENTIFIED BY '$userPasswordEscaped';"
log_notice "attach user ${USER} access (${GRANT}) to schema ${DATABASE}"
userGrants="GRANT ${GRANT} ON ${DATABASE}.* TO '$USER'@'${MARIADB_ROOT_HOST}';"

docker_process_sql --database=mysql <<-EOSQL
  ${createUser}
  ${userGrants}
EOSQL