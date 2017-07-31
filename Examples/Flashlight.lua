--[[
  --QUICK EXAMPLE OF HOW TO DO SIMPLE GADGET--
  So, this is a fairly simple gadget, it spawns a gameObject, parents it, then sets local pos/rot, adds a component to it, and toggles it on/off. 

  Very neat and simple
--]]

function Flashlight:Awake()
  self.useKey = HBU.GetKey("UseGadget") --HBU.GetKey fetches from settings, always CamelCase 
      --^ If you want to use W/S for instance, you'd do HBU.GetKey("Move"), then HBU.GetKey:GetKey() will give you a -1 -> 1 value ;) 

  --Create objects
  self.obj = GameObject("FlashlightObj") --name the object FlaslightObj, cause why not
  self.obj.transform:SetParent(Camera.main.transform) --parent it inside the main camera
  self.obj.transform.localPosition = Vector3(0,0,0) --set the **localposition** to 0,0,0 (aka relative pos to parent)
  self.obj.transform.localRotation = Quaternion.identity --set localrotation to identity (forward)
  self.light = self.obj:AddComponent("UnityEngine.Light") --Add a light component, which is under UnityEngine
  self.light.type = LightType.Spot --Defaults to Point light so, change to spot
  self.light.range = 1000 -- up the range a fair bit
  self.light.intensity = 1.5 -- up the intensity a bit
  self.light.spotAngle = 55 -- set the angle to a neat 55° 
  self.light.enabled = false -- Turn it off by default

end

function Flashlight:Update()
  if(self.useKey:GetKeyDown())then
    self.light.enabled = not self.light.enabled --turn it on/off if useKey is pressed down 
  end
end
function Flashlight:OnDestroy()
  GameObject.Destroy(self.obj) --since we create an object, we don't wanna add infinite amount of objects obviously ;) 
end
