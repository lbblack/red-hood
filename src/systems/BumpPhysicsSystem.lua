local BumpPhysicsSystem = tiny.processingSystem(class("BumpPhysicsSystem"))

function BumpPhysicsSystem:init(bumpWorld)
    self.bumpWorld = bumpWorld
end

BumpPhysicsSystem.filter = tiny.requireAll('hitbox', 'pos', 'vel')

local function collisionFilter(e1, e2)
    if e1.isPlayer then
        if e2.isEnemy then
            return 'cross'
        end
    end
    if e1.isEnemy then
        if e2.isPlayer then
            return 'cross'
        end
    end

    if e1.isObject or e2.isObject then
        return 'slide'
    end
end

function BumpPhysicsSystem:process(e, dt)
    if e.isObject then
        return
    end

    local pos = e.pos
    local vel = e.vel
    
    local cols, len
    pos.x, pos.y, cols, len = self.bumpWorld:move(e, pos.x + vel.x * dt,
                                                     pos.y + vel.y * dt,
                                                     collisionFilter)
    e.grounded = false
    e.isLanding = true

    if len == 0 then
        e.isWallsliding = false
        e.grounded = false
    end

    for i = 1, len do
        local col = cols[i]
        local collided = true
        if col.type == "touch" then
        elseif col.type == "slide" then
        end

        -- player collision
        if e.isPlayer and e.checkCollisions then
            if not col.other.isEnemy then
                e.isWallsliding = (e.isWallsliding or col.normal.x ~= 0)
            end
            -- if there is a collision 
            if col.normal.x ~= 0 then
                if not col.other.isEnemy then
                    e.vel.x = 0
                end
            end
            -- if there is a collision on the y axis
            if col.normal.y ~= 0 then
                e.grounded = col.normal.y == -1
                if not col.other.isEnemy then
                    e.vel.y = 0
                    e.isLanding = e.landingTimer.count == 0
                end
            elseif not col.other.isEnemy then
                e.grounded = false
                e.landingTimer.time = 0
                e.landingTimer.count = 0
            end

            -- mutate fall speed while wallsliding
            if e.isWallsliding and e.vel.y > 0 and not e.isEnemy then
                e.vel.y = math.min(e.wallslideSpeed, e.vel.y)
                if e.platforming.dir == 'l' then
                    e.vel.x = -200
                else
                    e.vel.x = 200
                end
            end
        end

        if e.grounded and e.isLanding then
            e.moving = false
            e.landingTimer.time = e.landingTimer.time + dt
            if e.landingTimer.time >= e.landingTimer.maxTime then
                e.landingTimer.time = 0
                e.isLanding = false
                e.landingTimer.count = e.landingTimer.count + 1
            end
        end
    end
end

function BumpPhysicsSystem:onAdd(e)
    local pos = e.pos
    local hitbox = e.hitbox

    self.bumpWorld:add(e, pos.x, pos.y, hitbox.w, hitbox.h)
end

function BumpPhysicsSystem:onRemove(e)
    self.bumpWorld:remove(e)
end

return BumpPhysicsSystem
