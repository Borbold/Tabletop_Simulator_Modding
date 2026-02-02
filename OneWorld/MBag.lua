function UpdateSave()
    self.script_state = JSON.encode({
        ["cloneActiveBagGUID"] = cloneActiveBag and cloneActiveBag.getGUID(),
        ["ss"] = ss, ["prs"] = prs
    })
end

function onLoad(savedData)
    local loadedData = JSON.decode(savedData or "")
    if loadedData then
        prs = loadedData.prs or ""
        ss = loadedData.ss or ""
        cloneActiveBag = loadedData.cloneActiveBagGUID and getObjectFromGUID(loadedData.cloneActiveBagGUID)
    end

    activeBag = nil
    oneWorld = getObjectFromGUID(self.getGMNotes())
    if (prs and prs ~= "") or (ss and ss ~= "") then
        Wait.condition(
            function()
                if prs ~= "" then oneWorld.setVar("prs", prs) end
                if ss ~= "" then oneWorld.setVar("ss", ss) end
            end,
            function() return oneWorld ~= nil end
        )
    end
    Wait.condition(function() vBase = oneWorld.getVar("vBase") end, function() return oneWorld.getVar("vBase") ~= nil end)
end

-- Build --
function CreateBagBuild(bag)
    vBase = oneWorld.getVar("vBase")
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
    UpdateSave()
    Wait.time(|| oneWorld.call("SetUI"), 0.1)
end
local function PutObjectsBuild(objectsString, index)
    local objectWords = vBase.call("parseStringInWords", {pString=objectsString[index],rStr="[^,]+"})
    local t = {
        guid = objectWords[1]:sub(3),
        position = {x=tonumber(objectWords[2]), y=tonumber(objectWords[3]), z=tonumber(objectWords[4])},
        rotation = {x=tonumber(objectWords[5]), y=tonumber(objectWords[6]), z=tonumber(objectWords[7])},
        callback = "UnderPack", callback_owner = self, smooth = false
    } activeBag.takeObject(t).setLock(objectWords[8] == "1")
    return index + 1
end
function Build()
    prs = oneWorld.getVar("aBase").getLuaScript()
    if prs == "" or #activeBag.getObjects() == 0 then return end
    ss = ""
    local objectsString, index = vBase.call("parseStringInWords", {pString=prs,rStr="[^\n]+"}), 1
    if(oneWorld.getVar("toggleMapBuild")) then
        while index <= #objectsString do
            index = PutObjectsBuild(objectsString, index)
            if(index >= 5001) then print("[ff0000]ERROR[-]") break end
        end
        Wait.time(|| EndBuild(), 0.2)
    else
        Wait.condition(
            function() Wait.time(|| EndBuild(), 0.2) end,
            function()
                -- A rather unnecessary workaround. With just one object in the field, it throws an error that doesn't affect the script's operation.
                if #objectsString == 1 and index == 2 then return true end
                index = PutObjectsBuild(objectsString, index)
                return index > #objectsString
            end
        )
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
    Wait.condition(
        function() oneWorld.call("SetUI") end,
        function() return not tBag end
    )
    UpdateSave()
end
function DoClear()
    ss = oneWorld.getVar("ss")
    oneWorld.getVar("aBase").setDescription(cloneActiveBag.getGUID())
    local packGUID = vBase.call("parseStringInWords", {pString=ss,rStr="[^,]+"})
    local index = 1
    if(oneWorld.getVar("toggleMapBuild")) then
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
    Wait.condition(
        function() oneWorld.call("SetUI") end,
        function() return not tBag end
    )
    if(cloneActiveBag) then cloneActiveBag.destruct() cloneActiveBag = nil end
end
function DoPack(mBag)
    ss = oneWorld.getVar("ss")
    oneWorld.getVar("aBase").setDescription(mBag.getGUID())
    local packGUID = vBase.call("parseStringInWords", {pString=ss,rStr="[^,]+"})
    local index = 1
    if(oneWorld.getVar("toggleMapBuild")) then
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
        local objectsString = vBase.call("parseStringInWords", {pString=eBase.getLuaScript(),rStr="[^\n]+"})
        local index = 1
        Wait.condition(function()
            local wSize = oneWorld.getVar("wBase").getScale()
            local vSize = oneWorld.getVar("vBase").getScale()
            local baseInfo = string.format(
                "%s,{%f;1.0;%f},{%f;1.0;%f},%d,%d,2,%d",
                eBase.getGUID(), wSize[1], wSize[3], vSize[1], vSize[3], oneWorld.getVar("r1"), oneWorld.getVar("r3"), oneWorld.getVar("r90")
            )
            bag.setDescription(baseInfo) eBase.setDescription(bag.getGUID()) bag.putObject(eBase)
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
        local prefix = string.sub(currentBase, 1, 2)
        if prefix == "i_" or prefix == "c_" then
            local newGuid = string.sub(currentBase, 3)
            obj.setDescription(newGuid)
            local src = getObjectFromGUID(newGuid).getLuaScript()
            if string.sub(src, -2) ~= "\r\n" then
                src = src .. "\r\n"
            end
            obj.setLuaScript(src)
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