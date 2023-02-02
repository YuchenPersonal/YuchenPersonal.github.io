---
layout: post
title: "C Style Cast a Const Pointer Function Parameter to a Non Const Pointer"
date: 2023-02-02 21:21:00 +0000
categories: [Programming]
tags: [C++]
---

Today when I was coding C++ doing some castings from const void* to void* I have noticed one thing which is really interesting.

So, if a function takes in a const type*, you can C style cast it to the non const type* and you'll be able to use the returned pointer to modify the parameter's value.

It only applies to function parameter.

```cpp
int* TestFunc(const int* Ptr)
{
    //int* Ptr2 = Ptr; // Compile error cannot convert from 'const int *' to 'int *'
	int* Ptr2 = (int*)Ptr;

	//*Ptr2 = 8; // *Ptr will be changed to 8

	return Ptr2;
}

int main()
{
	int Index = 0;
	const int* ConstPtr = &Index;
	int* NonConstPtr = TestFunc(ConstPtr);
	//*NonConstPtr = 1; // Index's value will be changed to 1

	//int Index2 = 2;
	//const int* ConstPtr2 = &Index2;
	//int* NonConstPtr2 = ConstPtr2; // Compile error cannot convert from 'const int *' to 'int *'

	return 0;
}
```