local IdleWalkAISystem = tiny.processingSystem(class("IdleWalkAISystem"))

function IdleWalkAISystem:init()
	self.walkTimer = {
		time = 0,
		max = 0.5
	}

	self.idleTimer = {
		time = 0,
		max = 5
	}
end

IdleWalkAISystem.filter = tiny.requireAll('vel', 'pos', 'ai')

function IdleWalkAISystem:process(e, dt)
	if e.ai == "idleWalk" then
		if e.dir == 'r' then
			e.vel.x = e.speed
		elseif e.dir == 'l' then
			e.vel.x = -e.speed
		end
		e.walkAnimation:update(dt)

		local wt = self.walkTimer

		wt.time = wt.time + dt
		if wt.time > wt.max then
			e.dir = e.dir == 'r' and 'l' or 'r'
			wt.time = 0
			e.ai = "idle"
			e.vel.x = 0
		end
	elseif e.ai == "idle" then
		if e.isEnemy and e.idleSprite then
	        e.idleAnimation:update(dt)
	    end

	    local it = self.idleTimer
	    it.time = it.time + dt
	    if it.time > it.max then
	    	it.time = 0
	    	e.ai = "idleWalk"
	    end
	end

end

return IdleWalkAISystem