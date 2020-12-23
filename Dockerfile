FROM alpine:3.12.3 AS builder

WORKDIR /build

ARG UNBOUND_SHA=a954043a95b0326ca4037e50dace1f3a207a0a19e9a4a22f4c6718fc623db2a1
ARG UNBOUND=unbound-1.13.0

RUN apk add --no-cache curl build-base openssl-dev expat-dev

RUN curl -sO https://nlnetlabs.nl/downloads/unbound/${UNBOUND}.tar.gz

RUN test ${UNBOUND_SHA} = `sha256sum ${UNBOUND}.tar.gz | cut -d' ' -f1`

RUN tar xzf "${UNBOUND}.tar.gz"

WORKDIR /build/${UNBOUND}

RUN ./configure --prefix=''

RUN make -j`getconf _NPROCESSORS_ONLN`

RUN cp unbound /bin/unbound

FROM alpine:3.12.3 AS runner

COPY --from=builder /bin/unbound /bin/unbound

RUN adduser -g unbound -D -s /bin/sh unbound

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/bin/unbound", "-d" ]
