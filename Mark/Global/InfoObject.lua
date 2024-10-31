local putObjects = {}

function onCollisionEnter(info)
    Wait.time(|| CollisionEnter(info), 0.5)
end
function CollisionEnter(info)
    local obj = info.collision_object
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local name = obj.getName():gsub("%[.-%]","")
        local arg = {name = name, description = obj.getDescription(), color = self.getName()}
        table.insert(putObjects, arg)
        Global.call("UpdateInformation", putObjects)
    end
end

function onCollisionExit(info)
    local obj = info.collision_object
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local nameObj = obj.getName():gsub("%[.-%]","")
        local id
        for i = 1, #putObjects do
            if nameObj == putObjects[i].name then
                id = i
                break
            end
        end
        table.remove(putObjects, id)
        if #putObjects == 0 then table.insert(putObjects, {color = self.getName()}) end
        Global.call("UpdateInformation", putObjects)
    end
end