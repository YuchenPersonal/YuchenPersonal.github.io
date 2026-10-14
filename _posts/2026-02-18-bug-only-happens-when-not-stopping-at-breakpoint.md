---
layout: post
title: "Intermittent Bug That Only Happens When Not Stopping at a Breakpoint in Visual Studio"
date: 2026-02-18 21:30:00 +0000
categories: [Programming]
tags: [UE5, C++]
---

Recently, I spent a couple days digging into a tricky bug that's been passed like a hot potato through multiple people's hands.

I have got a solid repro in editor but a weird thing is if I add a breakpoint in VS, stop at the breakpoint then continue the flow, the issue doesn't happen anymore even in my solid repro scenario.

I placed a breakpoint on this line:
```
if (GetOverrideMaterial() == nullptr)
```
There is a Blueprint GameplayCueNotify that removes the material override.

Here’s the strange part:

If I hit the breakpoint and pause execution in Visual Studio, the material override gets removed before the if condition is evaluated. As a result, GetOverrideMaterial() returns nullptr.

However, if I do not stop at the breakpoint and let the game run normally, the material override is not removed before the check, and GetOverrideMaterial() returns a valid material.

So effectively:

When paused in the debugger → the GameplayCueNotify runs first → material is removed → the if sees nullptr.

When not paused → the if runs first → material is still valid.

I've added some logs to the override material removal function and the if check that confirmed the behaviour described above.

My best guessing on what's happening here is that BP GameplayCueNotify was triggered by a timed event so if I pause the game in VS, the time is up hence the notify gets triggered.

The purpose of this post is for me to keep this in mind in case so if similar things happen again I won't be fooled and can investigate further.