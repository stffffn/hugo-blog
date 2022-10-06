---
title: "{{ substr (replace .Name "-" " " | title) 11 }}"
slug: "{{ substr (.Name | title | lower) 11 }}"
date: {{ now.Local.Format "2006-01-02" }}
summary: 'Summary goes here'
tags:
  - Tag
  - Another Tag
---
