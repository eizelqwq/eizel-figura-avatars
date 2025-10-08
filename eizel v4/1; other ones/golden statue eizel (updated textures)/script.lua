toggle = false

----Eizel's script.lua----

--Config--/

vanilla_model.HELMET_ITEM:setVisible(true)
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.HELMET:setVisible(false)

--Nametag--/

local name = {
    {text = "", color = "#f5cc27"}
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

--Low Perms--/

if avatar:getPermissionLevel()=="LOW" then
    models.model.root:setVisible(false)
end
