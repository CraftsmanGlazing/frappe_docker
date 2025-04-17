#!/bin/bash

#Docker Info
backend="frappe_docker_backend-1"
frontend="frappe_docker-frontend-1"
scheduler="frappe_docker-scheduler-1"
websocker="frappe_docker-websocket-1"
queueLong="frappe_docker-queue-long-1"
queueShort="frappe_docker-queue-short-1"

container_array=(${frontend} ${backend} ${scheduler} ${websocket} ${queueLong} ${queueShort})


##installing backend files in all containers
for container in ${container_array[@]}; do
        echo "$container : Install Started"
        docker exec ${container} python -m pip install --upgrade redis &
        sleep 2
        docker exec ${container} import redis from redis.commands.json.path import Path &
        sleep 3
        docker exec ${container} bench get https://github.com/frappe/wiki.git --branch version-14 --resolve-deps &
done
wait
echo "Finished Installing/Downloading on all containers"
#Installing App
echo "Starting Install on Application"
docker exec ${backend} bench --site frontend install-app wiki
docker exec ${backend} bench --site frontend migrate
docker exec ${backend} bench --site frontend clear-cache
echo "Restarting... Please Note: you may need to restart docker containters"
##Services Restart
docker exec ${backend} bench restart
docker restart $(docker ps -q) #docker restart doesn't work it locks up
