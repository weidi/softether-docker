FROM alpine as builder

LABEL version="0.1"

RUN mkdir /usr/local/src && apk update && apk add binutils \
        build-base \
        readline-dev \
        openssl-dev \
        ncurses-dev \
        git &&\
        apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
WORKDIR /usr/local/src
RUN git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git

WORKDIR /usr/local/src/SoftEtherVPN

RUN ./configure && make


FROM alpine
RUN apk update && apk add readline \
        openssl &&\
        apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
WORKDIR /root/
VOLUME /mnt
RUN ln -s /mnt/vpn_server.config vpn_server.config && \
        mkdir /mnt/backup.vpn_server.config &&\
        ln -s /mnt/backup.vpn_server.config backup.vpn_server.config &&\
        ln -s /mnt/lang.config lang.config
COPY --from=builder /usr/local/src/SoftEtherVPN/bin/vpnserver .
CMD ["/root/vpnserver", "execsvc"]
