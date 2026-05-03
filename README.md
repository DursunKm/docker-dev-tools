# docker-dev-tools

A container-based development toolkit for Linux. Keeps the host machine clean by running all development tools through Docker containers, while exposing them under their original command names — so the shell behaves as if the tools were installed natively.

## Why

Installing runtimes globally on a development machine causes version conflicts, pollutes the system, and makes environments hard to reproduce. This project solves that by wrapping each tool in a dedicated Docker container. The host requires no runtime installations. Commands remain identical to their native counterparts.

## How It Works

Each tool is defined as a Docker Compose service. A thin shell script in `bin/` acts as a proxy: it receives the command, mounts the current project directory as `/workspace` inside the container, runs the tool, then removes the container. Nothing persists on the host except the project's own output files.

## Requirements

- Linux
- Docker with the Compose plugin

## Installation

Clone this repository to a fixed location on your machine:

```sh
git clone https://github.com/DursunKm/docker-dev-tools.git ~/docker-dev-tools
```

Run the install script:

```sh
cd ~/docker-dev-tools
bash install.sh
```

This adds `bin/` to the front of your `PATH` in `~/.bashrc`. Running it again is safe — it will not create duplicate entries.

Reload the shell:

```sh
source ~/.bashrc
```

No further steps are required. Docker images are pulled automatically on first use.

## Principles

These rules apply to every tool in this repository, without exception.

1. **The host stays clean.**
   No runtime (`node`, `python`, `go`, etc.) is installed on the host. All tools run exclusively through containers.

2. **Commands keep their original names.**
   Wrapper scripts use the exact same name as the tool they wrap. `npm` stays `npm`, `gh` stays `gh`. There are no aliases or renamed commands for default versions.

3. **Containers are ephemeral.**
   All commands run with `docker compose run --rm`. Each invocation creates a fresh container that is automatically removed when the command exits. No background processes accumulate.

4. **Persistent data lives under `volumes/`.**
   Caches, auth state, and tool configuration are stored under `volumes/<service>/` as host-directory bind mounts. This makes them inspectable, portable, and easy to clear.

5. **Project-local artifacts stay in the project.**
   `node_modules`, `.venv`, and similar directories are created inside the project directory — not inside the container. This preserves IDE integration such as IntelliSense and type checking.

6. **Multiple versions follow a consistent naming convention.**
   The default version uses the base command name (`python`, `node`). Alternative versions append the version identifier (`python3.12`, `node22`). Each maps to a dedicated Compose service.

7. **Adding a new tool follows one pattern.**
   Add a service to `docker-compose.yml`, add wrapper scripts to `bin/`, and create the corresponding directory under `volumes/`. The principles above remain unchanged.

## Repository Structure

```
.
├── docker-compose.yml        # All service definitions
├── bin/                      # Wrapper scripts (one per command)
└── volumes/
    ├── node20/
    │   └── npm_cache/        # Shared npm cache across projects
    └── gh/
        └── config/           # GitHub CLI auth and configuration
```

## Included Tools

| Command(s) | Image | Purpose |
|---|---|---|
| `node`, `npm`, `npx` | `node:20-alpine` | Node.js 20 runtime |
| `gh` | `maniator/gh:latest` | GitHub CLI |

## Extending

To add a new tool:

1. Add a service entry to `docker-compose.yml`.
2. Create a wrapper script in `bin/` using the tool's original command name.
3. Create `volumes/<service>/` for any data that should persist between runs.

Use an existing script in `bin/` as a reference — all wrappers follow the same minimal structure.

## License

MIT — see [LICENSE](LICENSE).
