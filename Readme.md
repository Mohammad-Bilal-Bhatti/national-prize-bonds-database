
# National Prize Bonds Database

This repository contains publically available list of prize bonds draw data offered by the state bank of Pakistan.

This repo will contains raw + json formatted files that can be used by anyone who what to play with the data.

# File Structure
```
/raw
  /200
    /2024-01-22.txt
    /2024-04-22.txt
  /750
    /2024-02-22.txt
    /2024-05-22.txt
/json
  /200
    /2024-01-22.txt
    /2024-04-22.txt

/scripts
Makefile
```

# Working

Scripts are designed to pull and scrap data from national saving website, process and store data in the respective directories.

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


# License

MIT - General Public License
