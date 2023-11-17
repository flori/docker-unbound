FROM alpine:3.18 AS builder

WORKDIR /build

ARG UNBOUND_SHA=a97532468854c61c2de48ca4170de854fd3bc95c8043bb0cfb0fe26605966624
ARG UNBOUND=unbound-1.19.0

RUN apk add --no-cache curl build-base openssl-dev expat-dev

ADD --checksum=sha256:${UNBOUND_SHA} https://nlnetlabs.nl/downloads/unbound/${UNBOUND}.tar.gz "${UNBOUND}.tar.gz"

RUN tar xzf "${UNBOUND}.tar.gz"

WORKDIR /build/${UNBOUND}

RUN ./configure --prefix=''

RUN make -j $(getconf _NPROCESSORS_ONLN)

RUN cp unbound /bin/unbound

RUN adduser -g unbound -D -s /bin/sh unbound

FROM alpine:3.18 AS runner

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder /bin/unbound /bin/unbound

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/bin/unbound", "-d" ]
