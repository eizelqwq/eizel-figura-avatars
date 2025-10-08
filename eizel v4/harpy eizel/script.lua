toggle = false

----Eizel's script.lua----

--Config--/

vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.ARMOR:setVisible(true)
vanilla_model.HELMET:setVisible(true)
vanilla_model.BOOTS:setVisible(true)

--Hiding The Playerhead in First Person--/

function events.render(_,context)
    models.model.root.Torso.Neck:setVisible(not (renderer:isFirstPerson() and context == "OTHER"))
  end

--Nametag--/

local name = {
    {text = "Ei", color = "#913558"},
    {text = "ze", color = "#b74366"},
    {text = "l", color = "#c7677d"}
  }
  nameplate.LIST:setText(toJson(name))
  nameplate.ENTITY:setText(toJson({name, " ${badges} ", "\n"}))
  nameplate.CHAT:setText(toJson({
    text = "",
    extra = name,
    hoverEvent={
        action="show_text",
        contents={
          name,
          {text = "\n- music enjoyer‚ plays bass‚ still uses cds, listens to pusa‚ goodness, aerosmith‚ etc. - doesn't watch youtube or anything so probably won't have any idea what you're talking about", color = "#D3D3D3"}
        }
      }
  }))

-- inserted by nathan >:3
keybinds:fromVanilla"key.use".press = function() return true end
keybinds:fromVanilla"key.attack".press = function() return not player:getTargetedEntity() end
renderer:setBlockOutlineColor(0, 0, 0, 0)

-- Soma: If you have some issues with my stuff, make sure that these are here and that they're pointing to the right parts !
-- Making some shortcut global variables. Saves some typing and instructions I guess
ROOT = models.model.root
TORSO = ROOT.Torso
HEAD = TORSO.Neck.Head
BODY = TORSO.Body
LARM = TORSO.LeftArm
RARM = TORSO.RightArm
LLEG = ROOT.LeftLeg
RLEG = ROOT.RightLeg

----API Junk----/

---physBoneAPI---/

local physBone = require("physBoneAPI")

--physBone Hair--

function events.entity_init()
    physBone:newCollider(HEAD.ColliderHead)

    PhysBoneLeftBit = HEAD.Hair.PhysBoneLeftBit:newPhysBone("physBone"):setLength(12)
        :setNodeEnd(6)
        :setBounce(0.2)
        --:blacklistCollider("ColliderBack")
        :blacklistCollider("ColliderHead")
    PhysBoneRightBit = HEAD.Hair.PhysBoneRightBit:newPhysBone("physBone"):setLength(12)
        :setNodeEnd(6)
        :setBounce(0.2)
        --:blacklistCollider("ColliderBack")
        :blacklistCollider("ColliderHead")
    PhysBonePonytail = HEAD.PhysBonePonytail:newPhysBone("physBone"):setLength(16)
        :setAirResistance(0.3)
        --:setGravity(-20)
        :setNodeEnd(16)
        :setBounce(0.2)
        --:blacklistCollider("ColliderFront")
end
--

--KattArmour--/

--

---SquAPI---/

local squapi = require("SquAPI")

--SquAPI Bewbs--/

squapi.bewb:new(
    models.model.root.Torso.Body.Bewbs, --element
    0.55, --(2) bendability
    0.05, --(0.05) stiff
    0.9, --(0.9) bounce
    true, --(true) doIdle
    4, --(4) idleStrength
    1, --(1) idleSpeed
    -100, --(-10) downLimit
    100  --(25) upLimit
)

--SquAPI Eyes--/

squapi.eye:new(
    models.model.root.Torso.Neck.Head.Eyes.Irises.LeftIris.Iris,  --the eye element
    0,  --(0.25) left distance
    1,  --(1.25) right distance
    0,  --(0.0) up distance
    0   --(0.0) down distance
)

squapi.eye:new(
  models.model.root.Torso.Neck.Head.Eyes.Irises.RightIris.Iris,  --the eye element
    1,  --(0.25) left distance
    0,  --(1.25) right distance
    0,  --(0.0) up distance
    0   --(0.0) down distance
)

--SquAPI Blinking--/

squapi.randimation:new(
    animations.model.Blink,    --animation
    nil,    --(200) chanceRange
    nil     --(false) isBlink
)

--SquAPI Bounce--/

squapi.bounceWalk:new(
  models.model,   --model
  nil    --(1) bounceMultiplier
)

--SquAPI Ears--/

squapi.ear:new(
    models.model.root.Torso.Neck.Head.ElfEars.left_ear, --leftEar
    models.model.root.Torso.Neck.Head.ElfEars.right_ear, --(nil) rightEar
    1, --(1) rangeMultiplier
    true, --(false) horizontalEars
    0.5, --(2) bendStrength
    false, --(true) doEarFlick
    0, --(400) earFlickChance
    nil, --(0.1) earStiffness
    0.5  --(0.8) earBounce
)

----Action Wheel----/

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

local secondPage = action_wheel:newPage()
local thirdPage = action_wheel:newPage()
local fourthPage = action_wheel:newPage()

local toSecond = mainPage:newAction()
    :title("Armour Toggles")
    :item("netherite_chestplate")
    :onLeftClick(function()
    action_wheel:setPage(secondPage)
end)

local toMain = secondPage:newAction()
    :title("Main Page")
    :item("grass_block")
    :onLeftClick(function()
    action_wheel:setPage(mainPage)
    end)

local toThird = mainPage:newAction()
    :title("Outfits")
    :item("allium")
    :onLeftClick(function()
    action_wheel:setPage(thirdPage)
end)

local toMain = thirdPage:newAction()
    :title("Main Page")
    :item("grass_block")
    :onLeftClick(function()
    action_wheel:setPage(mainPage)
    end)

local toFourth = mainPage:newAction()
    :title("Emotes")
    :item("armor_stand")
    :onLeftClick(function()
    action_wheel:setPage(fourthPage)
end)

local toMain = fourthPage:newAction()
    :title("Main Page")
    :item("grass_block")
    :onLeftClick(function()
    action_wheel:setPage(mainPage)
    end)


--Outfit Manager by Somataru--/

local _currentOutfit = 2
local currentOutfit = 2

OutfitParts = {
    TORSO.Neck.Choker,
    HEAD.ElfEars.left_ear.EarringsL,
    HEAD.ElfEars.right_ear.EarringsR,
    BODY.Bewbs,
    BODY.Body,
    BODY.Jacket,
    LARM.LeftArm,
    LARM.LeftSleeve,
    LARM.LeftHand,
    RARM.RightArm,
    RARM.RightSleeve,
    RARM.RightHand,
    LLEG.LeftLeg,
    LLEG.LeftPants,
    LLEG.LeftFoot.LeftFoot,
    LLEG.LeftFoot.LeftShoe,
    RLEG.RightLeg,
    RLEG.RightPants,
    RLEG.RightLeg,
    RLEG.RightPants,
    RLEG.RightFoot.RightFoot,
    RLEG.RightFoot.RightShoe
}

-- Define accessories here, makes things cleaner
local zackyAccessories = {
    BODY.Bewbs.Bow,
}
local strawberryAccesories = {
    BODY.Bow,
}

-- Outfit list
OUTFIT_PREFIX = "textures."
ICON_PREFIX = "textures."

--[[
Here's where you can add outfits ! Everything else should be taken care of.
Doesn't use PickSomathing, but it's more or less the same format, so it should be straighforward.
Did a global, sue me.
--]]
Outfits = {
    {name="Eizel's Clothes", texture="outfit1", icon="icon1", accessories=nil},
    {name="Zacky's PJs", texture="outfit2", icon="icon2", accessories=nil},
    {name="Eizel's Strawberry Swimsuit", texture="outfit3", icon="icon3", accessories=strawberryAccesories},
}


function pings.setOutfit(outfit) SetOutfit(outfit) end
function SetOutfit(outfit)
    if outfit ~= nil and outfit > #Outfits then return end
    _currentOutfit = currentOutfit
    currentOutfit = outfit

    local indexCheck = 1
    local outfitInfo = Outfits[currentOutfit]

    for index, part in pairs(OutfitParts) do
        if indexCheck ~= index then
            if host:isHost() then print("§cOutfitPart #"..indexCheck.." to #"..(index-1).." are nil !") end
        end

        part:setPrimaryTexture("CUSTOM", textures[OUTFIT_PREFIX..outfitInfo.texture])
        indexCheck = index + 1
    end

    if Outfits[_currentOutfit].accessories then
        for index, part in pairs(Outfits[_currentOutfit].accessories) do
            part:setVisible(false)
        end
    end

    indexCheck = 1
    if outfitInfo.accessories then
        for index, part in pairs(outfitInfo.accessories) do
            if indexCheck ~= index then
                if host:isHost() then print("§cAccessory parts #"..indexCheck.." to #"..(index-1).." are nil !") end
            end

            part:setVisible(true)
            indexCheck = index + 1
        end
    end
end

--Auto-add the outfits to the action wheel--/

for i, outfit in ipairs(Outfits) do
    if Outfits[i].action == nil then
        local action = thirdPage:newAction()
            :title(outfit.name)
            :onLeftClick(function() pings.setOutfit(i) end)
        
        if outfit.icon and textures[ICON_PREFIX..outfit.icon] then
            action = action:texture(textures[ICON_PREFIX..outfit.icon])
        else
            action = action:item("minecraft:barrier")
        end

        Outfits[i].action = action
    end
end

---Toggling Armour Visibility---/

--

----Animations----/

local currentAnim = 0

local currentAnim = 0

Animations = {
  animations.model.ClubPenguinDance
}

function pings.setAnimation(animID) setAnimation(animID) end
function setAnimation(animID)
  currentAnim = animID

  for index, anim in pairs(Animations) do
    anim:setPlaying(index == animID)
  end
end

    function pings.toggling(state)
     pings.setAnimation(1)
    end

--Sitting Pose 1--/

local keybindState = false

function pings.sit(state)
  animations.model.sit:setPlaying(state)
  renderer:setEyeOffset(0, -0.50, 0)
  keybindState = state
  if state then
    animations.model.sit:setPlaying(true)
    renderer:setOffsetCameraPivot(0, -0.50, 0)
    renderer:setEyeOffset(0, -0.44, 0)
    keybindState = true
  else
    animations.model.sit:setPlaying(false)
    renderer:setOffsetCameraPivot(0, 0, 0)
    renderer:setEyeOffset(0, 0, 0)
    keybindState = false
  end
end

local forward = keybinds:fromVanilla("key.forward")
forward.press = function() return keybindState end

local back = keybinds:fromVanilla("key.back")
back.press = function() return keybindState end

local left = keybinds:fromVanilla("key.left")
left.press = function() return keybindState end

local right = keybinds:fromVanilla("key.right")
right.press = function() return keybindState end

local right = keybinds:fromVanilla("key.sneak")
right.press = function() return keybindState end

local right = keybinds:fromVanilla("key.jump")
right.press = function() return keybindState end

local toggleaction = fourthPage:newAction()
      :title("sit")
      :toggleTitle(":3")
      :item("dirt")
      :toggleItem("dirt")
      :setOnToggle(pings.sit)

----Actions----/

--Recieving Pats--/

function events.entity_pat(entity, ctx)
    if ctx ~= "UNPAT" then -- checks if it isnt "UNPAT", effectively meaning "PAT" or "WHILE_PAT"
      animations.model.boing:stop():play()
      sounds["entity.turtle.shamble_baby"]:pos(player:getPos()):play()
    end
  end

--Crawling--/

--

--Crouching--/

function events.render()
    crouching = player:getPose() == "CROUCHING"
    gliding = player:isGliding()
    animations.model.Crouching:setPlaying(crouching and not gliding)
end

--Crouching/Vertical Bounce--/

local wobblelib = require("lib.CMwubLib")
local bodyWobble = wobblelib:newWobbleSetup()

local isCrouching = false

function events.RENDER()
    if player:isLoaded() then
        bodyWobble:update(player:getVelocity().y,false)
        models.model.root:setScale(1 + bodyWobble.wobble*0.1,1 - bodyWobble.wobble*0.075,1 + bodyWobble.wobble*0.1)
        if player:isCrouching() and isCrouching == false then
            bodyWobble:setWobble(0.3,0.3,0.3)
            isCrouching = true
        elseif not player:isCrouching() and isCrouching == true then
            bodyWobble:setWobble(-0.3,-0.3,-0.3)
            isCrouching = false
        end
    end
end

--Hugging--/

local hugging = false
---@param target Player
function hug(target)
    if target == nil then return end
    if not target:getName() == "_Wicker" then
        if target:getVariable().ktzukii_noHugs == true then return end
    end
    
    if target:isSneaking() and target:getName() == "_Wicker" then return end
    if target:getVariable().MovementAPI or target:getVariable().movement then
        hugging = true
        animations.model.hugging:play()

        host:actionbar("Hugging target")
        events.tick:register(function()
            if hugging then
                if target:isSneaking() then
                    if target:getName() == "_Wicker" then return end
                    events.tick:remove("hug")
                    animations.model.hugging:stop()
                end

                if target:getVariable().movement then
                    target:getVariable().movement.setPos(
                        models.model.root.HugPivot:partToWorldMatrix():apply()
                        - vec(0, target:getBoundingBox().y / 2, 0)
                    )
                else
                    target:getVariable().MovementAPI.ThrowToPos(
                        models.model.root.HugPivot:partToWorldMatrix():apply()
                        - vec(0, target:getBoundingBox().y / 2, 0)
                    )
                end
            else
                events.tick:remove("hug")
                animations.model.hugging:stop()
            end
        end, "hug")
    else
        hugging = false
        animations.model.hugging:stop()
        host:setActionbar("Target does not have MovementAPI.. :(")
    end
end

function stop_hug()
  hugging = false
  events.tick:remove("hug")
  animations.model.hugging:stop()
end

avatar:store("huggingPlayer", nil)
function pings.hug(uuid)
    avatar:store("huggingPlayer", uuid)
    local target = world.getEntity(uuid)
    hug(target)
end
function pings.stop_hug()
    stop_hug()
    avatar:store("huggingPlayer", nil)
end

local hug = keybinds:newKeybind("hug", "key.keyboard.h", false)
hug.press = function()
  local target = player:getTargetedEntity(500)
  if target == nil then return end
  local uuid = target:getUUID()

  pings.hug(uuid)
end

local hug = keybinds:newKeybind("stop hug", "key.keyboard.j", false)
hug.press = function()
        pings.stop_hug()
    end

--Meowing--/

function events.chat_receive_message(raw)
    if raw:find("meow") then
        pings.meow()
    end
  end
  function pings.meow()
    if player:isLoaded(true) then
        sounds:playSound("minecraft:entity.cat.stray_ambient", player:getPos())
    end
  end

