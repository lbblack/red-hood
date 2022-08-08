local IdleWalkAISystem = tiny.processingSystem(class("IdleWalkAISystem"))

function IdleWalkAISystem:init()
	self.walkTimer = {
		time = 0,
		max = 1.5,
		count = 0
	}

	self.idleTimer = {
		time = 0,
		max = 2,
		count = 0
	}
end

IdleWalkAISystem.filter = tiny.requireAll('vel', 'pos', 'ai')

function IdleWalkAISystem:process(e, dt)
	if e.hit then
		return
	end

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
			wt.count = wt.count + 1
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
	    	it.count = it.count + 1
	    	e.ai = "idleWalk"

	    	if it.count > 2 then
	    		e.ai = "attack"
	    	end
	    end
	end

end

return IdleWalkAISystem