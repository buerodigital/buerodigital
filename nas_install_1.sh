#!/bin/bash

confirm="n"
function funct_pull {
docker-compose -f /bdcloud/01_proxy/docker-compose.yml pull
docker-compose -f /bdcloud/02_pihole/docker-compose.yml pull
docker-compose -f /bdcloud/03_samba/docker-compose.yml pull
docker-compose -f /bdcloud/09_dms/docker-compose.yml pull
docker-compose -f /bdcloud/10_dlna/docker-compose.yml pull
}
while [ "$confirm" == "n" ]
do
  funct_pull
  echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" abbrechen:\n"
  read confirm
done


# Installation 01_proxy
docker network create proxy
docker volume create --name=conf_01_proxy
docker volume create --name=conf_01_heimdall
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d
docker-compose -f /bdcloud/01_proxy/docker-compose.yml down
sudo cp -f /bdcloud/01_proxy/default /var/lib/docker/volumes/conf_01_proxy/_data/nginx/site-confs/default
sudo cp -f /bdcloud/01_proxy/proxy.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy.conf
sudo mkdir /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs
sudo cp -f /bdcloud/01_proxy/heimdall.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/heimdall.subfolder.conf


# Installation 02_pihole
docker volume create --name=conf_02_pihole
docker volume create --name=conf_02_pihole_dns
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo cp /bdcloud/02_pihole/resolv.conf /etc/resolv.conf
docker-compose -f /bdcloud/02_pihole/docker-compose.yml up -d
docker-compose -f /bdcloud/02_pihole/docker-compose.yml down
sudo cp -f /bdcloud/02_pihole/pihole.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/pihole.subfolder.conf


# Installation 04_Samba
docker volume create --name=smb_video
docker volume create --name=smb_audio
docker volume create --name=smb_pictures
docker volume create --name=smb_fakturama
docker volume create --name=smb_home_mark
docker volume create --name=smb_tv
docker-compose -f /bdcloud/03_samba/docker-compose.yml up -d
docker-compose -f /bdcloud/03_samba/docker-compose.yml down


# Installation 09_Papermerge
docker volume create --name=conf_09_dms_config
docker volume create --name=conf_09_dms_data
docker-compose -f /bdcloud/09_dms/docker-compose.yml up -d
docker-compose -f /bdcloud/09_dms/docker-compose.yml down
sudo cp -f /bdcloud/09_dms/papermerge.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/papermerge.subfolder.conf


# Installation 10_DLNA
docker volume create --name=conf_10_dlna
docker-compose -f /bdcloud/10_dlna/docker-compose.yml up -d
docker-compose -f /bdcloud/10_dlna/docker-compose.yml down
sudo cp -f /bdcloud/10_dlna/emby.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/emby.subfolder.conf


# Dienste starten
docker-compose -f /bdcloud/02_pihole/docker-compose.yml up -d
docker-compose -f /bdcloud/03_samba/docker-compose.yml up -d
docker-compose -f /bdcloud/09_dms/docker-compose.yml up -d
docker-compose -f /bdcloud/10_dlna/docker-compose.yml up -d
# Proxy als letztes starten
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d


