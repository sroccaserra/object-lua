require 'objectlua.bootstrap'

local Object = objectlua.Object
local _G = _G
local classes = {}

module(...)

---
-- Private method

local function register(self, name)
    _G.assert('string' == _G.type(name))
    classes[name] = self
    -- Prepare the class to be used as a module. Since all class
    -- inherit from Class, and as a module, Class has an _M, a _NAME,
    -- and a _PACKAGE field, they need to be explicitely overriden in
    -- all subclasses (see implementation tests). And these fields are
    -- useful, they allow the class to describe itself in the "Lua
    -- module way".
    _G.rawset(self, '_M', self)
    _G.rawset(self, '_NAME', name)
    _G.rawset(self, '_PACKAGE', name:gsub('[^\.]+$', ''))
    _G.rawset(self:package(), self:shortName(), self)
end

----
--  Class public methods

function new(self, ...)
   local instance = self:basicNew()
   instance:initialize(...)
   return instance
end

function subclass(self, className)
   local metaclass = _M:new()
   metaclass:setSuperclass(self.class)
   metaclass:setAsMetaclass()
   local class = metaclass:new()
   class:setSuperclass(self)
   if 'string' == _G.type(className) then
       _G.assert(nil == self:find(className))
       register(class, className)
       register(metaclass, className..' Metaclass')
   end
   return class
end

function isMeta(self)
   return self.class == _M
end

function name(self)
    return self._NAME
end

function shortName(self)
    return self._NAME:gsub(self._PACKAGE, '')
end

function package(self)
    local name = self:name()
    local package = _G
    for packageName in name:gmatch('([^%.]*)%.') do
        if nil == package[packageName] then
            package[packageName] = {}
        end
        package = package[packageName]
    end
    return package
end

function inheritsFrom(self, class)
    if nil == self or Object == self then
        return false
    end
    local superclass = self.superclass
    if superclass == class then
        return true
    end
    return superclass:inheritsFrom(class)
end

local defaultOptions = {is='rw'}
function has(self, symbol, options)
    options = options or defaultOptions
    options.is = options.is or defaultOptions.is
    local functionName = symbol:match('[^%w]*(.*)')
    local capitalized = functionName:sub(1, 1):upper()..functionName:sub(2)
    local geterSymbol
    local isBoolean = options.is:find('b')
    if isBoolean then
        geterSymbol = functionName
    else
        geterSymbol = 'get'..capitalized
    end
    local seterSymbol = 'set'..capitalized

    _G.assert(nil == _G.rawget(self.__prototype__, geterSymbol))
    _G.assert(nil == _G.rawget(self.__prototype__, seterSymbol))

    local default = options.default
    if options.is:find('r') then
        _G.rawset(self.__prototype__, geterSymbol, function(self)
                                                       return self[symbol] or default
                                                   end)
    end

    if options.is:find('w') then
        _G.rawset(self.__prototype__, seterSymbol, function(self, value)
                                                       self[symbol] = value
                                                   end)
    end
end

function all()
    local t = {}
    for k, v in _G.pairs(classes) do
        t[k] = v
    end
    return t
end

function find(self, name)
    return classes[name]
end

function unregister(self)
    self:package()[self:shortName()] = nil
    if _G.package.loaded[self._NAME] == self then
        _G.package.loaded[self._NAME] = nil
    end
end


-- Note: calling reset() will unregister (and allow you to reload or
-- redefine) all user defined classes, but not the Object and Class
-- classes (and corresponding metaclasses).
function reset()
    for name, class in _G.pairs(classes) do
        if class:package() ~= _G.objectlua then
            class:unregister()
        end
    end

    classes = {}

    register(Object, 'objectlua.Object')
    register(_G.objectlua['Object Metaclass'], 'objectlua.Object Metaclass')
    register(_M, 'objectlua.Class')
    register(_G.objectlua['Class Metaclass'], 'objectlua.Class Metaclass')
end

_M.reset()
