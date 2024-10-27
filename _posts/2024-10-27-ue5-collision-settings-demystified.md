---
layout: post
title: "UE5.3 Collision Settings Demystified"
date: 2024-10-27 22:02:00 +0000
categories: [Programming, Collision]
tags: [UE5, Collision]
---

I recently started a refactor of my project's collision settings which dramatically simplified it and improved my understanding of how the collision settings work.

The first part of collision settings contains Trace Channel and Object Channel. 

We need trace channel because sometimes we need a check to gather information with no real objects involved. E.g. Rifle fire doesn't spawn projectile actors, it's just a line trace.

Object channels are more like what this object is in terms of collision handling, so each object will have a object channel. E.g. Static mesh actors usually have World Static.

Then in the collision settings we have collision presets. They are a group of collision settings like what type of collision object channel I have and what my responses are to different collision channels.

For example, in my project, enemy's melee attack collision ignores everything except overlapping with player object channel which is used by the player capsule and my PlayerCapsule collision preset looks like this. 

![Player Capsule Collision Preset](/assets/img/PlayerCapsuleCollisionPreset.jpg)

It blocks all three trace channels because it needs to be seen by AI (Visibility) and it needs to be hit by line trace using Weapon channel. (I have no experience of Overlap response for trace types.)

It blocks WorldStatic because that's what my landscape uses so the player can walk on it.

It blocks Pawn because I don't want AI's body to overlap my player's body.

It overlaps WorldDynamic because some collisions use this object channel like explosions, they use component overlap event to deal damage.

It blocks projectile because most of my AI's projectiles uses component hit event which requires the response to be block.

One big gotcha is **only your projectile's root component is able to trigger component hit event** so if you want to use component hit you have to set your root component's collision settings. In my project, one of my enemy spawns a projectle from its hand and throws it, this projectile has to make the static mesh as its root to relatively easily attach/detach it to/from a socket, so I have to set the collision setting on the static mesh.

Another thing that tripped me up when debugging collisions was **logic in a Blueprint’s Construction Script. After dragging the Blueprint into a level, I made some changes to the BP's Construction Script. However, the placed actor didn’t reflect the updated Construction Script logic because it had already been instantiated.**
