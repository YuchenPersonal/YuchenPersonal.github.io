---
layout: post
title: "Fix CMC Traversal Animation Selection"
date: 2026-10-14 21:00:00 +0000
categories: [Programming]
tags: [UE5, Animation]
---

Today I investigated a traversal animation issue in the Game Animation Sample 5.8 CMC character used by Pisces.

When the character stood on a 2.5m platform and tried to traverse over a 1m obstacle with no floor behind it, its hands grabbed the air above the ledge. Running traversal worked correctly, but stationary traversal did not.

## How CMC selects a traversal animation

The traversal flow is:

1. The `CharacterMovementComponent` provides the character's movement mode, such as `Walking`, `Falling`, or `Flying`.
2. The character implements `Get Properties for Traversal` from `BPI_SandboxCharacterPawn`. This converts the CMC movement mode into a custom traversal movement mode, stored in `S_CharacterPropertiesForTraversal`.
3. `AC_TraversalLogic::TryTraversalAction` reads those properties and checks the obstacle geometry to determine the traversal action, obstacle height, and other conditions.
4. `CHT_TraversalMontages_CMC` uses the action type, traversal movement mode, obstacle height, speed, and pose matching to select a montage and start time.
5. `PerformTraversalAction_CMC` plays the montage and temporarily sets the CMC movement mode to `Flying`. When the traversal finishes, it restores an appropriate movement mode.

The CMC movement mode is mapped to the traversal movement mode as follows:

| CMC movement mode | Traversal movement mode |
| --- | --- |
| None | OnGround |
| Walking | OnGround |
| Navmesh Walking | OnGround |
| Falling | InAir |
| Swimming | InAir |
| Flying | InAir |
| Custom | InAir |

For example, when the obstacle has no back floor, the traversal action can be `Vault`. For the same action and obstacle height, the Chooser can select different animations depending on the traversal movement mode:

- `OnGround` can select a grounded vault montage such as `Vault_1_0_stand_F_Lfoot`.
- `InAir` can select `Catch_Vault_high`.

## What went wrong

The obstacle height was correctly measured at about 97.5cm, and the `FrontLedge` motion-warping target appeared to be in the correct position. However, the character ended up playing `Catch_Vault_high`, which made its hands grab above the ledge.

I tried forcing `Catch_Hurdle_med_stand`, which fixed the hand alignment. This suggested that the problem was related to animation selection rather than simply the ledge position.

Further debugging showed that `TryTraversalAction` could run again while a traversal was already in progress. During a traversal, CMC is intentionally set to `Flying`, which is reported to the Chooser as `InAir`. A repeated traversal check could therefore select an airborne catch animation instead of the original grounded vault animation.

## The fix

I added a guard at the start of `TryTraversalAction`:

```cpp
// Pseudocode for the Blueprint logic.
if (DoingTraversalAction)
{
    return;
}
```

This prevents a new traversal request from being processed while the character is already traversing.

After the fix, the correct stationary vault animation played and the character aligned with the ledge in testing.
