local bump = require("lib.bump")
local Level = class("Level")

local PlayerControlSystem = require("src.systems.PlayerControlSystem")
local DrawSystem = require ("src.systems.DrawSystem")
local BumpPhysicsSystem = require ('src.systems.BumpPhysicsSystem')
local PlatformingSystem = require("src.systems.PlatformingSystem")
local IdleWalkAISystem = require("src.systems.IdleWalkAISystem")
local UpdateSystem = require("src.systems.UpdateSystem")

function Level:init()
	self.world = nil
	print("Loaded level!")
end

function Level:load()
	local Player = require("src.entities.Player")
	local Skeleton = require("src.entities.Skeleton")
	local Solid  = require("src.entities.Solid")
	local world = tiny.world()

	world:addSystem(PlayerControlSystem())
	world:addSystem(DrawSystem())
	world:addSystem(BumpPhysicsSystem(bump.newWorld()))
	world:addSystem(PlatformingSystem())
	world:addSystem(IdleWalkAISystem())
	world:addSystem(UpdateSystem())
	world:addEntity(Player({x = 20, y = 100}))
	world:addEntity(Skeleton({x = 630, y = 300}))
	world:addEntity(Solid({x = 20, y = 500, w = 1000, h = 32}))
	world:addEntity(Solid({x = 600, y = 300, w = 80, h = 160}))

	world:addEntity(Solid({x = 600-200, y = 300 - 25, w = 150, h = 140}))

	self.world = world
end

function Level:onDestroy()
	tiny.clearEntities()
	tiny.clearSystems()
end

return Level