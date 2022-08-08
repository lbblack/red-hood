local Hitbox = class("Hitbox")

function Hitbox:init(args)
	self.w, self.h = args.w, args.h
	self.hostile = args.hostile or false
	self.active = args.active or false
end

function Hitbox:onCollide(e)
	-- print(e.isCollidable)
end

return Hitbox