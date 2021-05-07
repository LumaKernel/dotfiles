function get_fingerprint {
  CERTIFICATE_INFO="$(openssl s_client -connect "$1" -CAfile /usr/share/ca-certificates/mozilla/DigiCert_Assured_ID_Root_CA.crt >/dev/fd/1 </dev/null 2>/dev/null)"

  CERTIFICATE_BODY="$(echo "$CERTIFICATE_INFO" | while read LINE; do
    if test "$LINE" = "-----BEGIN CERTIFICATE-----"; then
      FOUND_CERTIFICATE=1
    fi
    if test "$FOUND_CERTIFICATE" = 1; then
      echo "$LINE"
      if test "$LINE" = "-----END CERTIFICATE-----"; then
        break
      fi
    fi
  done)"

  echo "$CERTIFICATE_BODY" | sha256sum | awk '{print $1}'
}

function verify_host {
  HOST="$1"
  COMPUTED="$(get_fingerprint "$HOST")"
  EXPECTED="$2"
  if test "$COMPUTED" != "$EXPECTED"; then
    echo "Host $HOST is obsolete!"
    echo "Please verify the site is still reliable or not."
    echo
    echo "Computed: $COMPUTED"
    echo "Expected: $EXPECTED"

    exit 1
  fi
}

function verify_github {
  verify_host github.com:443 "b8d899154b9bedc003b380cc7cbc810df9f6150b649f03fda74b616e9acfde88"
  verify_host raw.githubusercontent.com:443 "80e801c3a29dd05d8bf590847c2746ec205e91b8ccf99fd6be12e3923fa069cb"
}
