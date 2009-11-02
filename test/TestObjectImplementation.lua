-- -*- compile-command: "rake" -*-

require 'objectlua.init'

local Object = objectlua.Object
local Class  = objectlua.Class
local _G = _G

local id = 0
local function uniqueName()
    id = id + 1
    return 'name_'..tostring(id)
end

module(...)

function tearDown()
    Class.reset()
end

function testObjectModel()
    _G.assertEquals(_G.debug.getmetatable(Class), Class.class.__prototype__)
    _G.assertEquals(_G.debug.getmetatable(Class.class.__prototype__), Object.class.__prototype__)
    _G.assertEquals(_G.debug.getmetatable(Object.class), Class.__prototype__)
    _G.assertEquals(_G.debug.getmetatable(Class.__prototype__), Object.__prototype__)
end

function testClassMethods()
   local Foo = Object:subclass()
   function Foo.class:sayHello()
      return 'Hello'
   end

   _G.assertEquals(nil, Foo.class.sayHello)
   _G.assertEquals('function', _G.type(Foo.class.__prototype__.sayHello))
   _G.assertEquals('Hello', Foo:sayHello())
end

function testFenv()
    local function notFenved()
        _G.assert(toto ~= 1)
    end

    local function fenved()
        notFenved()
        return toto
    end

    _G.setfenv(fenved, _G.setmetatable({toto = 1}, {__index = _G}))
    _G.assertEquals(fenved(), 1)
end

function testUniqueName()
    _G.assert(uniqueName() ~= uniqueName())
end

function testFenvEqualsModule()
    local packageName = uniqueName()
    local moduleName = uniqueName()
    local fullName =  packageName..'.'..moduleName

    _G[fullName] = {}
    local package = {}
    _G[packageName] = package
    local module = {}
    package[moduleName] = module

    _G.module(fullName)
    local fenv = _G.getfenv(1)

    _G.assertEquals(module, fenv)
    _G.assertEquals(_M, fenv)
    _G.assert(_G[fullName] ~= fenv)

    _G.assertEquals(_PACKAGE, packageName..'.')
    _G.assertEquals(_NAME, fullName)
end

function testFenvEqualsModuleEqualsClassInClassDefinition()
    local packageName = 'party'
    local moduleName = 'Person'
    local fullName =  packageName..'.'..moduleName

    local Person = Object:subclass(fullName)

    _G.assertEquals(nil, _G[fullName])
    _G.assertEquals(nil, _G.package.loaded[fullName])
    _G.assertEquals(Person, _G[packageName][moduleName])
    _G.assertEquals(Person._M, Person)
    _G.assertEquals(Person._NAME, 'party.Person')
    _G.assertEquals(Person._PACKAGE, 'party.')
    _G.assertEquals(Person:name(), 'party.Person')
    _G.assertEquals(Person:shortName(), 'Person')

    _G.module(fullName)

    _G.assertEquals(nil, _G[fullName])
    _G.assertEquals(Person, _G[packageName][moduleName])
    _G.assertEquals(Person, _G.package.loaded[fullName])
    _G.assertEquals(Person, _G.getfenv())
    _G.assertEquals(Person, _M)

    _G.assertEquals(_NAME, fullName)
    _G.assertEquals(_PACKAGE, packageName..'.')
end
