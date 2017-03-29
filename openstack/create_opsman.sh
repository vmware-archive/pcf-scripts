#!/bin/bash

set -evx

openstack --verbose ${OS_INSECURE} server create --image ${2:?Please specify opsman image to use} --flavor m1.large --key-name pcf --security-group opsmanager --availability-zone ${OS_SINGLETON_AVAILABILITY_ZONE:?} --nic net-id=${MGMT_NETWORK_ID:?},v4-fixed-ip=$(dig +short opsman.${CF_SYS_DOMAIN:?}) ${1:?Please specify name of opsman server to create}
#openstack --verbose ${OS_INSECURE} server create --image ${2:?Please specify opsman image to use} --flavor m1.large --key-name pcf --security-group opsmanager --availability-zone ${OS_SINGLETON_AVAILABILITY_ZONE:?} --nic net-id=${MGMT_NETWORK_ID:?},v4-fixed-ip=10.2.16.16 ${1:?Please specify name of opsman server to create}
