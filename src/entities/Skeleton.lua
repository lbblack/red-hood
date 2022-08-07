local Hitbox = require "src.entities.Hitbox"
local anim8 = require "lib.anim8"
local Skeleton = class("Skeleton")

function Skeleton:init(args)
	self.pos = {
		x = args.x,
		y = args.y
	}

	self.maxHealth = 100
	self.health = self.maxHealth

	self.vel = {
		x = 0,
		y = 0
	}
	self.gravity = 400
	self.speed = 25

	self.ai = "idleWalk"
	self.isAlive = true
	self.isSolid = true
	self.isEnemy = true

	self.isAttacking = false

	self.hitbox = Hitbox({w=20, h=50})
	self.dir = 'l'

	self.idleSprite = love.graphics.newImage("assets/Skeleton/Idle.png")
	self.idleSprite:setFilter("nearest", "nearest")
	local gIdle = anim8.newGrid(150, 150, self.idleSprite:getWidth(), self.idleSprite:getHeight())
	self.idleAnimation = anim8.newAnimation(gIdle('1-4', 1), 0.3)

	self.walkSprite = love.graphics.newImage("assets/Skeleton/Walk.png")
	self.walkSprite:setFilter("nearest", "nearest")
	local gWalk = anim8.newGrid(150, 150, self.walkSprite:getWidth(), self.walkSprite:getHeight())
	self.walkAnimation = anim8.newAnimation(gWalk('1-4', 1), 0.2)

	self.attackSprite = love.graphics.newImage("assets/Skeleton/Attack.png")
	self.attackSprite:setFilter("nearest", "nearest")
	local gAttack = anim8.newGrid(150, 150, self.attackSprite:getWidth(), self.attackSprite:getHeight())
	self.attackAnimation = anim8.newAnimation(gAttack('1-8', 1), 0.15)
end

return Skeleton