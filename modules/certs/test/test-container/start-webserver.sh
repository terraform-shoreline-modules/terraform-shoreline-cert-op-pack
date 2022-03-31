#!/bin/bash

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -nodes -sha256 -days "${1:-30}" -subj "/C=US/ST=California/L=City/O=Company Name/OU=Org/CN=certs-demo.default"
echo "created cert for ${1:-30} days"
nohup python3 main.py & 2> /tmp/nohup.out
echo "python process is started" && sleep 2
