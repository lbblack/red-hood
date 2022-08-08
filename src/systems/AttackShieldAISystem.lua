local AttackShieldAISystem = tiny.processingSystem(class("AttackShieldAISystem"))

AttackShieldAISystem.filter = tiny.requireAll("isEnemy")

function AttackShieldAISystem:init(target)
	self.target = target or false

	self.attackTimer = {
		time = 0,
		max = 2
	}

	self.waitTimer = {
		time = 0,
		max = love.math.random(0, 30) / 10
	}

	self.shieldTimer = {
		time = 0,
		max = 3
	}
end

local function distance(x1, y1, x2, y2)
	return math.sqrt((x1 - y1) * (x1 - y1) + (x2 - y2) * (x2 - y2))
end

AttackShieldAISystem.filter = tiny.requireAll("ai", "isAttacking", "isShielding", "isEnemy")

function AttackShieldAISystem:process(e, dt)
	if e.hit then
		return
	end

	self.isAttacking = false

	if e.ai == "attack" then
		-- print("ATTACKING")
		e.attackAnimation:update(dt)

		-- damage the player under enemy attack
		if self.target then
			if self.target.isPlayer then
				self.isAttacking = true
			end
		end

		self.attackTimer.time = self.attackTimer.time + dt
		if self.attackTimer.time >= self.attackTimer.max then
			self.attackTimer.time = 0
			e.ai = "shield"
		end
	elseif e.ai == "shield" then
		-- print("SHIELDING")
		e.shieldAnimation:update(dt)

		self.shieldTimer.time = self.shieldTimer.time + dt
		if self.shieldTimer.time >= self.shieldTimer.max then
			self.shieldTimer.time = 0
			e.ai = "attack"
		end
	end
end

return AttackShieldAISystem