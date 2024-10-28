function onCollisionEnter(info)
    local obj = info.collision_object
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local arg = {name = obj.getName(), description = obj.getDescription(), color = self.getName()}
        Global.call("AddNewInformation", arg)
    end
end

function onCollisionExit(info)
    local obj = info.collision_object
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local arg = {name = obj.getName(), description = obj.getDescription(), color = self.getName()}
        Global.call("RemoveNewInformation", arg)
    end
end