function UpdateSave()
    local dataToSave = {
        ["aBagGUID"] = aBag and aBag.getGUID() or nil, ["mBagGUID"] = mBag and mBag.getGUID() or nil,
        ["vBaseGUID"] = vBase and vBase.getGUID() or nil, ["wBaseGUID"] = wBase and wBase.getGUID() or nil,
        ["tZoneGUID"] = tZone and tZone.getGUID() or nil,
        ["OWEnable"] = OWEnable, ["mapIsBuild"] = mapIsBuild, ["tBag"] = tBag,
        ["baseVGUID"] = baseVGUID, ["baseWGUID"] = baseWGUID
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    local loadedData = JSON.decode(savedData or "")
    if(loadedData) then
        baseVGUID = loadedData.baseVGUID or ""
        baseWGUID = loadedData.baseWGUID or ""
        OWEnable = loadedData.OWEnable or false
        mapIsBuild = loadedData.mapIsBuild or false
        tBag = loadedData.tBag or false
        aBag = loadedData.aBagGUID and getObjectFromGUID(loadedData.aBagGUID) or nil
        mBag = loadedData.mBagGUID and getObjectFromGUID(loadedData.mBagGUID) or nil
        vBase = loadedData.vBaseGUID and getObjectFromGUID(loadedData.vBaseGUID) or nil
        wBase = loadedData.wBaseGUID and getObjectFromGUID(loadedData.wBaseGUID) or nil
        tZone = loadedData.tZoneGUID and getObjectFromGUID(loadedData.tZoneGUID) or nil
        if(wBase) then aBase = getObjectFromGUID(wBase.getDescription()) end
    end

    r1, r2, r3 = 0, 0, 0
    lnk, ss, prs = "", "", ""
    sizeVPlate, sizeWPlate = 25, 1.85
    r90 = 0, 0
    wpx, pxy, nl, linkToMap, activeEdit = nil, nil, nil, nil, nil
    treeMap = {}
    currentBase = "x"
    toggleMapBuild = false
    if(OWEnable) then Wait.time(function() ContinueUnit() end, 1) end
end

function RecreateObjects(allObj)
    for _,g in ipairs(allObj) do
        if g.getName() == "_OW_vBase" then vBase = g end
    end
    reStart()
    local o, i = {}, {}
    i.image = self.UI.getCustomAssets()[4].url  i.thickness = 0.1
    if not vBase then
        local p, rotY = self.getPosition(), math.rad(self.getRotation().y)
        o.type = "Custom_Token" o.scale = {0.5, 1, 0.5} o.rotation = self.getRotation()
        o.position = {p[1] + 3*math.cos(rotY) + 1*math.sin(rotY), p[2] + 2.5, p[3] - 3*math.sin(rotY) - 1*math.cos(rotY)}
        vBase = spawnObject(o)
        vBase.setCustomObject(i)
    end
    if(not tZone) then
        local posZone = vBase.getPosition() + {x=0, y=vBase.getBoundsNormalized().size.y, z=0}
        o.type = "ScriptingTrigger" o.rotation = vBase.getRotation() o.position = posZone o.scale = vBase.getBoundsNormalized().size
        tZone = spawnObject(o)
    end
    Wait.time(|| PutVariable(), 0.2)
end
local function InitUnit(allObj)
    Wait.time(|| RecreateObjects(allObj), 0.2)
    if(not FindBags(allObj)) then return false end
    local s = ""
    if mBag.getName() == "Same_Name_Here" or aBag.getName() == "Same_Name_Here" then s = s.." ReName Your Bags." end
    if mBag.getName() != aBag.getName() then s = s.." Unmatched Bag Names." end
    if(#s > 0) then broadcastToAll(s, {0.943, 0.745, 0.14}) return false end
    if(currentBase) then
        local p = aBag.getPosition()
        if p[2] < -10 then vBaseOn = true
        else vBaseOn = false end
        broadcastToAll("(LOCK or continue from save)", {0.7, 0.7, 0.7})
        broadcastToAll("Initializing ONE WORLD...", {0.943, 0.745, 0.14})
        currentBase = nil
    end
    return true
end
function ContinueUnit()
    self.interactable = false self.lock()
    mBag.lock() mBag.interactable = false
    aBag.lock() aBag.interactable = false
    vBase.interactable = false vBase.lock()
    wBase.interactable = false wBase.lock()
    vBaseOn = true reStart()
    local p = aBag.getPosition()
    broadcastToAll("Continue ONE WORLD...", {0.943, 0.745, 0.14})
    currentBase = aBase.getGUID()
    local bn = ""
    bn, _, _, r1, r3, pxy, r90, lnk = ParceData(wBase.getDescription())
    self.UI.setAttribute("mainPanel", "active", true)
    local r = self.getRotation() if r[2] > 180 then r2 = -1 else r2 = 1 end
    broadcastToAll("Running Version: "..self.getDescription(), {0.943, 0.745, 0.14})
    SetUIText(bn)
    r1, r3, r90 = 0, 0, 0
    rotBase() Wait.time(|| SetUI(), 0.1)
end

function TogleEnable()
    if activeEdit then EditMode() return end
    if treeMap[1] != string.sub(aBag.getDescription(), 10) then reStart() end

    local p = self.getPosition()
    if not vBaseOn then
        self.UI.setAttribute("mainPanel", "active", true)
        local r = self.getRotation() if r[2] > 180 then r2 = -1 else r2 = 1 end
        self.interactable = false self.lock()
        mBag.lock() mBag.setScale({0, 0, 0}) mBag.setPosition({-10, -50, 10}) mBag.interactable = false
        aBag.lock() aBag.setScale({0, 0, 0}) aBag.setPosition({-10, -55, -10}) aBag.interactable = false
        self.setRotation({x=0, y=0, z=0})
        vBase.interactable = false vBase.lock() vBase.setScale({sizeVPlate, 1, sizeVPlate}) vBase.setPosition({0, 0.91, 0})
        wBase.interactable = false wBase.lock() wBase.setScale({sizeWPlate, 1, sizeWPlate}) wBase.setPosition({p[1], p[2] + 0.105, p[3] - (0.77*r2)})
        broadcastToAll("Running Version: "..self.getDescription(), {0.943, 0.745, 0.14})
        vBaseOn = true SetUIText()
        r1, r3, r90 = 0, 0, 0
        rotBase() Wait.time(|| SetUI(), 0.1)
        return
    end
    if not aBase then
        OWEnable = false
        self.UI.setAttribute("mainPanel", "active", false)
        self.UI.setAttribute("b2", "text", "←")
        self.UI.setAttribute("editMenuPanel", "active", false)
        vBaseOn = false
        self.interactable = true self.unlock() self.setPositionSmooth({p[1], p[2] + 0.1, p[3]})
        mBag.unlock() mBag.setScale({1, 1, 1}) mBag.setPosition({p[1] - 3, p[2] + 3, p[3]}) mBag.setPositionSmooth({p[1] - 3, p[2] + 2, p[3]})
        aBag.unlock() aBag.setScale({1, 1, 1}) aBag.setPosition({p[1], p[2] + 3, p[3]}) aBag.setPositionSmooth({p[1], p[2] + 2, p[3]})
        mBag.interactable = true aBag.interactable = true vBase.interactable = true vBase.unlock() vBase.setScale({0.5, 1, 0.5})
        vBase.setPosition({p[1] + 3, p[2] + 3, p[3] - 1}) vBase.setPositionSmooth({p[1] + 3, p[2] + 2, p[3] - 1})
        wBase.interactable = true  wBase.unlock() wBase.setScale({0.5, 1, 0.5})
        wBase.setPosition({p[1] + 3, p[2] + 3, p[3] + 1}) wBase.setPositionSmooth({p[1] + 3, p[2] + 2, p[3] + 1})
        wpx = nil
        reStart(self.UI.getAttribute("b1", "text")) Wait.time(|| SetUI(), 0.1)
        return
    end
    if tBag then ClearSet("true")
    else NoBase() end
    Wait.time(|| SetUI(), 0.1)
end

function PutVariable()
    local r = self.getRotation()
    if r[2] > 180 then r2 = -1 else r2 = 1 end

    vBase.setName("_OW_vBase") baseVGUID = vBase.getGUID()

    if vBaseOn then
        vBase.interactable = false
    end

    tZone.setName("_OW_tZone")

    Wait.condition(function()
        baseWGUID = wBase.getGUID()
        r = wBase.getRotation()
        if r[1] > 170 then
            r1 = 180
        end

        if r[3] > 170 then
            r3 = 180
        end

        local g = wBase.getDescription()
        if g != "" and getObjectFromGUID(g) then
            aBase = getObjectFromGUID(g)
            _, _, _, r1, r3, pxy, r90, lnk = ParceData(g)
        end
        if vBaseOn then
            wBase.interactable = false
        end
    end,
    function() return wBase ~= nil end)

    SetUIText()
    Wait.time(|| SetUI(), 0.1)
end

function reStart(what)
    treeMap = {} treeMap[1] = string.sub(aBag.getDescription(), 10) treeMap[0] = 1
    if treeMap[1] == "" then treeMap[1] = nil treeMap[0] = 0 end
    treeMap[-1] = treeMap[0]

    local o = {
        type = "ScriptingTrigger", scale = self.getBoundsNormalized().size + {x=0, y=10, z=0},
        position = self.getPosition() - {x=0, y=5, z=0}, rotation = self.getRotation()
    }
    do
        local zoneForSBx = spawnObject(o)
        Wait.condition(function()
        local zoneObj = zoneForSBx.getObjects()
        for i = 1, #zoneObj do
            if zoneObj[i].getName():find("SBx_") then
            if(what == "END") then
                Wait.time(function()
                    if(tZone) then tZone.destruct() tZone = nil end
                    aBag.putObject(zoneObj[i])
                end, 1)
            end
                if vBaseOn and zoneObj[i].guid == wBase.getDescription() then
                    if zoneObj[i].guid == treeMap[1] then
                        treeMap[2] = treeMap[1] treeMap[0] = 2 treeMap[-1] = 2
                    else
                        treeMap[2] = treeMap[1] treeMap[3] = zoneObj[i].guid treeMap[0] = 3 treeMap[-1] = 3
                    end
                end
            end
        end
        zoneForSBx.destruct()
        end, function() return #zoneForSBx.getObjects() > 0 end)
    end
    UpdateSave()
end

function SetUI()
    local forText, g = "", "Init"
    if vBaseOn then
        if wBase.getDescription() != "" then g = "CLR" else g = "END" end
    end
    self.UI.setAttribute("b1", "text", g)

    if wpx or pxy then forText = "*" end
    self.UI.setAttribute("b6", "text", forText)
    forText = "S"
    if toggleMapBuild then forText = "F" end
    self.UI.setAttribute("b10", "text", forText)

    for i = 1, 8 do
        self.UI.setAttribute("EMP"..i, "active", false)
    end
    if aBase then
        for i = 1, 6 do
            self.UI.setAttribute("EMP"..i, "active", true)
        end
    else
        for i = 7, 8 do
            self.UI.setAttribute("EMP"..i, "active", true)
        end
    end

    self.UI.setAttribute("b9", "active", false)
    if aBase then
        if aBase.getLuaScript() != "" and not pxy and string.sub(aBase.getName(), 5) == self.UI.getAttribute("mTxt", "text") then
            if(not tBag) then self.UI.setAttribute("b9", "active", true) end
        end
    end

    if(linkToMap) then
        self.UI.setAttribute("EMP1", "text", "unLink")
    else
        self.UI.setAttribute("EMP1", "text", "Link")
    end
end

function SetUIText(text)
    local g = text ~= nil and text or "One World"
    self.UI.setAttribute("mTxt", "text", g)
    local b = ParceData(treeMap[treeMap[0]])
    if(not aBase or g == b) then
        self.UI.setAttribute("mTxt", "textColor", "White")
    elseif(pxy) then
        self.UI.setAttribute("mTxt", "textColor", "Green")
    else
        self.UI.setAttribute("mTxt", "textColor", "Grey")
    end
end

function FindBags(allObj)
    local p, s = self.getPosition(), ""
    for _,g in ipairs(allObj) do
        if(g.getDescription() == "_OW_mBaG") then mBag = g end
        if(g.getDescription():find("_OW_aBaG")) then aBag = g end
        if(g.getName() == "_OW_wBase") then wBase = g end
    end
    if not mBag or not aBag then
        s = s.."Missing bags. Zone Object Bag and(or) Base Token Bag."
        CreateStartBags()
    end
    if not wBase then
        s = s.." Missing Hub View Token."
        WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/WBase.lua", self, "NewWBase")
    end
    if s != "" then
        broadcastToAll(s, {0.943, 0.745, 0.14})
        return false
    end
    return true
end
function NewWBase(request)
    local p, rotY = self.getPosition(), math.rad(self.getRotation().y)
    local o = {
        type = "Custom_Token", position = {p[1] + 3*math.cos(rotY) - 1*math.sin(rotY), p[2] + 2.5, p[3] - 3*math.sin(rotY) + 1*math.cos(rotY)},
        scale = {0.5, 1, 0.5}
    }
    wBase = spawnObject(o) wBase.setGMNotes(self.getGUID())
    local i = {
        image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg", thickness = 0.1
    }
    wBase.setCustomObject(i)
    wBase.setLuaScript(request.text) wBase.setName("_OW_wBase")
    wBase.setRotation(self.getRotation())
end

function cbTObj()
    wBase = getObjectFromGUID(baseWGUID) wBase.interactable = false
    vBase = getObjectFromGUID(baseVGUID) vBase.interactable = false
    if nl then wBase.call("MakeLink") end
    Wait.condition(function()
        local boundsSize = wBase.getBoundsNormalized().size
        if(r90 == 0 and (Round(boundsSize.x, 2) > 9.01 or Round(boundsSize.z, 2) > 5.35) or
            r90 == 1 and (Round(boundsSize.x, 2) > 5.35 or Round(boundsSize.z, 2) > 9.01)) then
            FitBase()
        end
        local sizeZone = {vBase.getBoundsNormalized().size.x, 10, vBase.getBoundsNormalized().size.z}
        local posZone = vBase.getPosition() + {x=0, y=5, z=0}
        tZone.setPosition(posZone) tZone.setScale(sizeZone) tZone.setRotation(vBase.getRotation())
        rotBase()
    end, function() return wBase and true or false end)
end
function FitBase()
    if isPVw() or not aBase or activeEdit then return end
    local baseSize = wBase.getBoundsNormalized().size baseSize.y = 1
    if baseSize.z > baseSize.x*1.05 then r90 = 1
    else r90 = 0 end
    baseSize.x = r90 == 0 and (9.01/baseSize.x)*sizeWPlate or (5.35/baseSize.x)*sizeWPlate
    baseSize.z = r90 == 0 and (5.35/baseSize.z)*sizeWPlate or (9.01/baseSize.z)*sizeWPlate
    wBase.setScale(baseSize)
    JotBase(string.format("{%f;%d;%f}", baseSize.x, 1, baseSize.z))
end

function rotBase()
    if(r90 == 0) then
        vBase.setRotation({0, r1, r3})
        if wpx == nil or wpx == wBase.getDescription() then wBase.setRotation({0, r1, r3}) wBase.call("SetLinks") end
    else
        vBase.setRotation({r3, 90, r1})
        if wpx == nil or wpx == wBase.getDescription() then wBase.setRotation({r3, 90, r1}) wBase.call("SetLinks") end
    end
end

function ClearSet(keepBase, delete)
    ButtonPack(delete, nil, nil, keepBase)
end

function JotBase(wScaleBase, vScaleBase)
    local e = string.char(10)
    local s, locS = aBag.getLuaScript(), ""
    local findGUID = "-"..wBase.getDescription()..","
    for strok in s:gmatch("[^\n]+") do
        if(not strok:find(findGUID)) then
            locS = locS..strok.."\n"
        end
    end
    local name = aBase.getName():sub(5)
    local strWScale = wScaleBase and wScaleBase or string.format("{%f;%d;%f}", wBase.getScale().x, 1, wBase.getScale().z)
    local strVScale = vScaleBase and vScaleBase or string.format("{%f;%d;%f}", vBase.getScale().x, 1, vBase.getScale().z)
    local parentFlag = pxy and 8 or 2
    aBag.setLuaScript(locS..string.format("--%s,%s,%s,%s,%s,%s,%s,%s,%s", aBase.getGUID(), name, strWScale, strVScale, r1, r3, parentFlag, r90, (lnk ~= nil and lnk ~= "" and lnk.."," or "")))
end

function NoBase()
    r1, r3, r90 = 0, 0, 0
    aBase, lnk = nil, ""
    wpx, pxy = nil, nil
    rotBase()
    wBase.setDescription("") wBase.setScale({sizeWPlate, 1, sizeWPlate})
    vBase.setScale({sizeVPlate, 1, sizeVPlate})
    local c = {} c.image = self.UI.getCustomAssets()[4].url
    vBase.setCustomObject(c) vBase.reload()
    wBase.setCustomObject(c) wBase.reload()
    SetUIText()
    Wait.time(|| cbTObj(), 0.2)
end

function GetBase(bGuid)
    linkToMap = nil
    if not vBaseOn or bGuid == wBase.getDescription() then return end
    if tBag then ClearSet() end
    wBase.setDescription("")
    local preLNK = lnk
    _, _, _, r1, r3, pxy, r90, lnk = ParceData(bGuid)
    aBase = nil
    if pxy and not wpx then
        wpx = bGuid
        broadcastToAll("Entering Parent View...", {0.286, 0.623, 0.118})
    elseif(wpx) then lnk = preLNK end
    if getObjectFromGUID(bGuid) then cbGetBase(getObjectFromGUID(bGuid)) return end

    local t = {
        guid = bGuid, position = {0,-3, 0}, rotation = {0, 0, 0},
        smooth = false, callback = "cbGetBase", callback_owner = self
    }
    aBag.takeObject(t)
    UpdateSave()
end
local function RollBack(guid)
    local n = 0
    for i = 2, treeMap[0] do if(treeMap[i] == guid) then n = i break end end
    if n == 0 then treeMap[0] = treeMap[0] + 1
    else for i = n, treeMap[0] do treeMap[i] = treeMap[i + 1] end end
    treeMap[treeMap[0]] = guid treeMap[-1] = treeMap[0]
end
function cbGetBase(base)
    local scalewBase, scalevBase = {}, {}
    _, scalewBase, scalevBase = ParceData(base.getGUID())
    local locPos = self.getPosition()
    base.setPosition({locPos.x, locPos.y - 0.5, locPos.z}) base.lock() base.interactable = false aBase = base
    wBase.setDescription(base.getGUID())
    local p = self.getPosition() wBase.setPosition({p[1], p[2] + 0.05, p[3] - (0.77*r2)})
    RollBack(base.getGUID())
    local v = {}
    if wpx and wpx != wBase.getDescription() then
        v.image = base.getCustomObject().image
    else
        wBase.setCustomObject({image = base.getCustomObject().image}) wBase.setScale(scalewBase) wBase.reload()
        if pxy then
            v.image = getObjectFromGUID(wpx).getCustomObject().image
        else
            v.image = base.getCustomObject().image
        end
    end
    vBase.setCustomObject(v) vBase.setScale(scalevBase) vBase.reload()
    rotBase() SetUIText(base.getName():sub(5))
    Wait.time(function()
        SetUI() cbTObj()
    end, 0.3)
end

function isPVw() if wpx then broadcastToAll("Action Canceled While in Parent View.", {0.943, 0.745, 0.14}) return true end end

function ParceData(bGuid)
    local h, k, e, s = string.char(45), string.char(44), string.char(10), aBag.getLuaScript()
    local fBase = string.find(s, k, string.find(s, h..bGuid..k))
    if not fBase then if vBaseOn then broadcastToAll("No base map.", {0.943, 0.745, 0.14}) end return end
    local d, dFlag = {}, false
    for w in aBag.getLuaScript():gmatch("[^,{}\n]+") do
        if(dFlag == true) then
            if(w:find("%-%-")) then break end
            table.insert(d, w)
        end
        if(w == "--" .. bGuid) then dFlag = true end
    end
    for i = 9, #d do
        d[8] = d[8]..","..d[i]
    end
    d[6] = tonumber(d[6])
    if d[6] == 0 then d[6] = 8
    elseif d[6] == 1 or d[6] == 2 then d[6] = nil end
    if wpx and wpx != bGuid then d[6] = nil end

    local scalewBase, i = {}, 1
    for w in d[2]:gmatch("[^;]+") do
        if(i == 1) then scalewBase.x = tonumber(w) end
        if(i == 2) then scalewBase.y = tonumber(w) end
        if(i == 3) then scalewBase.z = tonumber(w) end
        i = i + 1
    end
    local scalevBase, i = {}, 1
    for w in d[3]:gmatch("[^;]+") do
        if(i == 1) then scalevBase.x = tonumber(w) end
        if(i == 2) then scalevBase.y = tonumber(w) end
        if(i == 3) then scalevBase.z = tonumber(w) end
        i = i + 1
    end
    return d[1], scalewBase, scalevBase, tonumber(d[4]), tonumber(d[5]), d[6], tonumber(d[7]), d[8]
end

function mvPoint()
    if treeMap[-1] < 2 then
        treeMap[-1] = treeMap[0]
    end
    if treeMap[-1] > treeMap[0] then
        treeMap[-1] = 2
    end
    SetUIText(ParceData(treeMap[treeMap[-1]]))
    Wait.time(|| SetUI(), 0.1)
    if aBase and treeMap[-1] == treeMap[0] then
        self.UI.setAttribute("mTxt", "textColor", "#b15959")
    end
end

function CbImport()
    local p = self.getPosition()
    p[1] = p[1] - (5.5*r2)
    aBase.setPosition({p[1], p[2] + 4, p[3]})
    local e, k, s = string.char(10), string.char(44), string.sub(iBag.getName(), 5)
    local g = iBag.getDescription() aBase.setName("SBx_"..s)
    if(#g == 6) then
        g = g.."{1.85;1;1.85},{25.0;1.0;25.0},0,0,2,0"
        iBag.setDescription(g)
    elseif(not g:find("{")) then
        g = g:sub(1, 6).."{1.85;1;1.85},{25.0;1.0;25.0},0,0,2,0"
        iBag.setDescription(g)
    end
    s = aBag.getLuaScript()
    s = s.."\n--"..aBase.getGUID()..k..string.sub(aBase.getName(), 5)..string.sub(g, 7)..","..e aBag.setLuaScript(s)
    iBag.setDescription("")  iBag.setName("")  aBase.setDescription(iBag.guid)  
    getObjectFromGUID(getObjectFromGUID(currentBase).getDescription()).destruct() getObjectFromGUID(currentBase).destruct()  currentBase = nil
    broadcastToAll("Import Complete.", {0.943, 0.745, 0.14}) nl = aBase.getGUID() wBase.call("MakeLink")
    aBase.unlock() aBag.putObject(aBase) aBase = nil iBag.unlock() mBag.putObject(iBag) iBag = nil
end

function cbNABase(base)
    local p = self.getPosition() base.setScale({0.5, 1, 0.5}) base.setName("SBx_Name of Zone")
    p[1] = p[1] - (5.8 * r2)  base.setPosition({p[1], p[2] + 3, p[3]})
end

function CreateStartBags()
    if(not mBag) then
        WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/MBag.lua", self, "cbNMBag")
    end
    if(not aBag) then
        local p = {
        type = "Bag",
        callback_owner = self, callback = "cbNABag"
        } aBag = spawnObject(p)
    end
end
function cbNMBag(request)
    mBag = spawnObject({type = "Bag"}) mBag.setGMNotes(self.getGUID()) mBag.setLuaScript(request.text)
    mBag.setDescription("_OW_mBaG") mBag.setName("Same_Name_Here") mBag.setColorTint({0.713, 0.247, 0.313})
    local p, rotY = self.getPosition(), math.rad(self.getRotation().y)
    mBag.setPosition({p[1] - 3*math.cos(rotY), p[2] + 2.5, p[3] + 3*math.sin(rotY)})
    mBag.setPositionSmooth({p[1] - 3*math.cos(rotY), p[2] + 1.5, p[3] + 3*math.sin(rotY)})
end
function cbNABag(bag)
    bag.setDescription("_OW_aBaG") bag.setName("Same_Name_Here") bag.setColorTint({0.713, 0.247, 0.313})
    local p = self.getPosition()
    bag.setPosition({p[1], p[2] + 2.5, p[3]})
    bag.setPositionSmooth({p[1], p[2] + 1.5, p[3]})
end

function PutBase(guid)
    aBase = getObjectFromGUID(guid) JotBase()
    aBase.setLuaScript("") aBase.setDescription("") wBase.setDescription("")
    if not treeMap[1] then treeMap[1] = guid aBag.setDescription("_OW_aBaG_"..treeMap[1]) treeMap[0] = 1 end
    currentBase = guid broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
    Wait.time(|| cbPutBase(), 0.2)
end
function cbPutBase()
    nl = currentBase
    GetBase(currentBase)
    currentBase = nil
end

--- Buttons ---
function EnableOneWorld(_, _, id)
    if(aBag == null) then aBag = nil end if(mBag == null) then mBag = nil end
    if(vBase == null) then vBase = nil end if(wBase == null) then wBase = nil end

    if(self.UI.getAttribute(id, "text") == "Init") then
        OWEnable = true
        local posZone = self.getPosition() + {x=0, y=self.getScale().y*1.65, z=0}
        local o = {
            type = "ScriptingTrigger", position = posZone,
            rotation = self.getRotation(), scale = self.getBoundsNormalized().size + {x=0, y=3, z=0}
        }
        do
            local locZone = spawnObject(o)
            Wait.condition(function()
                if(InitUnit(locZone.getObjects())) then
                    Wait.time(|| TogleEnable(), 0.2)
                end
                locZone.destruct()
            end, function() return #locZone.getObjects() > 0 end,
            1, function()
                if(InitUnit(getAllObjects())) then
                    Wait.time(|| TogleEnable(), 0.2)
                end
                locZone.destruct()
            end)
        end
    else
        TogleEnable()
    end
end

function SelectMap()
    if(mapIsBuild) then broadcastToAll("Pack or Clear map", {0.94, 0.65, 0.02}) return end
    if activeEdit then EditMode() return end
    if not vBaseOn or not aBase then return end
    if linkToMap then GetBase(linkToMap) linkToMap = nil Wait.time(|| SetUI(), 0.1) return end
    if treeMap[-1] != treeMap[0] then GetBase(treeMap[treeMap[-1]]) SetUIText(ParceData(treeMap[treeMap[-1]])) end
end

function EditMenu(_, _, id)
    if(self.UI.getAttribute(id, "text") == "←") then
        self.UI.setAttribute(id, "text", "→")
        self.UI.setAttribute("editMenuPanel", "active", true)
    else
        self.UI.setAttribute(id, "text", "←")
        self.UI.setAttribute("editMenuPanel", "active", false)
    end
end

function ButtonVert() if isPVw() then return end if aBase then r3 = 180 - r3 rotBase() JotBase() end end
function ButtonHorz() if isPVw() then return end if aBase then r1 = 180 - r1 rotBase() JotBase() end end

function SettingSizeBase()
    self.UI.setAttribute("settingSizes", "active",
        self.UI.getAttribute("settingSizes", "active") == "false" and "true" or "false")
end

function ButtonParent()
    if not vBaseOn or not aBase then return end
    local v, f, g = {}, nil, "Ending Parent View..."
    if pxy then
        if wpx then
            if wpx == wBase.getDescription() then
                pxy = nil f = 1 v.image = aBase.getCustomObject().image
            end
            wpx = nil
        else
            pxy = nil f = 1 v.image = aBase.getCustomObject().image
        end
    else
        if wpx then
            v.image = aBase.getCustomObject().image
            _, _, _, r1, r3, pxy, r90, lnk = ParceData(aBase.getGUID())
            pxy = nil wpx = nil
            SetUIText() wBase.setCustomObject(v) wBase.reload()
            Wait.time(|| cbTObj(), 0.2)
        else
            if tBag then
                broadcastToAll("Pack or Clear Zone to Enter Parent View.", {0.943, 0.745, 0.14})
                return
            end
            pxy = true v.image = aBase.getCustomObject().image
            wpx = wBase.getDescription() g = "Entering Parent View..."
        end
    end
    if f then
        JotBase() vBase.setCustomObject(v) vBase.reload() Wait.time(|| cbTObj(), 0.2)
    end
    broadcastToAll(g, {0.286, 0.623, 0.118})
    Wait.time(|| SetUI(), 0.1)
end

function ButtonHome()
    if(activeEdit) then return end
    if wpx then
        wpx = nil
        GetBase(treeMap[1])
        return
    end
    if not vBaseOn then
        return 
    end
    linkToMap = nil Wait.time(|| SetUI(), 0.1)
    if treeMap[0] < 2 or not aBase then
        if treeMap[1] then
            GetBase(treeMap[1])
        end
        return
    end
    treeMap[-1] = treeMap[-1] + 1
    mvPoint()
end

function ButtonBack()
    if activeEdit then return end
    if wpx then  wpx = nil GetBase(treeMap[1]) return end
    if not vBaseOn then return end  linkToMap = nil  Wait.time(|| SetUI(), 0.1)
    if treeMap[0] < 3 then ButtonHome() return end
    if not aBase then  GetBase(treeMap[treeMap[0]]) return end
    treeMap[-1] = treeMap[-1] - 1
    mvPoint()
end

function ButtonBuild()
    if activeEdit then return end
    if currentBase then if string.sub(currentBase, 1, 3) == "xv." then newCode() return end end
    if not vBaseOn or not aBase then return end
    if aBase.getDescription() == "" then return end
    if ss != "" or prs != "" then
        broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})
        return
    end
    if #tZone.getObjects() > 0 then
        for _, item in ipairs(tZone.getObjects()) do
            if item.getName() ~= "_OW_vBase" then
                local iPos = item.getPosition()
                item.setPosition({iPos[1], tZone.getBoundsNormalized().size.y, iPos[3]})
            end
        end
    end
    broadcastToAll("Recalling Zone Objects...", {0.943, 0.745, 0.14})
    tBag = true
    local t = {
        smooth = false, guid = aBase.getDescription(), position = {-2, -46, 7},
        callback = "CreateBagBuild", callback_owner = mBag
    }
    mBag.takeObject(t)
    mapIsBuild = true
    UpdateSave()
end

function ButtonLink()
    if isPVw() then return end
    if not vBaseOn or not aBase then return end
    if linkToMap and treeMap[-1] == treeMap[0] and string.sub(aBase.getName(), 5) != self.UI.getAttribute("mTxt", "text") then
        local tLnk = {}
        for w in lnk:gmatch("[^,]+") do if(not w:find(linkToMap)) then table.insert(tLnk, w) end end
        lnk = ""
        for i,v in ipairs(tLnk) do lnk = lnk..v if(i ~= #tLnk) then lnk = lnk.."," end end
        nl = linkToMap
        linkToMap = nil
        SetUIText(aBase.getName():sub(5))
        JotBase()
        wBase.call("SetLinks")
        Wait.time(|| SetUI(), 0.1)
    else
        nl = aBase.getGUID()
    end
    wBase.call("MakeLink")
    linkToMap = nil
end

function ButtonPack(player, _, _, keepBase)
    if isPVw() then return end
    if not vBaseOn or not aBase then return end

    local preLoad = ""
    if player then
        local iPos, iGuid, iLock, iRot
        for _, item in ipairs(tZone.getObjects()) do
            iPos, iGuid = item.getPosition(), item.getGUID()
            iLock = item.getLock() and 1 or 0
            if item.getName() ~= "_OW_vBase" and
            not string.find("FogOfWarTrigger@ScriptingTrigger@3DText", item.name) and
            not item.hasTag("noPack") then
                ss = ss..item.guid..","
                iRot = item.getRotation()
                preLoad = preLoad.."--"..iGuid..","..iPos[1]..","..iPos[2]..","..iPos[3]..","..iRot[1]..","..iRot[2]..","..iRot[3]..","..iLock.."\n"
            end
        end
    end
    if #ss > 0 then
        tBag = false
        if(player) then
            aBase.setLuaScript(preLoad)
        end
        broadcastToAll("Packing Zone...", {0.943, 0.745, 0.14})
        local t = {}
        if(keepBase) then
            mBag.call("DoClear")
        else
            t = {
                type = "Bag", position = {0, 4, 0},
                callback_owner = mBag, callback = "DoPack"
            }
            spawnObject(t)
        end
        mapIsBuild = false
        UpdateSave()
    else
        broadcastToAll("(to empty a zone, use Delete)", {0.7, 0.7, 0.7})
        broadcastToAll("No Objects Found in Zone.", {0.943, 0.745, 0.14})
    end
end

function ButtonDelete()
    if isPVw() then return  end
    if not vBaseOn or not aBase then return end
    if aBase.getLuaScript() != "" and not tBag then broadcastToAll("Deploy Zone to Delete.", {0.943, 0.745, 0.14})  return end
    if tBag then
        currentBase = aBase.getGUID()
        ClearSet(nil, true) wBase.setDescription("")
        aBase.setLuaScript("")
        broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
    else
        local g = aBase.getGUID()
        if g == treeMap[1] then broadcastToAll("Can't Delete Home, Edit Art Instead.", {0.943, 0.745, 0.14}) return end
        local e, k, h, s = string.char(10), string.char(44), string.char(45), aBag.getLuaScript()
        treeMap[treeMap[0]] = nil
        treeMap[0] = treeMap[0] - 1
        local newS = ""
        for str in s:gmatch("[^\n]+") do
        if(str:find(h..g..k) == nil) then
            if(str:find(g) == nil) then
            newS = newS..str.."\n"
            else
            for word in str:gmatch("[^,]+") do
                if(word:find(g) == nil) then
                newS = newS..word..","
                end
            end
            newS = newS.."\n"
            end
        end
        end
        aBag.setLuaScript(newS)
        aBase.destruct()
        NoBase()
    end
    SetUIText()
    Wait.time(|| SetUI(), 0.1)
end

function ButtonCopy()
    if(isPVw()) then return end
    if(not vBaseOn or not aBase) then return end
    aBase = aBase.clone({position = {6, -28, 6}})
    broadcastToAll("...Copy Complete.", {0.943, 0.745, 0.14})
    local pos = self.getPosition() pos[1] = pos[1] - (5.7*r2) aBase.setRotation({0, 90, 0})  
    aBase.setPosition({pos[1], pos[2] + 2.5, pos[3]}) aBase.setLuaScript("") aBase.setDescription("")
    aBase.setName("SBx_Copy_"..string.sub(aBase.getName(), 5))
    aBase.unlock() SetUIText()
    Wait.time(|| SetUI(), 0.1)
end

function EditMode()
    if isPVw() then return end
    if not vBaseOn or wBase.getDescription() == "" then return end
    aBase = getObjectFromGUID(wBase.getDescription())
    if tBag then broadcastToAll("Pack or Clear Zone before Edit.", {0.943, 0.745, 0.14})  return end
    if not activeEdit then
        activeEdit = 1  local p = self.getPosition()
        broadcastToAll("Alter this Token: Name, Custom Art or Tint.", {0.943, 0.745, 0.14})
        self.UI.setAttribute("mTxt", "text", "Exit Edit Mode")
        self.UI.setAttribute("mTxt", "textColor", "#f1b531")
        aBase.interactable = true  aBase.unlock()  aBase.setRotation({0, 0, 0})  
        aBase.setPosition({p[1], p[2] + 3, p[3] + (4.7*r2)})
    else
        JotBase() StowBase() NoBase() SetUIText() activeEdit = nil
        broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
        Wait.time(|| SetUI(), 0.1)
    end
end
function StowBase()
    aBase.unlock()
    aBag.putObject(aBase)
    aBase = nil
end

function ButtonExport()
    if isPVw() then return  end
    if not vBaseOn or not aBase then return end
    if not tBag then broadcastToAll("Deploy Zone to Export.", {0.943, 0.745, 0.14}) return end
    broadcastToAll("Bagging Export...", {0.943, 0.745, 0.14})
    local t = {
        type = "Bag", position = self.getPosition()+{x=10,y=1,z=0},
        callback_owner = mBag, callback = "Export"
    } iBag = spawnObject(t)
end

function ButtonSeeAll()
    if not vBaseOn then return end
    broadcastToAll("Use the One World Logo.", {0.943, 0.745, 0.14})
    if aBase then treeMap = {} treeMap[-1] = 1 treeMap[0] = 1 treeMap[1] = aBase.getGUID() return end
    local s, t = aBag.getLuaScript(), {}
    for strok in s:gmatch("[^\n]+") do
        for w in strok:gmatch("[^,]+") do
            if(#w > 3) then table.insert(t, w:sub(3)) end
            break
        end
    end
    s = ""
    treeMap = {} treeMap[-1] = 2 treeMap[0] = #t + 1 treeMap[1] = t[1]
    for i,v in ipairs(t) do
        treeMap[i + 1] = v
    end
end

function ButtonNew()
    local p = {}  p.type = "Custom_Token"  p.position = {0, -23, 0}  p.rotation = {0, 90, 0}  p.callback = "cbNABase"
    p.callback_owner = self  local o = spawnObject(p)  local i = {}
    i.thickness = 0.1  i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/sample_token.png"  o.setCustomObject(i)
end
--- Buttons ---
--- Input ---
function ChangeSettingSize(player, input, id)
    self.UI.setAttribute(id, "text", input)
    id = id:sub(1, #id - 1)
    Wait.time(function()
        local strScale = string.format("{%s;1;%s}", self.UI.getAttribute(id.."X", "text"), self.UI.getAttribute(id.."Z", "text"))
        if(id:find("wBase")) then JotBase(strScale) end
        if(id:find("vBase")) then JotBase(nil, strScale) end
        broadcastToAll("{en}Update the base to confirm the changes{ru}Обновите базу для подтверждения изменений", {0.943, 0.745, 0.14})
        self.UI.setAttribute("b1", "text", "UPD")
        UpdateSave()
    end, 0.1)
end
--- Input ---
function Round(num, idp) return math.floor(num*(10^idp))/10^idp end

function toggleBuildMap()
    toggleMapBuild = not toggleMapBuild
    Wait.time(|| SetUI(), 0.1)
end