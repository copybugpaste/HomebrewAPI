local Gadget = {}
function main(gameObject)
  Gadget.gameObject = gameObject
  return Gadget
end

function Gadget:Start()
  Debug.Log("Custom gadget has started!")
end
function Gadget:OnDestroy()
  Debug.Log("Custom gadget has stopped")
end
