#!/bin/bash
set -u

./scripts/cf/login -o cloudops -s cloudops

curl "https://app-usage.${CF_SYS_DOMAIN}/system_report/app_usages" -k \
     -H "authorization: `cf oauth-token`"

