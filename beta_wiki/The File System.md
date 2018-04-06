# Files in Homebrew
### First Approach
The first way of accessing Files is actually from the ``System.IO.File`` class, which you can easily find Tutorials for online by [searching 'c# file things' on google](https://www.google.de/search?q=c%23+file+things&oq=c%23+file+things).

Luckily you can access almost all class in HB-Lua by just typing the name, ``Slua.CreateClass("ClassName")`` or ``Slua.GetClass("ClassName")``.

In this case, we'll use the second one, since we can't do ``new File()`` in C# (instead you use ``File.ReadAllText("Path")``).

So pretty much all we need is:
```lua
Slua.GetClass("System.IO.File").ReadAllText("this is where the path goes")
```
this should return a ``string`` object, so just plain text of what's in the File.

For all the functionality ``System.IO.File`` has to offer, check out [the official Documentation](https://msdn.microsoft.com/en-us/library/system.io.file.aspx).
### Second Approach
Now, using the C# System stuff is useful, but there is something way way easier than that, but it's HB-specific:
```lua
file2string("this is where the path goes")
```
also returns a ``string``, should work _exactly_ the same.

_Author: Ryz_