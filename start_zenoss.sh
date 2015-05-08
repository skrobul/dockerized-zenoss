#!/bin/bash
service rabbitmq-server start
sleep 1
# RabbitMQ ctl stores configuration that is specific to current hostname
# which changes every time when the container is started, so we have to 
# re-set the passwords first

PASS="grep amqppassword \$ZENHOME/etc/global.conf | awk '{print \$2}'"
RABBITMQCTL=$(which rabbitmqctl)
$RABBITMQCTL stop_app
$RABBITMQCTL reset
$RABBITMQCTL start_app
$RABBITMQCTL add_user "zenoss" "$(su -l zenoss -c "$PASS")"
$RABBITMQCTL add_vhost "/zenoss"
$RABBITMQCTL set_permissions -p "/zenoss" "zenoss" '.*' '.*' '.*'


for serv in snmpd memcached mysql exim zenoss crond jexec ; do
    service $serv start
done
# Finally, redirect logs to stdout
tail -f /opt/zenoss/log/*.log
