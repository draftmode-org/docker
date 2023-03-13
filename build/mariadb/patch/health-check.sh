#!/bin/bash
set -eo pipefail
source /usr/local/bin/patch-helper.sh

initialize
CHECK_DB="mysqly"
if ! exists_database ${CHECK_DB}; then
  echo "healthcheck failed, check ${CHECK_DB}" >&2
  exit 1
fi