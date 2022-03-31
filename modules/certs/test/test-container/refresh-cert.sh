#!/bin/bash

# we are ignoring first arg since it'll be always "renew" because this module will always add that argument as a first one.
pkill -9 python
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -sha256 -days "${2:-30}" -subj "/C=US/ST=California/L=City/O=Company Name/OU=Org/CN=certs-demo.default"
echo changed expiration days to "${2:-30}" days
sleep 2
nohup python3 main.py &
sleep 2
echo restarted the web server