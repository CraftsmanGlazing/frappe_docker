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
        docker exec ${container} bench get https://github.com/frappe/print_designer.git --branch main --resolve-deps &
done
wait
#Installing App
docker exec ${backend} bench --site frontend install-app print_designer
docker exec ${backend} bench --site frontend migrate
docker exec ${backend} bench --site frontend clear-cache

##Services Restart
docker exec ${backend} bench restart
docker restart $(docker ps -q)

### This all needs to be integrated in here as well ( I dont know if all these updates are needed as I fixed it but its not obvious this had anything to do with it.
#apt update
#apt install dbus
#apt install -y fonts-liberation libappindicator3-1 libasound2 \
#    libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 libgdk-pixbuf2.0-0 \
#    libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 \
#    xdg-utils libu2f-udev libvulkan1 libxss1 libgbm1
#apt install wget
#wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
#echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | \
#  tee /etc/apt/sources.list.d/google-chrome.list

#apt update
#apt install -y wget gnupg2 software-properties-common
#apt install -y google-chrome-stable

# You need to do this to get out of annoying extra error
#nano apps/print_designer/print_designer/pdf_generator/cdp_connection.py
#async def _disconnect(self):
    #try:
    #    if self.connection:
            # Check if the connection has a 'closed' attribute
    #        if hasattr(self.connection, 'closed') and not self.connection.closed:
     #           await self.connection.close()
      #      self.connection = None
   # except Exception as e:
   #     frappe.log_error(
    #        title="Error during WebSocket disconnection", message=frappe.get_traceback()
