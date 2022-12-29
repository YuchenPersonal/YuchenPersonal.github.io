---
layout: post
title: "What you have to add to .uproject and what you need to add to .Build.cs"
date: 2022-12-19 21:21:00 +0000
categories: [Programming]
tags: [UE4]
---

It turns out you don't necessarily have to add every module to .uproject to get it built.

As long as a module is added as a dependency to one module in .uproject, it will be built.

E.g. I have a RandomNumber module and my main game module is dependent on it (It's in my MainGameModule.Build.cs's private dependencies), as long as my main game module is added to my .uproject, the RandomNumber will be built.

One thing to notice is if you want an automated test to show up in the editor session frontend, you'd have to add the test module to .uproject.

My understanding about why .Target.cs, .Build.cs, and .uproject

We need .Target.cs because we can have the same project on different targets (e.g. Game.Target.cs GameEditor.Target.cs and GameServer.Target.cs) and different targets can have different modules (e.g. a module may only be needed for editor build)

.Build.cs is about what's needed for this module (a dll) to be built

.uproject contains modules in the project and can be used to enable/disable plugins