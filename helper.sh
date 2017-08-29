#!/bin/bash

[[ -f .venv/bin/activate ]] ||  {
  echo "Unable to find virtualenv environment in .venv/. initializing"
  pip install virtualenv
  scripts/install_packages
}

source .venv/bin/activate

echo "scripts/<environment>/setup_tunnel"
echo or scripts/jumpbox/setup_tunnel
echo "then log in with:"

echo scripts/opsman/login
echo scripts/cf/login
