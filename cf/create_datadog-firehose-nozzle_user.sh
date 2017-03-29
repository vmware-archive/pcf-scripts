#!/bin/bash

./scripts/cf/login_uaa

uaac client add --name datadog-firehose-nozzle \
  --authorities oauth.login,doppler.firehose \
  --authorized_grant_types authorization_code,client_credentials,refresh_token \
  --scope openid,oauth.approvals,doppler.firehose \
  --secret "${CF_UAA_DATADOG_CLIENT_SECRET:?Please supply a secret for datadog client}" datadog-firehose-nozzle
