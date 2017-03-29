set -e

GROUP_NAME=${1:-'scim.write'}

if [ -z $CF_UAA_URI ]; then
  echo "Uaa endpoint not set. Exiting..."
  exit 1
fi
echo "Working with the following context"
uaac info | grep "uaa:"

GROUP_ID=`uaac curl /Groups/ | sed '1,/RESPONSE BODY/d' | jq -r -c ".resources[]| select(.displayName==\"${GROUP_NAME}\")| .id"`


if [ -z $GROUP_ID ]; then
  echo "Group $GROUP_NAME not found. Exiting..."
  exit 1
fi

echo "Looking for members of group $GROUP_NAME: $GROUP_ID"
echo "Note: Not all groups that should return members actually do. Verify."
uaac curl /Groups/$GROUP_ID/members?returnEntities=true | sed '1,/RESPONSE BODY/d' | jq -r -c '.[].entity.userName'
