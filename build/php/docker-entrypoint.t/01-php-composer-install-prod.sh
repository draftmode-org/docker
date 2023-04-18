#!/bin/bash
set -e

log_notice "composer install..."
composer install --no-interaction --prefer-dist --no-dev --no-scripts --no-progress
log_notice "composer install completed"


