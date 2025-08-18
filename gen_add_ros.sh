#!/bin/bash

BASE=https://raw.githubusercontent.com/osrf/docker_images/refs/heads/

function fix_downloaded {
    sed -i '/^# setup timezone/,/^$/    s/^/#/' $1
    sed -i '/^# setup environment/,/^$/ s/^/#/' $1
    sed -i '/^# setup entrypoint/,/^$/  s/^/#/' $1
    sed -i '/^### start:ros-base/,/^$/  s/^/#/' $1
    sed -i '/^CMD/                      s/^/#/' $1
    sed -i '/^ENTRYPOINT/               s/^/#/' $1
    #sed -i '/^FROM/d'                           $1
    #sed -i '1i FROM ${BASE_IMAGE}'              $1
    sed -i -e 's/^FROM \(.*\)/ARG BASE_IMAGE=\1\nFROM ${BASE_IMAGE}/' $1
}

#RUN if [ ! -e /etc/timezone ]; then \
#    echo "Etc/UTC" > /etc/timezone && \
#    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
#    apt-get update && \
#    apt-get install -q -y --no-install-recommends tzdata && \
#    rm -rf /var/lib/apt/lists/* ; \
#    fi
function conditional_set_timezone {
    sed -i -e 's@^## setup timezone@RUN if [ ! -e /etc/timezone ]; then \\ \n    echo "Etc/UTC" > /etc/timezone \&\& \\ \n    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime \&\& \\ \n    apt-get update \&\& \\ \n    apt-get install -q -y --no-install-recommends tzdata \&\& \\ \n    rm -rf /var/lib/apt/lists/* ; \\ \n    fi\n## setup timezone(org)@' $1
}

## humble 22.04
FNAME=Dockerfile.add_humble
wget ${BASE}master/ros/humble/ubuntu/jammy/ros-core/Dockerfile -O - >  "${FNAME}"
echo "### start:ros-base" >> "${FNAME}"
wget ${BASE}master/ros/humble/ubuntu/jammy/ros-base/Dockerfile -O - >> "${FNAME}"
fix_downloaded "${FNAME}"
conditional_set_timezone "${FNAME}"

## jazzy 24.04
FNAME=Dockerfile.add_jazzy
wget ${BASE}master/ros/jazzy/ubuntu/noble/ros-core/Dockerfile -O - >  "${FNAME}"
echo "### start:ros-base" >> "${FNAME}"
wget ${BASE}master/ros/jazzy/ubuntu/noble/ros-base/Dockerfile -O - >> "${FNAME}"
fix_downloaded "${FNAME}"
conditional_set_timezone "${FNAME}"

## noetic 20.04
FNAME=Dockerfile.add_noetic
wget ${BASE}master/ros/noetic/ubuntu/focal/ros-core/Dockerfile -O - >  "${FNAME}"
echo "### start:ros-base" >> "${FNAME}"
wget ${BASE}master/ros/noetic/ubuntu/focal/ros-base/Dockerfile -O - >> "${FNAME}"
fix_downloaded "${FNAME}"
conditional_set_timezone "${FNAME}"

## TODO rolling
#master/ros/rolling/jammy/noble/ros-core/Dockerfile
#master/ros/rolling/jammy/noble/ros-base/Dockerfile
#master/ros/rolling/ubuntu/noble/ros-core/Dockerfile
#master/ros/rolling/ubuntu/noble/ros-base/Dockerfile
