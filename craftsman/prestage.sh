#!/bin/bash
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
echo "Confirming Correct Applications:"
echo -n ${APPS_JSON_BASE64} | base64 -d

printf 'Does this have all applications included (y/n)? '
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then 
    echo "Continuing...."
else
    echo "Cancelled"
    exit
fi
echo "Building Local Docker Image this will take a wile.."
sudo docker build \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=craftsman-custom:latest \
  --file=images/layered/Containerfile .

echo "Docker Image Created"
export CUSTOM_IMAGE='craftsman-custom'
export CUSTOM_TAG='latest'
