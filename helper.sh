#!/bin/bash

[[ -f .venv/bin/activate ]] ||  {
  echo "Unable to find virtualenv environment in .venv/. initializing"
  pip install virtualenv
  scripts/install_packages
}

source .venv/bin/activate

# netcat options aren't portable
if [ $(nc -v 2>&1 | grep -c netcat-openbsd) -ne 0 ]; then
  # e.g. on jumpbox
  NC_TIMEOUT="-w 1"
else
  NC_TIMEOUT="-G 1"
fi

nc ${NC_TIMEOUT} -z ${BOSH_IP} 25555 && {
  echo "Log in with:"
} || {
  echo Unable to ping BOSH director. start ssh tunnel by performing the following:
  echo "scripts/<environment>/setup_tunnel"
  echo or scripts/jumpbox/setup_tunnel
  echo "then log in with:"
}

echo scripts/opsman/login
echo scripts/cf/login
