#!/bin/bash

if [ "`whoami`" == "root" ]; then
  echo "[Error] Do NOT Run with sudo."
  exit 1
fi

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
source "$SCRIPT_DIR/utils/get_fingerprint.sh"

verify_github

DIR="$HOME/.local/share/nextword"
mkdir -p "$DIR"
cd "$DIR"

DO_DOWNLOAD=1
DO_EXTRACT=1

if test -f large.tar.gz; then
  echo "$DIR/large.tar.gz is found. re-download? [y/N]"
  read ans
  case "${ans}" in
    y*|Y*)
      DO_DOWNLOAD=1
      ;;
    *)
      DO_DOWNLOAD=0
  esac
fi

if test DO_DOWNLOAD == 1; then
  wget https://github.com/high-moctane/nextword-data/archive/large.tar.gz
fi

if test -d nextword-data-large; then
  echo "$DIR/nextword-data-large/ is found. re-extract? [y/N]"
  read ans
  case "${ans}" in
    y*|Y*)
      DO_EXTRACT=1
      ;;
    *)
      DO_EXTRACT=0
  esac
fi

if test DO_EXTRACT == 1; then
  tar -xzf large.tar.gz
fi
