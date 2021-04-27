#!/bin/bash

docker stop $(sudo docker ps -a -q)
docker rm $(sudo docker ps -a -q)
docker system prune -a --volumes
sudo umount /var/lib/docker/volumes

cd /
sudo rm -Rf /bdcloud

sudo git clone https://github.com/buerodigital/bdcloud.git
#sudo mkdir /bdcloud/_volumes
#sudo cp -R /var/lib/docker/volumes/ /bdcloud/_volumes
sudo chown -R 1000:1000 /bdcloud
sudo chmod -R +x /bdcloud
#sudo mount --bind /bdcloud/_volumes /var/lib/docker/volumes


cd /bdcloud/00_host
./bdcloud.sh


