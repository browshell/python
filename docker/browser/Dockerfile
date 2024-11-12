FROM ubuntu:latest

# Instalacja zależności
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    curl \
    unzip \
    nodejs \
    npm \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Instalacja Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Instalacja Puppeteer
RUN npm install puppeteer

# Kopiowanie plików pluginu
COPY plugin/ /app/plugin/
WORKDIR /app

# Instalacja zależności Node.js
COPY package.json /app/
RUN npm install

# Kopiowanie skryptów
COPY scripts/ /app/scripts/
RUN chmod +x /app/scripts/*

EXPOSE 3000
EXPOSE 8081
EXPOSE 8082

CMD ["sh", "/app/scripts/start.sh"]
