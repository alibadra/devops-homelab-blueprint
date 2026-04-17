# DevOps Homelab Blueprint

A complete self-hosted DevOps platform for on-premises or homelab environments. One `make up` command to launch a full CI/CD stack with reverse proxy, secret management, and container orchestration.

## Stack

| Service | Purpose | URL |
|---------|---------|-----|
| **Traefik** | Reverse proxy + automatic TLS | traefik.lab.local |
| **Portainer** | Docker management UI | portainer.lab.local |
| **Vault** | Secret management | vault.lab.local |
| **Gitea** | Self-hosted Git | git.lab.local |
| **Drone** | CI/CD (Gitea-integrated) | ci.lab.local |
| **Registry** | Private Docker registry | registry.lab.local |

## Architecture

```
Internet / LAN
       │
   [Traefik :443]  ← Let's Encrypt or self-signed
       │
   ┌───┴────────────────────────────┐
   │                                │
[Portainer]  [Gitea]  [Drone]  [Vault]  [Registry]
```

## Quick Start

```bash
# 1. Clone
git clone https://github.com/alibadra/devops-homelab-blueprint.git
cd devops-homelab-blueprint

# 2. Configure
cp .env.example .env
nano .env   # set your domain, passwords

# 3. Create Docker network
make network

# 4. Start everything
make up

# 5. Initialize Vault
make vault-init
```

## Requirements

- Docker >= 24 + Compose plugin
- Domain or local DNS (`*.lab.local → server IP`)
- 4 GB RAM minimum (8 GB recommended)

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make up` | Start all services |
| `make down` | Stop all services |
| `make logs` | Tail all logs |
| `make vault-init` | Initialize and unseal Vault |
| `make backup` | Backup all volumes |
| `make update` | Pull latest images and restart |
