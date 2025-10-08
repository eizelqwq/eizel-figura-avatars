
---(If any item is not desired, replace with "nil".)---

shiModel=nil --The base model (only used for leaning into turns when walking quickly)
shiLArm=models.model.root.Torso.LeftArm --LeftArm
shiRArm=models.model.root.Torso.RightArm --RightArm
shiLLeg=models.model.root.LeftLeg --LeftLeg
shiRLeg=models.model.root.RightLeg --RightLeg
shiBody=models.model.root.Torso --Body/torso (the pivot with the body arms and head in it)
shiNeck=models.model.root.Torso.Neck
shiHead=models.model.root.Torso.Neck.Head --Head
shiBodyXStrength=.6 --max rotation distance for the Body's X axis
shiBodyYStrength=.3 --max rotation distance for the Body's Y axis
shiLArmXStrength=.15 --max rotation distance for the LeftArm's X axis
shiRArmXStrength=.15 --max rotation distance for the RightArm's X axis
shiLLegZStrength=0 --max rotation distance for the LeftLeg's Z axis
shiRLegZStrength=0 --max rotation distance for the RightLeg's Z axis
shiNeckXStrength=.15 --max rotation distance for the Neck's X axis
shiNeckYStrength=.5 --max rotation distance for the Neck's y axis
shiHeadXStrength=.5 --max rotation distance for the Head's X axis
shiHeadYStrength=.5 --max rotation distance for the Head's y axis
shiRotTurnStiff=.1 --How quickly the player leans into turns
shiRotStiffX=.1 --how quickly the player leans on the X Axis
shiRotStiffY=.1 --how quickly the player leans on the Y Axis
shiBoatLean=false --lean to the sides whileturning in a boat
shiIdleSpeed=.07 --set this to 0 if you dont want the idle
shiIdleStrength=1 --set this to 0 if you dont want the idle
shiSpring=false --smoother/spring (T/F)
--spring variables init--
shiturnAngle=0
shiRotX=0
shiRotY=0
shiTurnDis=0
shiRotxDis=0
shiRotYDis=0
shiIdle = 0
function events.tick()
    shiIdle = shiIdle + (1 * shiIdleSpeed)
    local shiHeadOriginRotX=((vanilla_model.HEAD:getOriginRot()+180)%360-180).x
    local shiHeadOriginRotY=((vanilla_model.HEAD:getOriginRot()+180)%360-180).y
    if shiSpring == true then
        shiRotXDis = (shiRotX - shiHeadOriginRotX)
        shiRotX=shiRotX-shiRotStiffX*shiRotXDis
        shiRotYDis = (shiRotY - shiHeadOriginRotY)
        shiRotY=shiRotY-shiRotStiffY*shiRotYDis
    else
        shiRotX=shiHeadOriginRotX
        shiRotY=shiHeadOriginRotY
    end
end
function events.render()
    if shiLArm ~= nil then
        shiLArm:setRot((math.sin(shiIdle)*shiIdleStrength)-(shiRotX*shiLArmXStrength),0,-10)
    end
    if shiRArm ~= nil then
        shiRArm:setRot((math.sin(shiIdle)*shiIdleStrength)-(shiRotX*shiRArmXStrength),0,10)
    end
    if player:isCrouching() then
        if shiLLeg ~= nil then
            shiLLeg:setRot((shiRotY/16),(0),-(shiRotY*shiLLegZStrength))
            shiLLeg:setPos((shiRotY*shiLLegZStrength)/4,0,(shiRotY/90))
        end
        if shiRLeg ~= nil then
            shiRLeg:setRot(-(shiRotY/16),(0),-(shiRotY*shiRLegZStrength))
            shiRLeg:setPos((shiRotY*shiRLegZStrength)/4,0,-(shiRotY/90))
        end
    else
        if shiLLeg ~= nil then
            shiLLeg:setRot((shiRotY/14),(0),0)
            shiLLeg:setPos(0,0,(shiRotY/40))
        end
        if shiRLeg ~= nil then
            shiRLeg:setRot(-(shiRotY/14),(0),0)
            shiRLeg:setPos(0,0,-(shiRotY/60))
        end
    end
    if shiNeck ~= nil then
        if shiBody ~= nil then
            shiBody:setRot((math.sin(shiIdle)*shiIdleStrength)+(shiRotX*shiBodyXStrength)/3,(shiRotY*shiBodyYStrength),0)
        end
        if shiHead ~= nil then
            shiNeck:setRot((shiRotX*shiNeckXStrength)/2,(-shiRotY*shiNeckYStrength)/-3,0)
        end
        shiHead:setRot((shiRotX*shiHeadXStrength)/-2,(-shiRotY*(shiHeadYStrength*1.15)),0)
    else
        if shiBody ~= nil then
            shiBody:setRot((math.sin(shiIdle)*shiIdleStrength)+(shiRotX*shiBodyXStrength),(shiRotY*shiBodyYStrength),(shiRotY*(shiBodyYStrength/6)))
        end
        if shiHead ~= nil then
            shiHead:setRot((-shiRotX*shiHeadXStrength),(-shiRotY*shiHeadYStrength),(shiRotY*(shiHeadYStrength/9)))
        end
    end
end