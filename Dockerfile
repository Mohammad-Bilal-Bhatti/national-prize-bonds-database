FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Default command (can be overridden)
CMD ["node", "scripts/fetch.js"]
