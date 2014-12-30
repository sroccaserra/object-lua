[Deprecated] - I now prefer to use proper [prototype-based object oriented programming][pbp], in both Lua and JavaScript.

For inspiration, you can look at these JS refs:

- the _Objects Linked to Other Objects_ (OLOO) part of the [New Rules for JavaScript (video)][nrfjs] presentation,
- [JS Inheritance is awesome, and you're doing it wrong][ydiw], blog post.

And of course, the historical papers about prototypical objects:

- [Using Prototypical Objects to Implement Shared Behavior in Object Oriented Systems][upo], Henry Lieberman, 1986,
- [Class Warfare: Classes vs. Prototypes][cvo], Brian Foote, OOPSLA '89,
- [Organizing Programs Without Classes (pdf)][opwc], UNGAR, CHAMBERS, CHANG, HÖLZLE, 1991.

[pbp]: https://en.wikipedia.org/wiki/Prototype-based_programming
[nrfjs]: https://www.youtube.com/watch?v=S4cvuuq3OKY
[ydiw]: https://coderwall.com/p/sd9lda

[upo]: http://web.media.mit.edu/~lieber/Lieberary/OOP/Delegation/Delegation.html
[cvo]: http://www.laputan.org/reflection/warfare.html
[opwc]: https://cs.au.dk/~hosc/local/LaSC-4-3-pp223-242.pdf

ObjectLua
=========


A class-oriented OOP module for Lua

This is an implementation of a class-oriented Lua module, coded entirely in Lua. The object model allows you to override `new()` (see tests), so you can write classes that behave the way you want. While still in design stage, the interface is getting quite stable and I will add a multiple inheritance mechanism if a user asks me to, or if I need it miself.

This is a beta release, please report bugs & feature requests to the project's [UserVoice Page][uv].



Features
--------

* Class oriented
* All classes derive from Object
* Single inheritance (will add multiple if someone needs it)
* All method calls are virtual, the class of the instance determines the bound method
* Access to superclass method in overriden methods with a Java-like `super.method(self)`
* The use of super only grants access to methods, NOT to data members (prevents many evils)
* Consistent use of `:`, always use `:` to call any method of any class or instance
* Object model allows to redefine `new()` in any class (see tests)
* Use `has` to define members (inspired by Moose)
* Hopefully only one way to do things, very predictible results

Note: there is a `Prototype.lua` file in the package, which is completely independant, but if you need prototype-based oop have a look at it (it provides a `super(self)` function).


Warnings
--------

* This is a beta release.  Changes can be made in the future
* No optimization.  This is still in the design stage


Code
----

This project's code can be dowloaded from its [GitHub page][gh].

You can also install ObjectLua from LuaRocks:

    $ luarocks install objectlua


Tests and Usage
---------------

See [TestObject](http://github.com/sroccaserra/object-lua/blob/master/test/TestObject.lua).

The tests documenting ObjectLua usage can be found in the `test` directory. You can run them with:

    $ rake test

They use [LuaUnit][lu].


References
----------

* [PIL][], by Roberto Ierusalimschy.
* The [Lua Wiki][lw].
* [Open Reusable Object Models](http://www.vpri.org/pdf/tr2006003a_objmod.pdf), by Ian Piumarta & Alessandro Warth, for bootstraping the object model.
* [This article](http://ejohn.org/blog/simple-javascript-inheritance/) by John Resig for one of the previous implementations of super().
* [This exchange](http://mail.python.org/pipermail/python-dev/2001-May/014508.html) between Guido van Rossum (Python) and Jim Althoff (Smalltalk) for the object model.
* [Traits: Composable Units of Behavior](http://www.iam.unibe.ch/~scg/Archive/Papers/Scha03aTraits.pdf) by Nathanael Schärli, Stéphane Ducasse, Oscar Nierstrasz and Andrew Black for Traits

The main point is to bootstrap the object model and then,
build on it to populate `Class` with `new()`, `inheritsFrom()`, `subclass()`,
and `Object` with `initialize()`, `isKindOf()`, `clone()`...

Thanks to Ludovic Perrine for making things clearer with enlightening discussions.
Thanks to Robert Rangel for finding a blocker bug fixed in version 0.0.3.


See Also
--------

* The project's [UserVoice page][uv] for bugs & feature requests.
* The project's [GitHub page][gh]
* ObjectOrientedProgramming

[uv]: http://sroccaserra.uservoice.com/pages/object_lua
[gh]: http://github.com/sroccaserra/object-lua
[lu]: http://luaforge.net/projects/luaunit/
[pil]: http://www.lua.org/pil/
[lw]: http://lua-users.org/wiki/
