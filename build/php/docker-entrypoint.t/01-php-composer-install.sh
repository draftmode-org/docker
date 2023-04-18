#!/bin/bash
set -e

if [[ -n ${PHP_COMPOSER_INSTALL_ARGUMENTS} ]];then
  log_notice "composer install..."
  # shellcheck disable=SC2086
  composer install ${PHP_COMPOSER_INSTALL_ARGUMENTS}
  log_notice "composer install completed"
else
  log_notice "no composer install, ENV PHP_COMPOSER_INSTALL_ARGUMENTS not set"
fi
