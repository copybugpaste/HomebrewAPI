function Binocular:Awake()
  self.defaultFoV = HBU.GetSetting("FieldOfView")
  self.useGadgetKey = HBU.GetKey("UseGadget")
  self.useGadgetSecondaryKey = HBU.GetKey("UseGadgetSecondary")
  self.zoomInKey = HBU.GetKey("ZoomIn")
  self.zoomOutKey = HBU.GetKey("ZoomOut")
  
  --load camera ui from resources ( could create from scratch , got posebility to load ur own images, but eh need a fast solution atm)
  local prefab = Resources.Load("5HomebrewGadgets/CameraUI")
  self.cameraUI = GameObject.Instantiate(prefab)
  
  --gather parts of the prefab
  self.distanceText = self.cameraUI.transform:Find("Top/DistanceText"):GetComponent("Text")
  self.timeText = self.cameraUI.transform:Find("Top/TimeText"):GetComponent("Text")
  self.canvasGroup = self.cameraUI:GetComponent("CanvasGroup")
  self.leftLineTransform = self.cameraUI.transform:Find("Left")
  self.rightLineTransform = self.cameraUI.transform:Find("Right")
  self.rectableTransform = self.cameraUI.transform:Find("Rectacle")
  self.leftLineOriginalLocalPosition = self.leftLineTransform.localPosition
  self.rightLineOriginalLocalPosition = self.rightLineTransform.localPosition
  
  self.tod = UnityEngine.Object.FindObjectOfType("TOD_Sky")

  --make UI invisible at start
  self.canvasGroup.alpha = 0
  
  --setup some vars
  self.watching = false
  self.curFieldOfView = self.defaultFoV
  self.zoomSpeed = 0.1
  self.lastScrollTime = 0.0

  self.superSize = 1.5
  self:GetPP()
  HBU.EnableGadgetMouseScroll()
end
function Binocular:GetPP()
  self.pp = Camera.main:GetComponent("PostProcessingBehaviour")
end
function Binocular:OnDestroy()
  --destroy ui
  self:TurnOff()
  if( Slua.IsNull(self.cameraUI) == false ) then
    GameObject.Destroy(self.cameraUI)
  end
  --reset camera fov
end
function Binocular:TurnOff()
  self.watching = false
  self.canvasGroup.alpha = 0
  Camera.main.fieldOfView = self.defaultFoV
  HBU.EnableGadgetMouseScroll()
end

function Binocular:Update()
  if( HBU.MayControle() == false or HBU.InSeat()  or HBU.InBuilder()) then 
      self:TurnOff()
    return
  end
  if( self.watching == false ) then
    --enable watch
    if( self.useGadgetSecondaryKey.GetKeyDown() ) then
      self.canvasGroup.alpha = 1
      self.watching = true
      HBU.DisableGadgetMouseScroll()
    end
  else
    if(self.useGadgetKey:GetKeyDown())then
      --Take screenshot
      local c = coroutine.create(function()
          -- Hide the camera util, the rest of the UI, and disable AA to stop ugly banding from happening.
          local aa_enabled = self.pp.profile.antialiasing.enabled
          self.pp.profile.antialiasing.enabled = false
          self.canvasGroup.alpha = 0
          local mm = GameObject.Find("MainMenu")
          mm:SetActive(false)
          -- Wait a frames to be sure it's all done, and camera has rerendered the entire frame
          Yield(WaitForEndOfFrame())
          
          -- os.date("%x_%X") will produce 07/19/17_12:00:15, those aren't valid filename characters, so we replace them. 
          -- this is less code then formatting day, month, year, hour, mins, seconds, seperatly I guess. 
          local time = os.date("%x_%X")
          local filename = string.gsub(string.gsub(time,"/","_"),":","_")
          local path = Application.persistentDataPath .. "/screenshots/" .. filename .. ".png"

          Application.CaptureScreenshot(path,self.superSize)

          --Wait for a second, to make sure the screenshot is actually written to, otherwise you'll see UI in the picture!
          Yield(WaitForSeconds(1.0))
          -- Turn everything back on
          self.pp.profile.antialiasing.enabled = aa_enabled
          mm:SetActive(true)
          self.canvasGroup.alpha = 1
          Debug.Log("Saved screenshot to " .. path)
      end)
      coroutine.resume(c)
    end
    --handle zooming
    if( Time.time > self.lastScrollTime + 0.07) then
      local scroll = Input.GetAxis("Mouse ScrollWheel")
      if( scroll == 0) then scroll = self.zoomInKey.GetKey() - self.zoomOutKey.GetKey() end
      if( scroll ~= 0 ) then
        --self.lastScrollTime = Time.time
        if( scroll < 0 ) then
          self.curFieldOfView = self.curFieldOfView * (1.0 + self.zoomSpeed )
        end
        if( scroll > 0 ) then
          self.curFieldOfView = self.curFieldOfView * (1.0 / (1.0 + self.zoomSpeed ) )
        end
      end
    end
    
    --clamp and apply field of view
    self.curFieldOfView = Mathf.Clamp(self.curFieldOfView , 1,90)
    Camera.main.fieldOfView = self.curFieldOfView
    
    --disable watch
    if( self.useGadgetSecondaryKey.GetKeyDown() ) then
      self:TurnOff()
    end

    self:UpdateUI()
  end
end

function Binocular:UpdateUI()
  --set ingame timer to ToD Cycle time 
  local time = self.tod.Cycle.DateTime;
  self.timeText.text = time:ToString("HH:mm");
  
  -- Calc&Set distance text
  local distance = "infinite"
  local ok,hitinfo = Physics.Raycast(Camera.main.transform.position,Camera.main.transform.forward, Slua.out)
  if(ok) then 
    distance = string.format("%.2f",hitinfo.distance) .. "m"
  end
  self.distanceText.text = distance
end