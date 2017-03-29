#!/bin/bash
TODAY_FORMAT=`date +%Y%m%d` # formatted like cf smoke test spaces

# issues:
# 1. routes without apps (old)
# 2. apps
# 3. services

./scripts/cf/login -o redis-smoke-test-org -s redis-smoke-test-space || \
  ./scripts/cf/login -o system -s redis-smoke-test-space

if [ $? -ne 0 ]; then
  echo "login/target failed. exit..."
  exit
fi

echo "Issue 1 of 3: routes without apps"
echo Count of routes:
for i in 1 2 3; do
  cf routes | wc -l
  cf delete-orphaned-routes -f
done
echo This may be incomplete. New count of routes:
cf routes | wc -l


echo "Issue 2 of 3: all apps"
app_list=`cf a | cut -f 1 -d " "`
echo "App count:"
echo $app_list | wc -w
for app in $app_list; do
  cf d $app -f -r;
done

echo "Issue 3 of 3: services leak"
# if we delete one in use, it emits an error and leaves it as in use
service_list=`cf services | grep p-redis | cut -f 1 -d " "`
echo "Service count:"
echo $service_list | wc -w
for service in `echo $service_list`; do
  cf delete-service $service -f || echo "Couldn't delete service. Continuing..."
done
