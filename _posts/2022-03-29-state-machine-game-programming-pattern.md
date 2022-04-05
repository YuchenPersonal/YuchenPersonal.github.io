---
layout: post
title: "State Machine Game Programming Pattern"
date: 2022-03-29 18:46:00 +0000
categories: [Programming]
tags: [Game Programming Patterns, State Machine Pattern]
---

## Why?

Imagine you're creating a parkour game character like the one in subway surfer.

You want to play different anim loops when the character is in the middle lane, in the air, on the wall or holding a magnet.

The most straight forward idea would be having a bunch of enums for each situation and a big switch to handle all of them.

One big problem with this approach is all the code is in one file. It's hard to debug when it's not working correctly and it's hard to collaborate because everyone will need to modify this file.

In order to solve all these, you need state machine pattern to reduce conjunctions among different character states.

## How?

It depends on the game engine you're using you can either store the state machine in your base character class and have your AI character and player character derive from it to be able to use the state machine.

But I'd recommend creating a state machine component and just attach it to any character that needs it.

You'd also need a class to be the base state and other states will derive from it.

Back to the parkour game, you can have RunState, RunOnTheWallState, JumpState, FlyState, HoldMagnetState.

Each of them will have a few virtual functions:

```cpp
virtual void Enter();       // This is called when the character enters this state. You can activate a VFX or SFX using this for example.
virtual void Exit();        // Called when the character exits this state. Similarly, you can deactivate something here.
virtual void Update();      // Called to do some regular stuff e.g. to check if we should stay in this state or we should exit.
virtual void HandleInput(); // Each state can have its own valid inputs e.g. you can't jump while in FlyState
```

## Getting Complicated

Each state can also have multiple conditions to decide whether it's OK to continue or to exit to a different state.
For server client architecture, server and client will need to sync states. In UE4, you'll likely need some RPCs to achieve this.
Each state may also need to sync with corresponding animation state.
