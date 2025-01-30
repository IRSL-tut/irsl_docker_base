#!/bin/bash

set -e

## required
_DOCKER_FILES=${DOCKER_FILES:-$@}
_INPUT_IMAGE=${INPUT_IMAGE:-""}

## optional
_PULL=${PULL:-""}
_CACHE=
_OUTPUT_IMAGE=${OUTPUT_IMAGE:-"build_output"}
_BUILD_PREFIX=${BUILD_PREFIX:-"temp/build_image"}

if [ -n "$NO_CACHE" ]; then
    _CACHE='--no-cache'
fi

# echo ${_DOCKER_FILES}
# for fname in ${_DOCKER_FILES}; do
#     set -x
#     echo ${fname}
#     set +x
# done

if [ -z "${_INPUT_IMAGE}" ]; then
    echo "Please set INPUT_IMAGE environment-variable"
    exit 0
fi

if [ -n "${_PULL}" ]; then
    set -x
    docker pull ${_INPUT_IMAGE}
    set +x
fi

_CNTR=0
_NEXT_IMAGE=${_BUILD_PREFIX}:${_CNTR}

for fname in ${_DOCKER_FILES}; do
    set -x
    docker build . ${_CACHE} --progress=plain -f ${fname} \
           --build-arg BASE_IMAGE=${_INPUT_IMAGE} \
           -t ${_NEXT_IMAGE}
    set +x
    _INPUT_IMAGE=${_NEXT_IMAGE}
    _CNTR=$(expr ${_CNTR} + 1)
    _NEXT_IMAGE=${_BUILD_PREFIX}:${_CNTR}
    _CACHE=
done

docker tag ${_INPUT_IMAGE} ${_OUTPUT_IMAGE}

# INPUT_IMAGE=ubuntu:24.04 OUTPUT_IMAGE=repo.irsl.eiiris.tut.ac.jp/irsl_base:one_nvidia ./build_sequential.sh Dockerfile.add_glvnd Dockerfile.add_virtualgl Dockerfile.add_one Dockerfile.add_entrypoint
# INPUT_IMAGE=ubuntu:22.04 ./build_sequential.sh Dockerfile.add_glvnd Dockerfile.add_virtualgl Dockerfile.add_humble Dockerfile.add_entrypoint
# INPUT_IMAGE=ubuntu:20.04 ./build_sequential.sh Dockerfile.add_glvnd Dockerfile.add_virtualgl Dockerfile.add_noetic Dockerfile.add_entrypoint
