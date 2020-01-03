# softether-docker

This container is designed to be as small as possible and host a SoftEther VPN Server
It´s based on Alpine so result is around 10MB!

Available Tags
---------
`latest` most of the commits to development branch

`stable` release flagged as stable

`beta` release flagged as beta

Usage docker run
--------

This will keep your config and Logfiles in the docker volume `softetherdata`

`docker run -d --rm --name softether-vpn-server -v softetherdata:/mnt -p 443:443/tcp -p 992:992/tcp -p 1194:1194/udp -p 5555:5555/tcp -p 500:500/udp -p 4500:4500/udp -p 1701:1701/udp --cap-add NET_ADMIN toprock/softether`

Usage docker-compose
--------
The same command can be achieved by docker-compose
```
version: '3'
services:
  softethervpn:
    image: toprock/softether
    restart: always
    ports:
      - 443:443
      - 992:992
      - 1194:1194/udp
      - 5555:5555
      - 500:500/udp
      - 4500:4500/udp
      - 1701:1701/udp
    cap_add:
      - NET_ADMIN
    volumes:
      - softether_data:/mnt
volumes:
  softether_data:
```