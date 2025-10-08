-------------------------------------------------------------------------------------------------------------
---Animation to reposition the player on the bike, without this the player will be at the same position as z when on the bike---
shiReposPlayer=animations.model.ShiBikeRide
-------------------------------------------------------------------------------------------------------------
---VECTORS---

local bikeY=0
local bikeTurn=0

local _bikeY = 0
local _bikeTurn = 0


local bikeStiffY=.1
local bikeYDis= 0
local bikeTurnStiff=.1
local bikeTurnDis=0
local turnDirec=0

local vehicle = nil
local riderIsShiji = false
local isBike = false
local boatRider1 = nil

local BoatRot = nil
local BoatRotInRadians = nil
local normalX = 0
local normalY = 0
local VelocityN = vec(0, 0, 0)

local _normalX = 0
local _normalY = 0

local pitch = 0
local yaw = 0

function events.tick()
    if player:isLoaded(true) then
        vehicle=player:getVehicle("minecraft:boat")
        if vehicle then
            boatRider1=vehicle:getPassengers()[1]
            TurnDir = boatRider1:getVariable("turndirection",TurnDir)
            if TurnDir ~= nil then
                _bikeY = bikeY
                _bikeTurn = bikeTurn

                bikeYDis=(bikeY-player:getVelocity().y)
                bikeY=bikeY-bikeStiffY*bikeYDis
                bikeTurnDis=(bikeTurn-(TurnDir*320))
                bikeTurn=bikeY-bikeTurnStiff*bikeTurnDis
            end

            riderIsShiji = boatRider1:getVariable().isshiji

            if riderIsShiji then
                isBike = boatRider1:getVariable("shibikestate",isBike)
                if isBike then
                    nameplate.entity:setVisible(false)
                    shiReposPlayer:play()
                    renderer:setRootRotationAllowed(false)

                    BoatRot=-vehicle:getRot().y
                    BoatRotInRadians = math.rad(BoatRot)

                    _normalX = normalX
                    _normalY = normalY
                    normalX = math.cos(BoatRotInRadians)
                    normalY = math.sin(BoatRotInRadians)
                end
            end
        end
    end
end
-------------------------------------------------------------------------------------------------------------
---pos---
function events.render(delta)
    if player:isLoaded(true) then
        vehicle=player:getVehicle("minecraft:boat")
        if vehicle and riderIsShiji and boatRider1 and isBike then
            pitch = vehicle:getPassengers()[1]:getVariable("shipitch",pitch)
            yaw = vehicle:getPassengers()[1]:getVariable("shiyaw",yaw)
            if yaw == 0 and pitch == 0 then
                print(pitch,yaw)
            end
            models.model:setRot(-math.deg(pitch)/1.5,math.deg(yaw)+180, 0)

            local nx = math.lerp(_normalX, normalX, delta)
            local ny = math.lerp(_normalY, normalY, delta)
            models.model:setPos(ny*13.625,0,nx*13.625)
            local bt = math.lerp(_bikeTurn, bikeTurn, delta)
            local by = math.lerp(_bikeY, bikeY, delta)
            models.model.root:setPos(math.clamp(bt/200,-2,2),(-by*4)+11,-1)
            models.model.root:setRot(0,0,math.clamp(bt*1.5,-30,30))
        else
            nameplate.entity:setVisible(true)
            isBike = false
            shiReposPlayer:stop()
            renderer:setRootRotationAllowed(true)
            renderer:setRenderVehicle(true)
            models.model.root:setRot()
            models.model.root:setPos()
            models.model:setRot()
            models.model:setPos()
        end
    end
end
