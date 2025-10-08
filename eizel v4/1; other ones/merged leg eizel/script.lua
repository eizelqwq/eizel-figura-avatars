toggle = false

----Eizel's script.lua----

--Config--/

vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET:setVisible(true)
vanilla_model.BOOTS:setVisible(false)

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
          {text = "\n- music enjoyer‚ plays bass‚ still uses cds - doesn't watch youtube or anything so probably won't have any idea what you're talking about", color = "#D3D3D3"}
        }
      }
  }))

avatar:store("color", "#c7677d")

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

--KattArmour--/

local kattArmor = require("KattArmor")()

-- #REGION KATTARMOR
kattArmor.Armor.Helmet
-- the `addParts` function is not strict with the number of ModelParts provided. Add or remove parts as desired.
    :addParts(
      models.model.root.Torso.Neck.Head.Helmet,
      models.model.root.Torso.Neck.Head.Helmet
      .HelmetHat -- This is the helmet's secondary layer. Unused in vanilla, but usable with resource packs.
    )
-- trims need a seperate cube to correctly function, so they get registered seperatly.
    :addTrimParts(
      models.model.root.Torso.Neck.Head.Helmet.HelmetTrim,
      models.model.root.Torso.Neck.Head.Helmet.HelmetHatTrim
    )

kattArmor.Armor.Chestplate
    :addParts(
      models.model.root.Torso.Body.Chestplate,
      models.model.root.Torso.RightArm.RightChestplate.RightArmArmor,
      models.model.root.Torso.LeftArm.LeftChestplate.LeftArmArmor
    )
    :addTrimParts(
      models.model.root.Torso.Body.Chestplate.ChestplateTrim,
      models.model.root.Torso.RightArm.RightChestplate.RightArmArmorTrim,
      models.model.root.Torso.LeftArm.LeftChestplate.LeftArmArmorTrim
    )



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

---GSAnimBlend---/

require("GSAnimBlend")
animations.model.ShiBikeRide:setBlendTime(5)
animations.model.Crouching:setBlendTime(5)
animations.model.Hugging:setBlendTime(5)
animations.model.Blink:setBlendTime(5)
animations.model.SitLegsSpread:setBlendTime(5)
animations.model.SitLegsTogether:setBlendTime(5)
animations.model.SitLegsCrossed:setBlendTime(5)
animations.model.SitLegsSpread:setBlendTime(5)
animations.model.boing:setBlendTime(5)


----Action Wheel----/

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

local secondPage = action_wheel:newPage()
local thirdPage = action_wheel:newPage()
local fourthPage = action_wheel:newPage()

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


----Animations----/

--Sitting Pose 1--/

local sitScript = require("sittingcyclething")

-- Todo, move the action wheel action in there, can't be bothered remaking the whole action wheel too
sitScript.action = fourthPage:newAction()
      :title("§lSitting Animation -- UNUPDATED LABEL")
      :item("dirt")
      :toggleItem("dirt")
      :setOnToggle(function(state) pings.sit(state, sitScript.currentSitAnim) end)
      :onRightClick(function() pings.sitCycle(sitScript.currentSitAnim) end)

sitScript.updateActionLabel()

--Club Penguin Dance--/

function pings.clubAnimation(state)
    clubAnimation(state)
end
function clubAnimation(state)
    isClub = state
    animations.model.ClubPenguinDance:setPlaying(state)
end

local toMain = fourthPage:newAction()
    :title("Club Penguin Dance")
    :item("emerald")
    :toggleItem("minecraft:barrier")
    :setOnToggle(
        pings.clubAnimation
    )
    :toggled(isClub)

--Spooky Month Dance--/

function pings.spookyAnimation(state)
    spookyAnimation(state)
end
function spookyAnimation(state)
    isSpooky = state
    animations.model.SpookyMonthDance:setPlaying(state)
end

local toMain = fourthPage:newAction()
    :title("Spooky Month Dance")
    :item("pumpkin")
    :toggleItem("minecraft:barrier")
    :setOnToggle(
        pings.spookyAnimation
    )
    :toggled(isSpooky)


----Actions----/

--Toggling UwUSpeak--/

function events.chat_send_message(msg)
    if msg:find("/") then return msg end
    if not toggle then return msg end
    return uwuify(msg)
  end
  
  function toggleUwuify(state)
    toggle = state
  end
  
  local toggleaction = mainPage:newAction()
    :title("uwuify disabled")
    :toggleTitle("uwuify enabled")
    :item("red_wool")
    :toggleItem("green_wool")
    :setOnToggle(toggleUwuify)

--Recieving Pats--/

function events.entity_pat(entity, ctx)
    if ctx ~= "UNPAT" then -- checks if it isnt "UNPAT", effectively meaning "PAT" or "WHILE_PAT"
      animations.model.boing:stop():play()
      sounds["entity.turtle.shamble_baby"]:pos(player:getPos()):play()
    end
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
        animations.model.Hugging:play()

        host:actionbar("Hugging target")
        events.tick:register(function()
            if hugging then
                if target:isSneaking() then
                    if target:getName() == "_Wicker" then return end
                    events.tick:remove("hug")
                    animations.model.Hugging:stop()
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
                animations.model.Hugging:stop()
            end
        end, "hug")
    else
        hugging = false
        animations.model.Hugging:stop()
        host:setActionbar("Target does not have MovementAPI.. :(")
    end
end

function stop_hug()
  hugging = false
  events.tick:remove("hug")
  animations.model.Hugging:stop()
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

--Resyncs--/
function pings.resync(
        syncClub,
        syncSpooky,
        syncIsSitting, syncCurrentSitAnim,
        syncOutfit
    )
    isClub = syncClub
    clubAnimation(isClub)

    isSpooky = syncSpooky
    spookyAnimation(isSpooky)

    sitScript.sync(syncIsSitting, syncCurrentSitAnim)

    if syncOutfit ~= currentOutfit then SetOutfit(syncOutfit) end
end

function events.tick()
    if world.getTime() % 50 == 0 and not (host:isHost() and client:isPaused()) then
        pings.resync(
            isClub,
            isSpooky,
            sitScript.isSitting, sitScript.currentSitAnim,
            currentOutfit
        )
    end
end
