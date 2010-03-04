--
-- Prototype-based Oop in Lua
--

module(..., package.seeall)

----
--  Primitive method

local function __getSuper__(parent, symbol)
    return function(...)
               return parent[symbol](...)
           end
end

local function __addSuper__(parent, symbol, method)
    local fenv = getfenv(method)
    setfenv(method, setmetatable({super = __getSuper__(parent, symbol)},
                                 {__index = fenv, __newindex = fenv}))
    return method
end

local function __newindex__(table, key, value)
    local proto = table.__prototype__
    if nil ~= proto and 'function' == type(value) then
        value = __addSuper__(proto, key, value)
    end
   rawset(table, key, value)
end

local function __delegated__(self)
    local t = setmetatable({}, self)
    rawset(t, '__prototype__', self)
    rawset(t, '__index', t)
    rawset(t, '__newindex', __newindex__)
    return t
end

----
--  Bootstraping...

Prototype = __delegated__()
Prototype.delegated = __delegated__

----
--

function Prototype:initialize()
    -- Override to suit your needs
end

function Prototype:prototype()
    return self.__prototype__
end

function Prototype:spawn(...)
    local t = self:delegated()
    t:initialize(...)
    return t
end

----
--  Done.

function Prototype:delegatesTo(object)
    if self.__prototype__ == object then
        return true
    end
    if nil == self.__prototype__ or nil == object then
        return false
    end

    return self.__prototype__:delegatesTo(object)
end

function Prototype:clone()
    local t = self:delegated()
    for k, v in pairs(self) do
        t[k] = v
    end
    return t
end

return Prototype
