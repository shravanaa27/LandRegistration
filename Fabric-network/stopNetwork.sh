#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#
echo "Tearing down ......."
############## host terminal ##############

docker-compose -f docker/docker-compose-3org.yaml down

docker-compose -f docker/docker-compose-ca.yaml down

docker rm -f $(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')

docker volume prune

sudo rm -rf organizations/

sudo rm -rf channel-artifacts/

docker ps -a

echo "Done execution"

