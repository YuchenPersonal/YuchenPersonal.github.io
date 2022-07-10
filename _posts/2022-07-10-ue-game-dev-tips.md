---
layout: post
title: "Unreal Engine Game Development TIps"
date: 2022-07-10 20:40:00 +0000
categories: [Programming]
tags: [UE4]
---

In this post, I'll be sharing some of the unreal engine game development tips I've learned/been learning from the projects I've worked on/been working on.

I'll keep this updated as much as possible. Hopefully these tips will help to make your unreal engine game projects organized and sustainable.

* Develop a tool (VS extension if you're using Visual Studio) to automatically format includes in your cpp files.

1. We can copy the full path of a header in VS so the tool usually translates from it.
2. This is to make sure all the include files are in the same format. <> or "" are picked correctly.
3. This also enables us to sort all includes efficiently.

* Sort your includes in alphabetical order.

1. We can tell easily whether the include we are trying to add already exists.
