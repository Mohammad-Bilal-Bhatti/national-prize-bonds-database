
fetch:
	@echo "Calling fetch with amount: ${amount}"
	@node scripts/fetch.js ${amount}

parse-json:
	@echo "Calling parse with amount: ${amount}"
	@node scripts/parse-json.js ${amount}

clean:
	@echo "Cleaning up raw files"
	@rm -rf ./raw

	@echo "Cleaning up json files"
	@rm -rf ./json

.PHONY: fetch parse-json clean