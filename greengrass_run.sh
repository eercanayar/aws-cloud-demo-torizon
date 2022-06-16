#!/bin/bash
set -e

source ./project_settings.sh

PROJ_NAME='aws-cloud-demo-torizon'


ssh -t torizon@$BOARD_IP "\
 docker run -it --network host \
    -v /dev:/dev \
    -v /tmp:/tmp \
    -v /run/udev/:/run/udev/ \
    -v /home/torizon/greengrass/:/greengrass/ \
    -v /home/torizon/kvs/:/kvs/ \
    --env-file=/home/torizon/kvs-settings \
    --device-cgroup-rule='c 81:* rmw' \
    --device-cgroup-rule='c 4:* rmw' \
    --device-cgroup-rule='c 13:* rmw' \
    --device-cgroup-rule='c 199:* rmw' \
    --device-cgroup-rule='c 226:* rmw' \
    -e ACCEPT_FSL_EULA=1 \
    --name $PROJ_NAME \
    $DOCKERHUB_LOGIN/$PROJ_NAME"
