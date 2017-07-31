# HomebrewAPI
The official API documentation for Homebrew Vehicle Sandbox 


# Foreword 
This documentation is a huge work in progress, and we'll be updating this farely often. 

# Basics
Before you start implementing your own gadget, take your time to view some of the examples already in-game, as they're a great starting point for gadgets. 
You'll notice that the lua scripts in Homebrew look a little bit different then regular lua scripts, 

most importantly, they all follow very strict coding rules. [See Examples](Examples/Flashlight.lua)

# New Gadget Tutorial
## Foreword
In this quick little tutorial, we'll make a flashlight, which you can toggle on and off, as a gadget.

Start by opening up your Lua location (``c:/users/[your-username]/appdata/locallow/CopyBugPaste/Homebrew14/Lua/GadgetLua``)
We'll need to make a couple of files to get a fully working gadget. 
First create a new lua file, called Flashlight

Then you'll need an "info" file, this is just a text file which will display the info about your gadget. 

Your gadget will also need a picture (64x48 pixels is recommended) of the same name.

In the end, you'll end up with 3 files, 
```
Flashlight.lua
Flashlight.info
Flashlight.png
```
And that's enough to have a 100% working gadget.
## The Code
Next we'll insert the basic mechanics into our flashlight tool. 
Open up the Flashlight.lua file, and start by creating the functions we'll need

```lua
function Flashlight:Start()

end 
function Flashlight:Update()

end
function Flashlight:OnDestroy()

end
```
every script in Homebrew will follow this syntax, ``function filename:functionName``
and we expose all the default unity monobehaviour voids, like 
Start, Update, OnDestroy, etc, for more information you can always check up on the Unity3D page about [Monobehaviours](https://docs.unity3d.com/ScriptReference/MonoBehaviour.html)

So, what does a flashlight gadget actually need? It needs a key to toggle it on/off, a way to see when the button is pressed, and the light to turn on or off obviously!

So, let's start by getting the key. 

```lua
function Flashlight:Start()
    self.useKey = HBU.GetKey("UseGadget")
end 
``` 
We use the function HBU.GetKey(string) to return a HBKeybind, we _could_ also use the default [Unity3D Input class](https://docs.unity3d.com/ScriptReference/Input.html), but that will make your gadget keyboard specific. 

As you can see the input for HBU.GetKey are the names of your keybinds in Homebrew! 
<img src="http://i.imgur.com/hJeDFKr.png"/>

Next we'll need to create the light objects, set the correct parents, and set the settings we want. 

This is fairly simple if you've ever dabbled into Unity3D 

```lua 
function Flashlight:Start()
  self.useKey = HBU.GetKey("UseGadget") 
  --Create objects
  self.obj = GameObject("FlashlightObj") -- This gives the gameobject we create the name "FlashlightObj"
  self.obj.transform:SetParent(Camera.main.transform) --parent it inside the main camera
  self.obj.transform.localPosition = Vector3(0,0,0) --set the **localposition** to 0,0,0 (aka relative pos to parent)
  self.obj.transform.localRotation = Quaternion.identity --set localrotation to identity (forward)
  self.light = self.obj:AddComponent("UnityEngine.Light") --Add a light component, which is under UnityEngine
end
```

Next we need to make sure the light gets destroyed, when you switch gadgets, so let's do that now before we test our code, (just in-case).

We'll use the OnDestroy function provided by Unity for this. 

```lua
function Flashlight:OnDestroy()
    GameObject.Destroy(self.obj)
end 
```
This makes sure that when we switch our gadgets, the light object gets killed as well, and it won't create more then one when we switch back to the flashlight tool. 

**Remember to always clean up your objects!** 

So now you've got a light! But, it's a point light! That's not what we want, we want a spotlight. 

This is quite easy to correct, we just need to set some variables on the light component!

```lua
  self.light.type = LightType.Spot --Defaults to Point light so, change to spot
  self.light.range = 500 -- up the range a fair bit
  self.light.intensity = 1.5 -- up the intensity a bit
  self.light.spotAngle = 55 -- set the angle to a neat 55° 
```
We can just chuck those values in Start, right after we create the light. 

Now if you try the gadget in Homebrew, you'll see that switching to the flashlight will create the light, and switching to another gadget destroys it. 

So let's add the functionality to enable/disable it manually, by pressing your LMB/RT 
```lua 
function Flashlight:Update()
  if(self.useKey:GetKeyDown())then
    self.light.enabled = not self.light.enabled --turn it on/off if useKey is pressed down 
  end
end
```

And that's it! You can always customize the code a lot further (like changing the colors, range, if it displays shadows or not, etc)

