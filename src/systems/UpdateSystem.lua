local UpdateSystem = tiny.processingSystem(class("UpdateSystem"))

UpdateSystem.filter = tiny.requireAll("pos", "vel", "hitbox")

function UpdateSystem:process(e, dt)

	-- a lot of this is just for a landing animation
	if e.isPlayer then
		-- update anim8 animations
        if not e.grounded then
            e.isLanding = false

            e.landingAnimation:gotoFrame(1)
        	e.idleAnimation:gotoFrame(1)
        	e.runAnimation:gotoFrame(1)

            e.jumpAnimation:update(dt)
           	e.fall1Animation:update(dt)
           	e.fall2Animation:update(dt)
        	e.wallslideAnimation:update(dt)
        else
        	e.jumpAnimation:gotoFrame(1)
        	e.fall1Animation:gotoFrame(1)
        	e.fall2Animation:gotoFrame(1)

        	e.runAnimation:update(dt)
        	e.idleAnimation:update(dt)
        	e.landingAnimation:update(dt)

            if e.isAttacking then
                e.attack1Animation:update(dt)
            end
        end

        -- reset landing animation
        if e.isWallsliding or len == 0 then
            e.landingAnimation:gotoFrame(1)
            e.isLanding = false
            e.landingTimer.time = 0
            e.landingTimer.count = 0
        end

        if e.grounded then
            e.moving = false
            e.landingTimer.time = e.landingTimer.time + dt
            if e.landingTimer.time >= e.landingTimer.maxTime then
                e.landingTimer.time = 0
                e.isLanding = false
                e.landingTimer.count = e.landingTimer.count + 1
                e.landingAnimation:gotoFrame(1)
            end
        end

        -- misc player landing animation shenanagins
        if e.landingTimer.time == 0 and e.landingTimer.count == 0 then
            e.isLanding = e.grounded
        end
        -- print("Player = ", e.isLanding, e.landingTimer.time, e.landingTimer.count, e.grounded)

        -- mutate fall speed while wallsliding
        if e.isWallsliding and e.vel.y > 0 and not e.isEnemy then
            e.vel.y = math.min(e.wallslideSpeed, e.vel.y)
            if e.platforming.dir == 'l' then
                e.vel.x = -100
            else
                e.vel.x = 100
            end
        end

        if e.vel.y > -175 then
        	e.isWallsliding = e.isWallsliding
        else
        	e.isWallsliding = false
        end
    end

    if e.isAttacking and e.attackAnimation then
    	e.attackAnimation:update(dt)
    end
end

return UpdateSystem