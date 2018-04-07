# Part Interaction
### Finding a single Part
In order to find Parts, first of all we need the Part name. You can find any Part name by spawning any vehicle that has the Part attached.

After you spawned that vehicle, run this in the console:
```lua
parts = HBU.GetMyOldestVehicle():GetComponentsInChildren("Part")
for k,v in pairs(iter(parts)) do
  print(v.name)
end
```
And find the part you need, the name should be similar to the one showed in the Builder.

So this code above first gets your Vehicle, and finds all "Part" components in children objects. Afterwards it iterates through all found Parts and prints the GameObject's name, which is important in the next bit:
```lua
singlePart = GameObject.Find("Hemi servo(Clone)")
```
This simply finds **one** Hemi Servo by name. This solution should be fast enough and work well if you are sure that there's only one Part of that type.

Note: Double check that the Part it found is from the correct vehicle.

### Finding all Parts
Now let's find all Parts of one type:
```lua
-- Finds parts on *all* vehicles
function FindPartsAll(partName)
  results = {}
  for k,v in pairs(iter(GameObject.FindObjectsOfType("Part"))) do
    if (v.gameObject.name == partName.."(Clone)") then
      table.insert(results, v.gameObject)
    end
  end
  return results
end

-- Finds parts on *your last* vehicles
function FindParts(partName)
  results = {}
  for k,v in pairs(iter(HBU.GetMyOldestVehicle():GetComponentsInChildren("Part"))) do
    if (v.gameObject.name == partName.."(Clone)") then
      table.insert(results, v.gameObject)
    end
  end
  return results
end
```

You can just copy-paste these functions whereever you need them and use them like
```lua
FindParts("Hemi servo") -- The function adds "(Clone)"
FindPartsAll("Hemi servo")
```
Both should return a lua table with [``GameObject``](https://docs.unity3d.com/ScriptReference/GameObject.html)s.

They work the same as the snippets above, but they add all the results into a table and return that table at the end.

_Author: Ryz_