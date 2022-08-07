local anim8 = require 'lib.anim8'

local Hitbox = require "src.entities.Hitbox"
local Player = class("Player")

function Player:init(args)
	self.pos = {
		x = args.x,
		y = args.y
	}
	self.vel = {x = 0, y = 0}
	self.platforming = {
		accel = 750,
		speed = 240,
		friction = 1200,
		airFriction = 400,
		decel = 800,
		dir = 'r',
		jump = 445
	}
	self.speed = 300
	self.controlable = true
	self.isAlive = true
	self.isPlayer = true
	self.isSolid = true
	self.checkCollisions = true
	self.grounded = false
	self.gravity = 700
	self.isLanding = false

	self.isWallsliding = false
	self.wallslideSpeed = 200

	self.isSliding = false

	self.landingTimer = {
		time = 0,
		maxTime = 0.75,
		count = 0
	}

	self.sprite = love.graphics.newImage("assets/red hood itch free.png")
	self.idleSprite = love.graphics.newImage("assets/idle sheet.png")

	self.sprite:setFilter("nearest", "nearest")
	self.idleSprite:setFilter("nearest", "nearest")
	-- print(self.sprite)
	local g = anim8.newGrid(64, 52, self.sprite:getWidth(), self.sprite:getHeight())
	self.runAnimation = anim8.newAnimation(g('2-22', 1), 0.05)
	self.jumpAnimation = anim8.newAnimation(g('36-42', 1), 0.15)
	self.fall1Animation = anim8.newAnimation(g('41-45', 1), 0.08)
	self.fall2Animation = anim8.newAnimation(g('46-48', 1), 0.12)
	self.landingAnimation = anim8.newAnimation(g('49-54', 1), 0.18)
	self.wallslideAnimation = anim8.newAnimation(g('56-60', 1), 0.18)
	self.slideAnimation = anim8.newAnimation(g('55-61', 1), 0.1)
	g = anim8.newGrid(64 + 16, 80, self.idleSprite:getWidth(), self.idleSprite:getHeight())
	self.idleAnimation = anim8.newAnimation(g('1-18', 1), 0.1)

	self.hitbox = Hitbox({w = 20, h = 25})

	self.maxHealth = 100
	self.health = self.maxhealth
end

return Player