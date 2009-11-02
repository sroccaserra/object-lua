-- -*- compile-command: "rake" -*-

require 'objectlua'

local Object = objectlua.Object
local Trait  = objectlua.Trait

TestTraits = {}

function TestTraits:testUse()
   Trait:named('TNamed')
   function TNamed:getName()
      return self.name
   end
   function TNamed:setName(name)
      self.name = name
   end

   local Toto = Object:subclass()
   Toto:uses(TNamed)

   local toto = Toto:new()
   toto:setName('John')
   assertEquals('John', toto:getName())
end

function TestTraits:testMultipleUse()
   Trait:named('TNamed')
   function TNamed:isNamed()
      return true
   end

   Trait:named('TKnown')
   function TKnown:isKnown()
      return true
   end

   local Toto = Object:subclass()
   Toto:uses(TNamed, TKnown)

   local toto = Toto:new()
   assert(toto:isNamed())
   assert(toto:isKnown())
end

function TestTraits:testAddStateToTraitFails()
   Trait:named('TNamed')
   assertError(function()
                  TNamed.toto = 1
               end)
end

function TestTraits:testTraitUsingOtherTrait()
   Trait:named('TNamed')
   function TNamed:isNamed()
      return true
   end

   Trait:named('TKnown')
   TKnown:uses(TNamed)
   function TKnown:isKnown()
      return true
   end

   local Toto = Object:subclass()
   Toto:uses(TKnown)

   local toto = Toto:new()
   assert(toto:isNamed())
   assert(toto:isKnown())
end

function TestTraits:testInstanciationFails()
   Trait:named('TNamed')
   assertError(function()
                  TNamed:new()
               end)
end

function TestTraits:testChangeUsedTraitFails()
   Trait:named('TNamed')
   Object:subclass():uses(TNamed)
   assertError(function()
                  function TNamed:toto()
                  end
               end)
end

function TestTraits:testDoesUse()
   Trait:named('TNamed')
   local Toto = Object:subclass()
   Toto:uses(TNamed)
   assert(not Toto:doesUse(Trait))
   assert(Toto:doesUse(TNamed))
end

function TestTraits:testConflictFails()
   Trait:named('TOne')
   function TOne:equals(other)
      return 1 == other
   end
   Trait:named('TTwo')
   function TTwo:equals(other)
      return 2 == other
   end

   local Toto = Object:subclass()
   Toto:uses(TOne)
   assertError(function()
                  Toto:uses(TTwo)
               end)
end

function TestTraits:testAliasing()
   Trait:named('TOne')
   function TOne:equals(other)
      return 1 == other
   end
   local Toto = Object:subclass()
   Toto:uses(TOne:alias{equals = "equalsTOne"})
   local toto = Toto:new()
   assert(toto:equalsTOne(1))
   assertEquals(toto.equals, nil)
end

function TestTraits:testResolvedConflict()
   Trait:named('TOne')
   function TOne:equals(other)
      return 1 == other
   end
   Trait:named('TTwo')
   function TTwo:equals(other)
      return 2 == other
   end

   local Toto = Object:subclass()
   Toto:uses(TOne:alias{equals = "equalsTOne"},
         TTwo:alias{equals = "equalsTTwo"})
   function Toto:equals(other)
      return self:equalsTOne(other) or self:equalsTTwo(other)
   end

   local toto = Toto:new()
   assert(toto:equals(1))
   assert(toto:equals(2))
   assert(not toto:equals(3))
end

function TestTraits: testAliasedCallInsideTrait()
    Trait:named('TOne')
    function TOne:equals(other)
        return 1 == other
    end
    function TOne:notEquals(other)
        return not self:equals(other)
    end

    local Toto = Object:subclass()
    Toto:uses(TOne:alias{equals = "equalsTOne"})

    local toto = Toto:new()
    assert(toto:equals(1))
    assert(toto:notEquals(0))
end
