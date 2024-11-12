FROM nginx:alpine

# Instalacja dodatkowych narzędzi
RUN apk add --no-cache \
    nodejs \
    npm \
    python3 \
    py3-pip

# Instalacja websocketd dla obsługi WebSocket
RUN wget https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-linux_amd64.zip \
    && unzip websocketd-0.4.1-linux_amd64.zip \
    && mv websocketd /usr/bin/ \
    && rm websocketd-0.4.1-linux_amd64.zip

# Kopiowanie konfiguracji nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY proxy.conf /etc/nginx/conf.d/default.conf

# Kopiowanie skryptów
COPY scripts/ /scripts/
RUN chmod +x /scripts/*

EXPOSE 8080
EXPOSE 8081

CMD ["sh", "/scripts/start.sh"]
