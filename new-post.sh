#!/bin/sh
# SLUGGIFY based on https://gist.github.com/oneohthree/f528c7ae1e701ad990e6

if [ -z "$1" ]
then
  echo "Enter a title"
  exit
fi

SLUGGIFY=$(echo "$1" | iconv -t ascii//TRANSLIT | sed -r 's/[~\^]+//g' | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+\|-+$//g' | tr A-Z a-z)
hugo new posts/$(date +%Y-%m-%d)-$(echo $SLUGGIFY).md