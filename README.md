# jacoelho/generate-certificate

to generate a certificate:

- ```docker run --rm -v $(pwd):/certificates -e "SERVER=server.example.com" jacoelho/generate-certificate```

for the specified server will generate:

  * cacert.pem
  * server.key
  * server.pem
