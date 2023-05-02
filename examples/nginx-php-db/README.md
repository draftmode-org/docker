# NGINX with PHP fpm and socket
As simple as possible.

- two service
  - php: (based on webfux/php base image)
    - using composer
  - nginx: (based on webfux/nginx base image)

- for nginx
  - 99-unix-socket-user (to attach nginx user to usergroup "socket")
- for php
  - 99-unix-socket-user (to attach ```$(whoami)``` user to usergroup "socket")
  - 99-php-composer-install (run run composer install)

### How to deploy
[Usage of docker compose command](../README.md#usage-of-docker-compose-command)

### How to reach (www)
http://www.dev.webfux.io

### How to reach (api)
http://api.dev.webfux.io

---
[Back to examples overview](../README.md)