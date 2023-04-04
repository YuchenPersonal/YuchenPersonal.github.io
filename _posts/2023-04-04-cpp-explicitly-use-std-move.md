---
layout: post
title: "C++ Explicitly Use std::move"
date: 2023-04-04 19:17:00 +0000
categories: [Programming]
tags: [C++]
---

Here's a super simple example on when you need to use std::move explicitly.

```cpp
#include <iostream>
#include <vector>

struct FRow
{
	FRow()
	{
		std::cout << "FRow ctor!\n";
	}

	FRow(const FRow& InOther)
	{
		std::cout << "FRow copy ctor!\n";
	}

	FRow(FRow&& InOther) noexcept
	{
		std::cout << "FRow move ctor!\n";
	}
};

int main()
{
	std::vector<FRow> TempRows;

	for (int Index = 0; Index < 1; Index++)
	{
	    FRow TempRow;

		TempRows.push_back(TempRow); // copy ctor
		// TempRows.push_back(std::move(TempRow)); move ctor
	}

	return 0;
}
```
In the above example, if you do std::move(TempRow), the move ctor will be called. Otherwise the copy ctor will be called.

In summary, you need to use std::move on a rvalue that you know it's not gonna needed anymore/safe to be moved but the compiler can't deduce whether it's needed anymore/whether it's safe to move it. 

This also applies to a temp value declared in a scope as shown in the above example, even though it's about to go out of scope.

Here's a good example from MS Learn on how to create move ctor and assignment operator

[Move Constructors and Move Assignment Operators (C++)](https://yuchenpersonal.github.io/assets/pdf/Move-Constructors-and-Move-Assignment-Operators-C++.pdf)
