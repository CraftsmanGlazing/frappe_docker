#!/bin/bash

#Running The Docker Container Build
sudo chmod + prestage.sh
sudo ./prestage.sh

localhostname=$(hostname)

echo "What is the Domain?"
read DOMAIN

echo " Whats the Lookup in Domain?"
read SUB

cd ..
docker compose -f pwd.yml up -d
cd craftsman/

export HTTP_HOSTNAME="$localhostname"
export HTTP_DOMAIN="$DOMAIN"
export HTTP_SUB="$SUB"

docker compose -f https-compose.yml up -d
