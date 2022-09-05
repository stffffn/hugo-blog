---
title: 'Another Test Post'
slug: 'another-test-post'
date: 2022-09-02
tags:
  - Tag1
  - Ein Tag
  - Noch ein Tag
---

Another Test Post Content, lorem ipsum.

This is a sentence with a `Inline Code Test` lorem ipsum dolor.  
Another line of words just for testing.

```shell
#!/bin/sh
# SLUGGIFY based on https://gist.github.com/oneohthree/f528c7ae1e701ad990e6

if [ -z "$1" ]
then
  echo "Enter a title"
  exit
fi

SLUGGIFY=$(echo "$1" | iconv -t ascii//TRANSLIT | sed -r 's/[~\^]+//g' | sed -r 's/[^a-zA-Z0-9]+/-/g' | sed -r 's/^-+\|-+$//g' | tr A-Z a-z)
hugo new posts/$(date +%Y-%m-%d)-$(echo $SLUGGIFY).md
```

```javascript
if (100 > x) {
  console.log('HENLO');
}
```
