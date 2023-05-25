#!/bin/bash
set -e

# default configuration
HOST=${MARIADB_ROOT_HOST:-%}
DATABASE="*"
EXECUTE=false

# for all arguments
y=0
ARGUMENTS=( "$@" )
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    --user=*)
      USERNAME="${ARGUMENT#*=}"
      ;;
    --password=*)
      PASSWORD="${ARGUMENT#*=}"
      ;;
    --database=*)
      DATABASE="${ARGUMENT#*=}"
      ;;
    --host=*)
      HOST="${ARGUMENT#*=}"
      ;;
    --grant=*)
      GRANT="${ARGUMENT#*=}"
      case ${GRANT} in
        migration)
          GRANT="ALL"
          ;;
        application)
          GRANT="SELECT, INSERT, UPDATE, DELETE, EXECUTE"
          ;;
        readonly)
          GRANT="SELECT"
          ;;
        *)
          log_error '--grant, allowed values (migration|application|readonly)'
      esac
      ;;
    --execute)
      EXECUTE=true
    ;;
    *)
      log_error "option $ARGUMENT not supported"
    ;;
  esac
  (( y++))
done

# protection
if [ -z "$USERNAME" ]; then
  log_error "missing argument --user (e.g. --user=max)"
fi
if [ -z "$PASSWORD" ]; then
  log_error "missing argument --password (e.g. --password=max)"
fi
if [ -z "$GRANT" ]; then
  log_error "missing argument --grant (e.g. --grant=application)"
fi
exit 1
INIT_DB_FOLDER="/docker-entrypoint-initdb.d"
if [ -d "$INIT_DB_FOLDER" ]; then
  USER_ENV_FILE="/$INIT_DB_FOLDER/00-user-$USERNAME.env"
  {
    echo "USERNAME=\"$USERNAME\"";
    echo "PASSWORD=\"$PASSWORD\"";
    echo "GRANT=\"$GRANT\"";
    echo "HOST=\"$HOST\"";
    echo "DATABASE=\"$DATABASE\"";
  } > "$USER_ENV_FILE"
fi
if [ "$EXECUTE" == "true" ]; then
    mysql_initialize "$@"
    create_user "$USER_ENV_FILE"
fi