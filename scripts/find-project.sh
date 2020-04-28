#!/bin/bash

# /abc  ./abc というファイル
# /abc/ ./abc というディレクトリ配下
# abc/  任意位置の abc というディレクトリ配下
# abc   任意位置の abc というファイル

function make-filter () {
  echo "$*" | \
    awk '/^\// && !/\// { print "." $0 } \
         /^\/.*\/$/ { print "." $0 "*" } \
         /\/$/ && !/^\// { print "*/" $0 "*" } \
         !/^\// && !/\/$/ && !/^\s*$/ { print "*/" $0 }'
}

function finalize () {
  echo "$*" | \
    awk '{ print " -a ( -not -path \"" $0 "\" ) " }'
}

FILTER=''

for filename in ',project_ignore' '.project_ignore'
do
  if test -f "$filename"; then
    FILTER0="$(make-filter "$(cat "$filename")")"
    if test -n "$FILTER0"; then
      if test -n "$FILTER"; then
        FILTER="$(printf "$FILTER\n$FILTER0")"
      else
        FILTER="$FILTER0"
      fi
    fi
  fi
done

if test -n "$FILTER"; then
  FILTER="$(finalize "$FILTER")"
  echo "$FILTER" | xargs find . -type f
else
  find .
fi
