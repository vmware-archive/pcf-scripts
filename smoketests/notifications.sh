#!/bin/bash

timestamp=`date +'%s'`
recipent=${IMAP_USER}
which uaac > /dev/null || gem install cf-uaac --no-ri --no-rdoc
uaac target uaa.${CF_SYS_DOMAIN:?} --skip-ssl-validation
uaac token client get notifications --secret ${NOTIFICATIONS_CLIENT_SECRET:?}
# it will ask for a secret. get that from the manifest; search for `emails.write`

uaac curl -X POST \
  -H "X-NOTIFICATIONS-VERSION: 1" \
  -d '{
    "to":"'$recipent'",
    "subject":"'${ENVIRONMENT_NAME}' notifications smoketest '${timestamp}'",
    "text":"this is a test",
    "kind_id":"my-notification"
  }' \
  https://notifications.${CF_SYS_DOMAIN}/emails

echo "Sleeping 30 seconds..."
sleep 30

ruby ./scripts/smoketests/check-imap-emails.rb
