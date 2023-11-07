---
layout: post
title: "A Tricky bug about collision, overlap, actor hidden and tick"
date: 2023-11-07 10:50:00 +0000
categories: [Programming, Collision, Overlap]
tags: [UE4, Collision, Overlap]
---

Yesterday I created a bug that I was so confused about:

I have a StageProceedTriggerActor which gets activated when the current stage is finished and it's ready to proceed to next stage.

This StageProceedTriggerActor gets deactivated when player overlaps with it.

```cpp
void AStageProceedTrigger::OnOverlapped(AActor* OverlappedActor)
{
	if (auto* PlayerCharacterInterface = FInterfaceHelper::GetInterface<IPlayerCharacterInterface>(OverlappedActor))
	{
		if (auto* World = GetWorld())
		{
			FObjectMessagingHelper::SendMessageToObject(World->GetGameState(), FProceedToNextStage());
			DeactivateTrigger();
		}
	}
}

void AStageProceedTrigger::ActivateTrigger()
{
	EnableTriggerCollision();
	SetActorHiddenInGame(false);
	SetActorTickEnabled(true);
}

void AStageProceedTrigger::DeactivateTrigger()
{
	DisableTriggerCollision();
	SetActorHiddenInGame(true);
	SetActorTickEnabled(false);
}
```

However, if the player is at the trigger's location before it's activated, when it's activated, its collision will be disabled, actor will NOT be hidden and Tick will NOT be disabled.

I added one log to each function and I got both logs in correct order which made me even more confused...

```cpp

	UE_LOG(LogStageProceedTrigger, Warning, TEXT("ActivateTrigger"));

	UE_LOG(LogStageProceedTrigger, Warning, TEXT("DeactivateTrigger"));

	log:
		LogStageProceedTrigger: Warning: ActivateTrigger
		LogStageProceedTrigger: Warning: DeactivateTrigger

```

The worst part about this bug is this actor's collision was disabled as expected but hidden in game and tick were not set as expected.
I started to question about setting actor hidden and tick twice in one tick won't work. So I added a call of ActivateTrigger() and another call of DeactivateTrigger() in BeginPlay() but it turned out actor hidden and tick were set as expected.

Suddenly I realized what's happening here!

When the trigger gets activated, it will enable its collision first, then because the player is at trigger's location, OnOverlapped will be called which calls DeactivateTrigger which will disable the collision and set actor hidden to true and tick enabled to false.
Then, we will continue from AStageProceedTrigger::ActivateTrigger, SetActorHiddenInGame(false) and SetActorTickEnabled(true) which explains why collision was disabled but actor hidden and tick were NOT set correctly. (Basically a sequence of ActivateTrigger half way then DeactivateTrigger all the way and ActivateTrigger the other half which overrides half of what DeactivateTrigger did.)

So the fix would be to change the order of the function calls in ActivateTrigger and put EnableTriggerCollision at last

```cpp
void AStageProceedTrigger::ActivateTrigger()
{
	SetActorHiddenInGame(false);
	SetActorTickEnabled(true);
	EnableTriggerCollision();
}
```