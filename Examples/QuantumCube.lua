local QuantumCube={}
function main(gameObject)
  QuantumCube.gameObject = gameObject
  return QuantumCube;
end

function QuantumCube:Awake()
  self.defaultFoV = HBU.GetSetting("FieldOfView")
  self.spawnMode = false
  self.spawnTime = 0.0
  self.distanceSpeed = 0.1
  self.lastScrollTime = 0.0

  self.keys = {}
  self.keys.lmb = HBU.GetKey("UseGadget")
  self.keys.rmb = HBU.GetKey("UseGadgetSecondary")
  self.keys.inv = HBU.GetKey("Inventory")
  self.keys.zoomIn = HBU.GetKey("ZoomIn")
  self.keys.zoomOut = HBU.GetKey("ZoomOut")
  self.keys.run = HBU.GetKey("Run")

  self.inventory = {}
  self.inventory.pressedTime = 0.0
end

function QuantumCube:Null(obj)
  if obj then
    if Slua.IsNull(obj) then return true end
    return false
  end
  return true
end
function QuantumCube:Update()
  if HBU.MayControle() == false or HBU.InSeat() or HBU.InBuilder() then
    if self:Null(self.inventory.object) then
      self:DestroyObjects()
    end
    return
  end
  if self.spawnMode == false then
    if self:Null(self.inventory.object) then
      self:HandleInventory()
      -- handle if you can spawn or not.
      if self.keys.lmb.GetKeyDown() then
        if not self.assetPath then
          self.assetPath = HBU.LoadValue("quantumCubeSave", "assetPath") or ""
        end
        if HBU.CanSpawnVehicle(self.assetPath) then
          self.spawnMode = true
          self:DestroyIfPresent(self.disabled)
          self:DestroyIfPresent(self.inventory.loading)
          self.target = self:CreateTarget()
          self.spawnTime = Time.time
          HBU.DisableGadgetMouseScroll()
        else
          self:CreateCantSpawn()
        end
      end
      if self.keys.lmb:GetKeyUp() then
        self:DestroyIfPresent(self.disabled)
        self:DestroyIfPresent(self.inventory.loading)
      end
    end
  else
    self:UpdateTarget(self.target)
    if Time.time > self.spawnTime + 1 and Slua.IsNull(self.vehicle) then
      self.vehicle = HBU.SpawnVehicle(Vector3(0, 0, 0), Quaternion.identity, self.assetPath)
      if self:Null(self.vehicle) then
        self.spawnMode = false
        GameObject.Destroy(self.target)
        return
      end
      HBU.InitializeVehicle(self.vehicle)
    end
    if not self:Null(self.vehicle) then
      self.vehicle.transform.position = self.target.transform.position
      self.vehicle.transform.rotation = self.target.transform.rotation
      if self.keys.lmb.GetKeyDown() then
        HBU.DropVehicle(self.vehicle)
        GameObject.Destroy(self.target)
        self.vehicle = nil --don't care about this anymore
        self.spawnMode = false
        Camera.main.fieldOfView = self.defaultFoV
        HBU.SaveValue("quantumCubeSave", "targetDistance", tostring(self.targetDistance))
        HBU.EnableGadgetMouseScroll()
        return
      end
      if self.keys.rmb.GetKeyDown() then --ABORT
        self:DestroyObjects()
        GameObject.Destroy(self.vehicle)
        self.spawnMode = false
        self.inventory.pressedTime = Time.time
        HBU.SaveValue("quantumCubeSave", "targetDistance", tostring(self.targetDistance))
      return
      end
    end
  end
end

function QuantumCube:DestroyObjects()
  if self:Null(self.target) == false then
    self:DestroyIfPresent(self.vehicle)
    self.spawnMode = false
  end
  self:DestroyIfPresent(self.inventory.object)
  self:DestroyIfPresent(self.inventory.loading)
  self:DestroyIfPresent(self.target)
  self:DestroyIfPresent(self.disabled)
end
function QuantumCube:OnDestroy()
  self:DestroyObjects()
  HBU.EnableGadgetMouseScroll()
  Camera.main.fieldOfView = self.defaultFoV
end

function QuantumCube:HandleInventory()
  if self.keys.rmb.GetKeyDown() then
    self.inventory.pressedTime = Time.time
    self:CreateInventoryBar()
    self:DestroyIfPresent(self.disabled)
    return
  end

  if self.keys.rmb.GetKeyUp() then
    --destroy inv bar
    self.inventory.pressedTime = 0.0
    self:DestroyIfPresent(self.inventory.loading)
    return
  end

  if self.keys.rmb.GetKey() > 0.5 or self.keys.inv.GetKey() > 0.5 then
    self:UpdateInventoryBar()
    if Time.time > self.inventory.pressedTime + 0.5 then
      self.inventory.object = self:OpenBrowser()
      self:DestroyIfPresent(self.inventory.loading)
    end
  end
end

function QuantumCube:DestroyIfPresent(go)
  if not self:Null(go) then GameObject.Destroy(go) end
end
function QuantumCube:UpdateTarget(go)
  if Slua.IsNull(go) then return end
  --position it infront of camera and handle distance via scroll
  if Time.time > self.lastScrollTime + 0.07 then
    local scroll = Input.GetAxis("Mouse ScrollWheel")
    if scroll == 0 then scroll = self.keys.zoomIn.GetKey() - self.keys.zoomOut.GetKey() end
    if scroll ~= 0 then
      self.lastScrollTime = Time.time
      local speedMult = 1.0
      if self.keys.run.GetKey() > 0.5 then speedMult = 2.0 end
      if (scroll > 0) then
        self.targetDistance = self.targetDistance * (speedMult + self.distanceSpeed)
      end
      if (scroll < 0) then
        self.targetDistance = self.targetDistance * (1.0 / (speedMult + self.distanceSpeed))
      end
    end
  end

  --zoom cam
  if self.targetDistance > 20 then
    Camera.main.fieldOfView = self.defaultFoV * (1.0 / (1.0 + Mathf.Clamp01((self.targetDistance - 20) / 1000.0) * 4.0))
  end

  --smooth move target
  local targetPos = Camera.main.transform.position + Camera.main.transform.forward * self.targetDistance
  local targetRot = Quaternion.LookRotation(Vector3.Scale(Camera.main.transform.forward, Vector3(1, 0, 1)), Vector3.up)
  local targetDist = Vector3.Distance(Camera.main.transform.position, self.target.transform.position)
  self.target.transform.position = Vector3.Lerp(self.target.transform.position, targetPos, Mathf.Clamp01(Time.deltaTime * 20.0))
  self.target.transform.rotation = targetRot

  --draw line
  local i = 1
  local a = Camera.main.transform:TransformPoint(Vector3(-0.3, -0.5, 0))
  local b = Camera.main.transform:TransformPoint(Vector3(0, 0, targetDist * 0.8))
  local c = self.target.transform.position
  for i = 1, self.lr.positionCount do
    local factor = (i - 1.0) * (1.0 / self.lr.positionCount)
    self.lr:SetPosition(i - 1, self:Bezier(a, b, c, factor))
  end
  end
  function QuantumCube:Bezier(a, b, c, f)
  --return bezier point between a,b,c using factor f (0-1)
  local aa = Vector3.Lerp(a, b, f)
  local bb = Vector3.Lerp(b, c, f)
  return Vector3.Lerp(aa, bb, f)
  end
  function QuantumCube:CreateCantSpawn()
  if Slua.IsNull(self.disabled) then
    self.disabled = HBU.Instantiate("Panel", HBU.menu.gameObject.transform:Find("Foreground").gameObject)
    HBU.LayoutRect(self.disabled, Rect((Screen.width / 2) - 100, (Screen.height / 2) - 25, 200, 50))
    self.disabled:GetComponent("Image").color = Color(0.2, 0.2, 0.2, 1)
    self.disabledText = HBU.Instantiate("Text", self.disabled)
    local text = self.disabledText:GetComponent("Text")
    text.color = Color(1.0, 1.0, 1.0, 1.0)
    text.text = HBU.GetSpawnError(self.assetPath)
    text.alignment = TextAnchor.MiddleCenter
  end
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
  if not self.targetDistance then
    self.targetDistance = tonumber(HBU.LoadValue("quantumCubeSave", "targetDistance")) or 5.0
  end
  ret.transform.position = Camera.main.transform.position + Camera.main.transform.forward * self.targetDistance

  return ret
end
function QuantumCube:OpenBrowser()
--setup the correct args
  self.browserArgs = {
      "",
      {"Vehicle"},
      {"WorkshopDownloaded", "WorkshopUploaded", "Favorite"},
      function(assetPath)
        if not assetPath or tostring(assetPath) == "" then return ; end
        self.assetPath = assetPath
        GameObject.Destroy(self.inventory.object)
        HBU.SaveValue("quantumCubeSave", "assetPath", self.assetPath)
      end,
      function()
        if self.inventory and self.inventory.object and not Slua.IsNull(self.inventory.object) then GameObject.Destroy(self.inventory.object) ; end
      end
  }
  return HBU.OpenBrowser( unpack(self.browserArgs)  )
end
--[[

function QuantumCube:OpenBrowser()
--setup the correct values
  return HBU.OpenBrowser(
    "",
    {"Vehicle"},
    {"WorkshopDownloaded", "WorkshopUploaded", "Favorite"},
    function(assetPath)
      self.assetPath = assetPath
      GameObject.Destroy(self.inventory.object)
      HBU.SaveValue("quantumCubeSave", "assetPath", self.assetPath)
    end,
    function()
      GameObject.Destroy(self.inventory.object)
    end
  )
end
--]]

function QuantumCube:CreateInventoryBar()
  --create a background panel center of screen 100 by 20
  self.inventory.loading = HBU.Instantiate("Panel", HBU.menu.gameObject.transform:Find("Foreground").gameObject)
  HBU.LayoutRect(self.inventory.loading, Rect((Screen.width / 2) - 50, (Screen.height / 2) - 10, 100, 20))
  self.inventory.loading:GetComponent("Image").color = Color(0.2, 0.2, 0.2, 1)

  --create a panel in the background will serve as loading bar
  self.inventory.bar = HBU.Instantiate("Panel", self.inventory.loading)
  self.inventory.bar.transform.pivot = Vector2(0, 1)
  self.inventory.bar.transform.anchorMin = Vector2(0, 1)
  self.inventory.bar.transform.anchorMax = Vector2(0, 1)
  self.inventory.bar.transform.anchoredPosition = Vector2.zero
  self.inventory.bar.transform.offsetMin = Vector2(3, -3)
  self.inventory.bar.transform.offsetMax = Vector2(3, -3)
  self.inventory.bar:GetComponent("Image").color = Color(1, 0.5, 0, 1)

  --create text saying "inventory" in the background
  local text = HBU.Instantiate("Text", self.inventory.loading)
  text.transform.anchorMin = Vector2(0, 0)
  text.transform.anchorMax = Vector2(1, 1)
  text.transform.offsetMin = Vector2.zero
  text.transform.offsetMax = Vector2.zero
  text:GetComponent("Text").text = "Inventory"
  text:GetComponent("Text").color = Color.white
  text:GetComponent("Text").alignment = TextAnchor.MiddleCenter
  text:AddComponent("UnityEngine.UI.Outline")
end

function QuantumCube:UpdateInventoryBar()
  --set sise of the loading bar
  if self:Null(self.inventory.bar) then
    self:CreateInventoryBar()
  end
  self.inventory.bar.transform.sizeDelta = Vector2(((Time.time - self.inventory.pressedTime) / 0.5) * (100 - 6), (20 - 6))
end