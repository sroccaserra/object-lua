-- -*- compile-command: "rake" -*-

local Object = require 'objectlua.Object'

Object:subclass(...)
module(...)

_M:has('isWorking', {is='rb', default = true})

function itWorks()
    return true
end
