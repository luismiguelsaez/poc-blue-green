#!/usr/bin/env bash

# Check current running version, based on what upstream we're pointing to
grep -E "proxy_pass.*blue-application" conf/nginx-dynamic.conf 2>&1 >/dev/null && CURRENT="blue" && NEW="green"
grep -E "proxy_pass.*green-application" conf/nginx-dynamic.conf 2>&1 >/dev/null && CURRENT="green" && NEW="blue"

echo "Application currently running is [$CURRENT]"

# Reconfigure nginx file to point to the new version
echo "Switching from [$CURRENT] to [$NEW]"
sed -i '' -e 's/\(proxy_pass http:\/\/\).*;/\1'${NEW}'-application;/g' conf/nginx-dynamic.conf

# To force the new application version, we are forcing the recreation of the container
docker-compose stop $NEW
docker-compose rm -f $NEW
docker-compose up $NEW --build -d

# Check and reload new nginx configuration
docker-compose exec router nginx -t
docker-compose exec router nginx -s reload

# Check that the new version is returning a valid HTTP code
sleep 2
RES=$(curl localhost:8080/status -s -o/dev/null -w "%{http_code}")

# Auto-rollback to previous version if the HTTP code is not valid
if [[ "$RES" != "200" ]]
then
  echo "Got code [$RES]. Switching from [$NEW] to [$CURRENT]"
  sed -i '' -e 's/\(proxy_pass http:\/\/\).*;/\1'${CURRENT}'-application;/g' conf/nginx-dynamic.conf

  docker-compose exec router nginx -t
  docker-compose exec router nginx -s reload
else
  echo "Got code [$RES]. Keeping new version"
fi
