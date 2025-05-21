local sciptLinkPlate = [[
l1, l3, lh, u, sX, sY = nil, nil, nil, nil, nil, nil
function onDropped()
    local p, s = self.getPosition(), self.getScale()
    sX, sY = math.ceil(s.x*180), math.ceil(s.z*180)
end

function onPickedUp()
    u = self.held_by_color l1 = nil l3 = nil
    if math.abs(Player[u].lift_height - 0.03) > 0.005 then
        lh = Player[u].lift_height
    end
    Player[u].lift_height = 0.03
end
local function returnLiftHeight()
    if u and lh then
        Player[u].lift_height = lh u = nil lh = nil
    end
end
function onCollisionEnter()
    returnLiftHeight()
end
function onDestroy()
    returnLiftHeight()
end
]]

local UIscale = {x = 460, z = 250}
local collisionObj, oneWorld = nil, nil
function onLoad()
    collisionObj = nil
    oneWorld = getObjectFromGUID(self.getGMNotes())
end

function onCollisionEnter(info)
    if(not oneWorld or not oneWorld.getVar("vBaseOn") or collisionObj == info.collision_object) then return end
    collisionObj = info.collision_object collisionObj.setName(collisionObj.getName():gsub(",", ";"))
    local g = string.sub(collisionObj.getName(), 1, 4)
    local i = "https://steamusercontent-a.akamaihd.net/ugc/13045573010340250/36C6D007CDC8304626495A82A96511E910CC301B/"
    if self.getDescription() == "" and g == "SBx_" and collisionObj.name == "Custom_Token" then NewBase()
    elseif self.getDescription() == "" and g == "OWx_" and collisionObj.name == "Bag" then DoImport()
    elseif self.getDescription() != "" and collisionObj.getCustomObject().image == i then AddLink()
    else broadcastToAll("!! Clear Hub to Import !!", {0.95, 0.95, 0.95}) end
end

function NewBase()
    local s = oneWorld.getVar("aBag").getLuaScript()
    if(s:find(collisionObj.getGUID())) then broadcastToAll("Duplicate GUID.", {0.943, 0.745, 0.14})
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
            local t = {
                position = {-10, -45, 0},
                callback_owner = self, callback = "cbCTBase"
            }
            local i = {
                image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg",
                thickness = 0.1, type = "Custom_Token"
            }
            spawnObject(t).setCustomObject(i)
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
    local s = oneWorld.getVar("aBag").getLuaScript()
    if(collisionObj.getDescription() == self.getDescription()) then
        collisionObj.destruct()
        broadcastToAll("Link to Self or duplicate Link", {0.943, 0.745, 0.14})
        return
    end
    local locP = self.positionToLocal(collisionObj.getPosition())
    local lX, lZ, sX, sY = locP.x, locP.z, collisionObj.getVar("sX"), collisionObj.getVar("sY")
    local mapScale, mapBounds = self.getScale(), self.getBounds()
    local w, h = (UIscale.z + (mapScale.z - 1.85)*UIscale.z)/(mapBounds.size.z/2), (UIscale.x + (mapScale.x - 1.85)*UIscale.x)/(mapBounds.size.x/2)
    local x, z = Round(lX*h, 2), Round(lZ*w, 2)
    if(oneWorld.getVar("r90") == 1 and self.getRotation().z == 180) then x = x*(-1) end
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
    local h, w = UIscale.z + (self.getScale().z - 1.85)*UIscale.z, UIscale.x + (self.getScale().x - 1.85)*UIscale.x
    local xmlTable = {
        {
            tag = "Panel",
            attributes = {
                scale = 1.85/self.getScale().x.." 1 "..1.85/self.getScale().z,
                position = "0 0 "..(-6*rotZ),
                width = rotZ == 1 and tostring(w) or tostring(h),
                height = rotZ == 1 and tostring(h) or tostring(w),
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
                image = "https://steamusercontent-a.akamaihd.net/ugc/13045573010340250/36C6D007CDC8304626495A82A96511E910CC301B/",
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
    local r2, x = oneWorld.getVar("r2"), self.getPosition()
    x[1] = x[1]-(5.5 * r2)  x[2]=x[2]+2.5  local p = {}  p.type = "Custom_Token"  p.position = {x[1], x[2], x[3]}
    p.rotation = {0, 90, 0}  p.scale = {0.07, 0.1, 0.07}  p.callback = "cbMLink"  p.callback_owner = self
    local obj = spawnObject(p)  local i = {}  i.thickness = 0.01
    i.image = "https://steamusercontent-a.akamaihd.net/ugc/13045573010340250/36C6D007CDC8304626495A82A96511E910CC301B/" obj.setCustomObject(i)
end
function cbMLink(base)
    local nl = oneWorld.getVar("nl")
    base.setDescription(nl)
    local bn = oneWorld.call("ParceData", nl)
    base.setName(bn) oneWorld.setVar("nl", nil)
    base.setLuaScript(sciptLinkPlate) base.setGMNotes(self.getGMNotes())
end

function GetLink(id)
    if oneWorld.getVar("butActive") then oneWorld.call("EditMode") return end
    local l = ""
    for w in oneWorld.getVar("lnk"):gmatch("[^(@,)]+") do
        if(w:find("%a")) then
        if(id == 1) then
            l = w:sub(1, 6)
            break
        end
        id = id - 1
        end
    end
    local bn = string.sub(oneWorld.call("ParceData", l), 1, 21)
    if bn != oneWorld.UI.getAttribute("mTxt", "text") then oneWorld.call("SetUIText", bn) oneWorld.setVar("linkToMap", l) oneWorld.call("SetUI")
    else oneWorld.call("GetBase", l) end
end

function ButtonLink(_, _, id) GetLink(tonumber(id:gsub("%D", ""), 10)) end
function Round(num, idp) return math.ceil(num*(10^idp))/10^idp end