---
layout: post
title: "How to Write Good Code Tests"
date: 2022-02-17 20:20:20 +0000
categories: [Programming, AutomatedTesting]
---

## Unit Tests

Unit tests are the most common code tests.

The principle of writing code tests is: **Test the behaviour, not the implementation.**
My understanding is, for example, you want to test when we water a plant, it grows. Your test should pass no matter the function is done by loops or recursion.
Also according to my own experience, a code test is used to make sure the functionality you've created won't be broken accidentally or the bug you have fixed won't happen again. 

Here are some good practices on writing unit tests.

1. A unit test should be single purpose which means it's usually about an actor, a component or a struct.

2. We should avoid adding functions whose only purpose is to get access to some private variables. We should make use of the public functions if possible.
e.g. If we want to test a behaviour in a callback function, let's say when a door is opened, a sfx is played, we should try to use the public delegate to trigger the callback function rather than expose the callback function via a public test only function.

3. Set up a test situation that focuses on the thing you want to test which means you don't want to use the real/complex version of other things.
e.g. You want to write a test of the dialogue component attached to an NPC, in the unit test, you probably don't need a real NPC actor because it could have a bunch of other components you don't really want to deal with in dialogue component's unit test. Instead, you create a fake/mock/test version NPC which only has some basic functionalities or it can be a raw actor. A common way of doing this is to have the test version derive from actor + an NPC interface. The benefit of doing so is that you avoid all the unwanted complexity of the real NPC and you can also have the test version's interface return whatever value you want.

4. What if we want to test NPC? Usually an NPC class will have a bunch of components attached to it in code so it's very likely that an NPC unit test will be affected by something from one of its many components. E.g. one component wants to load an asset but this asset is specific to that component and this component will log an error if it fails to load the asset. Because NPC unit test doesn't set up that asset for that component, NPC unit test will fail but there's nothing wrong with NPC itself. So far I don't really have a perfect solution to this problem but 2 candidates I can think of are: 1. Downgrade the error to warning so it won't fail NPC's test. 2. Don't attach components in code. Do it in blueprints.

## Asset Tests

Asset tests are widely used to make sure someone won't change an asset property to be invalid. A common case is to check some important properties are not blank.
