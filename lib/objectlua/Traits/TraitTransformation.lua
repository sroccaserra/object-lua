--
--  The class TraitTransformation
--
local TraitComponent = require 'objectlua.Traits.TraitComponent'

module(...)

TraitTransformation = TraitComponent:subclass()

function TraitTransformation:initialize(component)
    self._component = component
end

function TraitTransformation:methods()
    self:requiredMethod()
end

function TraitTransformation:methodFor(key)
    self:requiredMethod()
end

function TraitTransformation:isOrContains(component)
    return self._component:isOrContains(component)
end

-- function TraitTransformation:subject(aTraitComposition)
--     self.subject = aTraitComposition
-- end

-- function TraitTransformation:trait()
--     return self.subject:trait()
-- end

-- function TraitTransformation:add()
-- end

-- function TraitTransformation:exclude()
--     error("Don't")
-- end

-- function TraitTransformation:alias()
-- end

-- function TraitTransformation.class:with(aTraitComposition)
--     local traitTransformation = self:new()
--     traitTransformation:subject(aTraitComposition)
--     return traitTransformation
-- end

return TraitTransformation
