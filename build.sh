#!/bin/bash
set -e

BASE_FOLDER=$(realpath $(dirname "$0"))
BUILD_ARG_FILE=".build.args"
DOCKER_FILE="Dockerfile"

function exit_help() {
    if [[ -n ${1} ]];then
      echo "$(tput setaf 1)[$(date)]<E> ${1}$(tput sgr 0)"
      echo
    fi
    echo "Usage: build.sh [DOCKER_FOLDER] [TAG] [BUILD_STAGE] (OPTIONS...)"
    echo
    echo "arguments:"
    echo "   DOCKER_FOLDER                        is an existing path within"
    echo "                                        /.Dockerfile"
    echo "   TAG                                  to be used tag for this build"
    echo "   BUILD_STAGE                          to be used build stage in Dockerfile"
    echo "                                        - no build step will be used"
    echo
    echo "options:"
    echo "                                        ...all given arguments are forwarded to the docker command"
    echo "   --preview                            just build the command(s) to be executed and print it"
    echo
    if [[ -n ${1} ]];then
      exit 1
    fi
}

if [[ -z ${1} ]]; then
  exit_help "argument [DOCKER_FOLDER] missing"
fi
DOCKER_FOLDER=${BASE_FOLDER}/${1}

if [ ! -f "${DOCKER_FOLDER}/${DOCKER_FILE}" ]; then
  exit_help "${DOCKER_FOLDER}/${DOCKER_FILE} file does not exists"
fi;

if [ ! -f "${DOCKER_FOLDER}/${BUILD_ARG_FILE}" ]; then
  exit_help "${DOCKER_FOLDER}/${BUILD_ARG_FILE} file does not exists"
fi;

if [[ -z ${2} ]]; then
  exit_help "argument [TAG] missing"
fi
TAG=${2}

#
# source .build.args (has to include BUILD_IMAGE_NAME)
#
# shellcheck source=php/.build.args
source "${DOCKER_FOLDER}/${BUILD_ARG_FILE}"

if [[ -z ${3} ]]; then
  exit_help "argument [BUILD_STAGE] missing, set - if no build stage should be used"
fi

if [[ ${3} != "-" ]];then
  TARGET=" --target ${3}"
fi

CMD="docker build${TARGET} --tag ${TAG} ."

#
# pass given .build.args as build-args to docker build
#
ARGUMENT=$(cat ${DOCKER_FOLDER}/${BUILD_ARG_FILE} | sed 's@^@--build-arg @g' | paste -sd ' ')
CMD="${CMD} ${ARGUMENT}"

#
# forward all given arguments to CMD (ignore first 3 arguments)
#
y=3
ARGUMENTS=( "$@" )
while [[ $y -lt ${#ARGUMENTS[@]} ]]
do
  ARGUMENT=${ARGUMENTS[$y]}
  case ${ARGUMENT} in
    --help)
      exit_help;
      (( y++))
      ;;
    --preview)
      PREVIEW_CMD=1
      (( y++))
      ;;
    *)
      CMD="${CMD} ${ARGUMENT}"
      (( y++))
    ;;
  esac
done

#
# execute or just preview prepared CMD
#
start=(date +%s)
echo "[$(date)]<I> switch to directory ${DOCKER_FOLDER}"
echo "[$(date)]<I> start execute command: ${CMD}"
if [[ -z ${PREVIEW_CMD} ]]; then
  cd "${DOCKER_FOLDER}"
  ${CMD}
fi
end=(date +%s)
runtime=$((end-start))
echo "[$(date)]<I> end execute command: (runtime: ${runtime} sec)"
echo
