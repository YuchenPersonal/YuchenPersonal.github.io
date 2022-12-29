---
layout: post
title: "UE4 Garbage Collection My Understanding"
date: 2022-12-29 21:21:00 +0000
categories: [Programming]
tags: [UE4]
---

My understanding about UE4's garbage colletion.

1. A UPROPERTY marked RAW pointer is counted as hard referenced so the UObject it points to won't be GCed.