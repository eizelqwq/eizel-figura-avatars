
local shiSkirt1=models.model.root.Torso.Body.GownSkirt --Skirt (the other parts branch off of this variable, if you named the bb parts the same as mine, then you only need to set this one up)
local shiSkirtFront={shiSkirt1.Front}--SkirtFront
local shiSkirtFrontCenter={shiSkirt1.Front.FrontCenter} --SkirtFrontCenter
local shiSkirtFrontLeft={shiSkirt1.Front.FrontLeft} --SkirtFrontRight
local shiSkirtFrontRight={shiSkirt1.Front.FrontRight} --SkirtFrontLeft
local shiSkirtBack={shiSkirt1.Back} --SkirtBack
local shiSkirtBackCenter={shiSkirt1.Back.BackCenter} --SkirtBackCenter
local shiSkirtBackLeft={shiSkirt1.Back.BackLeft} --SkirtBackRight
local shiSkirtBackRight={shiSkirt1.Back.BackRight} --SkirtBackLeft
local shiSkirtLeft={shiSkirt1.SkirtLeft} --Skirt left part
local shiSkirtRight={shiSkirt1.SkirtRight} --Skirt right part
local shiYDis=0
local shiVY=0
local shiVYStiffX=.1
function events.render()
    local shiVY_raw= math.clamp(((player:getVelocity().y)*60),-20,0)
    local shiLLegRot = vanilla_model.LEFT_LEG:getOriginRot().x
    local shiRLegRot = vanilla_model.RIGHT_LEG:getOriginRot().x
    local shiSkirtKick = shiLLegRot - shiRLegRot
    local shiSkirtKickABS = math.abs(shiSkirtKick)
    if not player:isGliding() then
        shiYDis=(shiVY-shiVY_raw)
        shiVY=math.clamp(shiVY-shiVYStiffX*shiYDis,-30,0)
    else
        shiVY=0
    end
    for _, part in pairs(shiSkirtFront) do
        part:setRot(math.clamp(shiSkirtKickABS,0,5)-shiVY,0,0)
    end
    for _, part in pairs(shiSkirtFrontCenter) do
        part:setRot((shiSkirtKickABS/4)-shiVY,-shiSkirtKick/15,-shiSkirtKick/10)
    end
    for _, part in pairs(shiSkirtFrontRight) do
        part:setRot((shiSkirtKickABS/5)-shiVY/2,shiSkirtKick/10,math.clamp(shiSkirtKick/8,0,90)-shiVY)
    end
    for _, part in pairs(shiSkirtFrontLeft) do
        part:setRot((shiSkirtKickABS/5)-shiVY/2,shiSkirtKick/10,math.clamp(shiSkirtKick/8,-90,0)+shiVY)
    end
    for _, part in pairs(shiSkirtBack) do
        part:setRot(-math.clamp(shiSkirtKickABS,0,5)+shiVY,0,0)
    end
    for _, part in pairs(shiSkirtBackCenter) do
        part:setRot((-shiSkirtKickABS/4)-shiVY,-shiSkirtKick/15,shiSkirtKick/10)
    end
    for _, part in pairs(shiSkirtBackRight) do
        part:setRot(-(shiSkirtKickABS/5)-shiVY/2,-shiSkirtKick/10,math.clamp(shiSkirtKick/8,0,90)-shiVY)
    end
    for _, part in pairs(shiSkirtBackLeft) do
        part:setRot(-(shiSkirtKickABS/5)-shiVY/2,-shiSkirtKick/10,math.clamp(shiSkirtKick/8,-90,0)+shiVY)
    end
    for _, part in pairs(shiSkirtRight) do
        part:setRot(0,-shiSkirtKick/10,-math.clamp(shiSkirtKickABS/8,-90,0)-shiVY)
    end
    for _, part in pairs(shiSkirtLeft) do
        part:setRot(0,-shiSkirtKick/10,math.clamp(shiSkirtKickABS/8,-90,0)+shiVY)
    end
    if player:isCrouching() then
        shiSkirt1:setRot(20,0,0)
    else
        shiSkirt1:setRot()
    end
end