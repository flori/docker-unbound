FROM alpine:3.12.1 AS builder

WORKDIR /build

ARG UNBOUND_SHA=5b9253a97812f24419bf2e6b3ad28c69287261cf8c8fa79e3e9f6d3bf7ef5835
ARG UNBOUND=unbound-1.12.0

RUN apk add --no-cache curl build-base openssl-dev expat-dev

RUN curl -sO https://nlnetlabs.nl/downloads/unbound/${UNBOUND}.tar.gz

RUN test ${UNBOUND_SHA} = `sha256sum ${UNBOUND}.tar.gz | cut -d' ' -f1`

RUN tar xzf "${UNBOUND}.tar.gz"

WORKDIR /build/${UNBOUND}

RUN ./configure --prefix=''

RUN make -j`getconf _NPROCESSORS_ONLN`

RUN cp unbound /bin/unbound

FROM alpine:3.12.1 AS runner

COPY --from=builder /bin/unbound /bin/unbound

RUN adduser -g unbound -D -s /bin/sh unbound

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/bin/unbound", "-d" ]
