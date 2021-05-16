#!/bin/bash

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
SCRIPTS_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
source "$SCRIPTS_DIR/utils/shared.sh"

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
