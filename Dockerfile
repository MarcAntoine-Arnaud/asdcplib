FROM alpine:3.6

ADD . /src

ADD http://mirror.ibcp.fr/pub/apache//xerces/c/3/sources/xerces-c-3.2.0.tar.gz /xerces/xerces-c-3.2.0.tar.gz

RUN runtime_deps='libstdc++ openssl' \
    && apk add --virtual .build-dependencies --no-cache openssl-dev cmake build-base expat \
    && cd /xerces \
    && tar -xf xerces-c-3.2.0.tar.gz \
    && cd xerces-c-3.2.0 \
    && ./configure --disable-static \
    && make \
    && make install \
    && cd /src \
    && rm -Rf /xerces \
    && ./configure --build=x86_64 --enable-phdr --enable-as-02 --with-xerces=/usr/local .. \
    && make \
    && make install \
    && apk del .build-dependencies \
    && apk add --no-cache $runtime_deps \
    && cd / \
    && rm -Rf /src
