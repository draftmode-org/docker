#!/bin/bash
set -eo pipefail
shopt -s nullglob
source "$BIN_DIR/.sql.helper.sh"

# INNODB_INITIALIZED
#
# This tests that the crash recovery of InnoDB has completed
# along with all the other things required to make it to a healthy
# operational state. Note this may return true in the early
# states of initialization. Use with a connect test to avoid
# these false positives.
s=$(docker_process_sql --skip-column-names -e 'select 1 from information_schema.ENGINES WHERE engine="innodb" AND support in ("YES", "DEFAULT", "ENABLED")')
if [ ! "$s" == 1 ]; then
  exit 1
fi
