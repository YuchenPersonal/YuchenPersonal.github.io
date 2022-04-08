---
layout: post
title: "UE4 Module Private and Public Dependency"
date: 2022-04-08 19:13:27 +0000
categories: [Programming]
tags: [UE4]
---

Modules in UE4 are dlls. Each module is compiled individually and modules are linked together to become an executable.

## Difference Between Privacy and Public Dependency

When you open a ModuleName.build.cs file, quite often you will see there are public and private dependencies in it.

A TLDR version guideline of which one to choose: Always use private dependency unless you have a good reason to not use it.

Let's say:

Module B has a **private** dependency on Module A

Module B will:
1. include Module A's public headers (Files in Module B can access stuff declared in Module A's Public folder's .h files).
2. link against Module A's cpp files (Files in Module B can call functions implemented in Module A's Private folder's .cpp files).

Module B has a **public** dependency on Module A

Module B will:
1. include Module A's public headers.
2. link against Module A's cpp files.

There's **no difference** between a private and a public dependency in the above case.

Let's continue:

Module C has a **public** dependency on Module B which has a **private** dependency on Module A

Module C will:
1. include Module B's public headers.
2. link against Module B's cpp files.
3. NOT include Module A's public headers.
4. NOT link against Module A's cpp files.

Module C has a **public** dependency on Module B which has a **public** dependency on Module A

Module C will:
1. include Module B's public headers.
2. link against Module B's cpp files.
3. include Module A's public headers. => **This is the only difference and it's not obvious!**
4. NOT link against Module A's cpp files.

Knowing this is quite useful when you debug link errors in your code. When the linker complains that it can't find the implementation of a function it's because the implementation is in another module which the current module doesn't have a dependency on.

I say always use private dependency because you can have a better idea of where the stuff you are using comes from because you only deal with one level of module dependency.
