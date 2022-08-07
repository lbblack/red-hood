local DrawSystem = tiny.processingSystem(class("DrawSystem"))
DrawSystem.isDrawSystem = true

DrawSystem.filter = tiny.requireAny("hitbox", "pos", "sprite")

function DrawSystem:init()
	local gamera = require("lib.gamera")
	self.cam = gamera.new(0,0, 1280, 720)
	self.cam:setScale(1.5, 1.5)
end

function DrawSystem:process(e, dt)
	self.cam:draw(function(l, t, w, h)
		if e.isObject then
			love.graphics.setColor(1, 1, 1, e.alpha or 0.5)
			love.graphics.rectangle("line", e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)

		-- draw player animations
		elseif e.isPlayer then
			self.cam:setPosition(e.pos.x, e.pos.y)
			love.graphics.setColor(1, 1, 1, e.alpha)
			-- love.graphics.rectangle("line", e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)
			-- love.graphics.rectangle("fill", e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)


			-- player animation
			-- most of these values are empirical lol
			local offy = 33
			local offx = {
				left = 0,
				right = 0
			}
			local offa = 23
			local offb = 41
			-- e.fall2Animation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, 0, 1, 1, 44, offy - 15)

			-- running animation
			if e.grounded and math.abs(e.vel.x) > 15 and not e.isLanding then
				if e.vel.x ~= 0 and e.runAnimation then
					-- running left
					if e.platforming.dir == 'l' then
						e.runAnimation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, 0, 1, 1, 22, offy - 15)
					-- running right
					else
						e.runAnimation:draw(e.sprite, e.pos.x + offx.right, e.pos.y, 0, -1, 1, 40, offy - 15)
					end
				end
			-- idle animation
			elseif e.grounded and math.abs(e.vel.x) <= 15 and not e.isLanding then
				if e.platforming.dir == 'l' then
					e.idleAnimation:draw(e.idleSprite, e.pos.x + offx.left, e.pos.y - offy, 0, -1, 1, 51)
				else
					e.idleAnimation:draw(e.idleSprite, e.pos.x + offx.right, e.pos.y - offy, 0, 1, 1, 32)
				end
			-- falling and jumping animation
			elseif not e.isWallsliding and not e.grounded and not e.isLanding then
				-- jumping
				if e.vel.y < 0 then
					if e.platforming.dir == 'l' then
						e.jumpAnimation:draw(e.sprite, e.pos.x + offx.right, e.pos.y, 0, 1, 1, offa, 20)
					else
						e.jumpAnimation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, 0, -1, 1, offb, 20)
					end
				-- falling from apex
				elseif e.vel.y < 75 and e.vel.y > -10 and not e.isLanding then
					if e.platforming.dir == 'l' then
						e.fall1Animation:draw(e.sprite, e.pos.x + offx.right, e.pos.y, 0, 1, 1, offa, 20)
					else
						e.fall1Animation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, 0, -1, 1, offb, 20)
					end
				-- falling faster
				elseif e.vel.y > 75 and not e.isLanding then
					if e.platforming.dir == 'l' then
						e.fall2Animation:draw(e.sprite, e.pos.x + offx.right, e.pos.y, 0, 1, 1, offa, 20)
					else
						e.fall2Animation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, 0, -1, 1, offb, 20)
					end
				end
			end

			-- wallsliding animation
			if e.isWallsliding and not e.isLanding then
				if e.platforming.dir == 'l' then
					e.wallslideAnimation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, math.pi / 2, -1, 1, 47, 46)
				else
					e.wallslideAnimation:draw(e.sprite, e.pos.x + offx.right, e.pos.y, -math.pi / 2, 1, 1, 47, 26)
				end
			end

			-- landing animation
			if e.isLanding then
				if e.platforming.dir == 'l' then
					e.landingAnimation:draw(e.sprite, e.pos.x + offx.right, e.pos.y, 0, 1, 1, offa, 20)
				else
					e.landingAnimation:draw(e.sprite, e.pos.x + offx.left, e.pos.y, 0, -1, 1, offb, 20)
				end
			end
		elseif e.isEnemy then
			-- love.graphics.rectangle("line", e.pos.x, e.pos.y, e.hitbox.w, e.hitbox.h)
			if not e.isAttacking then
				if math.abs(e.vel.x) < 20 then
					if e.dir == 'r' then
						e.idleAnimation:draw(e.idleSprite, e.pos.x, e.pos.y, 0, 1, 1, 70, 50)
					else
						e.idleAnimation:draw(e.idleSprite, e.pos.x, e.pos.y, 0, -1, 1, 90, 50)
					end
				else
					if e.dir == 'r' then
						e.walkAnimation:draw(e.walkSprite, e.pos.x, e.pos.y, 0, 1, 1, 70, 50)
					else
						e.walkAnimation:draw(e.walkSprite, e.pos.x, e.pos.y, 0, -1, 1, 90, 50)
					end
				end
			else
				if e.dir == 'r' then
					e.attackAnimation:draw(e.attackSprite, e.pos.x, e.pos.y, 0, 1, 1, 70, 50)
				else
					e.attackAnimation:draw(e.attackSprite, e.pos.x, e.pos.y, 0, -1, 1, 90, 50)
				end
			end
		end
	end)
end

return DrawSystem