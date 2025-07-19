local oneWorld, activeBag = nil, nil
function onLoad()
    oneWorld = getObjectFromGUID(self.getGMNotes())
end

-- Build --
function CreateBagBuild(bag)
    oneWorld.setVar("iBag", bag)
    bag.lock() activeBag = bag
    Build()
end

function Build()
    prs = oneWorld.getVar("aBase").getLuaScript()
    if prs == "" or #activeBag.getObjects() == 0 then return end
    if(oneWorld.getVar("toggleMapBuild")) then
        ss = ""
        local objectsString = {}
        for strok in prs:gmatch("[^\n]+") do
            table.insert(objectsString, strok)
        end
        local index = 1
        while index <= #objectsString do
            local objectWords = {}
            if(index > #objectsString) then return true end
            for w in objectsString[index]:gmatch("[^,]+") do
                table.insert(objectWords, w)
            end
            local fLock = objectWords[8]
            local t = {
                guid = objectWords[1]:sub(3),
                position = {x=tonumber(objectWords[2]), y=tonumber(objectWords[3]), z=tonumber(objectWords[4])},
                rotation = {x=tonumber(objectWords[5]), y=tonumber(objectWords[6]), z=tonumber(objectWords[7])},
                callback = "UnderPack", callback_owner = self, smooth = false
            }
            activeBag.takeObject(t).lock()
            index = index + 1
            if(index >= 5001) then print("[ff0000]ERROR[-]") break end
        end
        Wait.time(function()
            oneWorld.setVar("prs", prs)
            oneWorld.setVar("ss", ss)
            Wait.time(|| EndBuild(), 0.2)
        end, 0.2)
    else
        do
            ss = ""
            local objectsString = {}
            for strok in prs:gmatch("[^\n]+") do
                table.insert(objectsString, strok)
            end
            local index = 1
            Wait.condition(function()
                Wait.time(function()
                    oneWorld.setVar("prs", prs)
                    oneWorld.setVar("ss", ss)
                    Wait.time(|| EndBuild(), 0.2)
                end, 0.2)
            end,
            function()
                local objectWords = {}
                if(index > #objectsString) then return true end
                for w in objectsString[index]:gmatch("[^,]+") do
                    table.insert(objectWords, w)
                end
                local fLock = objectWords[8]
                local t = {
                    guid = objectWords[1]:sub(3),
                    position = {x=tonumber(objectWords[2]), y=tonumber(objectWords[3]), z=tonumber(objectWords[4])},
                    rotation = {x=tonumber(objectWords[5]), y=tonumber(objectWords[6]), z=tonumber(objectWords[7])},
                    callback = "UnderPack", callback_owner = self, smooth = false
                }
                activeBag.takeObject(t).lock()
                index = index + 1
                return index > #objectsString
            end)
        end
    end
end
function UnderPack(obj)
    ss = ss..obj.guid..","
    if(obj.hasTag("noInteract")) then obj.interactable = false else obj.interactable = true end
end

function EndBuild()
    broadcastToAll("Finished Building.", {0.943, 0.745, 0.14})
    if activeBag then
        activeBag.destruct()
        oneWorld.setVar("iBag", nil)
        activeBag = nil
    end
    Wait.time(|| oneWorld.call("SetUI"), 0.1)
end
----------

-- Pack --
function DoPack(mBag)
    if(oneWorld.getVar("toggleMapBuild")) then
        ss = oneWorld.getVar("ss")
        oneWorld.getVar("aBase").setDescription(mBag.getGUID())
        local packGUID, index = {}, 1
        for w in ss:gmatch("[^,]+") do
            table.insert(packGUID, w)
        end
        while(index <= #packGUID) do
            if(getObjectFromGUID(packGUID[index])) then
                mBag.putObject(getObjectFromGUID(packGUID[index]))
                ss = ss.gsub(packGUID[index], "", 1)
            end
            index = index + 1
            if(index >= 5001) then print("[ff0000]ERROR[-]") break end
        end
        Wait.time(|| EndPack(mBag, mBag.getName()), 0.2)
    else
        ss = oneWorld.getVar("ss")
        oneWorld.getVar("aBase").setDescription(mBag.getGUID())
        do
            local packGUID, index = {}, 1
            for w in ss:gmatch("[^,]+") do
                table.insert(packGUID, w)
            end
            Wait.condition(function()
                Wait.time(|| EndPack(mBag, mBag.getName()), 0.2)
            end, function()
                if(getObjectFromGUID(packGUID[index])) then
                    mBag.putObject(getObjectFromGUID(packGUID[index]))
                    ss = ss.gsub(packGUID[index], "", 1)
                end
                index = index + 1
                return index > #packGUID
            end)
        end
    end
end
function EndPack(mBag, keepBase)
    if mBag then self.putObject(mBag) end
    oneWorld.call("JotBase")
    if(not keepBase) then oneWorld.call("StowBase") oneWorld.call("NoBase") oneWorld.call("SetUIText") end
    oneWorld.setVar("prs", "")
    ss = "" oneWorld.setVar("ss", ss)
    broadcastToAll("Packing Complete.", {0.943, 0.745, 0.14})
    Wait.condition(function()
            oneWorld.call("SetUI")
        end, function() return not tBag end
    )
end
----------

-- Export --
function Export(bag)
    local eBase = oneWorld.getVar("aBase").clone({position = {-7, -23, -4}})
    bag.setName("OW"..string.sub(eBase.getName(), 3))
    do
        local objectsString, s = {}, eBase.getLuaScript()
        for strok in s:gmatch("[^\n]+") do
            table.insert(objectsString, strok)
        end
        local index = 1
        Wait.condition(function()
            local wSize = oneWorld.getVar("wBase").getScale()
            local vSize = oneWorld.getVar("vBase").getScale()
            s = string.format("%s,{%f;1.0;%f},{%f;1.0;%f},%d,%d,2,%d", eBase.getGUID(), wSize[1], wSize[3], vSize[1], vSize[3], oneWorld.getVar("r1"), oneWorld.getVar("r3"), oneWorld.getVar("r90"))
            bag.setDescription(s) eBase.setDescription(bag.getGUID()) bag.putObject(eBase)
            oneWorld.setVar("iBag", nil)
            Wait.time(|| oneWorld.call("SetUI"), 0.1)
        end,
        function()
            local objectGUID
            for w in objectsString[index]:gmatch("[^,]+") do
                objectGUID = w:sub(3)
                break
            end
            if getObjectFromGUID(objectGUID) then bag.putObject(getObjectFromGUID(objectGUID).clone()) end
            index = index + 1
            return index > #objectsString
        end)
    end
end
----------

-- Import --
function PreImport(obj)
    local currentBase = oneWorld.getVar("currentBase")
    if currentBase then
        local g = string.sub(currentBase, 1, 2)
        if g == "i_" or g == "c_" then
            g = string.sub(currentBase, 3)  obj.setDescription(g)  g = getObjectFromGUID(g).getLuaScript()
        if string.sub(g, string.len(g)-1) != string.char(13)..string.char(10) then g = g..string.char(13)..string.char(10) end
            obj.setLuaScript(g)
        end
    end
    obj.lock()
    local t = {position = {3, -29, -7}}
    local nBag = getObjectFromGUID(obj.getDescription()).clone(t)
    nBag.setPosition({3, -39, -7})
    nBag.lock()
    oneWorld.setVar("iBag", nBag)
    Wait.time(|| DoImport(obj.getGUID()), 0.2)
end
function DoImport(currentGUID)
    local t = {position = {0, -3, 0}}
    oneWorld.setVar("aBase", getObjectFromGUID(currentGUID).clone(t))
    oneWorld.setVar("currentBase", currentGUID)
    Wait.time(|| oneWorld.call("CbImport"), 0.2)
end
----------