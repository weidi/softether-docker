FROM alpine as builder
RUN mkdir /usr/local/src && apk update && apk add binutils \
        build-base \
        readline-dev \
        openssl-dev \
        ncurses-dev \
        git \
        cmake \
        zlib-dev \
        libsodium-dev \
        gnu-libiconv
#        apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community --allow-untrusted

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
WORKDIR /usr/local/src
RUN git clone https://github.com/weidi/SoftEtherVPN.git
ENV USE_MUSL YES
RUN cd SoftEtherVPN &&\
	git submodule update --init --recursive &&\
	./configure &&\
	make -C build

FROM alpine
RUN apk update && apk add --no-cache readline \
        openssl \
        libsodium \
        gnu-libiconv
#        apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so
ENV LD_LIBRARY_PATH /root
ENV PATH="/root:${PATH}"
WORKDIR /root/
VOLUME /mnt
RUN ln -s /mnt/vpn_bridge.config vpn_bridge.config && \
        mkdir /mnt/backup.vpn_bridge.config &&\
        ln -s /mnt/backup.vpn_bridge.config backup.vpn_bridge.config &&\
        ln -s /mnt/lang.config lang.config
COPY --from=builder /usr/local/src/SoftEtherVPN/build/vpnbridge /usr/local/src/SoftEtherVPN/build/vpncmd /usr/local/src/SoftEtherVPN/build/libcedar.so /usr/local/src/SoftEtherVPN/build/libmayaqua.so /usr/local/src/SoftEtherVPN/build/hamcore.se2 ./

EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp
CMD ["/root/vpnbridge", "execsvc"]
