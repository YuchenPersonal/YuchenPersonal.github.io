---
layout: post
title: "How to Write Good Code Tests"
date: 2022-02-17 20:20:20 +0000
categories: Programming, Automated Testing
---

## Unit Tests

Unit tests are the most common code tests.

The principle of writing code tests is: **Test the behaviour, not the implementation.**
My understanding of that is, whenever creating a code test, ask yourself a question, if someone changes a function name, will it break my test?
It shouldn't if it's a function that handles a step of a whole implementation, not interface functions like IsActive().

Here are some good practices on writting unit tests.

1. A unit test should be single purpose which means it's usually about an actor, a component or a struct.

2. We should avoid adding functions whose only purpose is to get access to some private variables. We should make use of the public functions if possible.
e.g. If we want to test a behaviour in a callback function, let's say when a door is opened, a sfx is played, we should try to use the public delegate to trigger the callback function rather than expose the callback function via a public test only function.

3. Set up a test situation that focuses on the thing you want to test which means you don't want to use the real/complex version of other things.
e.g. You want to write a test of the dialogue component attached to an NPC, in the unit test, you probably don't need a real NPC actor because it could have a bunch of other components you don't really want to deal with in dialogue component's unit test. Instead, you create a fake/mock/test version NPC which only has some basic functionalities or it can be a raw actor. A common way of doing this is to have the test version derive from actor + an NPC interface. The benefit of doing so is that you avoid all the unwanted complexity of the real NPC and you can also have the test version's interface return whatever value you want.

## Asset Tests

Asset tests are widely used to make sure someone won't change an asset property to be invalid. A common case is to check some important properies are not blank.