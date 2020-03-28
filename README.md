# softether-docker

This container is designed to be as small as possible and host a SoftEther VPN Server
It´s based on Alpine so result is around 10MB!
It´s based on the great work of [SoftEherVPN](https://github.com/SoftEtherVPN/SoftEtherVPN/)

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
version: '3'

services:
  softether:
    image: toprock/softether
    cap_add:
      - NET_ADMIN
    restart: always
    ports:
      - 53:53
      - 444:443
      - 992:992
      - 1194:1194/udp
      - 5555:5555
      - 500:500/udp
      - 4500:4500/udp
      - 1701:1701/udp
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "/etc/timezone:/etc/timezone:ro"
      - "./softether_data:/mnt"
      - "./softether_log:/root/server_log"
      - "./softether_packetlog:/root/packet_log"
      - "./softether_securitylog:/root/security_log"
```