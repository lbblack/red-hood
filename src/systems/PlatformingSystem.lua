local PlatformingSystem = tiny.processingSystem(class("PlatformingSystem"))

PlatformingSystem.filter = tiny.requireAll("vel", "gravity", "pos")

function PlatformingSystem:process(e, dt)
	if e.isObject then
		return
	end

	local gravity = e.gravity or 0
    e.vel.y = e.vel.y + gravity * dt
end

return PlatformingSystem