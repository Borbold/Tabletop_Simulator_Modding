local CameraFollow = [[
local offsetHeight, offsetFront, offsetBackwards, offsetRotate = 2, 0, 0, 0

local lookScreenIndex = 1
local exitScreenIndex = 10

local upIndex = 6
local leftIndex = 8
local downIndex = 4
local rightIndex = 5
local jumpIndex = 3

local up = false
local left = false
local down = false
local right = false
local jump = false

local canJump = false

function UpdateSave()
    local dataToSave = {
        ["offsetHeight"] = offsetHeight,
        ["offsetFront"] = offsetFront,
        ["offsetBackwards"] = offsetBackwards
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    local loadedData = JSON.decode(savedData or "")
    if loadedData then
        offsetHeight = loadedData.offsetHeight or offsetHeight
        offsetFront = loadedData.offsetFront or offsetFront
        offsetBackwards = loadedData.offsetBackwards or offsetBackwards
    end

    controllingPlayerColor, prevCPC = nil, nil
    moveSpeed, forceJump = 5, 5
    rotateY = 0
    self.addContextMenuItem("Set Camera", SetCamera)
    self.addContextMenuItem("UpHeight", UpHeight, true)
    self.addContextMenuItem("DownHeight", DownHeight, true)
    self.addContextMenuItem("BackFront", BackFront, true)
    self.addContextMenuItem("ForwardFront", ForwardFront, true)
    self.addContextMenuItem("PlusBackwards", PlusBackwards, true)
    self.addContextMenuItem("MinusBackwards", MinusBackwards, true)
    self.addContextMenuItem("Rotate", Rotate, true)

    if self.AssetBundle then
        indexMove = -1
        loopingEffects = self.AssetBundle.getLoopingEffects()
        if loopingEffects then
            for i,v in ipairs(loopingEffects) do
                if v == "Move" then
                    indexMove = i
                end
            end
        end
    end
end

function SetCamera(playerColor)
    if prevCPC == nil then
        Player[playerColor].broadcast("You are now controlling model Player.")
        Player[playerColor].broadcast("To exit first-person mode, press 0 on the nampad.")
        Player[playerColor].broadcast("To enter back mode, press 1 on the nampad.")
    end
    Player[playerColor].attachCameraToObject(
        {
            object = self,
            offset = {x = offsetFront, y = offsetHeight, z = offsetBackwards}
        }
    )
    SetPlayer(playerColor)
    UpdateSave()
end

function UpHeight(color) offsetHeight = offsetHeight + 0.25 SetCamera(color) end
function DownHeight(color) offsetHeight = offsetHeight - 0.25 SetCamera(color) end
function BackFront(color) offsetFront = offsetFront + 0.25 SetCamera(color) end
function ForwardFront(color) offsetFront = offsetFront - 0.25 SetCamera(color) end
function PlusBackwards(color) offsetBackwards = offsetBackwards + 0.25 SetCamera(color) end
function MinusBackwards(color) offsetBackwards = offsetBackwards - 0.25 SetCamera(color) end
function Rotate(color) offsetRotate = offsetRotate + 90 local l = upIndex upIndex = leftIndex leftIndex = downIndex downIndex = rightIndex rightIndex = l SetCamera(color) end

function onScriptingButtonDown(index, color)
    if index == lookScreenIndex and prevCPC == color and controllingPlayerColor == nil then
        SetCamera(color)
    end

    if color ~= controllingPlayerColor then return end

    if index == upIndex then
        up = true
    elseif index == leftIndex then
        left = true
    elseif index == downIndex then
        down = true
    elseif index == rightIndex then
        right = true
    elseif index == jumpIndex then
        jump = true
    elseif index == exitScreenIndex then
        local obj = self.clone()
        Player[color].attachCameraToObject({object = obj})
        obj.destruct()
        Player[color].setCameraMode("ThirdPerson")
        controllingPlayerColor = nil
    end
end

function onScriptingButtonUp(index, color)
    if color ~= controllingPlayerColor then return end

    self.setVelocity({x = 0, y = 0, z = 0})

    if index == upIndex then
        up = false
    elseif index == leftIndex then
        left = false
    elseif index == downIndex then
        down = false
    elseif index == rightIndex then
        right = false
    elseif index == jumpIndex then
        jump = false
    end
end

function SetPlayer(color)
    if controllingPlayerColor ~= nil and color ~= nil then return end
    controllingPlayerColor = color
    prevCPC = color
end

function onUpdate()
    if controllingPlayerColor == nil then return end

    if self then
        if loopingEffects and indexMove ~= -1 then playLoopingEffect(indexMove) end

        local ourForward = self.getTransformRight()
        ourForward:inverse()
        local ourLeft = self.getTransformForward()
        ourLeft:inverse()
        local ourRight = self.getTransformForward()
        local ourBack = self.getTransformRight()
        local ourForwardNormalized = Vector(ourForward.x, 0, ourForward.z)
        ourForwardNormalized:normalize()
        local ourLeftNormalized = Vector(ourLeft.x, 0, ourLeft.z)
        ourLeftNormalized:normalize()
        local ourRightNormalized = Vector(ourRight.x, 0, ourRight.z)
        ourRightNormalized:normalize()
        local ourBackNormalized = Vector(ourBack.x, 0, ourBack.z)
        ourBackNormalized:normalize()

        local velocityX, velocityY, velocityZ = 0, self.getVelocity().y, 0
        if up then
            velocityX = velocityX + (ourForwardNormalized.x * moveSpeed)
            velocityZ = velocityZ + (ourForwardNormalized.z * moveSpeed)
        end
        if left then
            velocityX = velocityX + (ourLeftNormalized.x * moveSpeed)
            velocityZ = velocityZ + (ourLeftNormalized.z * moveSpeed)
        end
        if down then
            velocityX = velocityX + (ourBackNormalized.x * moveSpeed)
            velocityZ = velocityZ + (ourBackNormalized.z * moveSpeed)
        end
        if right then
            velocityX = velocityX + (ourRightNormalized.x * moveSpeed)
            velocityZ = velocityZ + (ourRightNormalized.z * moveSpeed)
        end
        if jump and canJump then
            velocityY = forceJump
            canJump = false
        end
        self.setVelocity({x = velocityX, y = velocityY, z = velocityZ})
        rotateY = Player[controllingPlayerColor]:getPointerRotation() + offsetRotate
        self.setRotation({x = 0, y = rotateY, z = 0})
    end
end

function onCollisionEnter()
    canJump = true
end
]]

function onCollisionEnter(info)
    local obj = info.collision_object
    if(obj.getPosition().y < self.getPosition().y) then return end
    print("Script adding")
    obj.setLuaScript(CameraFollow)
end