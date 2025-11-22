.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Available commands:"
	@echo ""
	@echo "  help           Show this help message"
	@echo "  fetch          Fetch prize bond data for specified amount (usage: make fetch amount=750)"
	@echo "  parse-json     Parse JSON data for specified amount (usage: make parse-json amount=750)"
	@echo "  table          Generate markdown table for specified amount (usage: make table amount=750)"
	@echo "  clean          Clean up all generated files (raw, json, draws)"

fetch: ## Fetch prize bond data for specified amount (usage: make fetch amount=750)
	@echo "Calling fetch with amount: ${amount}"
	@node scripts/fetch.js ${amount}

parse-json: ## Parse JSON data for specified amount (usage: make parse-json amount=750)
	@echo "Calling parse with amount: ${amount}"
	@node scripts/parse-json.js ${amount}

table: ## Generate markdown table for specified amount (usage: make table amount=750)
	@echo "Calling table with amount: ${amount}"
	@mkdir -p draws
	@node scripts/table.js ${amount} > ./draws/${amount}.md

clean: ## Clean up all generated files (raw, json, draws)
	@echo "Cleaning up raw files"
	@rm -rf ./raw

	@echo "Cleaning up json files"
	@rm -rf ./json

	@echo "Cleaning up draws files"
	@rm -rf ./draws


.PHONY: help fetch parse-json table clean