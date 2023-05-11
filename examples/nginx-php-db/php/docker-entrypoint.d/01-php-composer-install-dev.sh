#!/bin/bash
log_notice "composer install..."
composer install --no-interaction --prefer-dist
log_notice "composer install completed"
