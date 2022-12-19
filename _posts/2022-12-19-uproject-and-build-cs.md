---
layout: post
title: "What you have to add to .uproject and what you need to add to .Build.cs "
date: 2022-12-19 21:21:00 +0000
categories: [Programming]
tags: [UE4]
---

It turns out you don't necessarily have to add every module to .uproject to get it built.

As long as a module is added as a dependency to one module in .uproject, it will be built.

E.g. I have a RandomNumber module and my main game module is dependent on it (It's in my MainGameModule.Build.cs's private dependencies), as long as my main game module is added to my .uproject, the RandomNumber will be built.

One thing to notice is if you want an automated test to show up in the editor session frontend, you'd have to add the test module to .uproject.