#!/bin/bash

openstack flavor create --ram 8192 --disk 80 --ephemeral 500 --vcpus 4 --rxtx-factor 1.0 --public m1.large_500e
