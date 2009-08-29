--
-- Tested with Lua 5.1.3
--

local Prototype = require 'objectlua.Prototype'
local _G = _G

module(...)

----
--  Testing initialization & delegatesTo
function testInitializationAndDelegatesTo()
    local namedObject = Prototype:delegated()
    function namedObject:initialize(name)
        self.name = name
    end

    local person = namedObject:delegated()

    local bob = person:spawn('Bob')
    local john = person:spawn('John')

    _G.assertEquals(bob.name, 'Bob')
    _G.assertEquals(john.name, 'John')

    local otherJohn = john:delegated()
    _G.assertEquals(otherJohn.name, 'John')
    _G.assert(otherJohn:delegatesTo(Prototype))
    _G.assert(otherJohn:delegatesTo(john))
end

----
--  Testing clone
function testClone()
    local bob = Prototype:delegated()
    function bob:getName()
        return 'X'
    end

    local john = bob:clone()

    function bob:getName()
        return 'Bob'
    end

    _G.assertEquals(bob:getName(), 'Bob')
    _G.assertEquals(john:getName(), 'X')

end

----
--  Testing super
function testSuper()
    local base = Prototype:delegated()
    function base:getName()
        return 'Base'
    end
    local derived = base:delegated()
    function derived:getName()
        return super(self)..'>>Derived'
    end

    local john = derived:spawn()
    _G.assertEquals(john:getName(), 'Base>>Derived')
end
