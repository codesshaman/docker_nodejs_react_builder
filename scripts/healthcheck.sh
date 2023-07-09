#!/bin/bash
port="$(grep "PORT" .env | sed -r 's/.{,5}//')"
result=$(curl -Is http://localhost:$port | head -n 1)
echo $result