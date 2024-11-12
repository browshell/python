#!/bin/sh
# Uruchomienie websocketd w tle
websocketd --port=8081 /scripts/shell-proxy.sh &

# Uruchomienie nginx
nginx -g "daemon off;"

