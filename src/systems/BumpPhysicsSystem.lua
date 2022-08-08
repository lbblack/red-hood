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

    if len == 0 then
        if e.isPlayer then
            e.isWallsliding = false
            e.grounded = false
            e.isAttacking = false
        end

        if e.isEnemy then
            e.grounded = false
            e.hit = false
        end
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
                    e.isLanding = e.landingTimer.count == 0 and math.abs(e.vel.x) < e.platforming.speed * 0.4
                end
            elseif not col.other.isEnemy then
                e.grounded = false
                e.landingTimer.time = 0
                e.landingTimer.count = 0
            end
        end

        if e.isEnemy and col.other.isObject then
            if col.normal.x ~= 0 then
                e.vel.x = 0
            elseif col.normal.y ~= 0 then
                e.vel.y = 0
            end

            if col.other.activeHitbox then
                e.hit = col.other.activeHitbox.active
            end
        end
    end

    if e.isPlayer then
        local pos = e.pos
        local activeHitbox = e.activeHitbox

        local x = pos.x - activeHitbox.w + 5
        if e.platforming.dir == 'r' then
            x = pos.x + e.hitbox.w - 5
        end

        local items, len = self.bumpWorld:queryRect(x,
                                                    pos.y + 12,
                                                    activeHitbox.w,
                                                    activeHitbox.h)

        for i = 1, len do
            local item = items[i]

            if item.isEnemy and activeHitbox.active and activeHitbox.hostile then
                if x < pos.x then
                    item.vel.x = -20
                    item.dir = 'r'
                else
                    item.vel.x = 20
                    item.dir = 'l'
                end

                if ((item.dir == 'l' and e.platforming.dir == 'r') or
                    (item.dir == 'r' and e.platforming.dir == 'l')) and item.ai ~= "shield" then
                    item.hit = true
                else
                    item.hit = false
                end
            elseif item.isEnemy and not activeHitbox.active then
                item.hit = false
            end
        end
    end

    if e.isEnemy then

        -- detecting for player hit
        local items, len1 = self.bumpWorld:queryRect(e.pos.x - 75, e.pos.y, 75, e.hitbox.h)
        for i = 1, len1 do
            local item = items[i]

            if item.isPlayer then
                if item.isAttacking then
                    if not (e.dir == 'l' and item.platforming.dir == 'r') and
                       not (e.dir == 'r' and item.platforming.dir == 'l') then
                        e.hit = false
                    end
                end

                if not item.activeHitbox.active then
                    e.hit = false
                end
            end
        end

        items, len2 = self.bumpWorld:queryRect(e.pos.x + e.hitbox.w, e.pos.y, 75, e.hitbox.h)
        for i = 1, len2 do
            local item = items[i]

            if item.isPlayer then
                if item.isAttacking then
                    if not (e.dir == 'l' and item.platforming.dir == 'r') and
                       not (e.dir == 'r' and item.platforming.dir == 'l') then
                        e.hit = false
                    end
                end

                if not item.activeHitbox.active then
                    e.hit = false
                end
            end
        end

        if len1 == 0 and len2 == 0 then
            e.hit = false
        end

        if e.isAttacking then

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
