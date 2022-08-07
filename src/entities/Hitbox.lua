local Hitbox = class("Hitbox")

function Hitbox:init(args)
	self.w, self.h = args.w, args.h
end

function Hitbox:onCollide(e)
	-- print(e.isCollidable)
end

return Hitbox