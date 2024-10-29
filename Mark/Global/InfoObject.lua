local putObjects = {}

function onCollisionEnter(info)
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
        local arg = {name = obj.getName(), description = obj.getDescription(), color = self.getName()}
        local id
        for id = 1, #putObjects do
            if arg.name == putObjects[id].name then
                break
            end
        end
        table.remove(putObjects, id)
        Global.call("UpdateInformation", putObjects)
    end
end