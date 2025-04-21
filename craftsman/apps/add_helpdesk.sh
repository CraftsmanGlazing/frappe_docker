#!/bin/bash

#Docker Info
backend="frappe_docker-backend-1"
frontend="frappe_docker-frontend-1"
scheduler="frappe_docker-scheduler-1"
websocker="frappe_docker-websocket-1"
queueLong="frappe_docker-queue-long-1"
queueShort="frappe_docker-queue-short-1"

container_array=(${frontend} ${backend} ${scheduler} ${websocket} ${queueLong} ${queueShort})


##installing backend files in all containers
for container in ${container_array[@]}; do
        echo $container
        docker exec ${container} bench get https://github.com/frappe/helpdesk.git --branch version-14 --resolve-deps &
done
wait
#Installing App
docker exec ${backend} bench --site frontend install-app helpdesk
docker exec ${backend} bench --site frontend migrate
docker exec ${backend} bench --site frontend clear-cache

##Services Restart
docker exec ${backend} bench restart
docker restart $(docker ps -q)
