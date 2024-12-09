function onLoad()
    locColors = "White Red Green Blue Brown Teal Yellow Orange Purple Pink"
    putObjects = {}
    avatar = getObjectFromGUID(self.getGMNotes())
    avatar.setVar("InfoObjectGUID", self.getGUID())
end

function onCollisionEnter(info)
    local obj = info.collision_object
    if(Global.getVar(obj.getGUID()) or obj.getPosition().y < self.getPosition().y) then return end
    Global.setVar(obj.getGUID(), true)
    
    local l1 = '"ImageURL":'
    local l2 = '"ImageSecondaryURL"'
    local objJSON = obj.getJSON()
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local URLImage = objJSON:sub(objJSON:find(l1) + #l1, objJSON:find(l2) - 1)
        URLImage = URLImage:match([["([^"]+)]])
        local name = obj.getName():gsub("%[.-%]","")
        local arg = {name = name, description = obj.getDescription(), color = self.getName(), image = URLImage, guid = obj.getGUID()}
        table.insert(putObjects, arg)
        
        if(locColors:find(self.getName())) then Global.call("UpdateInformation", putObjects) end
        avatar.call("UpdateInformation", putObjects)
    end
end

function RemoveBuff(guid)
    local obj = getObjectFromGUID(guid)
    if(not Global.getVar(obj.getGUID()) or obj.getPosition().y < self.getPosition().y) then return end
    Global.setVar(obj.getGUID(), false)

    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        local guidObj = obj.getGUID()
        for i = 1, #putObjects do
            if guidObj == putObjects[i].guid then
                table.remove(putObjects, i)
                break
            end
        end
        if(locColors:find(self.getName())) then Global.call("UpdateInformation", #putObjects == 0 and {{color = self.getName()}} or putObjects) end
        avatar.call("UpdateInformation", putObjects)
    end
end