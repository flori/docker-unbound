FROM alpine:3.16 AS builder

WORKDIR /build

ARG UNBOUND_SHA=6701534c938eb019626601191edc6d012fc534c09d2418d5b92827db0cbe48a5
ARG UNBOUND=unbound-1.16.0

RUN apk add --no-cache curl build-base openssl-dev expat-dev

RUN curl -sO https://nlnetlabs.nl/downloads/unbound/${UNBOUND}.tar.gz

RUN test ${UNBOUND_SHA} = `sha256sum ${UNBOUND}.tar.gz | cut -d' ' -f1`

RUN tar xzf "${UNBOUND}.tar.gz"

WORKDIR /build/${UNBOUND}

RUN ./configure --prefix=''

RUN make -j`getconf _NPROCESSORS_ONLN`

RUN cp unbound /bin/unbound

RUN adduser -g unbound -D -s /bin/sh unbound

FROM alpine:3.16 AS runner

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

COPY --from=builder /bin/unbound /bin/unbound

EXPOSE 53/udp 53/tcp

ENTRYPOINT [ "/bin/unbound", "-d" ]
