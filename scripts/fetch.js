
const path = require('path');
const { getLinks, listDirectory, downloadFile } = require('./utils');

async function main() {
    const args = process.argv.slice(2);
    if (args.length < 1) throw new Error('1 argument is required: <amount>');

    const validAmounts = ['100', '200', '750', '1500'];
    const amount = args[0];
    if (!validAmounts.includes(amount)) {
        throw new Error(`Invalid amount. Valid values are: ${validAmounts.join(', ')}`); 
    }

    const links = await getLinks(amount);

    const dirPath = path.join(__dirname, '..', 'raw', amount);
    const files = await listDirectory(dirPath);

    for (const item of links) {
        const { link, drawDate } = item;

        /* check draw file exists. */
        const exists = files.find(f => f.includes(drawDate));
        if (exists) {
            console.log(`${drawDate} file already exists. Skipping download.`);
            continue;
        };

        console.log(`Downloading file for draw date ${drawDate} from link: ${link}`);
        await downloadFile(link, amount, drawDate);
    }
}

main();