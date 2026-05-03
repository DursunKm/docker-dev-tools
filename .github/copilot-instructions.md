# Copilot Instructions for docker-dev-tools

## Mission
This repository provides containerized developer tools for Linux while keeping the host clean.
All tools must run through Docker containers and feel native from the shell.

## Non-Negotiable Rules
1. Do not require host runtime installs for wrapped tools.
2. Keep original command names. No aliases for default commands.
3. Run tools with ephemeral containers (`docker compose run --rm`).
4. Persist tool state only under `volumes/<service>/` when needed.
5. Keep project artifacts in the user project directory mounted at `/workspace`.
6. For alternate tool versions, use consistent naming (`tool`, `tool22`, etc.).
7. Follow the same extension pattern for every new tool.

## Standard Pattern for Adding a Tool
1. Add a service in `docker-compose.yml`.
2. Add a wrapper script in `bin/` with the exact tool name.
3. Add `volumes/<service>/` only if persistent cache/config is required.
4. If a reliable upstream image exists, prefer `image:`.
5. If not, add `images/<tool>/Dockerfile` and use `build:`.
6. Keep `working_dir: /workspace` and mount `${PROJECT_DIR}:/workspace`.

## Wrapper Script Contract
Use this shape for wrappers in `bin/`:

```sh
#!/usr/bin/env sh
set -eu

DEVTOOLS_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$PWD}"

PROJECT_DIR="$PROJECT_DIR" \
  docker compose -f "$DEVTOOLS_DIR/docker-compose.yml" run --rm <service> <command> "$@"
```

Notes:
- The wrapper filename should match the command users run.
- Wrappers must be executable.
- Keep scripts minimal; avoid extra logic unless necessary.

## Change Safety
- Make the smallest possible change set.
- Do not refactor unrelated files.
- Never remove existing behavior without explicit request.
- Never commit unless explicitly asked.

## Validation Checklist (Required)
After adding or changing a tool:
1. Ensure wrapper has execute permission.
2. Verify from repo root: `./bin/<tool> --version`.
3. Verify from another directory:
   `PATH="/path/to/docker-dev-tools/bin:$PATH" <tool> --version`
4. Update README sections affected by the change:
   - Repository Structure
   - Included Tools
   - Extending (if workflow changed)

## Documentation Expectations
- Keep README synchronized with real behavior.
- Document command names exactly as users will run them.
- Prefer concise operational language over long explanations.

## Review Focus
When reviewing changes, prioritize:
1. Host cleanliness guarantees
2. Command-name compatibility
3. Ephemeral container behavior
4. Correct persistence boundaries (`volumes/` only when needed)
5. Cross-project usability via PATH-based wrappers

## Exceptions
- **Docker socket access:** Tools that invoke `docker` or `docker compose` internally (e.g. `make`) may mount `/var/run/docker.sock` into the container. This is a functional requirement, not a rule violation. Document it explicitly in the service definition and in this file when applied.

## Out of Scope
- Adding host package manager install steps for wrapped tools
- Replacing wrappers with shell aliases
- Requiring users to run tools from this repository directory
