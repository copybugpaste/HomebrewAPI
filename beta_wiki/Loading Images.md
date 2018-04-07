# Loading Images
### The Homebrew Way
Loading images is made easy, because Devs are nice people and made this function for us:
```lua
HBU.LoadTexture2D("path")
```

It's recommended to use ``Application.persistentDataPath`` though:
```lua
HBU.LoadTexture2D(Application.persistentDataPath.."/")
```

``Application.persistentDataPath`` contatins the path
```
C:/Users/%USERPROFILE%/AppData/LocalLow/CopyBugPaste/Homebrew14
```
note: ``%USERPROFILE%`` is a Windows thing, so you can paste it into the Windows Explorer, and it's going to replace ``%USERPROFILE%`` with your user name.

So this AppData path is where most of the user-created files (including mods) are stored. It's recommended to put the required images into ModLua:
```
Application.persistentDataPath.."/Lua/ModLua/modImage.png"
```
so Users only have to copy-paste all the files into ModLua.

_Author: Ryz_