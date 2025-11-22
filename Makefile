.DEFAULT_GOAL := help

# Docker configuration
DOCKER_IMAGE := national-prize-bonds
DOCKER_RUN := docker run --rm \
	-v "$$(pwd)/scripts:/app/scripts" \
	-v "$$(pwd)/raw:/app/raw" \
	-v "$$(pwd)/json:/app/json" \
	-v "$$(pwd)/draws:/app/draws" \
	$(DOCKER_IMAGE)

help: ## Show this help message
	@echo "Available commands:"
	@echo ""
	@echo "  help           Show this help message"
	@echo "  build          Build the Docker image"
	@echo "  sync-all       Sync all amounts (100, 200, 750, 1500)"
	@echo "  sync           Fetch, parse, and generate table for specified amount (usage: make sync amount=750)"
	@echo "  fetch          Fetch prize bond data for specified amount (usage: make fetch amount=750)"
	@echo "  parse-json     Parse JSON data for specified amount (usage: make parse-json amount=750)"
	@echo "  table          Generate markdown table for specified amount (usage: make table amount=750)"
	@echo "  clean          Clean up all generated files (raw, json, draws)"

build: ## Build the Docker image
	@echo "Building Docker image..."
	@docker build -t $(DOCKER_IMAGE) .

sync-all: ## Sync all amounts (100, 200, 750, 1500)
	@echo "Syncing all prize bond amounts..."
	@$(MAKE) sync amount=100
	@$(MAKE) sync amount=200
	@$(MAKE) sync amount=750
	@$(MAKE) sync amount=1500
	@echo "✓ All amounts synced successfully!"

sync: ## Fetch, parse, and generate table for specified amount (usage: make sync amount=750)
	@echo "Syncing prize bond data for amount: ${amount}"
	@echo "Step 1/3: Fetching data..."
	@$(DOCKER_RUN) node scripts/fetch.js ${amount}
	@echo "Step 2/3: Parsing JSON..."
	@$(DOCKER_RUN) node scripts/parse-json.js ${amount}
	@echo "Step 3/3: Generating table..."
	@mkdir -p draws
	@$(DOCKER_RUN) node scripts/table.js ${amount} > ./draws/${amount}.md
	@echo "✓ Complete! Output saved to ./draws/${amount}.md"

fetch: ## Fetch prize bond data for specified amount (usage: make fetch amount=750)
	@echo "Calling fetch with amount: ${amount}"
	@$(DOCKER_RUN) node scripts/fetch.js ${amount}

parse-json: ## Parse JSON data for specified amount (usage: make parse-json amount=750)
	@echo "Calling parse with amount: ${amount}"
	@$(DOCKER_RUN) node scripts/parse-json.js ${amount}

table: ## Generate markdown table for specified amount (usage: make table amount=750)
	@echo "Calling table with amount: ${amount}"
	@mkdir -p draws
	@$(DOCKER_RUN) node scripts/table.js ${amount} > ./draws/${amount}.md

clean: ## Clean up all generated files (raw, json, draws)
	@echo "Cleaning up raw files"
	@rm -rf ./raw

	@echo "Cleaning up json files"
	@rm -rf ./json

	@echo "Cleaning up draws files"
	@rm -rf ./draws


.PHONY: help build sync-all sync fetch parse-json table clean