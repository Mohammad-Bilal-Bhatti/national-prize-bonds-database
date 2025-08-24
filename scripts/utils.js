
const cheerio = require('cheerio');
const axios = require('axios');
const fs = require('fs');
const path = require('path');

async function getLinks(amount) {
    const URL = `https://savings.gov.pk/rs-${amount}-prize-bond-draw/`

    console.log(`Fetching ${URL} page from Web.`);
    const response = await axios.get(URL);
    console.log(`GET: ${URL} completed with status ${response?.status}.`);

    if (!response?.data) {
      console.warn(`Unable to get page content for: ${URL}.`);
      return [];
    }

    const links = [];
    console.log(`Parsing html page ${URL} content.`);
    const $ = cheerio.load(response.data);
    $('a').each((index, element) => {
      const href = element?.attribs?.['href'];
      const textElement = $(element).text()?.trim();

      /* lookup for following pattern in the text. DD-MM-YYYY */
      const datePattern = /\d{1,2}-\d{1,2}-\d{4}/;
      const result = textElement?.match(datePattern);
      const drawDate = result ? result[0] : null;

      const isTxtOrDocFile = href?.endsWith('.txt') || href?.endsWith('.doc');

      if (isTxtOrDocFile) {
        if (drawDate) {
          links.push({ link: href, drawDate: formatDate(drawDate) });
        } else {
          console.warn(
            `Found a file link without a valid draw date: ${href} on text element: ${textElement}`,
          );
        }
      }

    });
    console.log(`Found total ${links.length} file links to download.`);
    return links;
}

async function listDirectory(directoryPath) {
    const exists = fs.existsSync(directoryPath);
    if (!exists) {
        console.log(`Created Directory ${directoryPath}`);
        fs.mkdirSync(directoryPath, { recursive: true });
    }
    
    return fs.readdirSync(directoryPath)
}

async function downloadFile(url, amount, drawDate) {
    const fileExt = url.substring(url.lastIndexOf('.'));
    const fileName = `${drawDate}${fileExt}`;
    const destinationPath = path.join(__dirname, '..', 'raw', amount, fileName);
    const writer = fs.createWriteStream(destinationPath);

    const response = await axios({
        url,
        method: 'GET',
        responseType: 'stream'
    });

    await response.data.pipe(writer);
}

function formatDate(date) {
    /* format date DD-MM-YYYY to YYYY-MM-DD */
    const [day, month, year] = date.split('-');
    return `${year}-${month}-${day}`;
}


module.exports = {
    getLinks,
    listDirectory,
    downloadFile
};