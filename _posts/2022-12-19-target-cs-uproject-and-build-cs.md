---
layout: post
title: ".Target.cs .uproject .Build.cs what they are and what you need to add to each of them"
date: 2022-12-19 21:21:00 +0000
categories: [Programming]
tags: [UE4, UE5]
---

## My understanding about why we need .Target.cs, .uproject, and .Build.cs

We need .Target.cs because we can have the same project on different targets (e.g. Game.Target.cs GameEditor.Target.cs and GameServer.Target.cs) and different targets can have different modules (e.g. a test module may only be needed for editor build)

.Build.cs is about what's needed for this module (a dll) to be built

.uproject contains modules in the project and can be used to enable/disable plugins

This is from my project called Newcastle, here we can see it has a property called AdditionalDependencies.

Any modules in AdditionalDependencies will be built as a Newcastle module dependency which means these modules don't need to be added to Newcastle.build.cs as dependencies.

```json
{
    "Name": "Newcastle",
    "Type": "Runtime",
    "LoadingPhase": "Default",
    "AdditionalDependencies": [
        "Engine",
        "AIModule",
        "UMG"
    ]
},
```

It turns out you don't necessarily have to add every module to .uproject to get it built.

As long as a module is added as a dependency to one module in .uproject, it will be built.

E.g. I have a RandomNumber module and my main game module is dependent on it (It's in my MainGameModule.Build.cs's private dependencies), as long as my main game module is added to my .uproject, the RandomNumber will be built.

## A few extra things about .uproject to point out:

1. If you want an automated test to show up in the editor session frontend, you have to add the test module to .uproject.
2. If you want to create a UObject in editor (e.g. a data asset, or a BP) deriving from a cpp class, you have to add the cpp module to .uproject.
3. If you add a blueprint spawnable component to a BP actor, the module that this component belongs to need to be added to .uproject.

Failing to do the above two could lead to missing/broken uassets and error/warning messages like:
LogLinker: Warning: [AssetLog] DA_Graveyard.uasset: **VerifyImport: Failed to find script package for import object** 'Package /Script/LevelGenerator'
LogLinker: Warning: **Unable to load** DA_Graveyard **with outer Package** /Game/Levels/Level_Graveyard/DA_Graveyard **because its class (StageDataAsset) does not exist**

It can be tricky to detect the cause of the above issue because uassets may still work due to cache but they could suddenly go missing/broken after you've changed something completely unrelated to the missing class but accidentally cleaned the cache.
