
# National Prize Bonds Database

This repository contains publically available list of prize bonds draw data offered by the state bank of Pakistan. This repo will contains raw + json formatted files that can be used by anyone who what to play with the data.


## All Draws Summary
Use following table to navigate to each sub-category of draw.

| Amount | Link |
|--------|------|
| 100    | [View All](draws/100.md) |
| 200    | [View All](draws/200.md) |
| 750    | [View All](draws/750.md) |
| 1500   | [View All](draws/1500.md) |


## Requirements
In order to run following command you need to have UNIX cli interface, make utility and nodejs installed already on your system.


## Commands
Following are the list of commands that are used to fetch, format, and make table of the fetched draws.

### Quick Start (Recommended)
```bash
# Sync all amounts (100, 200, 750, 1500) - fetches, parses, and generates tables
make sync-all

# Or sync a specific amount
make sync amount=100
make sync amount=200
make sync amount=750
make sync amount=1500
```

### Individual Commands
```bash
# Fetch Draws
make fetch amount=100
make fetch amount=200
make fetch amount=750
make fetch amount=1500

# Format Draws
make parse-json amount=100
make parse-json amount=200
make parse-json amount=750
make parse-json amount=1500

# Make Table
make table amount=100
make table amount=200
make table amount=750
make table amount=1500

# Clean
make clean
```

## Working

Scripts are designed to pull and scrap data from national saving website, process and store data in the respective directories.

## Sync Job

The `sync` command is a convenient wrapper that runs fetch, parse-json, and table commands in sequence for a specified amount.

### Sync All
- Executes the complete sync process for all amounts (100, 200, 750, 1500)
- Fetches latest draw data from the website
- Parses the data into JSON format
- Generates markdown tables for all amounts

### Sync Single Amount
- Executes the complete sync process for a specific amount
- Runs fetch → parse-json → table pipeline
- Outputs the final table to `./draws/{amount}.md`

## Fetch Job

Algorithm
- fetch and scrape draws page html for draw amount.
- scan raw directory for already downloaded files.
- download draw result file and store it into raw directory with date when draw happens.

## Parse Json Job

Algorithm
- read the raw directory.
- read raw file content and parse it into desired format.
- store the result find in the respective directory.

## Clean Job

Algorithm
- find and destroy all raw and parsed file(s).

## Format Job

Algorithm
- find all the files in the raw directory
- create markdown table form that driectory scan
- output standard output stream to some file.


## License

MIT - General Public License
