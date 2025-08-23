

fetch:
	@echo "Fetching data... ${amount}"
	@# Add your fetch commands here

parse-json:
	@echo "Parsing JSON data... ${amount}"
	@# Add your JSON parsing commands here

clean:
	@echo "Cleaning up..."
	@# Add your clean commands here

.PHONY: fetch parse-json clean