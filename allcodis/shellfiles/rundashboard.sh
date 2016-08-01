#!/bin/bash

HOST_IP=`hostname --ip-address`
sed -i "s/DASHBOARD_ADDR/${HOST_IP}/g" $CODIS_HOME/codisconf/config.ini
sed -i "s/ZOOKEEPER_IP/${ZOOKEEPER}/g" $CODIS_HOME/codisconf/config.ini
sed -i "s/PRODUCT_NAME/${PRODUCT}/g" $CODIS_HOME/codisconf/config.ini

$CODIS_HOME/bin/codis-config -c $CODIS_HOME/codisconf/config.ini dashboard --addr=${HOST_IP}:18087 >> $CODIS_HOME/codislog/${PRODUCT}.log 2>&1

