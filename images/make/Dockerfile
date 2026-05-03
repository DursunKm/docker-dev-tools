FROM alpine:3.20

RUN apk add --no-cache make bash git curl \
  && curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-27.5.1.tgz \
     | tar xz --strip-components=1 -C /usr/local/bin docker/docker \
  && mkdir -p /usr/local/lib/docker/cli-plugins \
  && curl -fsSL https://github.com/docker/compose/releases/download/v2.35.1/docker-compose-linux-x86_64 \
     -o /usr/local/lib/docker/cli-plugins/docker-compose \
  && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

WORKDIR /workspace
ENTRYPOINT ["make"]
