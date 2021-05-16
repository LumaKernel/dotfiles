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
