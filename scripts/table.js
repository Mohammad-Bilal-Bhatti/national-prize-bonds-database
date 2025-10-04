
const path = require('path');
const { listDirectory } = require('./utils');

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

    const rows = [];

    for (const rawFile of rawFiles) {
        const date = rawFile.replace('.txt', '');
        const rawFilePath = `[view](/raw/${amount}/${date}.txt)`;
        const jsonFilePath = `[view](/json/${amount}/${date}.json)`;

        rows.push({
            Date: date,
            Amount: amount,
            Raw: rawFilePath,
            Json: jsonFilePath,
        });

    }

    console.log('\n');
    console.log(`# Draw Results for ${amount} Winners`);
    console.log('Folloiwing are the available draw results. Click on "view" to see the raw text file or the parsed JSON file.');
    console.log('\n');
    printMarkdownTable(rows);
}

main();

function printMarkdownTable(rows) {
    const header = Object.keys(rows[0]);
    const separator = header.map(() => '---').join('|');

    console.log(`| ${header.join(' | ')} |`);
    console.log(`| ${separator} |`);

    for (const row of rows) {
        console.log(`| ${header.map(col => row[col]).join(' | ')} |`);
    }
}
