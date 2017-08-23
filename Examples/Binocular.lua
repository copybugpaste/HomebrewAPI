local Binocular={}
function main(gameObject)
  Binocular.gameObject = gameObject
  return Binocular
end

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

  self.superSize = 1 --set this higher for _ultra highres_ screenshots!
  self.takingPicture = false

  self.ppl =  Camera.main.gameObject:GetComponent("UnityEngine.Rendering.PostProcessing.PostProcessLayer")
end
function Binocular:OnDestroy()
  --destroy ui
  self:TurnOff()
  if( Slua.IsNull(self.cameraUI) == false ) then
    GameObject.Destroy(self.cameraUI)
  end
end
function Binocular:TurnOff()
  self.watching = false
  self.canvasGroup.alpha = 0
  Camera.main.fieldOfView = self.defaultFoV
  HBU.EnableGadgetMouseScroll()
end

function Binocular:Update()
  if self.takingPicture == true then return end
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
      self.takingPicture = true
      --Take screenshot
      self.canvasGroup.alpha = 0
      local mm = GameObject.Find("MainMenu")
      mm:SetActive(false)
      local time = os.date("%x_%X")
      local filename = string.gsub(string.gsub(time,"/","_"),":","_")
      local path = Application.persistentDataPath .. "/screenshots/" .. filename .. ".png"
      self.aaState = self.ppl.antialiasingMode
      self.ppl.antialiasingMode=0
      HBU.TakeScreenshot(
        path,
        function()
          mm:SetActive(true)
          self.canvasGroup.alpha = 1
          self.takingPicture = false
          self.ppl.antialiasingMode = self.aaState
        end,
        self.superSize
      )
      return
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
    distance = string.format("%.2fm",hitinfo.distance)
  end
  self.distanceText.text = distance
end