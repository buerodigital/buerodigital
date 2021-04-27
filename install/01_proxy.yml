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
      - conf_01_proxy:/config
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
      - conf_01_heimdall:/config
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


