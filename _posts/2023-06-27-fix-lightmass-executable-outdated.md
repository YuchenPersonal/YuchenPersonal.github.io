---
layout: post
title: "Fix Error Unreal Lightmass executable is outdated. Recompile UnrealLightmass project with Development configuration in Visual Studio."
date: 2023-06-27 19:50:00 +0000
categories: [Programming, Lightmass]
tags: [UE4, Lightmass]
---

You'll see this if you are building the engine from source.

You can fix this by:
1. Go to Visual Studio. 
2. Select UnrealLightmass as startup project.
3. Change config to Development Win64.
4. Right click and Build UnrealLightmass.

Make sure **you don't have unity build disabled locally** otherwise it won't work. 
Possibly because the light map system doesn't recognize non-unity build lightmass exe because it has NonUnity in its name.
Fix of this could be a pull request to the engine source.