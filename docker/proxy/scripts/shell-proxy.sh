#!/bin/sh
while read line; do
    # Przekazanie komendy do kontenera browser
    echo "$line" | nc browser 8082
done
