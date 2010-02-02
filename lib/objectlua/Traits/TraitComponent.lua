--
--  TraitComponent
--
local Object = require 'objectlua.Object'

module(...)

TraitComponent = Object:subclass()

function TraitComponent:methods()
    self:subclassResponsibility()
end

function TraitComponent:methodFor()
    self:subclassResponsibility()
end

function TraitComponent:isOrContains(component)
    return self == component
end

function TraitComponent:requiredMethod()
    error("Required method")
end

return TraitComponent
