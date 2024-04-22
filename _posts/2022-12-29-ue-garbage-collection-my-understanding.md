---
layout: post
title: "UE5 Garbage Collection My Understanding"
date: 2022-12-29 21:21:00 +0000
categories: [Programming]
tags: [UE5]
---

My understanding about UE5's garbage colletion. The engine version I'm testing on is UE5.3.2.

UObject* pointed objects will **NOT** be GCed if:
1. UObject* is marked as UPROPERTY.
2. UObject* is stored in TArray, TSet or TMap marked as UPROPERTY.
3. A UObject spawned via NewObject<UObjectName>() as a single instance can call AddToRoot to avoid being GCed.

I'd recommand testing the behaviour in your own code base rather than remembering the conclusion.
You can create a UTestGCObject : public UObject and new multiple instances of it and store them in different containers marked as UPROPERTY or not.
You can use TWeakObjectPtr to check if a UObject is GCed. TWeakObjectPtr will not stop pointed UObject from being GCed but if the UObject it's pointing to was GCed, it will be invalid (The VS watch window will show it as STALL).
To trigger GC, you can use the console command gc.CollectGarbageEveryFrame 1.

A few more things which may worth paying attention to are:
1. For UPROPERTY marked containers of UObject*, its element will be nulled when the UObject is GCed but its size won't change. Also if it's only destoryed but not GCed, IsValid() will fail but null pointer check will pass.
2. TObjectPtr behaves the same as UObject* in regards to garbage collection.