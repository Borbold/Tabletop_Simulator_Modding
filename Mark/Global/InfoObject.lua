function onLoad()
    putObjects = {}
    avatar = getObjectFromGUID(self.getGMNotes())
end

function onCollisionEnter(info)
    Wait.time(|| CollisionEnter(info), 0.5)
end
function CollisionEnter(info)
    local obj = info.collision_object
    local l1 = '"ImageURL":'
    local l2 = '"ImageSecondaryURL"'
    local objJSON = obj.getJSON()
    local URLImage = objJSON:sub(objJSON:find(l1) + #l1, objJSON:find(l2))
    URLImage = URLImage:gsub('"', "")
    URLImage = URLImage:gsub(',', "")
    URLImage = URLImage:gsub('\n', "")
    URLImage = URLImage:gsub(' ', "")
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local name = obj.getName():gsub("%[.-%]","")
        local arg = {name = name, description = obj.getDescription(), color = self.getName(), image = URLImage}
        table.insert(putObjects, arg)
        print("Hello ", URLImage)
        Global.call("UpdateInformation", putObjects)
        avatar.call("UpdateInformation", putObjects)
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
        Global.call("UpdateInformation", #putObjects == 0 and {{color = self.getName()}} or putObjects)
        avatar.call("UpdateInformation", putObjects)
    end
end