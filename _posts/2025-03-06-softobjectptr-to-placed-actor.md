---
layout: post
title: "TSoftObjectPtr Referencing Placed Actor can't be Resolved"
date: 2025-03-06 22:45:00 +0000
categories: [Programming]
tags: [UE5]
---

Two things I've learnt about using TSoftObjectPtr to reference Actors placed in the world.

1. The first thing is if you want to check if it's set, check its AssetPath and SubPathString from its TPersistentObjectPtr<FSoftObjectPath>.
2. The pointer may not be able to get resolved even after the placed Actor's BeginPlay. You can try to set a timer and keep checking after 1 or 2 seconds.
