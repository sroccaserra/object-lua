--
--  Tested with Lua 5.1.3 & Lua 5.1.4
--
require 'objectlua.init'

local Object = objectlua.Object
local Class  = objectlua.Class
local _G = _G

module(...)

function tearDown()
    Class.reset()
end


----
--  Inheritance & Initialization
function testInheritanceAndInitialization()
    local Person = Object:subclass('Person')

    function Person:initialize(name)
        self._name = name
    end

    local person = Person:new('John')
    local otherPerson = Person:new('Bob')

    _G.assertEquals(Person, person.class)
    _G.assertEquals(Object, Person.superclass)
    _G.assertEquals(Object.class, Person.class.superclass)
    _G.assertEquals(nil, person.new)
    _G.assertEquals(person._name, 'John')
    _G.assertEquals(otherPerson._name, 'Bob')
end

----
--  Testing subclassing
function testSubclassing()
   local Toto = Object:subclass()

   function Toto:initialize(name)
      self.name = name
   end

   local john = Toto:new('John')
   local bob = Toto:new('Bob')

   _G.assertEquals(john.name, 'John')
   _G.assertEquals(bob.name, 'Bob')
end

----
--  Calling super
function testSuper()
    local Toto = Object:subclass()
    function Toto:initialize(name)
        self.name = name
    end

    local Tata = Toto:subclass()
    function Tata:initialize(name)
       super.initialize(self, name)
    end

    local tata = Tata:new('Bob')
    _G.assertEquals(tata.name, 'Bob')
end

----
--  Calling super through two levels of inheritance.
--  This one can cause a stackoverflow with a too simple super() implementation.
function testSuperThroughTwoLevels()
    local Toto = Object:subclass()
    function Toto:initialize(name)
        self.name = name
    end

    local Tata = Toto:subclass()
    function Tata:initialize(name)
        super.initialize(self, name)
    end

    local Titi = Tata:subclass()
    function Titi:initialize(name)
        super.initialize(self, name)
    end

    local titi = Titi:new('Paul')
    _G.assertEquals(titi.name, 'Paul')
end

----
--  Virtual calls
function testVirtualCall()
    local Base = Object:subclass()

    function Base:initialize()
        self.type = self:getType()
    end

    function Base:getType()
        return 'base'
    end

    --
    local Derived = Base:subclass()

    function Derived:getType()
        return 'derived'
    end

    local derived = Derived:new()
    _G.assertEquals(derived.type, 'derived')
end

----
--  Super jump
function testSuperJump()
    local Level0 = Object:subclass()
    function Level0:getNumber()
        return 10
    end

    local Level1 = Level0:subclass()

    local Level2 = Level1:subclass()
    -- Calling super(self) in getNumber() on a Level2 object skips Level1
    -- (since it's not overriden here) and calls Level0:getNumber()
    function Level2:getNumber()
        return super.getNumber(self) + 1
    end

    local level2 = Level2:new()
    _G.assertEquals(level2:getNumber(), 11)
end

----
--  Super virtual calls through two levels...
function testVirtualSuperThroughTwoLevels()
    local Level0 = Object:subclass()
    function Level0:initialize()
        self.type = self:getType()
    end
    function Level0:getType()
        return 'level0'
    end
    _G.assertEquals(Level0:new().type, 'level0')

    local Level1 = Level0:subclass()
    function Level1:initialize()
        super.initialize(self)
    end
    function Level1:getType()
        return 'level1'
    end
    _G.assertEquals(Level1:new().type, 'level1')

    local Level2 = Level1:subclass()
    function Level2:initialize()
        super.initialize(self)
    end
    function Level2:getType()
        return 'level2'
    end
    _G.assertEquals(Level2:new().type, 'level2')
end

----
--  Calling initialize with two arguments through super
--  Passes since version 0.0.3
function testInitializeWithTwoArguments()
    local Toto = Object:subclass()

    function Toto:initialize(name, color)
        self.name = name
        self.color = color
    end

    local toto = Toto:new('Bob', 'red')
    _G.assertEquals(toto.name, 'Bob')
    _G.assertEquals(toto.color, 'red')

    local Tata = Toto:subclass()
    function Tata:initialize(name, color)
        super.initialize(self, name, color)
    end
    local tata = Tata:new('John', 'blue')
    _G.assertEquals(tata.name, 'John')
    _G.assertEquals(tata.color, 'blue')
end

----
--  Testing class methods
function testClassMethods()
   local Foo = Object:subclass()
   function Foo.class:sayHello()
      return 'Hello'
   end
   _G.assertEquals(Foo:sayHello(), 'Hello')
end

----
--  Testing super on class methods
function testSuperInClassMethods()
    local Level1 = Object:subclass()
    function Level1.class:getName()
        return 'Level1'
    end
    _G.assert('Level1' == Level1:getName())

    local Level2 = Level1:subclass()
    function Level2.class:getName()
        return super.getName(self)..'-Level2'
    end

    _G.assertEquals(Level2:getName(), 'Level1-Level2')
end

----
--  Testing isKindOf
function testIsKindOf()
    local Level1 = Object:subclass()
    local Level2 = Level1:subclass()
    local object = Object:new()
    local level2 = Level2:new()

    _G.assert(not object:isKindOf())
    _G.assert(object:isKindOf(Object))
    _G.assert(not object:isKindOf(Level1))
    _G.assert(level2:isKindOf(Object))
    _G.assert(level2:isKindOf(Level1))
    _G.assert(level2:isKindOf(Level2))
    _G.assert(not object:isKindOf(Class))

    _G.assert(not Level2:isKindOf(Level2))
end

----
--  Testing inheritsFrom
function testInheritsFrom()
    local Level1 = Object:subclass()
    local Level2 = Level1:subclass()

    _G.assert(Level1:inheritsFrom(Object))
    _G.assert(Level2:inheritsFrom(Object))
    _G.assert(Level2:inheritsFrom(Level1))
    _G.assert(not Level2:inheritsFrom(Level2))
end

----
--  Validating object model
function testObjectModel()
    _G.assertEquals(Object.class.class, Class)
    _G.assertEquals(Class.class.class, Class)
    _G.assertEquals(Object:subclass().class.class, Class)
    _G.assert(Object:isKindOf(Object))
    _G.assert(Object:isKindOf(Class))
    _G.assert(Class:isKindOf(Object))
    _G.assert(Class:isKindOf(Class))

    _G.assert(not Object:inheritsFrom(Class))
    _G.assert(Class:inheritsFrom(Object))
    _G.assert(not Object:inheritsFrom(Object))
end

----
--  Testing clone
function testClone()
    local Level1 = Object:subclass()
    local level1 = Level1:new()
    level1.value = 5
    level1.values = {6, 7}
    local clone = level1:clone()

    _G.assert(clone:isKindOf(level1.class))
    _G.assert(clone.value == level1.value)
    _G.assert(clone.values == level1.values)
end

----
--  Private metatables (get)
function testPrivateMetatable()
    local Level1 = Object:subclass()
    local level1 = Level1:new()

    _G.assertEquals(_G.getmetatable(Level1), 'private')
    _G.assertEquals(_G.getmetatable(level1), 'private')
end

----
--  Private metatables (set)
function testSetMetatableFails()
    local Titi = Object:subclass()
    local titi = Titi:new()
    _G.assertError(_G.setmetatable, titi, {})
end

----
--  Adding methods to an instance
function testAddingMethodToInstance()
    local john = Object:new()
    function john:itWorks()
        return true
    end
    _G.assert(john:itWorks())
end

----
--  Testing redefining new()
function testRedefiningNew()
    local OtherNew = Object:subclass()

    function OtherNew.class:new(...)
       local instance = super.new(self, ...)
       instance.fromOtherNew = true
       return instance
    end

    local Foo = OtherNew:subclass()
    _G.assert(Foo:isKindOf(Class))
    local foo = Foo:new()
    _G.assert(foo.fromOtherNew)
end

----
--  Testing exception in super(self)
--  Passes since 0.3.2
function testExceptionInSuper()
    local Base = Object:subclass()
    function Base:getString(name)
        _G.assert('string' == _G.type(name))
        return 'Base:'..name
    end

    local Derived = Base:subclass()
    function Derived:getString()
        _G.pcall(super.getString, self) -- throws & recovers immediately
        return super.getString(self, 'John')
    end

    local derived = Derived:new()
    _G.assertEquals(derived:getString(), 'Base:John')
end

----
--  Testing super(self) in tail call
function testSuperTailCall()
    local Base = Object:subclass()
    function Base:getAnyString()
        return 'Coco'
    end

    local Derived = Base:subclass()
    function Derived:getAnyString()
        return super.getAnyString(self)
    end

    local derived = Derived:new()
    _G.assertEquals(derived:getAnyString(), 'Coco')
end

----
--  Testing isMeta()
function testIsMeta()
   _G.assert(not Object:isMeta())
   _G.assert(not Class:isMeta())
   _G.assert(Object.class:isMeta())
   _G.assert(Class.class:isMeta())
   local Toto = Object:subclass()
   _G.assert(not Toto:isMeta())
   _G.assert(Toto.class:isMeta())
end

----
--  Multiple return values
function testMultipleReturnValues()
    local Toto = Object:subclass()
    function Toto:returnTwoValues()
        return 1, 2
    end

    local toto = Toto:new()
    a, b = toto:returnTwoValues()
    _G.assertEquals(a, 1)
    _G.assertEquals(b, 2)
end

----
--
function testCallingNonExistingMethodFails()
    local Titi = Object:subclass()
    local titi = Titi:new()
    _G.assertError(titi.aNonExistingMethod, titi)
end

----
--  Reading outside data
function testReadOutsideData()
    local toto = 1
    local Foo = Object:subclass()
    function Foo:readToto()
        _G.assertEquals(toto, 1)
    end

    local foo = Foo:new()
    foo:readToto()
end

----
--  Creating global data
function testCreateGlobalData()
    local Foo = Object:subclass()
    function Foo:createToto()
        toto = 2
    end

    local foo = Foo:new()
    foo:createToto()
    _G.assertEquals(toto, 2)
end

----
--  Testing named subclass in tail call
function testNamedSubclassInTailCall()
    return Object:subclass('NamedClass')
end

----
--  Testing named classes
function testClassName()
    local NamedClass = Object:subclass('NamedClass')
    _G.assertEquals(NamedClass:name(), 'NamedClass')
end

----
--  Testing scope
function testNamedAndAnonymClassScope()
    local assert = _G.assert
    local assertEquals = _G.assertEquals
    _G.setfenv(1, {})
    do
        local NamedClass = Object:subclass('NamedClass')
        local AnonymClass = Object:subclass()
    end

    assertEquals(NamedClass, nil)
    assertEquals(AnonymClass, nil)

    assert(nil ~= Class:find('NamedClass'))
    assertEquals(Class:find('AnonymClass'), nil)
end

----
--  Testing all Classes and class scope
function testAllClasses()
    (function()
         Object:subclass('NamedClass')
     end)()

    local classes = Class:all()

    _G.assertEquals(classes['objectlua.Object']:name(), 'objectlua.Object')
    _G.assertEquals(classes['objectlua.Object Metaclass']:name(), 'objectlua.Object Metaclass')

    _G.assertEquals(classes['objectlua.Class']:name(), 'objectlua.Class')
    _G.assertEquals(classes['objectlua.Class Metaclass']:name(), 'objectlua.Class Metaclass')

    _G.assertEquals(classes['NamedClass']:name(), 'NamedClass')
    _G.assertEquals(classes['NamedClass Metaclass']:name(), 'NamedClass Metaclass')
end

----
--  Testing requiring a class file
function testLoadAClassFromFile()
    local SomeClass = _G.require 'SomeClass'

    local someObject = SomeClass:new()
    _G.assertEquals(someObject:className(), 'SomeClass')
    _G.assert(someObject:itWorks())
    _G.assert(someObject:isWorking())
end

function testClassShadowedFails1()
    Object:subclass('SomeClass')
    _G.assertError(_G.require, 'SomeClass')
    _G.package.loaded.SomeClass = nil
end

function testClassShadowedFails2()
    _G.require 'SomeClass'
    _G.assertError(function()
                    Object:subclass('SomeClass')
                end)
end

function testGlobalName()
    local Toto = Object:subclass('tata.Toto')
    _G.assert(_G.tata)
    _G.assert(_G.tata.Toto)
end


function testHas()
    local Ball = Object:subclass('Ball')
    Ball:has('_color')

    local ball = Ball:new()
    ball:setColor('red')
    Ball:new():setColor('green')

    _G.assertEquals(ball:getColor(), 'red')
end

function testHasDefaultValue()
    local Ball = Object:subclass('Ball')
    Ball:has('_color', {default='red'})

    local ball = Ball:new()
    _G.assertEquals(ball:getColor(), 'red')

    ball:setColor('green')
    _G.assertEquals(ball:getColor(), 'green')
end

function testHasReadOnly()
    local Ball = Object:subclass('Ball')
    Ball:has('_color', {is='r', default='red'})

    local ball = Ball:new()

    _G.assertEquals(ball:getColor(), 'red')
    _G.assertEquals(ball.setColor, nil)
end

function testHasWriteOnly()
    local Ball = Object:subclass('Ball')
    Ball:has('_color', {is='w'})

    local ball = Ball:new()
    ball:setColor('red')

    _G.assertEquals(ball.getColor, nil)
    _G.assertEquals(ball._color, 'red')
end

function testHasUnderscoreInName()
    local Ball = Object:subclass('Ball')
    Ball:has('_color_1')
    Ball:has('_color_2')

    local ball = Ball:new()
    ball:setColor_1('red')

    _G.assertEquals(ball:getColor_1(), 'red')
end

function testHasBooleanAccessorWithoutGetPrefix()
    local Ball = Object:subclass('Ball')
    Ball:has('_isWorking', {is='rwb'})

    local ball = Ball:new()
    ball:setIsWorking(true)

    _G.assert(ball:isWorking())
end

function testHasInModule()
    local SomeClass = _G.require('SomeClass')
    local someObject = SomeClass:new()
    _G.assert(someObject:isWorking())
end
