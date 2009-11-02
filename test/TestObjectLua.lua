-- -*- compile-command: "rake" -*-

require 'luaunit'
require 'objectlua.init'

require 'TestObject'
require 'TestObjectImplementation'
require 'TestPrototype'

local result = LuaUnit:run()
if 0 ~= result then
    os.exit(1)
end

