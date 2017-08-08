local gadgetName = {}
function main(gameObject)
  gadgetName.gameObject = gameObject
  return gadgetName
end

function gadgetName:Start()
  Debug.Log("Custom gadget has started!")
end
function gadgetName:OnDestroy()
  Debug.Log("Custom gadget has stopped")
end