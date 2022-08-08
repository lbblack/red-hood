local ActiveHitboxSystem = tiny.processingSystem(class("ActiveHitboxSystem"))

ActiveHitboxSystem.filter = tiny.requireAll("hitbox", "pos")

function ActiveHitboxSystem:process(e, dt)
	if e.isAttacking and e.attackTimer.count < 1 and e.isPlayer then
		e.activeHitbox.active = true
		local x = e.platforming.x 
		local y = e.pos.y + 15

		e.attackTimer.time = e.attackTimer.time + dt
		if e.attackTimer.time >= e.attackTimer.maxTime then
			e.isAttacking = false
			e.attackTimer.time = 0
			e.attack1Animation:gotoFrame(1)
			e.activeHitbox.active = false
		end
	elseif not e.isAttacking and e.isPlayer then
		e.activeHitbox.active = false
	end

	if e.isEnemy and e.hit then
		-- e.takeHitAnimation:update(dt)
	end
end

return ActiveHitboxSystem