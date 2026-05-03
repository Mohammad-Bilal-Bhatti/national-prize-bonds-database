.DEFAULT_GOAL := help

# Cross-platform shell commands
ifeq ($(OS),Windows_NT)
    SHELL := cmd.exe
    CURRENT_DIR := $(subst \,/,$(CURDIR))
    RM_RECURSIVE = if exist "$(1)" rmdir /s /q "$(1)"
    MKDIR_P = if not exist "$(1)" mkdir "$(1)"
else
    CURRENT_DIR := $(CURDIR)
    RM_RECURSIVE = rm -rf "$(1)"
    MKDIR_P = mkdir -p "$(1)"
endif

# Docker configuration
DOCKER_IMAGE := national-prize-bonds
DOCKER_RUN := docker run --rm \
	-v "$(CURRENT_DIR)/scripts:/app/scripts" \
	-v "$(CURRENT_DIR)/raw:/app/raw" \
	-v "$(CURRENT_DIR)/json:/app/json" \
	-v "$(CURRENT_DIR)/csv:/app/csv" \
	-v "$(CURRENT_DIR)/draws:/app/draws" \
	$(DOCKER_IMAGE)

help: ## Show this help message
	@echo Available commands:
	@echo   help           Show this help message
	@echo   build          Build the Docker image
	@echo   sync-all       Sync all amounts (100, 200, 750, 1500)
	@echo   sync           Fetch, parse, and generate table for specified amount (usage: make sync amount=750)
	@echo   fetch          Fetch prize bond data for specified amount (usage: make fetch amount=750)
	@echo   parse-json     Parse JSON data for specified amount (usage: make parse-json amount=750)
	@echo   parse-csv      Parse CSV data for specified amount (usage: make parse-csv amount=750)
	@echo   table          Generate markdown table for specified amount (usage: make table amount=750)
	@echo   clean          Clean up all generated files (raw, json, csv, draws)

build: ## Build the Docker image
	@echo Building Docker image...
	@docker build -t $(DOCKER_IMAGE) .

sync-all: ## Sync all amounts (100, 200, 750, 1500)
	@echo Syncing all prize bond amounts...
	@$(MAKE) sync amount=100
	@$(MAKE) sync amount=200
	@$(MAKE) sync amount=750
	@$(MAKE) sync amount=1500
	@echo [OK] All amounts synced successfully!

sync: ## Fetch, parse, and generate table for specified amount (usage: make sync amount=750)
	@echo Syncing prize bond data for amount: $(amount)
	@$(MAKE) fetch amount=$(amount)
	@$(MAKE) parse-json amount=$(amount)
	@$(MAKE) parse-csv amount=$(amount)
	@$(MAKE) table amount=$(amount)
	@echo [OK] Complete! Output saved to ./draws/$(amount).md

fetch: ## Fetch prize bond data for specified amount (usage: make fetch amount=750)
	@echo Calling fetch with amount: $(amount)
	@$(DOCKER_RUN) node scripts/fetch.js $(amount)

parse-json: ## Parse JSON data for specified amount (usage: make parse-json amount=750)
	@echo Calling parse with amount: $(amount)
	@$(DOCKER_RUN) node scripts/parse-json.js $(amount)

parse-csv: ## Parse CSV data for specified amount (usage: make parse-csv amount=750)
	@echo Calling parse-csv with amount: $(amount)
	@$(DOCKER_RUN) node scripts/parse-csv.js $(amount)

table: ## Generate markdown table for specified amount (usage: make table amount=750)
	@echo Calling table with amount: $(amount)
	@$(call MKDIR_P,draws)
	@$(DOCKER_RUN) node scripts/table.js $(amount) > ./draws/$(amount).md

clean: ## Clean up all generated files (raw, json, csv, draws)
	@echo Cleaning up raw files
	@$(call RM_RECURSIVE,raw)
	@echo Cleaning up json files
	@$(call RM_RECURSIVE,json)
	@echo Cleaning up csv files
	@$(call RM_RECURSIVE,csv)
	@echo Cleaning up draws files
	@$(call RM_RECURSIVE,draws)

.PHONY: help build sync-all sync fetch parse-json parse-csv table clean
