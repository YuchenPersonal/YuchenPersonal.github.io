---
layout: post
title: "Pass Lambda Function as Parameter in UE4 C++"
date: 2022-05-06 15:55:00 +0000
categories: [Programming]
tags: [UE4]
---

Let's say you have an array of actor pointers. You want to iterate them and do something to each actor in the array.

You can implement it in a for loop but if you have multiple functions and each function does a different thing to each actor, you'll likely end up with multiple for loops.

To save you some coding, you can have a function called ForEachActor that takes a function as parameter and in the passed in function, you do something different to each actor in the array.

Here's an example of what I'm talking about in UE4 C++.

```cpp
// Definition
// This function takes another function as parameter
// The passed in function returns void and takes an actor* as parameter
void AYourActor::ForAllActors(TFunction<void(AActor*)> Callback)
{
    for (auto Actor : ActorArray)
    {
        Callback(Actor);
    }
}

// Use
void AYourActor::Function1()
{
    ForAllActors(
        [](AActor* InActor)
        {
            InActor->DoSomething();
        }
    );
}

void AYourActor::Function2()
{
    ForAllActors(
        [](AActor* InActor)
        {
            InActor->DoSomethingElse();
        }
    );
}
```