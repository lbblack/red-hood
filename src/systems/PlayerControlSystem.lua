local PlayerControlSystem = tiny.processingSystem(class("PlayerControlSystem"))

PlayerControlSystem.filter = tiny.requireAll("controlable", "isPlayer")

landingTimer = {
	time = 0,
	max = 5 * 0.2
}

function PlayerControlSystem:process(e, dt)
	keyRight = "right"
	keyLeft  = "left"
	keyUp    = "up"
	keyDown  = "down"

	-- update each animation
	if e.grounded then
		e.runAnimation:update(dt)
		e.idleAnimation:update(dt)
	else
		e.jumpAnimation:update(dt)
		e.fall1Animation:update(dt)
		e.fall2Animation:update(dt)
		e.wallslideAnimation:update(dt)
	end

	if e.isLanding then
		e.landingAnimation:update(dt)
	end

	local keyDown = love.keyboard.isDown

	-- try attack
	if e.grounded then
		local attacktime = e.attackTimer.time
		local maxtime = e.attackTimer.maxTime
		if keyDown("space") and attacktime <= maxtime then
			e.isAttacking = true
			e.activeHitbox.active = true
		end
	end

	-- try to go right...
	if keyDown(keyRight) then
		if e.vel.x < 0 then
			e.vel.x = math.min(0,
							   e.vel.x + e.platforming.decel * dt)
		else
			e.vel.x = math.min(e.platforming.speed,
							   e.vel.x + e.platforming.accel * dt)
		end

		if e.isAttacking then
			e.vel.x = e.attackSpeed * dt
		end

		e.platforming.dir = 'r'
	-- try to go left...
	elseif keyDown(keyLeft) then
		-- if we're going the opposite direction of left
		if e.vel.x > 0 then
			-- apply deceleration to the left
			e.vel.x = math.max(0,
							   e.vel.x - e.platforming.decel * dt)
		-- otherwise...
		else
			-- set the velocity to acceleration to the left
			e.vel.x = math.max(e.vel.x - e.platforming.accel * dt, -e.platforming.speed)
		end

		if e.isAttacking then
			e.vel.x = -e.attackSpeed * dt
		end
		
		e.platforming.dir = 'l'
	end

	-- if e.isLanding and (keyDown(keyRight) or keyDown(keyLeft)) then
	-- 	if e.landingTimer.time > e.landingTimer.maxTime / 4 then
	-- 		e.isLanding = false
	-- 		e.landingTimer.time = e.landingTimer.maxTime - dt
	-- 	end
	-- end

	if e.isLanding then
		local landSpeed = 220
		if e.vel.x > landSpeed then
			e.vel.x = landSpeed
		elseif e.vel.x < -landSpeed then
			e.vel.x = -landSpeed
		end
	end

	-- apply friction if no horizontal movement detected
	if not keyDown(keyLeft) and not keyDown(keyRight) then
		local low = 15

		local friction = e.grounded and e.platforming.friction or e.platforming.airFriction
		if e.vel.x > low then
			e.vel.x = e.vel.x - friction * dt
		elseif e.vel.x < -low then
			e.vel.x = e.vel.x + friction * dt
		else
			e.vel.x = 0
		end
		e.moving = false
	end

	-- slide down wall slowly
	if e.isWallsliding then
		e.vel.y = math.min(e.wallslideSpeed, e.vel.y)
	end

	-- handle jumping
	if (e.grounded or e.isWallsliding) and (not e.isAttacking) and keyDown(keyUp) then
		e.vel.y = -e.platforming.jump
		-- e.isLanding = false

		e.landingTimer.count = 0
		e.landingTimer.time = 0
		e.landingAnimation:gotoFrame(1)

		-- if e.isWallsliding then
		-- 	if e.platforming.dir == 'l' then
		-- 		e.vel.x = 500
		-- 	else
		-- 		e.vel.x = -500
		-- 	end
		-- end
	end
end

return PlayerControlSystem