#!/bin/bash
set -e

mysql_create_users() {
  local f
  for f; do
    mysql_create_user "$f"
  done
}

# method provides via ./bashrc
mysql_initialize "$@"

# create users
mysql_create_users /docker-entrypoint-initdb.d/00-user-*.env