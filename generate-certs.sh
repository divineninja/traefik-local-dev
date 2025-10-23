#!/bin/bash

# Create SSL certificates for local.test and *.local.test

echo "Generating self-signed SSL certificates for local.test and *.local.test"

# Create OpenSSL config file for SAN (Subject Alternative Names)
cat > ./certs/local.test.conf << EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
C=US
ST=Local
L=Local
O=Local Development
OU=IT Department
CN=local.test

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = local.test
DNS.2 = *.local.test
DNS.3 = traefik.local.test
DNS.4 = whoami.local.test
DNS.5 = app.local.test
EOF

# Generate private key
openssl genrsa -out ./certs/local.test.key 2048

# Generate certificate signing request
openssl req -new -key ./certs/local.test.key -out ./certs/local.test.csr -config ./certs/local.test.conf

# Generate self-signed certificate
openssl x509 -req -in ./certs/local.test.csr -signkey ./certs/local.test.key -out ./certs/local.test.crt -days 365 -extensions v3_req -extfile ./certs/local.test.conf

# Set proper permissions
chmod 600 ./certs/local.test.key
chmod 644 ./certs/local.test.crt

echo "SSL certificates generated successfully!"
echo "Certificate: ./certs/local.test.crt"
echo "Private Key: ./certs/local.test.key"
echo ""
echo "To trust the certificate on macOS, run:"
echo "sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./certs/local.test.crt"