#!/bin/bash
for serv in snmpd memcached mysql exim rabbitmq-server zenoss crond jexec ; do
    service $serv start
done
