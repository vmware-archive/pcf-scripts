#!/bin/bash
# Supply: pcf-openstack-1.7.0.0.raw

set -evx

openstack --verbose ${OS_INSECURE} image create ${1:?please specify opsman image name to create} --file ${2:?please specify opsman disk image file} --disk-format raw --min-disk 80 --min-ram 4096 #--protected --private
