#!/bin/bash

function install {
  echo "Install"
  
docker network create proxy
docker volume create --name=conf_01_proxy
docker volume create --name=conf_01_heimdall
  
  cat > 01_proxy.yml <<EOL
version: "3.7"

services:
  proxy:
    image: linuxserver/nginx:amd64-version-8349a582
    container_name: proxy
    depends_on:
      - "heimdall"
    environment:
      # User (Docker User) und Gruppen (Docker Gruppe) anpassen
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - conf_01_proxy:/config:z
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
    networks:
      - proxy


  heimdall:
    image: linuxserver/heimdall:version-2.2.2
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - conf_01_heimdall:/config:z
    restart: unless-stopped
    networks:
      - proxy

networks:
  proxy:
    external: true

volumes:
  conf_01_proxy:
    external: true
  conf_01_heimdall:
    external: true
    
  EOL
  
  CONFIRM="n"
  while [ "$CONFIRM" == "n" ]
  do
    docker-compose -f 01_proxy.yml pull
    echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" wiederholen:\n"
    read CONFIRM
  done  

docker-compose -f 01_proxy.yml up -d
docker-compose -f 01_proxy.yml down

sudo mkdir /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs

  cat > default <<EOL
#Zeilen eingefügt
map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
    }

server {
    listen 80 default_server;

    server_name _;

    return 301 https://$host$request_uri;
}

server {

        listen 443 ssl;

        root /config/www;
        index index.html index.htm index.php;

        server_name _;


        #Zeile eingefügt
        # enable subfolder method reverse proxy confs
        include /config/nginx/proxy-confs/*.subfolder.conf;

        ssl_certificate /config/keys/cert.crt;
        ssl_certificate_key /config/keys/cert.key;

        client_max_body_size 0;

#       location / {
#               try_files $uri $uri/ /index.html /index.php?$args =404;
#       }


        location ~ \.php$ {
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                # With php5-cgi alone:
                fastcgi_pass 127.0.0.1:9000;
                # With php5-fpm:
                #fastcgi_pass unix:/var/run/php5-fpm.sock;
                fastcgi_index index.php;
                include /etc/nginx/fastcgi_params;

        }
}      
  EOL
sudo mv default /var/lib/docker/volumes/conf_01_proxy/_data/nginx/site-confs/default

  cat > proxy.conf <<EOL
# Timeout if the real server is dead
proxy_next_upstream error timeout invalid_header http_500 http_502 http_503;

# Proxy Connection Settings
proxy_buffers 32 4k;
proxy_connect_timeout 240;
proxy_headers_hash_bucket_size 128;
proxy_headers_hash_max_size 1024;
proxy_http_version 1.1;
proxy_read_timeout 240;
proxy_redirect  http://  $scheme://;
proxy_send_timeout 240;

# Proxy Cache and Cookie Settings
proxy_cache_bypass $cookie_session;
#proxy_cookie_path / "/; Secure"; # enable at your own risk, may break certain apps
proxy_no_cache $cookie_session;

# Proxy Header Settings
proxy_set_header Connection $connection_upgrade;
proxy_set_header Early-Data $ssl_early_data;
proxy_set_header Host $host;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Ssl on;
proxy_set_header X-Real-IP $remote_addr;      
  EOL
sudo mv proxy.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy.conf

  cat > heimdall.subfolder.conf <<EOL
## Version 2020/12/09
# In order to use this location block you need to edit the default file one folder up and comment out the / location

location / {
    # enable the next two lines for http auth
    #auth_basic "Restricted";
    #auth_basic_user_file /config/nginx/.htpasswd;

    # enable the next two lines for ldap auth, also customize and enable ldap.conf in the default conf
    #auth_request /auth;
    #error_page 401 =200 /ldaplogin;

    # enable for Authelia, also enable authelia-server.conf in the default site config
    #include /config/nginx/authelia-location.conf;

    include /config/nginx/proxy.conf;
    resolver 127.0.0.11 valid=30s;
    set $upstream_app heimdall;
    set $upstream_port 443;
    set $upstream_proto https;
    proxy_pass $upstream_proto://$upstream_app:$upstream_port;

}      
  EOL
sudo mv heimdall.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/heimdall.subfolder.conf
  
  
}

function remove {
  echo "Remove"
}

function start {
  echo "Start"
  #docker-compose -f 01_proxy.yml up -d
}

function stop {
  echo "Stop"
  #docker-compose -f 01_proxy.yml down
  }

function help {
  echo "01_proxy\n"
  echo "Installiert die Grundfunktionalität\n\n"
  echo "Die Funktion bitte mit einem der folgenden Parameter aufrufen:\n"
  echo -e " -i, --install\t\t\t Installiert die Anwendung"
  echo -e " -s, --start, --restart\t\t\t Startet die Anwendung"   
  echo -e " -h, --stop, --halt\t\t\t Beendet die Anwendung"   
  echo -e " -r, --remove, --delete\t\t\t Deinstalliert die Anwendung (Volumes bleiben erhalten!)"   
}

case $1 in
  "-i" | "--install" )
    install 
    ;;
  "-s" | "--start" | "--restart" )
    start 
    ;;
  "-h" | "--stop" | "--halt" )
    stop
    ;;
  "-r" | "--remove" | "--delete")
    remove
    ;;
  "-a" | "--about" )
    about
    ;;
  *)
    help
    ;;
esac

exit 0
