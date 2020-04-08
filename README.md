# softether-docker

This container is designed to be as small as possible and host a SoftEther VPN Server
It´s based on Alpine so result is around 10MB!
It´s based on the great work of [SoftEherVPN](https://github.com/SoftEtherVPN/SoftEtherVPN/)

You will be unable to bridge to a physical Ethernet adapter as there is no inside a Container but SecureNAT and other stuff that doesn´t need physical L2 will work.


Available Tags
---------
[![](https://images.microbadger.com/badges/version/toprock/softether.svg)](https://microbadger.com/images/toprock/softether "Get your own version badge on microbadger.com") up to date commits to the development repository


[![](https://images.microbadger.com/badges/version/toprock/softether:stable.svg)](https://microbadger.com/images/toprock/softether:stable "Get your own version badge on microbadger.com") release from stable repository 

You can and should always specify your wanted version like `toprock/softether:5.01.9671` or `toprock/softether:4.32.9731`

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
  softether:
    image: toprock/softether:5.01.9672
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