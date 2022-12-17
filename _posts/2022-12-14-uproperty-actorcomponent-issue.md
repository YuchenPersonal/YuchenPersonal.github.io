---
layout: post
title: "UPROPERTY ActorComponent Created Using CreateDefaultObject Gets Nulled Before BeginPlay"
date: 2022-12-14 21:21:00 +0000
categories: [Programming]
tags: [UE4]
---

Today I was working on my hobby project and I came across a weird issue.

My GameMode C++ class has a component called SaveGameComponent. Its a blueprint spawnable compoennt. I created it in C++ using CreateDefaultObject.

I have a blueprint which derives from my GameMode called BP_GameMode.

However, the first time I play the game in edtior it works fine but after that when I want to find the SaveGameComponent in my GameMode::InitGame it's null.

From what I can see it seems to be this issue:

[UPROPERTY member vars reset to NULL by ObjectInitializer](https://forums.unrealengine.com/t/uproperty-member-vars-reset-to-null-by-objectinitializer/19959/19){:target="_blank"}

The way I fixed/worked around it was I just added the SaveGameComponent manually to the BP_GameMode.

This is a really weird issue and it doesn't seem to happen in every situation but it only happens to ActorComponents marked as UPROPERTY() (we have to mark to stop them being GCed but removing UPROPERTY() does stop the issue).

Creating a new BP from scratch fixes this issue so it seems to be a bug related to cached property.