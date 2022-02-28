#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
cd "$SCRIPT_DIR"

if test ! -d certs.local; then
  mkdir certs.local
else
  echo '[info] found certs.local/'
fi
cd certs.local

if ! test -f space.key.pem -a -f space.cert.pem; then
  openssl req -batch -new -newkey rsa:4096 -days 10000 -nodes -x509 \
      -subj "/C=JP/ST=Luma/L=LumaSpace/O=LumaPlanet/CN=space" \
      -keyout space.key.pem -out space.cert.pem
else
  echo '[info] found space.key.pem and space.cert.pem'
fi

if ! test -f space.cert.p12; then
  openssl pkcs12 -passout pass:space -inkey space.key.pem -in space.cert.pem -export -out space.cert.p12
else
  echo '[info] found space.cert.p12'
fi

function check_and_create_intermediate {
  PORT="$1"
  if ! test -f "$PORT.crt"; then
    openssl genrsa -out "$PORT.key" 4096
    openssl req -new -key $PORT.key -out "$PORT.csr" -subj "/C=JP/ST=Luma/L=LumaSpace/O=LumaPlanet/CN=space"
    openssl x509 -req -days 10000 -in "$PORT.csr" -CA space.cert.pem -CAkey space.key.pem -out "$PORT.crt" -set_serial "$PORT"
  else
    echo "[info] found $PORT.crt"
  fi
}

# check_and_create_intermediate 443

if ! test -f server.cert.pem; then
  openssl genrsa -out server.key.pem 4096
  openssl req -new -key server.key.pem -out server.csr -subj "/C=JP/ST=Luma/L=LumaSpace/O=LumaPlanet/CN=space"
  openssl x509 -req -in server.csr -CA space.cert.pem -CAkey space.key.pem -out server.cert.pem -CAcreateserial -days 10000 -sha256 -extfile ../server_cert_ext.cnf
else
  echo "[info] found server.cert.pem"
fi
