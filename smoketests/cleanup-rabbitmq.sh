#!/bin/bash

# this was written and tested on a Mac; dunno about Linux.

set -e

TODAY_FORMAT=`date +%Y_%m_%d` # formatted like rabbitmq smoke test spaces

./scripts/cf/login -o cloudops -s cloudops

DEFUNCT_SPACES=`cf spaces | grep rabbitmq-smoke-tests- | grep -v $TODAY_FORMAT || echo ""`

echo Count of spaces:
echo $DEFUNCT_SPACES | wc -w

for i in $DEFUNCT_SPACES; do
  cf delete-space $i -f
done


DEFUNCT_USERS=`cf org-users cloudops -a | grep rabbitmq-smoke-tests-USER | grep -v $TODAY_FORMAT || echo ""`

echo Count of users:
echo $DEFUNCT_USERS | wc -w

for i in $DEFUNCT_USERS; do
  cf delete-user $i -f
done
