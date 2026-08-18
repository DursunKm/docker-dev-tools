FROM node:20-slim

RUN apt-get update && apt-get install -y --no-install-recommends python3 \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

# --dangerously-skip-permissions refuses to run as root. Remap the image's
# built-in non-root "node" user to the host dev user's uid/gid so the bind
# mounts (project dir, config volume) stay writable without extra chowns.
RUN usermod -u 1001 node && groupmod -g 1001 node && chown -R node:node /home/node
USER node

WORKDIR /workspace
ENTRYPOINT ["claude"]
