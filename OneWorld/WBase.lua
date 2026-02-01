local sciptLinkPlate = [[
lh, pCol, sX, sY = nil, nil, nil, nil
function onDropped()
    local selfScale = self.getScale()
    sX, sY = math.ceil(selfScale.x*180), math.ceil(selfScale.z*180)
end
function onPickedUp()
    pCol = self.held_by_color
    if math.abs(Player[pCol].lift_height - 0.03) > 0.005 then
        lh = Player[pCol].lift_height
    end
    Player[pCol].lift_height = 0.03
end
local function returnLiftHeight()
    if pCol and lh then
        Player[pCol].lift_height = lh
        pCol, lh = nil, nil
    end
end
function onCollisionEnter() returnLiftHeight() end
function onDestroy() returnLiftHeight() end
]]

local UIscaleDivider = {w = 4.5, h = 2.65}
local UIscale = {w = 450, h = 270}
function onLoad()
    collisionObj, oneWorld = nil, getObjectFromGUID(self.getGMNotes())
end

function onCollisionEnter(info)
    if(not oneWorld or not oneWorld.getVar("vBaseOn") or collisionObj == info.collision_object) then return end
    collisionObj = info.collision_object collisionObj.setName(collisionObj.getName():gsub(",", ";"))
    local g = string.sub(collisionObj.getName(), 1, 4)
    if self.getDescription() == "" and g == "SBx_" and collisionObj.name == "Custom_Token" then NewBase()
    elseif self.getDescription() == "" and g == "OWx_" and collisionObj.name == "Bag" then DoImport()
    elseif self.getDescription() != "" and collisionObj.getCustomObject().image == oneWorld.UI.getCustomAssets()[6].url then AddLink()
    else broadcastToAll("!! Clear Hub to Import !!", {0.95, 0.95, 0.95}) end
end

function NewBase()
    local scr = oneWorld.getVar("aBag").getLuaScript()
    if(scr:find(collisionObj.getGUID())) then broadcastToAll("Duplicate GUID.", {0.943, 0.745, 0.14})
    else oneWorld.call("PutBase", collisionObj.getGUID()) end
end

function DoImport()
    if oneWorld.getVar("aBag").getDescription() == "_OW_aBaG" then
        broadcastToAll("!! Can Not Import to an Empty World !!", {0.95, 0.95, 0.95})
        return
    end
    if string.sub(collisionObj.getName(), 1, 4) == "SET_" then
        collisionObj.setDescription("")
        for i,v in ipairs(collisionObj.getObjects()) do
            if v.name:find("SBx_") then
                oneWorld.setVar("currentBase", "i_"..collisionObj.getGUID())  collisionObj.setDescription(v.getGUID())
                break
            end
        end
        if collisionObj.getDescription() == "" then
            broadcastToAll("Creating Hidden Base...", {0.943, 0.745, 0.14})
            spawnObject({position = {-10, -45, 0}, callback_owner = self, callback = "cbCTBase"})
            .setCustomObject({image = oneWorld.UI.getCustomAssets()[6].url, thickness = 0.1, type = "Custom_Token"})
            return
        end
    end
    broadcastToAll("Importing Art...", {0.943, 0.745, 0.14})
    local t = {
        position = {-10, -45, 0}, guid = string.sub(collisionObj.getDescription(), 1, 6),
        callback = "PreImport", callback_owner = oneWorld.getVar("mBag"), smooth = false
    }
    collisionObj.takeObject(t)
end
function cbCTBase(base)
    oneWorld.setVar("currentBase", "c_"..collisionObj.getGUID())
    collisionObj.setDescription(base.getGUID()) base.setName("SBx_"..string.sub(collisionObj.getName(), 5))
    oneWorld.getVar("mBag").call("PreImport", base)
end

function AddLink()
    if oneWorld.call("isPVw") then collisionObj.destruct() return end
    if(collisionObj.getDescription() == self.getDescription()) then
        collisionObj.destruct()
        broadcastToAll("Link to Self or duplicate Link", {0.943, 0.745, 0.14})
        return
    end
    local locP = self.positionToLocal(collisionObj.getPosition())
    local lX, lZ, sX, sY = locP.x, locP.z, collisionObj.getVar("sX"), collisionObj.getVar("sY")
    local mapScale, mapBounds = self.getScale(), self.getBounds()
    local w, h = UIscale.h/UIscaleDivider.h, UIscale.w/UIscaleDivider.w
    local vBase = oneWorld.getVar("vBase")
    local x, z = vBase.call("Round", {num=lX*h, idp=2}), vBase.call("Round", {num=lZ*w, idp=2})
    if(oneWorld.getVar("r90") == 1 and self.getRotation().z == 180) then
        x = x*(-1)
    end
    local lnk = oneWorld.getVar("lnk")
    lnk = lnk ~= nil and lnk ~= "" and lnk.."," or ""
    local newLnk = string.format("%s(%f;%f)(%f;%f)@%s", lnk, x, z, sX, sY, collisionObj.getDescription())
    oneWorld.setVar("lnk", newLnk)
    collisionObj.destruct()
    oneWorld.call("JotBase")
    SetLinks()
end

function SetLinks()
    local t = oneWorld.getVar("lnk")
    if(t == nil) then return end
    
    local rotZ, r90 = 0, oneWorld.getVar("r90")
    if(r90 == 1) then
        rotZ = ((self.getRotation().y == 270 and self.getRotation().z == 180) or (self.getRotation().y == 90 and self.getRotation().z == 180)) and -1 or 1
    else
        rotZ = self.getRotation().z == 0 and 1 or -1
    end
    local xmlTable = {
        {
            tag = "Panel",
            attributes = {
                scale = 1.85/self.getScale().x.." 1 "..1.85/self.getScale().z,
                position = "0 0 "..(-6*rotZ),
                width = rotZ == 1 and tostring(UIscale.w) or tostring(UIscale.h),
                height = rotZ == 1 and tostring(UIscale.h) or tostring(UIscale.w),
                rotation = "0 "..self.getRotation().z.." 0"
            },
            children = {
            }
        }
    }

    if self.getDescription() == "" then return end
    for str in t:gmatch("[%(%-?%d.%d;%-?%d.%d%)]*@") do
        local words = {}
        for word in str:gmatch("[^(;@,)]+") do
            table.insert(words, word)
        end
        local x, y = tonumber(words[1]), tonumber(words[2])
        local sX, sY = tonumber(words[3]), tonumber(words[4])

        local newButton = {
            tag = "Button",
            attributes = {
                id = "link"..(#xmlTable[1].children + 1),
                image = oneWorld.UI.getCustomAssets()[6].url,
                width = sX,
                height = sY,
                offsetXY = x.." "..y,
                onClick = "ButtonLink"
            }
        }
        table.insert(xmlTable[1].children, newButton)
    end

    self.UI.setXmlTable(xmlTable)
end

function MakeLink()
    local r2 = oneWorld.getVar("r2")
    local pos = self.getPosition() + {x=-5.5*r2, y=2.5, z=0}
    local p = {
        type = "Custom_Token", position = {pos[1], pos[2], pos[3]}, rotation = {0, 90, 0}, scale = {0.07, 0.1, 0.07},
        callback_owner = self, callback = "cbMLink"
    }
    spawnObject(p).setCustomObject({image = oneWorld.UI.getCustomAssets()[6].url, thickness = 0.01})
end
function cbMLink(base)
    local nl = oneWorld.getVar("nl")
    base.setDescription(nl)
    local bn = oneWorld.call("ParceData", nl)
    base.setName(bn) oneWorld.setVar("nl", nil)
    base.setLuaScript(sciptLinkPlate) base.setGMNotes(self.getGMNotes())
end

function GetLink(id)
    if(oneWorld.getVar("mapIsBuild")) then broadcastToAll("Pack map objects", {0.94, 0.65, 0.02}) return end
    if(oneWorld.getVar("activeEdit")) then oneWorld.call("EditMode") return end
    local lnk = ""
    for w in oneWorld.getVar("lnk"):gmatch("[^(@,)]+") do
        if(w:find("%a")) then
            if(id == 1) then
                lnk = w:sub(1, 6)
                break
            end
            id = id - 1
        end
    end
    local bn = string.sub(oneWorld.call("ParceData", lnk), 1, 21)
    if bn != oneWorld.UI.getAttribute("mTxt", "text") then oneWorld.call("SetUIText", bn) oneWorld.setVar("linkToMap", lnk) oneWorld.call("SetUI")
    else oneWorld.call("GetBase", lnk) end
end

function ButtonLink(_, _, id) GetLink(tonumber(id:gsub("%D", ""), 10)) end