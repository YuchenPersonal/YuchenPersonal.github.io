---
layout: post
title: "UE5.3 Localization"
date: 2024-12-15 22:30:00 +0000
categories: [Programming]
tags: [UE5, UE5/Localization]
---

1. Tools > LocalizationDashboard is where you want to go for localization.
2. Don't create a folder called Localization in your content folder manually, this will mess up the engine's localization process (e.g. failure of collecting texts).
3. You should use string table and hook up all your UI text to a string table's entry. This way you can avoid collecting the same text multiple times (Some common phases like Play, Quit).
4. Until you've added some entries to a string table, it won't show up in user widget's text field.
