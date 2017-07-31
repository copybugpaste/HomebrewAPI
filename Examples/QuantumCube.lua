function QuantumCube:Awake()
  self.spawnMode = false
  self.assetPath = HBU.LoadValue("quantumCubeSave","assetPath") or ""
  self.lastScrollTime = 0.0
  self.targetDistance = tonumber(HBU.LoadValue("quantumCubeSave","targetDistance")) or 5.0
  self.inventoryPressTime = 0.0
  self.browserOpen = false
  self.distanceSpeed = 0.2
  self.spawnModeTime = 0
  self.mouseDown = false
  self.inventoryKey = HBU.GetKey("Inventory")
  self.useGadgetKey = HBU.GetKey("UseGadget")
  self.useGadgetSecondaryKey = HBU.GetKey("UseGadgetSecondary")
  self.zoomInKey = HBU.GetKey("ZoomIn")
  self.zoomOutKey = HBU.GetKey("ZoomOut")
  self.running = true

  self.defaultFoV = HBU.GetSetting("FieldOfView")
end

function QuantumCube:Update()
  --return when in vheicle or if player cant be controled
  if( HBU.MayControle() == false or HBU.InSeat()  or HBU.InBuilder()) then 
    if self.browserOpen == false then 
      if self.running == true then 
        self:OnDestroy()
        self.running = false
      end
    end
    return 
  end 
  self.running = true
  if( self.spawnMode == false ) then

    --open inventory on right mouse button hold > 1 second
    if( self.browserOpen == false ) then
      if( self.inventoryKey.GetKeyDown() or self.useGadgetSecondaryKey.GetKeyDown()) then
          self.inventoryPressTime = Time.time
          self.mouseDown = true
          self:CreateInventoryBar()
      end
      if( (self.inventoryKey.GetKey() > 0.5 or self.useGadgetSecondaryKey.GetKey() > 0.5) and self.mouseDown == true ) then
        self:UpdateInventoryBar()
        if( Time.time > self.inventoryPressTime + 0.5 ) then
          self.browser = self:OpenBrowser()
          self.browserOpen = true
          self:DestroyInventoryBar()
        end
      end
      if( self.inventoryKey.GetKeyUp() or self.useGadgetSecondaryKey.GetKeyUp()) then
        self.mouseDown = false
        self:DestroyInventoryBar()
      end
    end
    if( self.useGadgetKey.GetKeyUp()) then 
      self:DestroyCantSpawn()
    end
    --enter spawn mode on left mouse button click and vehicle selected
    if( self.useGadgetKey.GetKeyDown() and self.browserOpen == false ) then
      if(HBU.CanSpawnVehicle(self.assetPath)) then 
        self.spawnMode = true
        --if inventory was pressed destroy ui
        if( self.ibar ~= nil ) then GameObject.Destroy(self.ibar) end
        --create target point
        self.target = self:CreateTarget()
        self.vehicle = nil --reset vehicle var ( itl be set whenever the async spawn call is finished )
        self.spawnModeTime = Time.time
        Debug.Log("spawnmode = true | spawnmodeTime = " .. Time.time)
      else
        self:CreateCantSpawn()
      end
    end
  else
    --update the target
    self:UpdateTarget(self.target)
    --spawn vehicle
    if( Time.time > self.spawnModeTime + 1 and self.vehicle == nil) then
      Debug.Log("Spawning vehicle")
      self.vehicle = HBU.SpawnVehicle(Vector3(0,0,0),Quaternion.identity,self.assetPath)
      Debug.Log("Vehicle Spawned");
      --stop if the vheicle failed to spawn 
      if( Slua.IsNull(self.vehicle) ) then
        Debug.LogError("Vehicle was nil")
        self.spawnMode = false
        --destroy the target point
        GameObject.Destroy(self.target)
        --reset fov
        Camera.main.fieldOfView = self.defaultFoV
        return
      end
      HBU.InitializeVehicle(self.vehicle)
    end

    --pposition vehicle at target
    if( Slua.IsNull(self.vehicle) == false ) then
      self.vehicle.transform.position = self.target.transform.position
      self.vehicle.transform.rotation = self.target.transform.rotation
    end

    --drop vehicle on left mouse button click if vehicle is loaded
    if( self.useGadgetKey.GetKeyDown() and self.vehicle ~= nil ) then
      HBU.DropVehicle(self.vehicle)
      GameObject.Destroy(self.target)
      self.spawnMode = false
      Camera.main.fieldOfView = self.defaultFoV
    end

    --abort spawning on right mouse button click
    if( self.useGadgetSecondaryKey.GetKeyDown()) then
      --destroy vehicle on abort , or stop async spawn on abort
      if( self.vehicle ~= nil ) then
        GameObject.Destroy(self.vehicle)
      end
      --destroy the target point
      GameObject.Destroy(self.target)
      --leave spawnmode
      self.spawnMode = false
      --reset fov
      Camera.main.fieldOfView = self.defaultFoV
    end
  end

end

function QuantumCube:OnDestroy()
  --reset fov
  Camera.main.fieldOfView = self.defaultFoV
  --if inventory is open drestroy it
  if( self.browser ~= nil ) then GameObject.Destroy(self.browser) end
  --if inventory was pressed destroy ui
  if( self.ibar ~= nil ) then GameObject.Destroy(self.ibar) end
  --destroy target
  if( self.target ~= nil ) then GameObject.Destroy(self.target) end
  --destroy vehicle if we were in sapwn mode
  if( self.spawnMode == true) then
    if(self.vehicle ~= nil) then
      GameObject.Destroy(self.vehicle)
    end
  end
  --destroy can't spawn UI 
  if( self.disabledBG ~= nil ) then 
    self:DestroyCantSpawn()
  end
  --save latest stats
  HBU.SaveValue("quantumCubeSave","assetPath",self.assetPath)
  HBU.SaveValue("quantumCubeSave","targetDistance",tostring(self.targetDistance))

  self.spawnMode = false
end

function QuantumCube:CreateTarget()
  --create gameObject from resources
  local prefab = Resources.Load("Commons/SphereUVMapped")
  local ret = GameObject.Instantiate(prefab)
  self.lr = ret:AddComponent("UnityEngine.LineRenderer")
  
  local light = ret:AddComponent("UnityEngine.Light")
  light.color = Color.green
  light.range = 20
  light.intensity = 5
  light.shadows = LightShadows.None
  
  --load resources
  local mat = Resources.Load("Commons/LineMaterial")
  local mat2 = Resources.Load("Commons/SpawnEffectMaterial")
  
  --assign material to the line renderer and setup its points + width and color
  ret:GetComponent("MeshRenderer").sharedMaterial = mat2
  
  self.lr.material = mat
  self.lr.widthMultiplier = 0.1
  self.lr.positionCount = 20
  self.lr.useWorldSpace = true
  self.lr.startColor = Color.green
  self.lr.endColor = Color.cyan
  
  --position the target infront of camera
  ret.transform.position = Camera.main.transform.position + Camera.main.transform.forward * self.targetDistance

  return ret
end

function QuantumCube:UpdateTarget( go )

  --position it infront of camera and handle distance via scroll
  if( Time.time > self.lastScrollTime + 0.07) then
    local scroll = Input.GetAxis("Mouse ScrollWheel") 
    if( scroll == 0) then scroll = self.zoomInKey.GetKey() - self.zoomOutKey.GetKey() end
    if( scroll ~= 0) then
      self.lastScrollTime = Time.time
      if( scroll > 0 ) then
        self.targetDistance = self.targetDistance * (1.0+self.distanceSpeed)
      end
      if( scroll < 0 ) then
        self.targetDistance = self.targetDistance *(1.0/(1.0+self.distanceSpeed))
      end 
    end
  end

  --zoom cam
  if( self.targetDistance > 20 ) then
    Camera.main.fieldOfView =self.defaultFoV * (1.0 / (1.0+Mathf.Clamp01((self.targetDistance-20)/1000.0)*4.0))
  end

  --smooth move target
  local targetPos = Camera.main.transform.position + Camera.main.transform.forward * self.targetDistance
  local targetRot = Quaternion.LookRotation(Vector3.Scale(Camera.main.transform.forward,Vector3(1,0,1)),Vector3.up)
  local targetDist = Vector3.Distance(Camera.main.transform.position,self.target.transform.position)
  self.target.transform.position = Vector3.Lerp(self.target.transform.position,targetPos,Mathf.Clamp01(Time.deltaTime * 20.0))
  self.target.transform.rotation = targetRot
  
  --draw line
  local i = 1
  local a = Camera.main.transform:TransformPoint(Vector3(-0.3,-0.5,0))
  local b = Camera.main.transform:TransformPoint(Vector3(0,0,targetDist*0.8))
  local c = self.target.transform.position
  for i=1,self.lr.positionCount do
    local factor = (i-1.0)*(1.0/self.lr.positionCount)
    self.lr:SetPosition(i-1,self:Bezier(a,b,c,factor))
  end
  
end

function QuantumCube:Bezier( a , b , c , f)
  --return bezier point between a,b,c using factor f (0-1)
  local aa = Vector3.Lerp(a,b,f)
  local bb = Vector3.Lerp(b,c,f)
  return Vector3.Lerp(aa,bb,f) 
end
function QuantumCube:CreateCantSpawn()
  if(Slua.IsNull(self.disabledBG)) then 
    self.disabledBG = HBU.Instantiate("Panel",HBU.menu.gameObject.transform:Find("Foreground").gameObject)
    HBU.LayoutRect(self.disabledBG,Rect((Screen.width/2)-100,(Screen.height/2)-25,200,50))
    self.disabledBG:GetComponent("Image").color = Color(0.2,0.2,0.2,1)
    self.disabled = HBU.Instantiate("Text",self.disabledBG)
    local text = self.disabled:GetComponent("Text")
    text.color = Color(1.0,1.0,1.0,1.0)
    text.text = HBU.GetSpawnError(self.assetPath)
    text.alignment = TextAnchor.MiddleCenter
  end
end
function QuantumCube:CreateInventoryBar()
  --create a background panel center of screen 100 by 20
  self.ibar = HBU.Instantiate("Panel",HBU.menu.gameObject.transform:Find("Foreground").gameObject)
  HBU.LayoutRect(self.ibar,Rect((Screen.width/2)-50,(Screen.height/2)-10,100,20))
  self.ibar:GetComponent("Image").color = Color(0.2,0.2,0.2,1)
  
  --create a panel in the background will serve as loading bar
  self.bar = HBU.Instantiate("Panel",self.ibar)
  self.bar.transform.pivot = Vector2(0,1)
  self.bar.transform.anchorMin = Vector2(0,1)
  self.bar.transform.anchorMax = Vector2(0,1)
  self.bar.transform.anchoredPosition = Vector2.zero
  self.bar.transform.offsetMin = Vector2(3,-3)
  self.bar.transform.offsetMax = Vector2(3,-3)
  self.bar:GetComponent("Image").color = Color(1,0.5,0,1)
  
  --create text saying "inventory" in the background
  local text = HBU.Instantiate("Text",self.ibar)
  text.transform.anchorMin = Vector2(0,0)
  text.transform.anchorMax = Vector2(1,1)
  text.transform.offsetMin = Vector2.zero
  text.transform.offsetMax = Vector2.zero
  text:GetComponent("Text").text = "Inventory"
  text:GetComponent("Text").color = Color.white
  text:GetComponent("Text").alignment = TextAnchor.MiddleCenter
  text:AddComponent("UnityEngine.UI.Outline")
end

function QuantumCube:UpdateInventoryBar()
  --set sise of the loading bar
  self.bar.transform.sizeDelta = Vector2(((Time.time - self.inventoryPressTime)/0.5)*(100-6),(20-6))
end
function QuantumCube:DestroyCantSpawn()
  if not Slua.IsNull(self.disabledBG) then GameObject.Destroy(self.disabledBG); self.disabledBG = nil end
end
function QuantumCube:DestroyInventoryBar()
  --destroy the ui
  GameObject.Destroy(self.ibar)
end

function QuantumCube:OpenBrowser()
  
  --open HB browser
  return HBU.OpenBrowser("",{"Vehicle"},{"WorkshopDownloaded","WorkshopUploaded","Favorite"},
            function(assetPath) 
              self.assetPath = assetPath
              GameObject.Destroy(self.browser)
              self.browserOpen = false 
            end,
            function() 
              GameObject.Destroy(self.browser) 
              self.browserOpen = false 
            end)
  
  --use below for browser mod
  
  --create empty gameObject
  --local ret = GameObject("browser")
  --add lua component
  --local comp = HBU.AddComponentLua(ret,"ModLua/Browser.lua")
  --call init on lua component
  --comp.self:Init(HBU.GetUserDataPath().."/Vehicle","Vehicle")
  --return ret
end