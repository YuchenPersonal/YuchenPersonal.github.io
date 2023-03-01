---
layout: post
title: "UE4 Cast and C++ Class Instance Construction"
date: 2023-02-06 19:17:00 +0000
categories: [Programming]
tags: [C++, UE4]
---

Today I came across an issue related to UE4's Cast and C++ class instance construction.

The appearance of this issue is even though I've checked the returned pointer of a Cast is not nullptr, accessing its property still causes a crash.

```cpp
if (auto* GunInterface = Cast<IGunInterface>(ASMComponent->GetOwner()))
{
	GunInterface->SetSecondsSinceLastFire(GunInterface->GetFireIntervalInSeconds());    // Crashes
}
```
A bit more background info on this, I have a class called AWeapon and another class called AGun which derives from AWeapon and IGunInterface.

```cpp
UCLASS()
class WEAPON_API AGun : public AWeapon, public IGunInterface
```

When the editor is creating a class default object for AGun, the editor calls AGun's ctor which calls AWeapon's ctor which pushes its action state to Default which leads to the crash above.

The problem here I think is related to how a C++ class instance is constructed, because the ASMComponent->GetOwner() is AGun so the returned GunInterface is not nullptr hence the if condition is true.

However, because we are trying to access the GunInterface's function in Weapon's ctor (Weapon isn't derived from IGunInterface), we stumbles into an area that hasn't be initialized yet.

The conclusion is: don't access things in the child class from parent class's ctor.