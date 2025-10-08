 --123yeah_boi321's SQUASHSCRIPT
local heads = {}
local skull_model =     models.Plushie.plush.Skull2

local DURATION = 10

function events.world_tick()
	local count = 0
    for i,v in pairs(heads) do 
        count = count + 1
        v.stretch = v.stretch + 1
        if v.stretch >= DURATION then heads[i] = nil end
    end
	
end

--easing modified from GNTweenLib

function events.SKULL_RENDER(delta,block,item,entity,type)
    if type == "BLOCK" then
        for name,player in pairs(world.getPlayers()) do
            local target_block,hit_pos,side = player:getTargetedBlock()
            if player:getSwingTime() == 2 and target_block:getPos() == block:getPos() then
                sounds:playSound("entity.turtle.shamble_baby",block:getPos(),2,2)
                :volume(1)
                :pitch(1)
                heads[tostring(block:getPos())] = {stretch = 0}
            end
        end
        local head = heads[tostring(block:getPos())]
        if head then
            local stretch = outElastic(head.stretch+delta, 0.1, -0.1, DURATION, 1, 6)
            if block.id:find("wall") then
				stretch = stretch/2
                skull_model:setScale(1+stretch,1+stretch,1-stretch)
                skull_model:setPos(0,-stretch*4,stretch*4)
            else
                skull_model:setScale(1+stretch,1-stretch,1+stretch)
            end
        else
            skull_model:setScale(1)
			skull_model:setPos(0,0,0)
        end
    else
		if type == "HEAD" then
			skull_model:setPos(0,7,0)
			skull_model:setScale(1)
		else
			skull_model:setPos(0,0,0)
			skull_model:setScale(1)
		end
    end
end

-- time, begin, change, duration, aplitude, period

function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < math.abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * math.pi) * math.asin(c/a)
  end

  return a * math.pow(2, -10 * t) * math.sin((t * d - s) * (2 * math.pi) / p) + c + b
end

