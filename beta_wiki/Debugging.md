# Debugging Lua Code

## Unity Methods

This is a tough one, since the lua you're making is very Homebrew specific (in most cases), it can be rather tough to debug values..

Thankfully, we supply everyone with a Console (´´home key`` to toggle it on/off), which will log each Debug message you put in.

![new_console](http://i.imgur.com/VzOyAnT.png)
It's fairly easy to send specific kind of logs using the default Unity "Debug" class

```lua
Debug.Log("This is a regular log")
Debug.LogWarning("This is a warning")
Debug.LogError("This is an error")
```

this will result in these messages in your console.

![chat_example](http://i.imgur.com/e6JNOoF.png)

this might not be the _handiest_ way for debugging though, as it requires you to be outside of a vehicle to toggle on/off.

The other way you can debug is via local chat messages!

## Chat Debugger

This is rather simple to implement, first we need to get the chat, then call a function to send a message.

Keep in mind this is **only locally**, so don't try spamming the chat, it won't do anything for other players.

```lua
self.chat = GameObject.FindObjectOfType("HBChat")
self.debug = function(msg) self.chat:AddMessage("[DEBUG]",msg) end
```

Then we can call it as such:

```lua
if Input.GetKeyDown(KeyCode.P) then
  self.debug("You pressed P!")
end
```

and it will look something like this

![name_color_example](http://i.imgur.com/HvLikrv.png)

As you can probably tell, this can be fairly handy in a lot of situations.

You can even add custom color coding to it if you want, let's change our original setup, and do that now.

```lua
self.chat = GameObject.FindObjectOfType("HBChat")
self.log      = function(msg) self.chat:AddMessage("[DEBUG]",msg, "ffffff") end
self.error    = function(msg) self.chat:AddMessage("[DEBUG]",msg, "cc0000") end
self.warning  = function(msg) self.chat:AddMessage("[DEBUG]",msg, "ffff00") end
```

this makes it a bit easier to quickly see if it's an error, warning, or a regular log.

We can also just change our 'name' value (``[DEBUG]``) to specify if it's a log, error, or warning, you could even colorize them quite easily!

```lua
self.error    = function(msg) self.chat:AddMessage("<color=#cc0000>[DEBUG]</color>",msg) end
```

which will result in the name being red

![red_error_log](http://i.imgur.com/fBupvJ4.png)

## Seperate Console window
Alternatively, you can also open up a custom instance of the Console we supply, and only place debug messages of your own design in there.
This is a bit more complex, but not too hard to figure out.

First we'll need to make a new Console, this is fairly straightforward

```lua
  self.console = HBConsoleManager.Create(Application.streamingAssetsPath .. "/HBConsole.exe", "Custom console yo!", 2000)
```

the ``HBConsoleManager.Create`` function takes a couple of argument, not _all_ are needed though.

``HBConsole.Create(string exePath, string consoleTitle = "Homebrew Console", int port = 1989, int consoleWidth = 255, int bufferSize = 1024, string prefix = ">>")``

The ones that definately need to change, is the port. We also specify a custom title, so it's a bit easier to differentiate between our own console, and the one embeded in Homebrew.

Next you'll need to hook up the events, and the destruction of your console.

```lua
function con:Start()
  self.console = HBConsoleManager.Create(Application.streamingAssetsPath .. "/HBConsole.exe", "Custom console", 2000)
  self.console.OnRead = self.onConsoleRead
  self.console.OnConnect = self.onConsoleConnect
  self.console:OpenConsole()
end
self.onConsoleRead = function(s)
  self.console:WriteLine("you wrote " .. s .. " in the console.")
end

self.onConsoleConnect = function()
  self.console:WriteLine("Your Console connected succesfully!")
end

function con:OnDestroy()
  self.console:KillConsole()
end
```

As you can see, we hook up ``console.OnRead`` and ``console.OnConnect``, OnRead gets called when the user inputs anything in the console, and presses enter. OnConnect gets called when the console has started succesfully.

Then we call ``console:OpenConsole()`` to open up the console, and we can log what-ever we want in there using ``console:WriteLine(message)``, the console also accepts color input (using html tags, like so ``<color=#FF0000>this is red</color>``), so you can slightly modify the functions we made for the getting the chat colors working, for our custom console.
![custom console funcs](http://i.imgur.com/i7kvneu.png)

```lua
self.log      = function(msg) self.console:WriteLine(string.format("<color=#ffffff>[DEBUG]</color> %s", msg)) end
self.error    = function(msg) self.console:WriteLine(string.format("<color=#ff0000>[DEBUG]</color> %s", msg)) end
self.warning  = function(msg) self.console:WriteLine(string.format("<color=#FFD700>[DEBUG]</color> %s", msg)) end
```

I think that's enough for now about regular text debugging.

## TODO

Add visual debugging, aka drawing cubes/circles/squares on screen, along with GUI elements for real-time visual debugging
