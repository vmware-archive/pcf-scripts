#!/bin/bash

# this was written and tested on a Mac; dunno about Linux.

set -e

TODAY_FORMAT=`date +%Y%m%d` # formatted like cf smoke test spaces

./scripts/cf/login -o cloudops -s cloudops-smoke-tests
cf stop cf-smoke-tests-0

DEFUNCT_SPACES=`cf spaces | grep cloudops-smoke-tests_ | grep -v $TODAY_FORMAT || echo ""`

echo Count of spaces:
echo $DEFUNCT_SPACES | wc -w

for i in $DEFUNCT_SPACES; do
  cf delete-space $i -f
done

cf start cf-smoke-tests-0
