#!/bin/bash
set -eo pipefail
shopt -s nullglob
source "$BIN_DIR/.sql.helper.sh"

# INNODB_BUFFER_POOL_LOADED
#
# Tests the load of the innodb buffer pool as been complete
# implies innodb_buffer_pool_load_at_startup=1 (default), or if
# manually SET innodb_buffer_pool_load_now=1
s=$(docker_process_sql --skip-column-names -e 'select VARIABLE_VALUE from information_schema.GLOBAL_STATUS WHERE VARIABLE_NAME="Innodb_buffer_pool_load_status"')
if [[ ! $s =~ 'load completed' ]]; then
  exit 1
fi
