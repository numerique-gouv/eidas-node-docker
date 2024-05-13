#!/bin/bash

set -e

if [ -z "$EIDAS_INSTANCE" -o -z "$EIDAS_PORT" ]; then
  echo Define EIDAS_INSTANCE and EIDAS_PORT
  exit 1
fi

if [ "$EIDAS_TYPE" != "mock" -a "$EIDAS_TYPE" != "node" ]; then
  echo "EIDAS_TYPE must be 'node' or 'mock'"
  exit 1
fi

ls -d /etc/eidas/instances/$EIDAS_INSTANCE

docker run \
 -p '[::1]':$EIDAS_PORT:8080 \
 --mount type=bind,source=/etc/eidas/instances/$EIDAS_INSTANCE,target=/config/eidas,readonly \
 eidas-$EIDAS_TYPE:tomcat-latest
