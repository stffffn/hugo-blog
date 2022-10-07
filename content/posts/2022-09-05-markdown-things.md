---
title: 'Markdown Things'
slug: 'markdown-things'
date: 2022-09-05
summary: 'This is a custom summary'
tags:
  - Markdown
  - Technology
  - WOW
---

Text before the first headline.

# Headline 1

## Headline 2

### Headline 3

---

**Bold**

_Italic_

**_Bold & Italic_**

> Quote

> ### Multi line Quote with a Headline
>
> First line  
> Second Line of the Quote

- List Item 1
- List Item 2
- List Item 3

1. Ordered List Item 1
2. Ordered List Item 2
3. Ordered List Item 1

| Table Column Name 1 | Column 2 Name | Short |
| ------------------- | ------------- | ----- |
| Row 1 Item          | 000           | 4     |
| Row 2 Item          | /             | 3     |
| Row 3 Item          | 888888        | 2     |

A line above the sentence containing a link.  
This is a [link](www.google.com) in between regular text.  
Little more text below the other sentence containing a link.

![Very happy cat](https://i.natgeofe.com/n/9135ca87-0115-4a22-8caf-d1bdef97a814/75552.jpg)

{{< figure src="https://i.natgeofe.com/n/9135ca87-0115-4a22-8caf-d1bdef97a814/75552.jpg" caption="This cat is obviously very happy. [Link](www.google.com)" >}}

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
