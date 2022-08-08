local PlatformingSystem = tiny.processingSystem(class("PlatformingSystem"))

PlatformingSystem.filter = tiny.requireAll("vel", "gravity", "pos")

function PlatformingSystem:process(e, dt)
	if e.isObject then
		return
	end

	if e.isEnemy then
		local enemyLow = 20
		if e.hit and e.vel.x > enemyLow then
			e.vel.x = e.vel.x - 80 * dt
		elseif e.hit and e.vel.x < -enemyLow then
			e.vel.x = e.vel.x + 80 * dt
		else
			e.vel.x = 0
		end
	end

	local gravity = e.gravity or 0
    e.vel.y = e.vel.y + gravity * dt
end

return PlatformingSystem