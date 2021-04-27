#!/bin/bash

confirm="n"
function funct_pull {
docker-compose -f /bdcloud/02_nextcloud/docker-compose.yml pull
}
while [ "$confirm" == "n" ]
do
  funct_pull
  echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" abbrechen:\n"
  read confirm
done


# Installation 02_nextcloud
docker volume create --name=data_02_nextcloud_db
docker volume create --name=data_02_nextcloud
docker volume create --name=conf_02_nextcloud
sudo cp -f /bdcloud/02_nextcloud/nextcloud.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/nextcloud.subfolder.conf
docker-compose -f /bdcloud/02_nextcloud/docker-compose.yml up -d
#docker-compose -f /bdcloud/02_nextcloud/docker-compose.yml down

# Dienste starten
#docker-compose -f /bdcloud/02_nextcloud/docker-compose.yml up -d
# Proxy als letztes starten
docker-compose -f /bdcloud/01_proxy/docker-compose.yml down
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d

echo -e "\nVor Seitenaufruf etwa 10-15 Minuten warten.\nEntsprechend der nextcloud.subfolder.conf die config.php im Container anpassen."
