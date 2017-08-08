# Finding Vehicles in Homebrew

This is quite an intensive subject, as finding your own vehicles can be quite an extensive task.

There are a couple of ways of doing it.

Grabbing your _latest spawned vehicle_ from HBU through a helper function.

Manually raycasting, and verifying it's a vehicle object.

Getting every single vehicle in-game, and filtering out to only select your own.

The easiest would be using HBU to return your latest vehicle, this is rather simple

```lua
self.vehicle = HBU.GetMyOldestVehicle()
if(Slua.IsNull(self.vehicle)) then
  Debug.LogError("There was no vehicle of yours spawned!")
  return
end
```

Be sure to check if the returned object is null or not, using ``Slua.IsNull(object)``!
Now, ``self.vehicle`` will be **the parent** of your vehicle pieces, if you don't split your vehicle (detachers, rotators, hinges, etc), then you don't need to worry about this,
and you'll be able to change the values by using ``self.vehicle.transform.GetChild(0)``, preferably caching it after ``HBU.GetMyOldestVehicle()``, since there is a slight cost to this call.

You can also see how many children your vehicle root actually has by using the ``transform.childCount`` property, so you can iterate over them as you please.

Raycasting is also a bit strange in Lua, since Unity's raycasting system uses some explicit C# language agnostics, more specifically, the ``out`` parameter.

Therefor Slua has a helper object for this.

```lua
local ok, hitinfo = Physics.Raycast(origin, direction, Slua.out)
if(ok) then
  Debug.Log("We've hit " .. hitinfo.transform.name)
end
```

As you can see, it returns 2 values, ok, and hitinfo (using Slua.out), ok is a boolean, to see if you actually hit _anything_, while hitinfo is a [RaycastHit](https://docs.unity3d.com/ScriptReference/RaycastHit.html)

Raycast hit contains the collider it hit, distance, normal, the point of contact, and some other values that might be of interest. Be sure to read up on the Unity3D page linked above about raycastHits!

The last method will be fetching all Vehicles in _'The scene'_, and returning only your own vehicles.

It's best to make a helper function for this

```lua
function GetMyVehicles()
  local vehicles = GameObject.FindObjectsOfType("VehicleRoot")
  local ret = {}
  for t in Slua.iter(vehicles) do
    local nc = t:GetComponent("NetworkBase")
    if not Slua.IsNull(nc) then --make sure networkbase isn't nil
      if nc.Owner then --make sure you're the owner of the vehicle
        table.insert(ret, t) --insert it into your return table
      end
    end
  end
  return ret
end
```

This function should return all the vehicles you have ownership of (**UNTESTED**)

What about finding the vehicle you're currently in? Thankfully this isn't too hard.

```lua
function GetCurrentVehicle()
  local vehicle = Camera.main.gameObject:GetComponentInParent("VehicleRoot")
  if(vehicle == nil or Slua.IsNull(vehicle)) then return nil end
  return vehicle
end
```

As you can see, this is _really simple_ code, since your camera gets parented inside the vehicle when you enter it, it's super simple to get the vehicle root object, and subsequently, all the vehiclepieces of said vehicleroot.