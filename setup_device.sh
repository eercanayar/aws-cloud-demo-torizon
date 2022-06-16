#!/bin/bash
set -e

source ./project_settings.sh

PROJ_NAME='aws-cloud-demo-torizon'
# !!! MANUALLY DELETE: sudo rm -rf /home/torizon/greengrass
# !!! MANUALLY DELETE: rm -rf kvs*

ssh -t torizon@$BOARD_IP "\
  rm -rf /home/torizon/greengrass-*.tar.gz"

scp -r \
  deploy/greengrass-*.tar.gz \
  torizon@$BOARD_IP:/home/torizon/

sshpass -p $BOARD_PWD ssh -t torizon@$BOARD_IP "\
  (echo $BOARD_PWD | sudo -S tar xvf greengrass-*.tar.gz ) \
  "
