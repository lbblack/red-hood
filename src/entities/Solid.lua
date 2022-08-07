local Hitbox = require("src.entities.Hitbox")

local Solid = class("Solid")

function Solid:init(args)

	self.isObject = true

	self.pos = {
		x = args.x,
		y = args.y,
	}

	self.vel = {
		x = 0,
		y = 0
	}

	self.hitbox = Hitbox({w = args.w, h = args.h})
end

return Solid