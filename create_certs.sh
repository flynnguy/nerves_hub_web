# Create keys and certificates for the API and Device endpoints api.${DOMAIN} and device.${DOMAIN}
# The certificates are signed by the Nerves Key Certificate Authority and intermediate certificates
# Run this from nerves_hub_web after copying certificates from nerves_hub_ca/etc/ssl to nerves_hub_web/etc/ssl

if [ -z "$1" ] 
then
	echo usage: ${0} DOMAIN
	echo "    e.g. ${0} nerves-hub.local"
	echo 
	exit 1
fi
DOMAIN=${1}

cd etc/ssl

# create extension files
echo subjectAltName = DNS:api.${DOMAIN} > api.ext
echo subjectAltName = DNS:device.${DOMAIN} > device.ext

# create a private key and certificate signing request (CSR) for api.${DOMAIN}.

openssl req -new -newkey rsa:2048 -nodes -keyout api.${DOMAIN}-key.pem -out api.${DOMAIN}.csr -subj "/CN=api.${DOMAIN}"
	
# create the certificate signed by server-root-ca

openssl x509 -req -sha256 -CA server-root-ca.pem -CAkey server-root-ca-key.pem -in api.${DOMAIN}.csr -out api.${DOMAIN}.pem -days 365 -CAcreateserial -extfile api.ext

# verify
	
openssl x509 -text -in api.${DOMAIN}.pem

# create a private key and certificate signing request (CSR) for device.${DOMAIN}.

openssl req -new -newkey rsa:2048 -nodes -keyout device.${DOMAIN}-key.pem -out device.${DOMAIN}.csr -subj "/CN=device.${DOMAIN}"

# create the certificate signed by root-ca

openssl x509 -req -sha256 -CA device-root-ca.pem -CAkey device-root-ca-key.pem -in device.${DOMAIN}.csr -out device.${DOMAIN}.pem -days 365 -CAcreateserial -extfile device.ext

# verify
	
openssl x509 -text -in device.${DOMAIN}.pem

cd -
