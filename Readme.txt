A class-oriented OOP module for Lua

This is an implementation of a class-oriented Lua module, coded entirely in Lua. The object model allows you to override 'new()' (see tests), so you can write classes that behave the way you want. While still in design stage, the interface is getting quite stable and I will add a multiple inheritance mechanism if a user asks me to, or if I need it miself.

This is a beta release, please report bugs & feature requests to the project's [http://sroccaserra.uservoice.com/pages/object_lua UserVoice page].


=== Features ===

        * Class oriented
        * All classes derive from Object
        * Single inheritance (will add multiple if someone needs it)
        * All method calls are virtual, the class of the instance determines the bound method
        * Access to superclass method in overriden methods with a Java-like {{super.method(self)}}
        * The use of super only grants access to methods, NOT to data members (prevents many evils)
        * Consistent use of {{:}}, always use {{:}} to call any method of any class or instance
        * Object model allows to redefine {{new()}} in any class (see tests)
        * Use "has" to define members (inspired by Moose)
        * Hopefully only one way to do things, very predictible results

Note: there is a {{Prototype.lua}} file in the package, which is completely independant, but if you need prototype-based oop have a look at it (it provides a {{super(self)}} function).


=== Warnings ===

        * This is an early release.  Changes can be made in the future
        * No optimization.  This is still in the design stage


=== Code ===

This project's code can be dowloaded from its [http://code.google.com/p/objectlua Google code page].

You can also install ObjectLua from LuaRocks:
{{{
    $ luarocks install objectlua
}}}


=== Tests and Usage ===

See TestObject.

The tests documenting ObjectLua usage can be found in the {{test}} directory. You can run them with:
{{{
    $ make test
}}}

They use [http://luaforge.net/projects/luaunit/ LuaUnit].


=== References ===

        * [http://www.lua.org/pil/ PIL], by Roberto Ierusalimschy.
        * The [http://lua-users.org/wiki/ Lua Wiki].
        * [http://www.vpri.org/pdf/tr2006003a_objmod.pdf Open Reusable Object Models], by Ian Piumarta & Alessandro Warth, for bootstraping the object model.
        * [http://ejohn.org/blog/simple-javascript-inheritance/ This article] by John Resig for one of the previous implementations of super().
        * [http://mail.python.org/pipermail/python-dev/2001-May/014508.html This exchange] between Guido van Rossum (Python) and Jim Althoff (Smalltalk) for the object model.
        * [http://www.iam.unibe.ch/~scg/Archive/Papers/Scha03aTraits.pdf Traits: Composable Units of Behavior] by Nathanael Schärli, Stéphane Ducasse, Oscar Nierstrasz and Andrew Black for Traits

The main point is to bootstrap the object model and then,
build on it to populate {{Class}} with {{new()}}, {{inheritsFrom()}}, {{subclass()}},
and {{Object}} with {{initialize()}}, {{isKindOf()}}, {{clone()}}...

Thanks to Ludovic Perrine for making things clearer with enlightening discussions.
Thanks to Robert Rangel for finding a blocker bug fixed in version 0.0.3.


=== See Also ===

        * The project's [http://sroccaserra.uservoice.com/pages/object_lua UserVoice page] for bugs & feature requests.
        * The project's [http://code.google.com/p/objectlua/ Google code page]
        * ObjectOrientedProgramming

