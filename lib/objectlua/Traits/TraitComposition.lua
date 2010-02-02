--
--  The TraitComposition class
--

local TraitComponent = require 'objectlua.Traits.TraitComponent'

module(..., package.seeall)

TraitComposition = TraitComponent:subclass()

function TraitComposition:initialize()
    self.children = {}
end

function TraitComposition:methods()
    local methods = {}
    for child in pairs(self.children) do
        for k, v in pairs(child:methods()) do
            methods[k] = v
        end
    end
    return methods
end

function TraitComposition:add(...)
    local methods = self:methods()
    for _, child in pairs{...} do
        assert(child:isKindOf(TraitComponent))
        if not self:isOrContains(child) then
            for k, v in pairs(child:methods()) do
                if nil ~= methods[k] then
                    error("Error: conflicting function '"..k.."'.")
                end
            end
            self.children[child] = true
        end
    end
 end

function TraitComposition:doesUse(trait)
   return self.children[trait]
end

function TraitComposition:methodFor(key)
    return self:methods()[key]
end

function TraitComposition:isOrContains(component)
    for child in pairs(self.children) do
        if child:isOrContains(component) then
            return true
        end
    end
    return super(self, component)
end

-- function TraitComposition:methodsFor(aSymbol)
--     local methods = {}
--     for k, v in pairs(self.transformations) do
--        transformation:collectMethodsForSymbolInto(aSymbol, methods)
--     end
--     return methods
-- end

return TraitComposition
