FROM alpine:3.12.0 AS builder

WORKDIR /build

ARG UNBOUND_SHA=9f2f0798f76eb8f30feaeda7e442ceed479bc54db0e3ac19c052d68685e51ef7
ARG UNBOUND=unbound-1.11.0

RUN apk add --no-cache curl build-base openssl-dev expat-dev

RUN curl -sO https://nlnetlabs.nl/downloads/unbound/${UNBOUND}.tar.gz

RUN test ${UNBOUND_SHA} = `sha256sum ${UNBOUND}.tar.gz | cut -d' ' -f1`

RUN tar xzf "${UNBOUND}.tar.gz"

WORKDIR /build/${UNBOUND}

RUN ./configure --prefix=''

RUN make -j`getconf _NPROCESSORS_ONLN`

RUN cp unbound /bin/unbound

FROM alpine:3.12.0 AS runner

COPY --from=builder /bin/unbound /bin/unbound

RUN adduser -g unbound -D -s /bin/sh unbound

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/bin/unbound", "-d" ]
