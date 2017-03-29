#!/bin/bash

# this was written and tested on a Mac; dunno about Linux.

set -e

TODAY_FORMAT=`date +%Y_%m_%d` # formatted like rabbitmq smoke test spaces

./scripts/cf/login -o cloudops -s cloudops

DEFUNCT_ORGS=`cf orgs | grep MySQLATS-ORG | grep -v $TODAY_FORMAT || echo ""`

echo Count of orgs:
echo $DEFUNCT_ORGS | wc -w

for i in $DEFUNCT_ORGS; do
  cf delete-org $i -f
done

DEFUNCT_QUOTAS=`cf quotas | grep MySQLATS-QUOTA | grep -v $TODAY_FORMAT | cut -f 1 -d " " || echo "" `

echo Count of quotas:
echo $DEFUNCT_QUOTAS | wc -w

for i in $DEFUNCT_QUOTAS; do
  cf delete-quota $i -f
done
