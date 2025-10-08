--  _                                   _   
-- | |_ _ __ _   _ _ __ ___  _ __   ___| |_ 
-- | __| '__| | | | '_ ` _ \| '_ \ / _ \ __|
-- | |_| |  | |_| | | | | | | |_) |  __/ |_ 
--  \__|_|   \__,_|_| |_| |_| .__/ \___|\__|
--                          |_|             

-- Author: Dogeiscut
-- Discord tag: @dogeiscut

-- Version: 0.1.0 

-- Description: Allows you to play a trumpet by renaming a spyglass

-- TODO: Fix off hand trumpet playing
-- TODO: Config: Root model, showing action wheel things.
-- TODO: Changing scale.
local function findTrumpetPivots(path, pivots)
    local pivots = pivots or {}
	for _,part in pairs(path:getChildren()) do
		local ID = part:getName()
		if ID:sub(0,#"TrumpetPivot") == "TrumpetPivot" then
			table.insert(pivots, part)
		end
		findTrumpetPivots(part, pivots)
	end
    return pivots
end
local function findRightSpyglassPivots(path, pivots)
    local pivots = pivots or {}
	for _,part in pairs(path:getChildren()) do
		local ID = part:getName()
		if ID:sub(0,#"RightSpyglassPivot") == "RightSpyglassPivot" then
			table.insert(pivots, part)
		end
		findRightSpyglassPivots(part, pivots)
	end
    return pivots
end
local function findLeftSpyglassPivots(path, pivots)
    local pivots = pivots or {}
	for _,part in pairs(path:getChildren()) do
		local ID = part:getName()
		if ID:sub(0,#"LeftSpyglassPivot") == "LeftSpyglassPivot" then
			table.insert(pivots, part)
		end
		findLeftSpyglassPivots(part, pivots)
	end
    return pivots
end

local trumpetPivots = findTrumpetPivots(models.model)
local leftPivots = findLeftSpyglassPivots(models.model)
local rightPivots = findRightSpyglassPivots(models.model)

local trumpetVolume = 0.1
local trumpetTargetVolume = 0.1

assert(#trumpetPivots>0, "No TrumpetPivot found! Add one to your avatar's mouth/head to use Trumpet.")

-- theres so many edge cases here im gonna kms
local true_left = false
function events.item_render(item, mode, pos, rot, scale, left)
    if not player:isLoaded() then return end
    
    for _,pivot in pairs(trumpetPivots) do
        pivot:setParentType("None")
    end
    for _,pivot in pairs(leftPivots) do
        pivot:setParentType("LeftSpyglassPivot")
    end
    for _,pivot in pairs(rightPivots) do
        pivot:setParentType("RightSpyglassPivot")
    end
    if item.id == "minecraft:spyglass" and item:getName() == "Trumpet" then
        for _,pivot in pairs(trumpetPivots) do
            pivot:setParentType((true_left and ("LeftSpyglassPivot") or ("RightSpyglassPivot")))
        end

        if left then
            for _,pivot in pairs(leftPivots) do
                pivot:setParentType("None")
            end
        else
            for _,pivot in pairs(rightPivots) do
                pivot:setParentType("None")
            end
        end

        models.Trumpet.trumpet.ItemTrumpet.origin:setRot(0,0,0)
        models.Trumpet.trumpet.ItemTrumpet.origin:setPos(1,4,0)
        local model = models.Trumpet.trumpet.ItemTrumpet:setPos(pos):setRot(rot):setScale(scale)
        if mode == "HEAD" then
            --model:setPos(0,0,0)
            models.Trumpet.trumpet.ItemTrumpet.origin:setPos(0,0,-3.5)
            models.Trumpet.trumpet.ItemTrumpet.origin:setRot(90,0,-90)
        else
            true_left = left
        end
        return model
    end
end

local scales = {
    full = {}, -- Chromatic scale (all notes valid)
    major = {0, 2, 4, 5, 7, 9, 11}, -- Major scale
    minor = {0, 2, 3, 5, 7, 8, 10}, -- Natural minor scale
    pentatonic = {0, 2, 4, 7, 9}, -- Major pentatonic scale
    blues = {0, 3, 5, 6, 7, 10} -- Blues scale
  }

local function calculatePitch(scale)
    local intervals = scale
    local function snap_to_pentatonic(note)
        if #intervals == 0 then return note end
        local octave = math.floor(note / 12)
        local relative_note = note % 12
        local closest = intervals[1]
        local min_diff = math.abs(relative_note - closest)
        for _, interval in ipairs(intervals) do
            local diff = math.abs(relative_note - interval)
            if diff < min_diff then
                min_diff = diff
                closest = interval
            end
        end
        return octave * 12 + closest
    end

    local minFreq = 0.5
    local maxFreq = 2
    local freq = ((-player:getRot().x + 90) / 180) * (maxFreq - minFreq) + minFreq
    local closest_note = math.floor(math.log(freq) / math.log(2) * 12 + 0.5)
    local pentatonic_note = snap_to_pentatonic(closest_note)
    local rounded_freq = 2 ^ (pentatonic_note / 12)
    return rounded_freq
end

function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, cat, path)
    if not path then return end
    if not player:isLoaded() then return end
    local handedness = player:isLeftHanded()
    local rightItem = player:getHeldItem(handedness)
    local leftItem = player:getHeldItem(not handedness)
    local holding_trumpet = (rightItem.id == "minecraft:spyglass" and rightItem:getName() == "Trumpet") or (leftItem.id == "minecraft:spyglass" and leftItem:getName() == "Trumpet")
    if (player:getPos() - pos):length() > 0.25 then return end
    if id:find(".spyglass.use") and holding_trumpet then
        pings.playTrumpet(calculatePitch(scales.major))
        return true
    elseif id:find(".spyglass") and holding_trumpet then
        pings.stopTrumpet()
        return true
    end
  end

local trumpet_sound = sounds["Trumpet.trumpet"]:setSubtitle("Trumpet toots"):setAttenuation(2):setVolume(1)
function events.tick()
    trumpet_sound:setVolume(trumpetVolume):setPos(player:getPos())
    trumpetVolume = math.lerp(trumpetVolume, trumpetTargetVolume, 0.6)
end

function pings.playTrumpet(pitch)
    if player:isLoaded() then
        trumpetVolume = 1
        trumpetTargetVolume = 1
        trumpet_sound:stop()
        trumpet_sound:setVolume(trumpetVolume):setPitch(pitch):setPos(player:getPos()):play()
        for _,pivot in pairs(trumpetPivots) do
            particles:newParticle("note", pivot:partToWorldMatrix()[4].xyz + (vec(pivot:partToWorldMatrix()[3].x*-14,pivot:partToWorldMatrix()[3].y*-14,pivot:partToWorldMatrix()[3].z*-14)), vec(pitch,pitch,pitch))
        end
    end
end

function pings.stopTrumpet()
    if player:isLoaded() then
        trumpetTargetVolume = 0
    end
end