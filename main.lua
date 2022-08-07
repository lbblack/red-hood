class = require "lib.30log"
tiny  = require "lib.tiny"
inspect   = require "lib.inspect"
gamestate = require "lib.gamestate"

local Level = require "src.states.Level"
local level, world

local drawSystem, updateSystem

function love.load()
	level = Level()
	level:load()

	drawSystem = tiny.requireAll("isDrawSystem")
	updateSystem = tiny.rejectAny("isDrawSystem")

	-- print(inspect(level.world))
end

function love.update(dt)
	
	if level.world then
 		tiny.update(level.world, dt, updateSystem)
	end

end

function love.draw()
	if level.world then
		tiny.update(level.world, dt, drawSystem)
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end

	if key == "r" then
		love.event.quit("restart")
	end
end
