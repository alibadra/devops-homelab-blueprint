.PHONY: up down logs update network backup vault-init help

COMPOSE=docker compose
ENV_FILE=.env

help:
	@echo "DevOps Homelab Blueprint — Available commands:"
	@echo ""
	@echo "  make network     Create the shared proxy Docker network"
	@echo "  make up          Start all services"
	@echo "  make down        Stop all services"
	@echo "  make logs        Tail logs for all services"
	@echo "  make update      Pull latest images and restart"
	@echo "  make vault-init  Initialize and print Vault unseal keys"
	@echo "  make backup      Backup all named volumes"
	@echo ""

network:
	docker network create homelab_proxy 2>/dev/null || true
	@echo "Network 'homelab_proxy' ready"

up: network
	$(COMPOSE) --env-file $(ENV_FILE) up -d
	@echo "All services started. Check 'make logs' for details."

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f --tail=50

update:
	$(COMPOSE) pull
	$(COMPOSE) up -d --remove-orphans

vault-init:
	@echo "Initializing Vault..."
	docker exec vault vault operator init -key-shares=5 -key-threshold=3
	@echo "IMPORTANT: Save the unseal keys and root token securely!"

backup:
	@mkdir -p ./backups/$(shell date +%Y%m%d)
	@for vol in traefik_certs portainer_data gitea_data gitea_db_data vault_data; do \
		echo "Backing up $$vol..."; \
		docker run --rm \
			-v $${vol}:/data:ro \
			-v $(PWD)/backups/$(shell date +%Y%m%d):/backup \
			alpine tar czf /backup/$${vol}.tar.gz -C /data .; \
	done
	@echo "Backups saved to ./backups/$(shell date +%Y%m%d)/"
