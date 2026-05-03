#!/usr/bin/env sh
set -eu

DEVTOOLS_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BIN_DIR="$DEVTOOLS_DIR/bin"
PROFILE="$HOME/.bashrc"
MARKER="# docker-dev-tools"
EXPORT_LINE="export PATH=\"$BIN_DIR:\$PATH\"  $MARKER"

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
