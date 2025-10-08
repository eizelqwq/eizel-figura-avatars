-- HugsLib.lua 
-- Creators: Ninjas, Shiji, Benky

HugsLib = {}

-- Config
HugsLib.Enabled    = true   -- Toggle hugs
HugsLib.WL_Enabled = false   -- Use whitelist?
HugsLib.Whitelist  = {      -- Names of players allowed to hug you
    "Thestrangeninjas","Benky112","CommanderShiji","EmmyLuL"
} 

-- Internal state
HugsLib._hugging = false  -- Tracks if you're currently hugging or not

-- Functions
local function tbl_contains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

local keypressed = false

-- Main hugging logic 
function HugsLib:hugs(leftArm, rightArm)
    local shouldHug = false

    if HugsLib.Enabled then
        local target = player:getTargetedEntity(1.3)
        if target and target:isPlayer() and keypressed then
            local myName = player:getName()

            if HugsLib.WL_Enabled then
                local theirWL = target:getVariable("HugsWhitelist")
                local theirSettings = target:getVariable("HugsSettings")

                -- If they don't have HugsLib, just hug them
                if theirWL == nil or theirSettings == nil then
                    shouldHug = true

                elseif 
                    theirSettings.WL_Enabled == true            -- Checks if they have hugs on
                    and tbl_contains(theirWL, myName)  -- Checks if your name is on their list
                then

                    shouldHug = true
                end
            else
                -- If your whitelist is disabled, hug regardless (Because why not?)
                shouldHug = true
            end
        end
    end

    -- Apply or remove arm rotation only when needed
    if shouldHug and not HugsLib._hugging then
        leftArm:setRot(90, 0, -30)
        rightArm:setRot(90, 0,  30)  
        HugsLib._hugging = true

    elseif not shouldHug and HugsLib._hugging then
        leftArm:setRot(0, 0, -7.5)
        rightArm:setRot(0, 0, 7.5)
        HugsLib._hugging = false
    end
end

-- Run the Hugging Cycle and store setting in avatar Vars
function events.tick()
    avatar:store("HugsWhitelist", HugsLib.Whitelist)
    avatar:store("HugsSettings", {
        Enabled = HugsLib.Enabled,
        WL_Enabled = HugsLib.WL_Enabled
    })

    HugsLib:hugs(models.model.root.Torso.LeftArm, models.model.root.Torso.RightArm) --Replace Arms with your models
end

function pings.hug_k_press()
    keypressed = true
end

function pings.hug_k_release()
    keypressed = false
end


local Key = keybinds:newKeybind("Hug", "key.keyboard.h")
Key:onPress(function()    pings.hug_k_press()   end)
Key:onRelease(function()  pings.hug_k_release() end)
