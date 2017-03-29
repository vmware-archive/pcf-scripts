#!/bin/bash

RESULTS_PER_PAGE=${RESULTS_PER_PAGE:-100}

if [[ "$(which cf)X" == "X" ]]; then
  echo "Please install cf"
  exit 1
fi
if [[ "$(which jq)X" == "X" ]]; then
  echo "Please install jq - http://stedolan.github.io/jq/download/"
  exit 1
fi

debug() {
  if [[ -n ${DEBUG} && ${DEBUG} != '0' ]];
    then echo >&2 '>> ' "$*"
  fi
}

function cf_curl() {
  set -e
  url=$1
    cf curl "${url}"
}

echo "The following apps have no buildpack explicitly set and will use the default:"
next_url="/v2/apps?results-per-page=${RESULTS_PER_PAGE}"
while [[ "${next_url}" != "null" ]]; do
  #debug "Finding Apps from ${next_url}"
  app_urls=$(cf_curl ${next_url} | jq -r -c '.resources[]| select(.entity.buildpack==null) | .metadata.url')
  for app_url in $app_urls; do
   # debug "Getting app data from $app_url"
    response=$(cf_curl $app_url)
    app_name=$(echo $response | jq -r -c .entity.name)
    buildpack=$(echo $response | jq -r -c .entity.buildpack)
    state=$(echo $response | jq -r -c .entity.state)
    space_url=$(echo $response| jq -r -c .entity.space_url)
    space_name=$(cf_curl $space_url | jq -r -c .entity.name)
    org_url=$(cf_curl $space_url | jq -r -c .entity.organization_url)
    org_name=$(cf_curl $org_url | jq -r -c .entity.name)
    echo -e "\033[0;32mApp Name: $app_name - Org: $org_name Space: $space_name State: $state\033[0m"
  done
  next_url=$(cf_curl ${next_url} | jq -r -c ".next_url")
done
