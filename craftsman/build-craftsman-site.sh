#!/bin/bash

#Running The Docker Container Build
sudo chmod + prestage.sh
sudo ./prestage.sh

localhostname=$(hostname)

echo "What is the Domain?"
read DOMAIN

echo " Whats the Lookup in Domain?"
read SUB

export HTTPS_HOSTNAME="$localhostname"
export HTTPS_DOMAIN="$DOMAIN"
export HTTPS_SUB="$SUB"

cd ..
docker compose -f pwd.yml up -d
cd craftsman/

docker compose -f https-compose.yml up -d
