---
layout: post
title: "Async Loading in UE4"
date: 2022-09-07 21:21:00 +0000
categories: [Programming]
tags: [UE4]
---

This anim montage was stored on the character BP using TSoftObjectPtr<UAnimMontage>.
This log is from a packaged DebugGame build.
```cpp
[2022.09.07-20.14.04:137][192]LogSEnemyCharacter: Warning: Streamable.RequestAsyncLoad ===========================
[2022.09.07-20.14.04:156][194]LogSEnemyCharacter: Warning: AnimMontageInfos[Index].AnimMontageType == EAnimMontageType::MeleeAttack
[2022.09.07-20.14.07:139][485]LogSEnemyCharacter: Warning: Streamable.RequestAsyncLoad ===========================
[2022.09.07-20.14.07:140][485]LogSEnemyCharacter: Warning: AnimMontageInfos[Index].AnimMontageType == EAnimMontageType::MeleeAttack
[2022.09.07-20.14.10:138][776]LogSEnemyCharacter: Warning: Streamable.RequestAsyncLoad ===========================
[2022.09.07-20.14.10:139][776]LogSEnemyCharacter: Warning: AnimMontageInfos[Index].AnimMontageType == EAnimMontageType::MeleeAttack
```
We can see the first time this anim montage was async loaded, it took 19ms. The second and third time only took 1ms.
So it's reasonable to say the first time it was async loaded from disk to memory and the rest times it was found it in memory.
I did this test because I was trying to decide whether to put this anim montage on the character BP or in a global setting.
Now I think it's better to put it on the character because once this character is destroyed, this anim montage will be removed from memory which is a good thing.

Another thing to notice is we also need
```cpp	
UPROPERTY()
UAnimMontage* LoadedAnimMontage;
```
on the character to make sure the loaded anim montage will stay in memory until the character is gone.