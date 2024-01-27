local getMultiplyObjectJSON = nil
local dontLoopInfo = 1

function onLoad()
    self.addContextMenuItem("Clear", ClearMultiplyObject)
    self.addContextMenuItem("Multiply", MultiplyObject)
end

function onCollisionEnter(info)
    if getMultiplyObjectJSON == nil and info.collision_object.getPosition().y > self.getPosition().y then
        getMultiplyObjectJSON = info.collision_object.getJSON()
        print(info.collision_object)
        dontLoopInfo = 0
        return
    elseif dontLoopInfo == 0 and info.collision_object.getPosition().y > self.getPosition().y then
        print("Multiply object already selected")
        dontLoopInfo = 1
    end
end

function ClearMultiplyObject()
    if getMultiplyObjectJSON then
        print("Clear multiply object")
        getMultiplyObjectJSON = nil
    end
end

function MultiplyObject()
    if getMultiplyObjectJSON then
        local bag = getObjectFromGUID(self.getGMNotes())
        if bag == nil then print("It's item nonexistent") return end
        local count = tonumber(self.getDescription())
        for i = 1, count do
            local newObject = spawnObjectJSON({
                json = getMultiplyObjectJSON,
                rotate = {0, 0, 0},
                position = {self.getPosition().x, self.getPosition().y + 1, self.getPosition().z}
            })
            local toPosition = {
                bag.getPosition().x,
                bag.getPosition().y + 5 + i * newObject.getScale().y * 0.1,
                bag.getPosition().z
            }
            newObject.setPositionSmooth(toPosition)
        end
    end
end