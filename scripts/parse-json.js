
const path = require('path');
const { listDirectory } = require('./utils');
const readline = require('readline');
const fs = require('fs');


async function main() {
    const args = process.argv.slice(2);
    if (args.length < 1) throw new Error('1 argument is required: <amount>');

    const validAmounts = ['100', '200', '750', '1500'];
    const amount = args[0];
    if (!validAmounts.includes(amount)) {
        throw new Error(`Invalid amount. Valid values are: ${validAmounts.join(', ')}`);
    }

    const dirPath = path.join(__dirname, '..', 'raw', amount);
    const rawFiles = await listDirectory(dirPath);

    for (const rawFile of rawFiles) {
        console.log(`Reading raw file: ${rawFile}`);

        const source = fs.createReadStream(path.join(dirPath, rawFile));
        const destination = path.join(__dirname, '..', 'json', amount);
        if (!fs.existsSync(destination)) {
            console.log(`Created Directory ${destination}`);
            fs.mkdirSync(destination, { recursive: true });
        }

        const outputJson = await parseRawToJson(source);

        const jsonFileName = rawFile.replace(path.extname(rawFile), '.json');
        fs.writeFileSync(path.join(destination, jsonFileName), JSON.stringify(outputJson, null, 2));
        console.log(`Wrote JSON file: ${jsonFileName} with ${outputJson.length} records.`);
    }

}

const PrizeEnum = Object.freeze({
    First: '1st',
    Second: '2nd',
    Third: '3rd',
});

async function parseRawToJson(readStream) {
    const drawWinners = [];

    console.log('Trying to read file content.');
    const rl = readline.createInterface({
        input: readStream,
        crlfDelay: Infinity,
    });

    const skipList = ['000000'];
    const skipWhenTo = ['000001', '999999'];

    let i = 0;
    for await (const line of rl) {
        /* match 6 digit number pattern enclosed by word boundary */
        const matched = line.matchAll(/\b\d{6}\b/gi);
        const includedTo = line.toLowerCase().includes('to');
        inner: for (const item of matched) {
            const number = item[0];

            /* if to symbol is encountered when reading line and number is in skipWhenTo list - skip to next matched item. */
            if (includedTo && skipWhenTo.includes(number)) continue inner;

            /* if number is present in skip list - skip to next matched item. */
            if (skipList.includes(number)) continue inner;

            const prize =
                i == 0
                    ? PrizeEnum.First
                    : i > 0 && i < 4
                        ? PrizeEnum.Second
                        : PrizeEnum.Third;
            drawWinners.push({ number, prize });
            i++;
        }
    }

    return drawWinners;
}


main();
