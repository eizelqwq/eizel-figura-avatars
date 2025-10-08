--[[ Soma's note:
This is most likely best as a short-term solution, as a lot of this code can be shared by other things like outfits.
Which is why I made a (bad but working) library to make selectors super easily.

A good script would actually keep all host-side things inside the data folder (which my lib doesn't), to save space.
Another flaw of this system is that any other animation thing needs to be taken care of, and I can't be there
monitoring the avatar to prevent bugs and clashing animations in the future, so I just won't.

You should learn how to script, otherwise this is going to be a recurring issue. I usually don't write code for
others for this very reason, and all I can do is hope that it'll work out for you.
]]

local sitScript = {}


sitScript.action = nil -- Can be set here instead idk
sitScript.currentSitAnim = 1
sitScript.anims = {
    {anim = animations.model.SitLegsSpread, name = "Sit"},
    {anim = animations.model.SitLegsTogether, name = "Legs Together"},
    {anim = animations.model.SitLegsCrossed, name = "Legs Crossed"}
}

sitScript.isSitting = false

-- Preventing movement --
function sitScript.preventMovement() return sitScript.isSitting end

local forward = keybinds:fromVanilla("key.forward")
forward.press = sitScript.preventMovement

local back = keybinds:fromVanilla("key.back")
back.press = sitScript.preventMovement

local left = keybinds:fromVanilla("key.left")
left.press = sitScript.preventMovement

local right = keybinds:fromVanilla("key.right")
right.press = sitScript.preventMovement

local right = keybinds:fromVanilla("key.sneak")
right.press = sitScript.preventMovement

local right = keybinds:fromVanilla("key.jump")
right.press = sitScript.preventMovement


-- Sitting Pose --

-- This thing makes the whole sitting script a bit awkward, I have to work around that. But as a bonus, you can set the minecart sit anim
function events.tick()
    animations.model.SittingMounted:setPlaying(player:getVehicle() ~= nil and not sitScript.isSitting)
end

function pings.sit(state, animIndex) sitScript.sit(state, animIndex) end
function sitScript.sit(state, animIndex)
    local sitAnim = sitScript.anims[animIndex].anim
    sitAnim:setPlaying(state)
    renderer:setEyeOffset(0, -0.50, 0)

    sitScript.isSitting = state

    if state then
        sitAnim:setPlaying(true)
        renderer:setOffsetCameraPivot(0, -0.50, 0)
        renderer:setEyeOffset(0, -0.44, 0)
        sitScript.isSitting = true
    else
        sitAnim:setPlaying(false)
        renderer:setOffsetCameraPivot(0, 0, 0)
        renderer:setEyeOffset(0, 0, 0)
        sitScript.isSitting = false
    end

    sitScript.updateActionLabel(true)
end

function pings.sitCycle(animIndex) sitScript.sitCycle(animIndex) end
function sitScript.sitCycle(animIndex)
    local _animIndex = animIndex
    animIndex = (animIndex) % #sitScript.anims + 1

    sitScript.anims[animIndex].anim:setPlaying(sitScript.isSitting)
    sitScript.anims[_animIndex].anim:setPlaying(false)

    sitScript.currentSitAnim = animIndex

    sitScript.updateActionLabel(true)
end


-- Utility to quickly get the current animation
function sitScript.getCurrent()
    return sitScript.anims[sitScript.currentSitAnim]
end


-- A utility to raname the title in a consistent way
function sitScript.updateActionLabel(doSound)
    if not host:isHost() or sitScript.action == nil then return end

    if doSound and player:isLoaded() then
        sounds:playSound("minecraft:ui.button.click", player:getPos(), 1.0, 1.0, false)
    end

    local newTitle = "§lSitting Animation\n§r"..(sitScript.isSitting and " > " or "§o§7  ")
    newTitle = newTitle..(sitScript.getCurrent().name or ":p")

    sitScript.action:title(newTitle)
end


-- A utility to make sitting less  of a nightmare, it's still intuitive
function sitScript.sync(state, animIndex)
    sitScript.isSitting = state

    if animIndex == sitScript.animIndex then return end
    sitScript.animIndex = animIndex

    for index, anim in pairs(sitScript.anims) do
        anim.anim:setPlaying(state and animIndex == index)
    end
end

return sitScript
