FROM alpine:3.20

ARG GH_VERSION=2.97.0

RUN apk add --no-cache bash git curl ca-certificates \
  && curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" \
     | tar xz --strip-components=2 -C /usr/local/bin "gh_${GH_VERSION}_linux_amd64/bin/gh"

WORKDIR /workspace
ENTRYPOINT ["gh"]
