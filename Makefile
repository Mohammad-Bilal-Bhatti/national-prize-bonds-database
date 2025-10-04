
fetch:
	@echo "Calling fetch with amount: ${amount}"
	@node scripts/fetch.js ${amount}

parse-json:
	@echo "Calling parse with amount: ${amount}"
	@node scripts/parse-json.js ${amount}

table:
	@echo "Calling table with amount: ${amount}"
	@mkdir -p draws
	@node scripts/table.js ${amount} > ./draws/${amount}.md

clean:
	@echo "Cleaning up raw files"
	@rm -rf ./raw

	@echo "Cleaning up json files"
	@rm -rf ./json

	@echo "Cleaning up draws files"
	@rm -rf ./draws


.PHONY: fetch parse-json table clean