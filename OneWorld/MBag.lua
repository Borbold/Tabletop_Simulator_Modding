local oneWorld, activeBag = nil, nil
function UpdateSave()
    local dataToSave = {
        ["cloneActiveBagGUID"] = cloneActiveBag and cloneActiveBag.getGUID() or nil,
        ["ss"] = ss, ["prs"] = prs
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    local loadedData = JSON.decode(savedData or "")
    if(loadedData) then
        prs = loadedData.prs or ""
        ss = loadedData.ss or ""
        cloneActiveBag = loadedData.cloneActiveBagGUID and getObjectFromGUID(loadedData.cloneActiveBagGUID) or nil
    end
    oneWorld = getObjectFromGUID(self.getGMNotes())
    Wait.time(function()
        if(prs) then oneWorld.setVar("prs", prs) end
        if(ss) then oneWorld.setVar("ss", ss) end
    end, 1.1)
end

-- Build --
function CreateBagBuild(bag)
    bag.lock() activeBag = bag
    cloneActiveBag = activeBag.clone()
    cloneActiveBag.setColorTint({0.713, 0.247, 0.313, 0.2})
    cloneActiveBag.setName("Copy build map")
    local posSpawn = oneWorld.getVar("wBase").getPosition()
    cloneActiveBag.setPosition({posSpawn.x, posSpawn.y - 5, posSpawn.z})
    Build()
end

local function EndBuild()
    oneWorld.setVar("prs", prs)
    oneWorld.setVar("ss", ss)
    broadcastToAll("Finished Building.", {0.943, 0.745, 0.14})
    if activeBag then
        activeBag.destruct()
        activeBag = nil
    end
    Wait.time(|| oneWorld.call("SetUI"), 0.1)
    UpdateSave()
end
local function PutObjectsBuild(objectsString, index)
    local objectWords = {}
    for w in objectsString[index]:gmatch("[^,]+") do
        table.insert(objectWords, w)
    end
    local fLock = objectWords[8] == "1"
    local t = {
        guid = objectWords[1]:sub(3),
        position = {x=tonumber(objectWords[2]), y=tonumber(objectWords[3]), z=tonumber(objectWords[4])},
        rotation = {x=tonumber(objectWords[5]), y=tonumber(objectWords[6]), z=tonumber(objectWords[7])},
        callback = "UnderPack", callback_owner = self, smooth = false
    } activeBag.takeObject(t).setLock(fLock)
    return index + 1
end
function Build()
    prs = oneWorld.getVar("aBase").getLuaScript()
    if prs == "" or #activeBag.getObjects() == 0 then return end
    ss = ""
    local objectsString, index = {}, 1
    for strok in prs:gmatch("[^\n]+") do
        table.insert(objectsString, strok)
    end
    if(oneWorld.getVar("toggleMapBuild")) then
        while index <= #objectsString do
            index = PutObjectsBuild(objectsString, index)
            if(index >= 5001) then print("[ff0000]ERROR[-]") break end
        end
        Wait.time(function()
            Wait.time(|| EndBuild(), 0.2)
        end, 0.2)
    else
        do
            Wait.condition(function()
                Wait.time(function()
                    Wait.time(|| EndBuild(), 0.2)
                end, 0.2)
            end,
            function()
                -- A rather unnecessary workaround. With just one object in the field, it throws an error that doesn't affect the script's operation.
                if #objectsString == 1 and index == 2 then return true end
                index = PutObjectsBuild(objectsString, index)
                return index > #objectsString
            end)
        end
    end
end
function UnderPack(obj)
    ss = ss..obj.guid..","
    if(obj.hasTag("noInteract")) then obj.interactable = false else obj.interactable = true end
end
----------

-- Clear --
local function EndClear()
    self.putObject(cloneActiveBag) cloneActiveBag = nil
    oneWorld.call("JotBase")
    prs = "" oneWorld.setVar("prs", "")
    ss = "" oneWorld.setVar("ss", ss)
    broadcastToAll("Clearing Complete.", {0.943, 0.745, 0.14})
    Wait.condition(function()
            oneWorld.call("SetUI")
        end, function() return not tBag end
    )
    UpdateSave()
end
function DoClear()
    ss = oneWorld.getVar("ss")
    oneWorld.getVar("aBase").setDescription(cloneActiveBag.getGUID())
    if(oneWorld.getVar("toggleMapBuild")) then
        local packGUID, index = {}, 1
        for w in ss:gmatch("[^,]+") do
            table.insert(packGUID, w)
        end
        while(index <= #packGUID) do
            if(getObjectFromGUID(packGUID[index])) then
                getObjectFromGUID(packGUID[index]).destruct()
            end
            index = index + 1
            if(index >= 5001) then print("[ff0000]ERROR[-]") break end
        end
        Wait.time(|| EndClear(), 0.2)
    else
        do
            local packGUID, index = {}, 1
            for w in ss:gmatch("[^,]+") do
                table.insert(packGUID, w)
            end
            Wait.condition(function()
                Wait.time(|| EndClear(), 0.2)
            end, function()
                if(getObjectFromGUID(packGUID[index])) then
                    getObjectFromGUID(packGUID[index]).destruct()
                end
                index = index + 1
                return index > #packGUID
            end)
        end
    end
end
-- Clear --

-- Pack --
local function EndPack(mBag)
    self.putObject(mBag)
    oneWorld.call("JotBase")
    oneWorld.call("StowBase") oneWorld.call("NoBase") oneWorld.call("SetUIText")
    oneWorld.setVar("prs", "")
    ss = "" oneWorld.setVar("ss", ss)
    broadcastToAll("Packing Complete.", {0.943, 0.745, 0.14})
    Wait.condition(function()
            oneWorld.call("SetUI")
        end, function() return not tBag end
    )
    if(cloneActiveBag) then cloneActiveBag.destruct() cloneActiveBag = nil end
end
function DoPack(mBag)
    ss = oneWorld.getVar("ss")
    oneWorld.getVar("aBase").setDescription(mBag.getGUID())
    if(oneWorld.getVar("toggleMapBuild")) then
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
        Wait.time(|| EndPack(mBag), 0.2)
    else
        do
            local packGUID, index = {}, 1
            for w in ss:gmatch("[^,]+") do
                table.insert(packGUID, w)
            end
            Wait.condition(function()
                Wait.time(|| EndPack(mBag), 0.2)
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
            if getObjectFromGUID(objectGUID) then bag.putObject(getObjectFromGUID(objectGUID)) end
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