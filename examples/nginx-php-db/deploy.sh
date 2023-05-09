#!/bin/bash
source .env.local
DIR=${PWD##*/}
APPLICATION="${DIR//-/_}"
echo ":$DIR:"
docker rm -f $(docker ps -aq -f name="$APPLICATION*")