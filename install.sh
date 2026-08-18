#!/usr/bin/env sh
set -eu

DEVTOOLS_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BIN_DIR="$DEVTOOLS_DIR/bin"
PROFILE="$HOME/.bashrc"
MARKER="# docker-dev-tools"
EXPORT_LINE="export PATH=\"$BIN_DIR:\$PATH\"  $MARKER"

# Pre-create bind-mount targets as the invoking user. Otherwise the Docker
# daemon creates them on first `run` as root, and the host user can no
# longer write to (or delete) their own cache/config directories.
mkdir -p \
  "$DEVTOOLS_DIR/volumes/node20/npm_cache" \
  "$DEVTOOLS_DIR/volumes/gh/config" \
  "$DEVTOOLS_DIR/volumes/claude/config"

if grep -qF "$MARKER" "$PROFILE" 2>/dev/null; then
    echo "Already installed. PATH entry exists in $PROFILE."
else
    printf '\n%s\n' "$EXPORT_LINE" >> "$PROFILE"
    echo "Installed. Added to $PROFILE:"
    echo "  $EXPORT_LINE"
    echo ""
    echo "Reload your shell to apply:"
    echo "  source $PROFILE"
fi
