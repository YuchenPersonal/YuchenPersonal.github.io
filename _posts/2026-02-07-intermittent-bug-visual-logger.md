---
layout: post
title: "Intermittent Bug Fixing and Visual Logger"
date: 2026-02-07 21:18:00 +0000
categories: [Programming]
tags: [UE5, C++]
---

Recently, I spent a couple days digging into an intermittent bug and finally got it fixed with visual logger's help. I'll document it here for future reference.

So, the bug was a VFX which should've been hidden stays on player. It's a bit tricky because when I tried to repro it in editor, sometimes the VFX will be hidden but not all the time.

In order to fix it, the first thing I needed to do was to get a consistent repro, let's say we have a function called HideVFX, someone had added some visual logs when they debugged this area previously so I enabled those visual logs.

Luckily, the repro rate was around 50% so I was able to get some visual logs for both working scenario and not working scenario. I then noticed that in all the working scenarios, there's an extra HideVFX call.

I then added callstack print to the visual logger and found out that this extra call comes from some budgeting code to reduce cost, so I disabled the budgeter and I managed to get a 100% repro of the bug.

The callstack print from visual logger also pointed me some places where the HideVFX called from so I was able to find the source and fixed the issue by moving the HideVFX to a different delegate.

Visual Logger can be very useful because it not only lets you see how many function calls there are, but also lets you see their orders. You can also filter visual logs using categories.

This is a good introduction of the visual logger. [Using the Visual Logger](https://unreal-garden.com/tutorials/visual-logger/){:target="_blank"} The one I used was just simple text log.