# The Unity Canvas
### Using the Unity Canvas
So, what you do is, you have a Canvas Object, with a Canvas Component.

Then, you can add "sub-objects" (usually called children, but that's weird), with UI Components like Image, Button, Slider...

For more information on this topic, check [_this_](https://unity3d.com/de/learn/tutorials/s/user-interface-ui) out

### Using the Unity Canvas _in Homebrew!_
In Homebrew, things are a bit different, we can use ``HBU.Instantiate`` to get a new UI object:
```lua
self.imageObject = HBU.Instantiate("RawImage", nil)
self.image = self.imageObject:GetComponent("RawImage")
```
now you can use ``self.image`` [like you would use a normal ``RawImage`` in Unity](https://docs.unity3d.com/ScriptReference/UI.RawImage.html).

For scaling and positioning you can use
```lua
self.image.transform.position = Vector3(0, 0, 0)
self.image.transform.localScale = Vector3(3, 3, 1)
```

**One important Note though:** Using ``HBU.Instantiate`` you can not access _all_ Unity UI Elements, the available stuff is:
* Button
* FloatInput
* Image
* ImageButton
* IntInput
* ObjectInput (Someone please test this some more ??)
* PasswordInput
* RawImage
* Scroll
* Text
* TextInput
* Toggle (Doesn't show up?)

_Author: Ryz_