local SkeletonAISystem = tiny.processingSystem(class("SkeletonAISystem"))

function SkeletonAISystem:init(target)
	self.target = target
end

SkeletonAISystem.filter = tiny.requireAll("ai", "isEnemy", "dir", "hit")

local function distance(x1, y1, x2, y2)
	return math.sqrt((x1 - y1) * (x1 - y1) + (x2 - y2) * (x2 - y2))
end

function SkeletonAISystem:process(e, dt)
	if e.hit then
		e.ai = "attack"
		e.takeHitAnimation:update(dt)
	end

	if e.ai == "attack" then
		if e.pos.x < self.target.pos.x then
			e.dir = 'r'
		else
			e.dir = 'l'
		end

		local enemyBuffer = 30
		if e.pos.x + e.hitbox.w + enemyBuffer < self.target.pos.x then
			e.vel.x = 200 * dt
		elseif e.pos.x - enemyBuffer > self.target.pos.x then
			e.vel.x = -200 * dt
		else
			e.vel.x = 0
		end
	end

	if e.ai == "attack" and 600 < distance(self.target.pos.x, self.target.pos.y, e.pos.x, e.pos.y) then
		e.ai = "idleWalk"
	end
end

return SkeletonAISystem