# Intro
### Okay, first things first. What is this all about?
This is a small Wiki to get you started with modding [Homebrew](http://store.steampowered.com/app/325420)
Having some basic knowledge of C# (especially in combination with Unity) and/or Lua would be helpful.
### What does "modding" mean?
Homebrew (I'm going to just call it "HB" from now on) has a Lua modding system that allows access to most of the default C# Unity and System stuff. This means we can kind of copy-paste some C# code (Lua is written a bit differently though).
# Getting Started
### Using mods
There are two "types" of mods: Gadgets and mods.

Gadgets are visible in the Player's inventory, while mods (confusing name, i know), usually run in the background or open up their own little window (example: BuilderTools).
To actually _use_ those, you have to put them in their correct folder, have a look at

`%APPDATA%/../LocalLow/CopyBugPaste/Homebrew14/Lua/`

you should see two Folders called 'ModLua' and 'GadgetLua', if not, create those.
As you might have imagined, background/windowed mods go into ModLua while Gadgets go into GadgetLua.
### Modding Basics
[_Source_](/copybugpaste/HomebrewAPI/blob/master/Examples/GadgetTemplate.lua)

First of all, we need a basic template:

~~~~lua
local AwesomeMod = {}

function AwesomeMod:Awake()
  print("AwesomeMod:Awake()") --prints 'AwesomeMod:Awake()' to the console, not very important
  
  --TODO: Do starting stuff here
end

function AwesomeMod:Update()
  --TODO: Do every-frame stuff right here
end

return AwesomeMod
~~~~

Alright, let's go through this step by step.

First important thing is
```lua
local AwesomeMod = {}
function main(gameObject)
  AwesomeMod.gameObject = gameObject
  return AwesomeMod
end
```
^ this. You should put your mod name instead of "AwesomeMod", but this line is important to have on pretty much any HB mod.

The ``function main`` bit is specific to _gadgets_, you won't need it in "normal" mods.

```lua
AwesomeMod:Awake()
```
is automatically called whenever

* The Player selects this gadget (If in GadgetLua)
* /reloadlua is called (If in ModLua)

so you usually use it to _load_ stuff that _does not change_. For example, the Player object never changes, so if we need to do something with the player, we can do it in "Awake()".

```lua
AwesomeMod:Update()
```
is automatically called _every frame_, so be careful what you put into this function.

```lua
--TODO: Do every-frame stuff right here
```
these are comments by the way, pretty handy if you want to point out something so people can understand your code easily.

_Author: Ryz_