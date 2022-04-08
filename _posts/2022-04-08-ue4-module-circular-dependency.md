---
layout: post
title: "UE4 Module Circular Dependency and How to Solve it"
date: 2022-04-08 19:58:27 +0000
categories: [Programming]
tags: [UE4]
---

Circular dependencies can appear when your project gets bigger and its module number grows.

For example:

Mechanism module depends on AI module.

You want to add something in your AI module which calls functions implemented in Mechanism module.
This means AI module has to depend on Mechanism.

You have a circular dependency and your project fails to build because the build tool can't figure out which module to build first (Both modules require the other one to be ready).

A good way to solve (not avoid because you can't predict it or I can't :)) circular dependency would be to create a MechanismFramework module and have the code needed by AI module in the Framework module. This way, instead of having AI and Mechanism dependent on each other, they both dependent on MechanismFramework.

Also we need to decide what should be put in the Framework module. In other words, what should be used by both the AI module and Mechanism module.

I'd say Interfaces. Ideally, modules don't really want to call functions implemented in another module, Interfaces should be the way for modules to communicate between each other. (But things are not always ideal especially when it comes to collaboration and fixed deadlines I know.)

Another thing which might be a good option to be put into Framework module is Messages if you are using Message Game Programming Pattern.
