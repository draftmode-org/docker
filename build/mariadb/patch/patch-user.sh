#!/bin/bash
set -eo pipefail
shopt -s nullglob
source /usr/local/bin/patch-helper.sh

DATABASE=${1}
if [ -z "$DATABASE" ]; then
  mysql_error $'argument <database> missing'
fi

USER=${2}
if [ -z "$USER" ]; then
  mysql_error $'argument <user> missing'
fi


PASSWORD=${3}
if [ -z "$PASSWORD" ]; then
  mysql_error $'argument <password> missing'
fi

GRANT=${4}
if [ -z "$GRANT" ]; then
  mysql_error $'argument <grant> missing'
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
    mysql_error $'argument <grant>, allowed values (mig|app|ro)'
esac

mysql_note "initialize: create user ${USER} for database ${DATABASE}"
initialize
if ! exists_database ${DATABASE}; then
  mysql_error "database ${DATABASE} does not exists, no further transaction"
fi

# If container is started as root user, restart as dedicated mysql user
if [ "$(id -u)" = "0" ]; then
  mysql_note "switching to dedicated user mysql"
  exec gosu mysql "patch-user.sh" "$@"
fi

userPasswordEscaped=$( docker_sql_escape_string_literal "${PASSWORD}" )
createUser="CREATE USER IF NOT EXISTS '$USER'@'${MARIADB_ROOT_HOST}' IDENTIFIED BY '$userPasswordEscaped';"
mysql_note "giving user ${USER} access (${GRANT}) to schema ${DATABASE}"
userGrants="GRANT ${GRANT} ON ${DATABASE}.* TO '$USER'@'${MARIADB_ROOT_HOST}';"

docker_process_sql --database=mysql <<-EOSQL
  ${createUser}
  ${userGrants}
EOSQL