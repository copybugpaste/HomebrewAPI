# Multiplayer
### What do we need in life?
We need a mod that adds the Face of Nicolas Cage on all the other players in HB. That's a fact.

Let's get started!

### The base
We are going to load a picture of Mister Cage as described [right here](../wiki/Loading-Images).

```lua
HBU.LoadTexture2D(Application.persistentDataPath.."/face.png")
```
returns a [``Texture2D``](https://docs.unity3d.com/ScriptReference/Texture2D.html) btw.

### Finding other Players
All other players can be found using
```lua
GameObject.FindObjectsOfType("OtherPlayer")
```
which returns an ``Array<OtherPlayer>``, which we can easily convert to a lua table using HB's ``iter`` (or ``iter_to_table`` in V14, works the same):
```lua
playerTable = iter(GameObject.FindObjectsOfType("OtherPlayer"))
```

Now we want to exectute something for _all_ players, which is done in Lua like
```lua
for k,v in pairs(iter(GameObject.FindObjectsOfType("OtherPlayer"))) do
  print(v)
end
```
``k`` is the key, which in this case is the index.
``v`` is the value, so the ``OtherPlayer`` object (this is what we need).

In Unity, you can often use ``.transform`` to access stuff like position, rotation, scale and more.

Let's give that a shot:
```lua
for k,v in pairs(iter(GameObject.FindObjectsOfType("OtherPlayer"))) do
  print(v.transform.position)
end
```
Great! Now we have all the other player's positions 😄.

# Cage-i-fying
### Adding a Plane
We can add a default Plane like this
```lua
GameObject.CreatePrimitive(PrimitiveType.Plane)
```
Now let's position this plane:
```lua
self.planeObject = GameObject.CreatePrimitive(PrimitiveType.Plane)
self.planeObject.transform.position = Vector3(100, 0, 0)
self.planeObject.transform.rotation = Quaternion.Euler(90, 0, 0)
```

Now parenting to the player:
```lua
self.planeObject = GameObject.CreatePrimitive(PrimitiveType.Plane)
self.planeObject.transform.parent = iter(GameObject.FindObjectsOfType("OtherPlayer"))[1].transform

self.planeObject.transform.localPosition = Vector3.zero
self.planeObject.transform.localRotation = Quaternion.identity
```
if you try this ^ code, you will get some _weird_ results:

![weird results](https://i.imgur.com/uezK1En.jpg)

Some tweaking later:
```lua
self.planeObject = GameObject.CreatePrimitive(PrimitiveType.Plane)
self.planeObject.transform.parent = iter(GameObject.FindObjectsOfType("OtherPlayer"))[1].transform

self.planeObject.transform.localPosition = Vector3(0, 0.8, 0.1) -- move it up and forwards
self.planeObject.transform.localRotation = Quaternion.Euler(90, 0, 0) -- rotate it correctly
self.planeObject.transform.localScale = Vector3.one * 0.2 -- scale it down
```
![not quite as weird results](https://i.imgur.com/eDokypg.jpg)

Now, it's not perfectly on the head, but one day someone is going to figure that out (hopefully).

### Adding a Plane _with a texture_
```lua
self.planeObject = GameObject.CreatePrimitive(PrimitiveType.Plane)
self.planeObject.transform.parent = iter(GameObject.FindObjectsOfType("OtherPlayer"))[1].transform

self.planeObject.transform.localPosition = Vector3(0, 0.8, 0.1)
self.planeObject.transform.localRotation = Quaternion.Euler(90, 0, 0)
self.planeObject.transform.localScale = Vector3.one * 0.2

self.renderer = self.planeObject:GetComponent("MeshRenderer") -- gets the MeshRenderer
self.renderer.material = Material(Shader.Find("Sprites/Default")) -- removes shading and enabled transparency
self.renderer.material.texture = HBU.LoadTexture2D(Application.persistentDataPath.."/face.png") -- sets face.png as the texture
```
Read more about the [MeshRenderer](https://docs.unity3d.com/ScriptReference/MeshRenderer.html)?

Now we should see one creepy face 👻.

![A Cagebot](https://i.imgur.com/gV1T4rx.jpg)

You can see who is the chosen one by typing
```lua
print(iter(GameObject.FindObjectsOfType("OtherPlayer"))[1].playerName.name)
```
into the console.

Last thing to do is loop through all players and do the thing:
```lua
for k,v in pairs(iter(GameObject.FindObjectsOfType("OtherPlayer"))) do
  local planeObject = GameObject.CreatePrimitive(PrimitiveType.Plane)
  planeObject.transform.parent = v.transform
  
  planeObject.transform.localPosition = Vector3(0, 0.8, 0.1)
  planeObject.transform.localRotation = Quaternion.Euler(90, 0, 0)
  planeObject.transform.localScale = Vector3.one * 0.2
  
  local renderer = local planeObject:GetComponent("MeshRenderer") -- gets the MeshRenderer
  renderer.material = Material(Shader.Find("Sprites/Default")) -- removes shading and enabled transparency
  renderer.material.texture = HBU.LoadTexture2D(Application.persistentDataPath.."/face.png") -- sets face.png as the texture
end
```

### Everything put together
```lua
local cage = {}

function cage:Awake()
  for k,v in pairs(iter(GameObject.FindObjectsOfType("OtherPlayer"))) do
    local planeObject = GameObject.CreatePrimitive(PrimitiveType.Plane)
    planeObject.transform.parent = v.transform
    
    planeObject.transform.localPosition = Vector3(0, 0.8, 0.1)
    planeObject.transform.localRotation = Quaternion.Euler(90, 0, 0)
    planeObject.transform.localScale = Vector3.one * 0.2
    
    local renderer = local planeObject:GetComponent("MeshRenderer") -- gets the MeshRenderer
    renderer.material = Material(Shader.Find("Sprites/Default")) -- removes shading and enabled transparency
    renderer.material.texture = HBU.LoadTexture2D(Application.persistentDataPath.."/face.png") -- sets face.png as the texture
  end
end

function cage:Update() end

return cage
```

![Final product](https://i.imgur.com/Ep4H5qDg.jpg)

Now, this mod is certainly not perfect, but I just wanted to show you how to
1. Combine different things you learned
2. Have fun with Nicolas Cage's face
3. Mess with Multiplayer

Thanks for reading 😄.

_Author: Ryz_