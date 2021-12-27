FROM alpine as builder
ARG GIT_TAG=v4.38-9760-rtm

RUN mkdir /usr/local/src && apk add binutils --no-cache\
        build-base \
        readline-dev \
        openssl-dev \
        ncurses-dev \
        git \
        cmake \
        zlib-dev \
        libsodium-dev \
        gnu-libiconv 

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
WORKDIR /usr/local/src
RUN git clone -b ${GIT_TAG} https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git
ENV USE_MUSL=YES
RUN cd SoftEtherVPN_Stable &&\
	git submodule update --init --recursive &&\
	./configure &&\
	make

FROM alpine
RUN apk add readline --no-cache\
        openssl \
        gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
ENV LD_LIBRARY_PATH /root
WORKDIR /root/
VOLUME /mnt
RUN ln -s /mnt/vpn_server.config vpn_server.config && \
        mkdir /mnt/backup.vpn_server.config &&\
        ln -s /mnt/backup.vpn_server.config backup.vpn_server.config &&\
        ln -s /mnt/lang.config lang.config
COPY --from=builder /usr/local/src/SoftEtherVPN_Stable/bin/vpnserver .

#Choose whatever you need to expose
EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp
CMD ["/root/vpnserver", "execsvc"]
