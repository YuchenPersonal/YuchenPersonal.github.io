---
layout: post
title: "Ideal Way to Organize A Large Game Codebase"
date: 2024-01-23 22:30:00 +0000
categories: [Programming]
tags: [UE4, UE5, Game Programming Patterns]
---

Let's start from a background story.

In my personal Unreal Engine game project, I have a game module called Effect which has a effect struct called OnFireEffect.
This Effect module also has a EffectComponent which has a function called ApplyEffect that can apply any effect to the component.
There's another module called Weapon which has a weapon class called Flamethrower, in its Fire function, it does a line trace by channel and if it hits something, it will get the EffectComponent from the hit actor and apply OnFireEffect to it.

This is a reasonable design but it has a flaw:
Weapon module has to depend on Effect module so if we make a change to this OnFireEffect, the flamethrower class needs to be recompiled. While if this doesn't sound too bad, what makes it worse is Unreal will also compile a generated cpp file called Module.Weapon.cpp which includes all cpp files you created and all gen.cpp files. So it eventually becomes changing a class in Effect module has caused all modules that depend on it to recompile.

In order to address the flaw, I created a new module called EffectFramework which hosts an effect message called FApplyOnFireEffect, in flamethrower it just fires this message to the hit actor.
I've also created another module called Flammable which has a Flammable Component that listens to this message on its owner and applies the OnFireEffect to its owner.

This makes me think about what the ideal way is to organize a large game codebase to achieve **a fast build time and reusability**.

For unreal game codebase, we will have a main game module, this main game module can depend on all other modules but no other module should depend on it except its test module. This main module is at the bottom of the dependency chain.

Then we may have feature modules which are closely related to this specific game project e.g. Weapon and these modules should be the second bottom.

The framework modules are modules that only contains information needed for cross-module communication e.g. messages/events/interfaces. Framework modules usually have a much less changing frequency than feature modules.

The highest module in the dependency chain would be tool modules, they shouldn't depend on any module in the game project. They only depend on core engine modules.

Game plugins are a bit different and they are on a different higher level so modules can depend on plugins but plugins don't depend on modules or other plugins.

So, lower level modules can depend on higher level modules, not the other way around and modules shouldn't depend on other modules on the same level.

<div>
<p>                     Engine Modules                         </p>
<p>------------------------------------------------------------</p>
<p></p>
<p>Game Codebase</p>
<p>                         Plugins                            </p>
<p>------------------------------------------------------------</p>
<p>                       Tool Modules                         </p>
<p>------------------------------------------------------------</p>
<p>                    Framework Modules                       </p>
<p>------------------------------------------------------------</p>
<p>                General Feature Modules                     </p>
<p>------------------------------------------------------------</p>
<p>          Game Project Specific Feature Modules             </p>
<p>------------------------------------------------------------</p>
<p>                     Main Game Module                       </p>
</div>