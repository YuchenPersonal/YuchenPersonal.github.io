---
layout: post
title: "MODULENAME_API dllimport dllexport and extern"
date: 2026-01-30 21:18:00 +0000
categories: [Programming]
tags: [UE5, C++]
---

In Unreal Engine C++, we can mark a class declaration or a class property using MODULENAME_API in a header. What this MODULENAME_API does is when MSVC compiles the module that contains this marked property/class, it becomes dllexport. When we compile a module that includes this marked property/class, it becomes dllimport. So, ultimately MODULENAME_API enables us to export the marked property/class from a module that defines it and use the marked property/class in modules that include it.

[Microsoft Learn dllexport, dllimport](https://learn.microsoft.com/en-us/cpp/cpp/dllexport-dllimport?view=msvc-170)

In standard C++, the extern keyword is most commonly used in a variable that needs to be accessed from different cpp files. Adding extern to a variable in a header can mark it as declaration to avoid redefinition error. 

For example, we have:<br>
globals.h
```
int sharedValue;   // definition
```
globals.cpp
```
#include "globals.h"
int sharedValue = 10;
```
main.cpp
```
#include "globals.h"
int main() { return 0; }
```
When we compile main.cpp and other.cpp, each of them will include the globals.h and have a int sharedValue definition in them.
When we link them together, we'll get a link error of multiple sharedValue definitions.
If we add extern to int sharedValue, this extern tells the compiler this is not a definition so we won't have the multiple definition linker error.