# Changelog

## 7-8-2017

### Added features

* HBU.GetPlayers() : Returns array of "OtherPlayer" component in servers.
* Change LuaComponent methods **!!VERY IMPORTANT!!** (see [examples](/Examples/GadgetTemplate.lua))
* Removed Hot-Reloading cause of IO errors, replaced with "reloadlua" command in Console (HOME)
* Exposed HBConsoleManager

* OnDamageSent callback added, value is float

```lua
self.DamageCallback = function(dmg, point)
  print(string.format("You've dealt %s damage at %s", dmg, point))
end

HBU.OnDamageSent = nil --deletes ALL callbacks
HBU.OnDamageSent = self.DamageCallback --replace ALL callback
HBU.OnDamageSent = { "+=" , self.DamageCallback }--adds the callback (which allows other lua files to also read this back, SUGGESTED)
HBU.OnDamageSent = { "-=" , self.DamageCallback }--removes the callback (call this in OnDestroy, so your lua file can be exposed properly when it's not needed anymore)

--You can also just direction set a function in there like so:
HBU.OnDamageSent = function(dmg, p) print(string.format("%s : %s", dmg, p)) end
--This is not recommended though
```