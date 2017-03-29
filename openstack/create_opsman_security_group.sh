#!/bin/bash
# TODO: It is idempotent

openstack ${OS_INSECURE} security group create opsmanager;

for ITERATOR in 22 80 443 25555; do 
  openstack ${OS_INSECURE} security group rule create -f yaml --ingress --proto tcp --ethertype IPv4 --dst-port $ITERATOR opsmanager;
done;
openstack ${OS_INSECURE} security group rule create -f yaml --ingress --proto tcp --ethertype IPv4 --dst-port 1:65535 --src-group opsmanager opsmanager;
openstack ${OS_INSECURE} security group rule create -f yaml --ingress --proto udp --ethertype IPv4 --dst-port 1:65535 --src-group opsmanager opsmanager;

