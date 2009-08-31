require 'objectlua.bootstrap'
require 'objectlua.Class'

local _G = _G

module(...)

function initialize(self)
end

function isKindOf(self, class)
   return self.class == class or self.class:inheritsFrom(class)
end

function clone(self, object)
    local clone = self.class:basicNew()
    for k, v in _G.pairs(self) do
        clone[k] = v
    end
    return clone
end

function className(self)
    return self.class:name()
end

function subclassResponsibility(self)
    _G.error("Error: subclass responsibility.")
end
