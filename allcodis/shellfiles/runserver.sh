#!/bin/bash

HOST_IP=`hostname --ip-address`

sed -i "s/LOCAL_IP/${HOST_IP}/g" $CODIS_HOME/serverconf/conf/server_6900.conf

$CODIS_HOME/bin/codis-server $CODIS_HOME/serverconf/conf/server_6900.conf

