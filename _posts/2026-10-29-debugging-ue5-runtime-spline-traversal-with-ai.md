---
layout: post
title: "Debugging GAS Runtime Spline Traversal With AI"
date: 2026-10-29 21:00:00 +0000
categories: [Programming]
tags: [UE5, Animation]
---


Today I implemented a new Spawn Fence skill in my Unreal Engine 5 game, inspired by Earthshaker's Fissure ability in Dota 2. The skill spawns a traversable obstacle in front of the player.

The implementation was straightforward because I already had a similar Spawn Platform skill and an existing traversable fence Blueprint. However, I encountered an interesting issue where the runtime-spawned fence behaved differently from the exact same Blueprint placed manually in the level.

With ChatGPT's assistance, I eventually found a simple fix. More importantly, the debugging process demonstrated how human observations and AI reasoning can complement each other.

## The issue

The fence spawned at the correct location and rotation, but traversal behaved incorrectly.

When the character attempted to traverse near either end of the fence, it would be pulled towards the centre instead of traversing from the nearest point.

Interestingly:

- The same Blueprint placed manually in the level worked correctly.

- The spawned fence had the correct visible geometry and rotation.

- Changing the spawned fence's yaw from 66° to 0°, then back to 66°, fixed traversal.

- Manually placed fences worked at any rotation.

The third observation was particularly important. It suggested that changing the actor's transform was refreshing something internally, rather than the rotation itself being incorrect.

## Investigating with AI

ChatGPT initially suspected the spawn rotation. We tried spawning the fence at zero rotation and applying the desired rotation afterwards, but this didn't resolve the issue.

Next, we suspected stale component transforms and tried explicitly updating the root component:

```cpp
RootComponent->UpdateComponentToWorld();
RootComponent->UpdateChildTransforms();
```

This also failed.

At this point, I remembered encountering a similar issue when implementing Spawn Platform. That obstacle originally used a non-uniformly scaled mesh, and traversal behaved incorrectly. I had worked around it by replacing the geometry with blocks using scale `(1, 1, 1)`, without discovering the underlying cause.

The new fence also used a non-uniformly scaled cube, so I suspected that the ledge components were affected by the scaling.

I shared this observation with ChatGPT, which helped redirect the investigation towards the traversal components rather than the spawning logic.

## Understanding the traversal system

The fence inherits from `LevelBlock\Traversable`, which contains four spline-based ledge components attached to its static mesh.

The component hierarchy is approximately:

```text
DefaultSceneRoot
└── StaticMesh (Non-uniform scale)
	 ├── Ledge_1
	 ├── Ledge_2
	 ├── Ledge_3
	 └── Ledge_4
```

I then showed ChatGPT the `GetLedgeTransforms` Blueprint function.

This function uses spline operations including:

1. `Find Location Closest to World Location`

2. `Get Distance Along Spline at Location`

3. `Get Transform at Distance Along Spline`

These operations determine the closest traversal position along a ledge.

ChatGPT suggested that the spline's internal data might not be correctly refreshed after runtime spawning, particularly when its parent component has non-uniform scaling.

This hypothesis also explained why manually changing the actor's rotation appeared to resolve the problem.

## The fix

After spawning the fence, I retrieved its spline components and explicitly called `UpdateSpline()`:

```cpp
AActor* SpawnedFence = World->SpawnActor<AActor>(LoadedFenceClass, SpawnLocation, SpawnRotation, SpawnParameters);

if (IsValid(SpawnedFence))
{
	TArray<USplineComponent*> SplineComponents;

	SpawnedFence->GetComponents<USplineComponent>(SplineComponents);

	for (USplineComponent* SplineComponent : SplineComponents)
	{
		SplineComponent->UpdateSpline();
	}
}
```
This fixed the traversal behaviour.

I tested the spawned fence at different rotations and confirmed that the character could traverse correctly from different positions along the obstacle.

The results strongly suggest that the spline data needed refreshing after runtime spawning. However, I haven't investigated the underlying engine implementation to confirm exactly why this happens.

## What I learned about human–AI collaboration

What I found most interesting was how we arrived at the solution.

ChatGPT contributed technical knowledge, generated hypotheses, and suggested experiments. However, several initial hypotheses were incorrect.

My contributions were equally important:

- **Observation:** I identified the behavioural difference between manually placed and runtime-spawned actors.

- **Experimentation:** I discovered that changing the rotation and restoring it fixed the same spawned actor.

- **Experience:** I remembered a similar issue from Spawn Platform involving non-uniform scaling.

- **Direction:** I suspected the ledge components and shared their implementation with ChatGPT.

- **Verification:** I tested the final fix at multiple angles before considering it resolved.

The AI couldn't have known about my earlier Spawn Platform experience without that information being provided. Equally, I hadn't identified `UpdateSpline()` as the solution until ChatGPT connected the symptoms to the spline-based traversal calculations.

The result came from an iterative process of observation, hypothesis, experimentation, and feedback.

## Final thoughts

This experience reinforced my approach to AI-assisted software engineering.

I don't want AI to blindly modify code until something works. I want to understand the problem, evaluate possible explanations, and make minimal, justified changes.

The human developer provides intent, historical context, observations, and judgment. The AI contributes technical knowledge, reasoning, and the ability to explore potential solutions quickly.

Neither side needs to have the complete answer at the beginning.

As I continue developing my own AI codebase agent, this is exactly the kind of collaboration I want to enable: an agent that can investigate real codebases, explain its reasoning, learn from feedback, and help developers maintain precise control over their systems.

**The goal isn't just to write code faster. It's to understand and solve problems more effectively.**

