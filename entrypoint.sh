#!/bin/sh

if [ -z "${SERVER}" ]; then
  echo "set variable SERVER:"
  echo "--env \"SERVER=server.example.com\""
  exit 1
fi

if [ -z "${SUBJECT}" ]; then
  echo "set variable SUBJECT:"
  echo "--env \"SUBJECT=/C=CA/ST=Canada/L=Canada/O=IT\""
  exit 1
else
    SUBJECT="${SUBJECT}/CN=${SERVER}"
fi

CA_DIR=./demoCA

for d in $(echo "private certs crl newcerts");
    do mkdir -m 0700 -p ${CA_DIR}/$d;
done

# Serial and registry
echo "1000" > ${CA_DIR}/serial
touch ${CA_DIR}/index.txt

openssl req \
        -new \
        -newkey rsa:4096 -days 365 \
        -nodes -x509 \
        -subj "${SUBJECT}" \
        -keyout ${CA_DIR}/private/cakey.pem  \
        -out ${CA_DIR}/cacert.pem
chmod 0400 ${CA_DIR}/private/cakey.pem

openssl genrsa -out server.key 4096
openssl req -new -newkey rsa:4096 -key server.key -out server.csr \
        -subj "${SUBJECT}"
# Sign the certificate!
openssl ca -in server.csr -out server.pem -batch

cp server.key /certificates
sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' server.pem > \
    /certificates/server.pem
cp ${CA_DIR}/cacert.pem /certificates
