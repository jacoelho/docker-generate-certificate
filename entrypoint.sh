#!/bin/bash

if [ -z "${SERVER}" ]; then
  echo "set variable SERVER:"
  echo "--env \"SERVER=server.example.com\""
  exit 1
fi

CA_DIR=./demoCA

mkdir -m 0700 -p ${CA_DIR}/{private,certs,crl,newcerts}

# Serial and registry
echo "1000" > ${CA_DIR}/serial
touch ${CA_DIR}/index.txt

openssl req \
    -new \
    -newkey rsa:4096 -days 365 \
    -nodes -x509 \
    -subj "/C=CA/ST=Canada/L=Canada/O=IT/CN=CA" \
    -keyout ${CA_DIR}/private/cakey.pem  \
    -out ${CA_DIR}/cacert.pem

chmod 0400 ${CA_DIR}/private/cakey.pem

openssl genrsa -out server.key 4096
openssl req -new -newkey rsa:4096 -key server.key -out server.csr -subj "/C=CA/ST=Canada/L=Canada/O=IT/CN=${SERVER}"

# Sign the certificate!
openssl ca -in server.csr -out server.pem -batch

cp server.key /certificates
cp server.pem /certificates
cp ${CA_DIR}/cacert.pem /certificates
