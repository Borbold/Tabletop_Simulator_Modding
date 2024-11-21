function onLoad()
    getMultiplyObjectJSON, dontLoopInfo = nil, 1
    self.addContextMenuItem("Clear", ClearMultiplyObject)
    self.addContextMenuItem("Multiply", MultiplyObject, true)
    self.addContextMenuItem("Ping", Ping)
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
        local info = {}
        self.getGMNotes():gsub("[^\n%.]+", function(str) table.insert(info, str) end)
        local count = tonumber(info[#info]:gsub("%D", ""), 10)
        for i = 1, #info - 1 do
            local bag = getObjectFromGUID(info[i])
            if bag == nil then print("It's item nonexistent") return end
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
end

function Ping(playerColor)
    local info = {}
    self.getGMNotes():gsub("[^\n%.]+", function(str) table.insert(info, str) end)
    for i = 1, #info - 1 do
        Player[playerColor].pingTable(getObjectFromGUID(info[i]).getPosition() + Vector(0, 1, 0))
    end
end