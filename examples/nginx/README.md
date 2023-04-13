# NGINX with static files 
As simple as possible.

- one service (based on webfux/nginx base image)
- static files
- listen on port 80 and given domain<br>
```
    environment:
      - DOMAIN=webfux.io
      - WEBSERVER_SUB_DOMAIN=www.dev
```
- /.deploy/templates/default.conf.template
```
    server_name ${WEBSERVER_SUB_DOMAIN}.${DOMAIN};
```
### How to deploy
[Usage of docker compose command](../README.md#usage-of-docker-compose-command)

### How to reach (www)
http://www.dev.webfux.io

---
[Back to examples overview](../README.md)