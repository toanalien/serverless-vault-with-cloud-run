FROM debian:buster as builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget unzip
RUN wget -q https://releases.hashicorp.com/vault/1.16.0-rc3/vault_1.16.0-rc3_linux_amd64.zip
RUN unzip vault_1.16.0-rc3_linux_amd64.zip

FROM alpine:latest as certs
RUN apk --update add ca-certificates

FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /vault .
ENTRYPOINT ["/vault", "server", "-config", "/etc/vault/config.hcl"]
