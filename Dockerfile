FROM golang:1.20 AS builder

COPY go.* /app/
COPY *.go /app/

WORKDIR /app

# Ensures a static binary that runs on alpine
ENV CGO_ENABLED 0

RUN go build -o codehn

FROM alpine:3

# Ensure that our app can verify TLS certificates
RUN apk update \
    && apk add ca-certificates \
    && rm -rf /var/cache/apk/*

COPY index.tmpl /app/
COPY index.xml.tmpl /app/
COPY favicon.ico /app/
COPY logo.gif /app/
COPY --from=builder /app/codehn /app/codehn

WORKDIR /app

ENTRYPOINT ["/app/codehn"]
