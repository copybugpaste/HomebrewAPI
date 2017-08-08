# Debugging Lua Code

## Unity Methods

This is a tough one, since the lua you're making is very Homebrew specific (in most cases), it can be rather tough to debug values..

Thankfully, we supply everyone with a Console (´´home key`` to toggle it on/off), which will log each Debug message you put in.

![console screenshot](http://i.imgur.com/gy4DR5t.png)

It's fairly easy to send specific kind of logs using the default Unity "Debug" class

```lua
Debug.Log("This is a regular log")
Debug.LogWarning("This is a warning")
Debug.LogError("This is an error")
```

this will result in these messages in your console.

![chat_example](http://i.imgur.com/lBQmjAy.png)

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

I think that's enough for now about regular text debugging.

## TODO

Add visual debugging, aka drawing cubes/circles/squares on screen, along with GUI elements for real-time visual debugging
