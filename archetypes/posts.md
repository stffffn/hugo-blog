---
title: "{{ substr (replace .Name "-" " " | title) 11 }}"
slug: "{{ substr (.Name | title | lower) 11 }}"
date: {{ now.Format "2006-01-02" }}
---
