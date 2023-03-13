# Examples

Every example requires to have built base images.<br>
_How to build base images: [README.md](../build/README.md)_

**Guideline**
1. [Docker and Docker compose](#docker-and-docker-compose)
   1. [Understanding multiple Compose files](#understanding-multiple-compose-files)
   2. [BuildContext for Dockerfiles](#buildcontext-for-dockerfiles)

**Examples**
1. [NGINX with static files](nginx/README.md)

# Guideline
## Docker and Docker compose

### Understanding multiple Compose files
By default, Compose reads two files:
- docker-compose.yml
- docker-compose.override.yml (optional, only if present)
#### docker-compose.yml
Contains your base configuration.
#### docker-compose.override.yml
The override file, as its name implies, can contain configuration overrides for existing services or entirely new services.
#### Usage of docker compose command
```
# local deployment (with docker-compose.override.yml)
docker compose up -d
```
```
# production deployment (ignore docker-compose.override.yml)
docker compose -f docker-compose.yml up -d
```
### BuildContext for Dockerfiles
The docker-compose.yml build has to have a path to the build context.<br>
_has to have: the way we are using docker_

The used Dockerfile, in the build process, can only access files and directories next to the given context path. This prevents having access to files/directories outside the given context path. Projects should be well organized and independently arranged. 

