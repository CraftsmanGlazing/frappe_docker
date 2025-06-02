#!/bin/bash
#Install ERPNEXT Container

cd ..
docker compose -f pwd.yml up -d

#Installing all Applications
allcontainers=($(docker ps -a --format "{{.Names}}"))
substring="frappe"
containers=()

for container in "${allcontainers[@]}"; do
        if [[ "${container}" == *"$substring"* ]]; then
                containers+=("${container}")
        fi
done

substring="backend"

for container in "${containers[@]}"; do
    if [[ "$container" == *"$substring"* ]]; then
        backend="$container"
    fi
done


docker exec ${backend} bench --site frontend install-app print_designer
docker exec ${backend} bench --site frontend install-app lms
docker exec ${backend} bench --site frontend install-app hrms
docker exec ${backend} bench --site frontend install-app helpdesk
docker exec ${backend} bench --site frontend install-app crm

docker exec ${backend} bench --site frontend migrate
docker exec ${backend} bench --site frontend clear-cache


# This has to be installed after
cd craftsman
docker compose -f https-compose.yml up -d
