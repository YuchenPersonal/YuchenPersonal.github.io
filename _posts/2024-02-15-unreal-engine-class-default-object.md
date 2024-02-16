---
layout: post
title: "In-Depth View of Unreal Engine Class Default Object"
date: 2024-02-15 23:50:00 +0000
categories: [UE4, UE5]
---

In order to understand the idea of class default object in unreal engine, we need to start from what a class is and what an object is.

In C++, a class is a definition of attributes collection. We use class to create objects so the created objects can have the attributes provided by the class.

Basically a class is a tool used to create objects that have same attributes.

In unreal, there's a thing called UClass which represents a class at runtime.

UClass is needed because we need to know how much memory we need to allocate when creating an UObject of this UClass. (See *UClass::GetPropertiesSize()* and *StaticAllocateObject()*)

UClass also has a function called GetDefaultObject which returns the class default object.

Each class only has one class default object.

We need this class default object because when we create a new UObject at runtime of a UClass, we can use the class default object as a template so all properties of the newly allocated object will copy properties from the class default object. (See *StaticConstructObject_Internal() > ~FObjectInitializer() > PostConstructInit() > InitProperties()*)

When you are editing a blueprint in editor, what you really are editing is the class default object of this blueprint class.

In conclusion, UClass is class at runtime and UObject is the instance, the real thing that can be created from UClass.

So a blueprint class you create in editor is a class because you use it as a template to create the real thing and the real thing you create is UObject.

Other examples of UObjects are UTexture, UDataAsset because they are the things you can use directly, not templates you use to instantiate things.