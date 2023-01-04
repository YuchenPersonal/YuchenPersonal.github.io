---
layout: post
title: "UE4 UWorld Spawn Actor"
date: 2023-01-04 21:21:00 +0000
categories: [Programming]
tags: [UE4]
---

In my AI spawner code, I have something like this:

```cpp
if (auto* ResultPawn = World->SpawnActorDeferred<APawn>(PawnClass, SpawnTransform))
{
    UGameplayStatics::FinishSpawningActor(ResultPawn, SpawnTransform);
    SpawnedPawnAmount++;
}
```

However, I've noticed that sometimes SpawnedPawnAmount is more than actual AI pawns in the level.

This is because even though the ResultPawn is not null, it's pending kill if the spawned AI collides with other objects so it's not added to the level.

Have a look at AActor::PostActorConstruction() and UWorld::DestroyActor for more info on this.

Please be careful, simply checking that the returned pointer isn't null doesn't mean the spawned pawn is valid.

In this case, you could set the ESpawnActorCollisionHandlingMethod to one of the always spawn options or you could check it's valid or I would recommand you just keeping spawning and increasing the SpawnedPawnAmount actor's BeginPlay function because this way is easier to be guarded by automated tests. It also ensures that the spawned pawn won't collide with other stuff which may result in the pawn getting stuck in place.

UE has its own garbage collection system so when you call Actor->Destroy() it won't free its memory immediately and null the actor pointer, it will just mark this actor as pending kill and next GC cycle will null all GC aware pointers that are pointing to it and actually free its memory;