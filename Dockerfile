FROM alpine:3.18 AS builder

WORKDIR /build

ARG UNBOUND_SHA=ee4085cecce12584e600f3d814a28fa822dfaacec1f94c84bfd67f8a5571a5f4
ARG UNBOUND=unbound-1.17.1

RUN apk add --no-cache curl build-base openssl-dev expat-dev

RUN curl -sO https://nlnetlabs.nl/downloads/unbound/${UNBOUND}.tar.gz

RUN test ${UNBOUND_SHA} = `sha256sum ${UNBOUND}.tar.gz | cut -d' ' -f1`

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
