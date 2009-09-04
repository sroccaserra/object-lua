local _G = _G

module(...)

_G.objectlua = {}


---
-- Helper methods

local function delegated(t, prototype)
    if nil == _G.rawget(prototype, '__index') then
        _G.rawset(prototype, '__index', prototype)
        _G.rawset(prototype, '__metatable', 'private')
    end
    return _G.setmetatable(t, prototype)
end

local function addSuper(superclass, symbol, method)
    local fenv = _G.getfenv(method)
    return _G.setfenv(method, _G.setmetatable(
                          {super = superclass.__prototype__},
                          {__index = fenv, __newindex = fenv}))
end

local function redirectAssignmentToPrototype(t, k, v)
    local superclass = t.superclass
    if nil ~= superclass  and 'function' == _G.type(v) then
        v = addSuper(superclass, k, v)
    end
    local prototype = t.__prototype__
    _G.assert(nil ~= prototype)
    _G.rawset(prototype, k, v)
end


---
-- Class methods used in bootstraping

local function basicNew(self, instance)
    _G.assert(nil ~= self.__prototype__)
    instance = instance or {}
    delegated(instance, self.__prototype__)
    _G.rawset(instance, 'class', self)
    return instance
end

local function setSuperclass(self, class)
    _G.assert(nil ~= class.__prototype__)
    _G.rawset(self, 'superclass', class)
    _G.rawset(self, '__prototype__', delegated({}, class.__prototype__))
end

local function setAsMetaclass(self)
    _G.rawset(self.__prototype__, '__newindex',  redirectAssignmentToPrototype)
end

---
-- Bootstraping.
-- Basic ideas:
-- * Classes are objects
-- * All Metaclasses are instances of Class
-- * Any class is a (unique) instance of its Metaclass

-- Object prototype (end point of method lookups)
local objectPrototype = {}

-- Class is a subclass of Object (1/2)
local Class = {__prototype__ = delegated({}, objectPrototype)}
-- Class instances have the method basicNew, setSuperclass, and setAsMetaclass
Class.__prototype__.basicNew = basicNew
Class.__prototype__.setSuperclass = setSuperclass
Class.__prototype__.setAsMetaclass = setAsMetaclass

-- ObjectMetaclass is an instance of Class
local ObjectMetaclass = basicNew(Class)
-- ObjectMetaclass is a subclass of Class
ObjectMetaclass:setSuperclass(Class)

-- Object is an instance of ObjectMetaclass
local Object = ObjectMetaclass:basicNew({__prototype__ = objectPrototype})

-- Class is a subclass of Object (2/2)
_G.rawset(Class, 'superclass', Object)

-- ClassMetaclass is an instance of Class (crossed reference)
local ClassMetaclass = basicNew(Class)
-- ClassMetaclass is a subclass of ObjectMetaclass
ClassMetaclass:setSuperclass(ObjectMetaclass)

-- Class is an instance of ClassMetaclass (crossed reference)
ClassMetaclass.__prototype__.__index = ClassMetaclass.__prototype__
_G.setmetatable(Class, ClassMetaclass.__prototype__)
_G.rawset(Class, 'class', ClassMetaclass)

-- redirect assignments in instances to instance's class __prototype__
Class:setAsMetaclass()
ObjectMetaclass:setAsMetaclass()
ClassMetaclass:setAsMetaclass()

-- Put Class and Object in the module
_G.objectlua.Object = Object
_G.objectlua['Object Metaclass'] = ObjectMetaclass
_G.objectlua.Class = Class
_G.objectlua['Class Metaclass'] = ClassMetaclass
