#!/bin/sh
# Uruchomienie serwera Node.js
node server.js &

# Uruchomienie proxy dla komend shell
nc -l -p 8082 -k -c 'xargs -I {} sh -c {}' &

# Uruchomienie Chrome w trybie headless
google-chrome --headless --disable-gpu --remote-debugging-port=9222
