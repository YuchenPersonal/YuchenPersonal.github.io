---
layout: post
title: "Observer and Message Game Programming Pattern"
date: 2022-04-02 19:44:01 +0000
categories: [Programming]
---

## Why?

Imagine you want to award the player who kills a boss.

In your AI's death code, you'd probably do something like this:

Get the RewardInterface from the Instigator/player and call a function named AwardPlayer.

Or even worse you just get the RewardComponent from the player and call a function on it. (This would require your AI module to link PlayerReward module which is why I think it's worse than the Interface approach which doesn't require a link between these two.)

Later on you may want to show a notification which means you'd put some UI code in AI's death code.

If it keeps going like this and you want to play a SFX, a VFX, you end up putting all sorts of code into your AI's death code.

That's why we need Observer/Message Pattern.

## How?

The Observer pattern in the above case: Reward code, VFX code, UI code and SFX code all derives from a class called Observer with a function called onNotify.

All these codes that care about AI's death will be added to AI's observers and in AI's death code it will

```cpp
for (int32 Index = 0; Index < Observers.Num(); Index++)
{
    Observer[Index]->OnNotify(this, AIDeathEvent);
}
```

The Message pattern is similar to Observer, but it's more flexible in my opinion. Instead of deriving everything from Observer, you just register a Message (UStruct) to a MessageHandler. A MessageHandler is basically anything that has a map of type (UStruct::StaticClass())=>callback functions (In practice, it can be an interface).

So still the above example, you'd have Reward code, VFX code, UI code and SFX code all register an AIDeathMessage to a reachable actor (GameState/GameInstance or even the killer's PlayerController). Then when the boss dies, it sends AIDeathMessage with useful parameters(the killer and some info about itself) to the MessageHandler that everybody has registered to. Everybody just handles AIDeathMessage in its own callback.

This way we don't mix up different codes in one place. Also because we only care about AIDeathMessage not everything in the AI module, the Reward, VFX, UI, SFX module don't need to include/link AI code.
