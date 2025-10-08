local IMMUNITIES = {
    Movement = false,
    Charter = false
}
--- @class MovementAPI
local movement = {}
--- @class CharterIntegration
local CharterIntegration = {}
local page = {
    immunities = IMMUNITIES,
    movement = function (state, self)
        IMMUNITIES.Movement = state
        host:actionbar("§fMovement Immunity: " .. tostring(IMMUNITIES.Movement))
    end,
    charter = function (state, self)
        IMMUNITIES.Charter = state
        host:actionbar("§6Charter Immunity: " .. tostring(IMMUNITIES.Charter))
    end
}


---Divine Dominance's clamping of position. Creates the "stuck in the field" effect.
---@param c1 Vector3
---@param c2 Vector3
---@return boolean; return false to symbolize that you don't want this to happen. Any CI-compliant avatar will cancel upon returning false.
function CharterIntegration:DD_ClampPos(c1, c2)
    if IMMUNITIES.Charter or not player:isLoaded() then return false end
    local p = player:getPos()
    local newVec = vec(
        math.clamp(p.x, c1.x, c2.x),
        math.clamp(p.y, c1.y, c2.y),
        math.clamp(p.z, c1.z, c2.z)
    )
    if newVec ~= p then
        c1 = c1 + 0.01
        c2 = c2 - 0.01
        newVec = vec(
            math.clamp(p.x, c1.x, c2.x),
            math.clamp(p.y, c1.y+0.1, c2.y),
            math.clamp(p.z, c1.z, c2.z)
        )
        movement.SetPos(newVec)
        if p.y ~= newVec.y then
            movement.AddVelocity(0,0.1,0)
        end
    end



    return true
end

---Function that is called when the player is caught in the Divine Dominance's area of effect.
---@param attacker string
---@return boolean; return false to symbolize that you don't want this to happen. Any CI-compliant avatar will cancel upon returning false.
function CharterIntegration:DD_Collapse(attacker)
    if IMMUNITIES.Charter or not player:isLoaded() then return false end
    movement.AddVelocity(0,60,0)
    return true
end

---Function that is called when the player is hit by the Lesser Divinity
---@param attacker string
---@return boolean?; return false to symbolize that you don't want this to happen. Any CI-compliant avatar will cancel upon returning false.
function CharterIntegration:LD_Hit(attacker)
    if IMMUNITIES.Charter or not player:isLoaded() then return end
    movement.AddVelocity(0,60,0)
    return true
end

---Function that is called when the player is hit by the Broken Lesser Divinity
---@param attacker string
---@return boolean?; return false to symbolize that you don't want this to happen. Any CI-compliant avatar will cancel upon returning false.
function CharterIntegration:BLD_Hit(attacker)
    if IMMUNITIES.Charter or not player:isLoaded() then return end
    movement.AddVelocity(-30    ,30,0)
    return true
end

---Adds velocity to the player.
---@param x integer | Vector3 
---@param y integer?
---@param z integer?
function movement.AddVelocity(x, y, z)
    if IMMUNITIES.Movement or not player:isLoaded() then return end
    local velocity
    if type(x) == "number" then
        velocity = vec(x,y--[[@as number]],z--[[@as number]])
    else
        velocity = x
    end
    if host:isHost() and goofy then
        goofy:setVelocity((getActualPlayerVelocity() + velocity):clampLength(-60, 60)--[[@as Vector3]])
    end
end

---Adds velocity to the player.
---@param x integer | Vector3 
---@param y integer?
---@param z integer?
function movement.SetVelocity(x, y, z)
    if IMMUNITIES.Movement or not player:isLoaded() then return end
    local velocity
    if type(x) == "number" then
        velocity = vec(x,y--[[@as number]],z--[[@as number]])
    else
        velocity = x
    end
    if host:isHost() and goofy then
        goofy:setVelocity(velocity:clampLength(-60, 60))
    end
end

--- Sets the position of the player.
---@param x integer | Vector3 
---@param y integer?
---@param z integer?
function movement.SetPos(x, y, z)
    if IMMUNITIES.Movement or not player:isLoaded() then return end
    local pos
    if type(x) == "number" then
        pos = vec(x,y--[[@as number]],z--[[@as number]])
    else
        pos = x
    end
    if host:isHost() and goofy then
        goofy:setPos(pos)
    end
end


--- Sets the position of the player.
---@param x integer | Vector3 
---@param y integer?
---@param z integer?
function movement.ThrowToPos(x, y, z)
    if IMMUNITIES.Movement or not player:isLoaded() then return end
    local pos
    if type(x) == "number" then
        pos = vec(x,y--[[@as number]],z--[[@as number]])
    else
        pos = x
    end
    if host:isHost() and goofy then
        goofy:setVelocity((pos - player:getPos()):clampLength(-60, 60))
    end
end

function getActualPlayerVelocity()
    return vec(table.unpack(player:getNbt().Motion))
end
avatar:store("MovementAPI", movement) 
avatar:store("CharterIntegration", CharterIntegration)

return page
