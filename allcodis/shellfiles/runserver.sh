#!/bin/bash

HOST_IP=`ip addr show eth0 | grep "inet " | awk '{print $2}'|awk -F'/' '{print $1}'`

sed -i "s/LOCAL_IP/${HOST_IP}/g" $CODIS_HOME/serverconf/conf/server_6900.conf

$CODIS_HOME/bin/codis-server $CODIS_HOME/serverconf/conf/server_6900.conf

