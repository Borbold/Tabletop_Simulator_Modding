local CONFIG = {
    OBJECT_NAMES = {
        VBASE = "_OW_vBase",
        WBASE = "_OW_wBase",
        MBAG = "_OW_mBaG",
        ABAG = "_OW_aBaG"
    },
    BAG_NAMES = {
        DEFAULT = "Same_Name_Here",
    },
    ZONE_PREFIX = "SBx_",
    UI_COLORS = {
        YELLOW = {0.94, 0.75, 0.14},
        GRAY = {0.7, 0.7, 0.7},
        GREEN = {0.29, 0.62, 0.12}
    },
    POSITIONS = {
        VBASE_ENABLED_Y = 0.91,
        WBASE_OFFSET_Y = 0.11,
        WBASE_OFFSET_Z_FACTOR = 0.77
    }
}
local BROADCAST_COLORS = CONFIG.UI_COLORS

local function safeGetGUID(obj)
    return obj and obj.getGUID() or nil
end
function UpdateSave()
    local dataToSave = {
        ["aBagGUID"] = safeGetGUID(aBag), ["mBagGUID"] = safeGetGUID(mBag),
        ["vBaseGUID"] = safeGetGUID(vBase), ["wBaseGUID"] = safeGetGUID(wBase),
        ["tZoneGUID"] = safeGetGUID(tZone),
        ["OWEnable"] = OWEnable, ["mapIsBuild"] = mapIsBuild, ["tBag"] = tBag,
        ["baseVGUID"] = baseVGUID, ["baseWGUID"] = baseWGUID
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

local function calculateRotationDirection()
    local selfRot = self.getRotation()
    r2 = selfRot[2] > 180 and -1 or 1
end
local function rotBase()
    local rotation = r90 == 0 and {0, r1, r3} or {r3, 90, r1}
    vBase.setRotation(rotation)
    if wpx == nil or wpx == wBase.getDescription() then
        wBase.setRotation(rotation)
        wBase.call("SetLinks")
    end
end
local function setObjectsInteractable(objects, isInteractable, isLocked)
    for _, obj in ipairs(objects) do
        if obj then
            obj.interactable = isInteractable
            if isLocked then
                obj.lock()
            else
                obj.unlock()
            end
        end
    end
end
local function ContinueUnit()
    setObjectsInteractable({self, mBag, aBag, vBase, wBase}, false, true)
    vBaseOn = true reStart()
    broadcastToAll("Continue ONE WORLD...", BROADCAST_COLORS.YELLOW)
    currentBase = aBase.getGUID()
    local bn = ""
    bn, _, _, r1, r3, pxy, r90, lnk = ParceData(wBase.getDescription())
    self.UI.setAttribute("mainPanel", "active", true)
    calculateRotationDirection()
    broadcastToAll("Running Version: "..self.getDescription(), BROADCAST_COLORS.YELLOW)
    SetUIText(bn)
    rotBase() Wait.time(|| SetUI(), 0.1)
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

    r1, r2, r3, r90 = 0, 0, 0, 0
    lnk, ss, prs = "", "", ""
    sizeVPlate, sizeWPlate = 25, 1.85
    wpx, pxy, nl, linkToMap, activeEdit = nil, nil, nil, nil, nil
    treeMap = {}
    currentBase = "x"
    toggleMapBuild = false
    if(OWEnable) then Wait.time(function() ContinueUnit() end, 1) end
end

local function OWSpawnObject(_type, _pos, _rot, _scale)
    return spawnObject({type = _type, position = _pos, rotation = _rot, scale = _scale})
end

function NewWBase(request)
    local rotY = math.rad(self.getRotation().y)
    local selfPos = self.getPosition() + {x=3*math.cos(rotY) - math.sin(rotY), y=2.5, z=math.cos(rotY) - 3*math.sin(rotY)}
    local selfRot, nSize = self.getRotation(), {0.5, 1, 0.5}
    wBase = OWSpawnObject("Custom_Token", selfPos, selfRot, nSize) wBase.setGMNotes(self.getGUID())
    wBase.setCustomObject({image = self.UI.getCustomAssets()[4].url, thickness = 0.1})
    wBase.setLuaScript(request.text) wBase.setName(CONFIG.OBJECT_NAMES.WBASE)
end
function NewVBase(request)
    local rotY = math.rad(self.getRotation().y)
    local selfPos = self.getPosition() + {x=3*math.cos(rotY) + math.sin(rotY), y=2.5, z=-(3*math.sin(rotY) + math.cos(rotY))}
    local selfRot, nSize = self.getRotation(), {0.5, 1, 0.5}
    vBase = OWSpawnObject("Custom_Token", selfPos, selfRot, nSize)
    vBase.setCustomObject({image = self.UI.getCustomAssets()[4].url, thickness = 0.1})
    vBase.setLuaScript(request.text) vBase.setName(CONFIG.OBJECT_NAMES.VBASE)
end

local function RecreateObjects(allObj)
    reStart()
    if(not tZone) then
        local posZone = self.getPosition() + {x=0, y=self.getBoundsNormalized().size.y, z=0}
        tZone = OWSpawnObject("ScriptingTrigger", posZone, self.getRotation(), self.getBoundsNormalized().size)
    end
    Wait.time(|| PutVariable(), 0.2)
end
local function CreateStartBags()
    if(not mBag) then
        WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/MBag.lua", self, "cbNMBag")
    end
    if(not aBag) then
        local setting = {
        type = "Bag",
        callback_owner = self, callback = "cbNABag"
        } aBag = spawnObject(setting)
    end
end
local function FindNeedObjects(allObj)
    local logS = ""
    for _,obj in ipairs(allObj) do
        if(obj.getDescription() == CONFIG.OBJECT_NAMES.MBAG) then mBag = obj
        elseif(obj.getDescription():find(CONFIG.OBJECT_NAMES.ABAG)) then aBag = obj
        elseif(obj.getName() == CONFIG.OBJECT_NAMES.WBASE) then wBase = obj
        elseif(obj.getName() == CONFIG.OBJECT_NAMES.VBASE) then vBase = obj end
    end
    if not mBag or not aBag then
        logS = logS.."Missing bags. Zone Object Bag and(or) Base Token Bag."
        CreateStartBags()
    end
    if not wBase then
        logS = logS.." Missing Hub View Token."
        WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/WBase.lua", self, "NewWBase")
    end
    if not vBase then
        logS = logS.." Missing Hub Map Token."
        WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/VBase.lua", self, "NewVBase")
    end
    if logS != "" then
        broadcastToAll(logS, BROADCAST_COLORS.YELLOW)
        return false
    end
    return true
end
local function InitUnit(allObj)
    Wait.time(|| RecreateObjects(allObj), 0.2)
    if(not FindNeedObjects(allObj)) then return false end
    local logStr = ""
    if mBag.getName() == CONFIG.BAG_NAMES.DEFAULT or aBag.getName() == CONFIG.BAG_NAMES.DEFAULT then logStr = logStr.." ReName Your Bags." end
    if mBag.getName() != aBag.getName() then logStr = logStr.." Unmatched Bag Names." end
    if(#logStr > 0) then broadcastToAll(logStr, BROADCAST_COLORS.YELLOW) return false end
    if(currentBase) then
        local selfPos = aBag.getPosition()
        if selfPos[2] < -10 then vBaseOn = true
        else vBaseOn = false end
        broadcastToAll("(LOCK or continue from save)", BROADCAST_COLORS.GRAY)
        broadcastToAll("Initializing ONE WORLD...", BROADCAST_COLORS.YELLOW)
        currentBase = nil
    end
    return true
end

local function positionObject(obj, position, scale, smooth)
    if not obj then return end
    
    obj.setScale(scale)
    if smooth then
        obj.setPositionSmooth(position)
    else
        obj.setPosition(position)
    end
end
local function positionObjectsForMode(selfPos, isEnabled)
    local mBagScale = isEnabled and {0, 0, 0} or {1, 1, 1}
    local aBagScale = isEnabled and {0, 0, 0} or {1, 1, 1}
    local vBaseScale = isEnabled and {sizeVPlate, 1, sizeVPlate} or {0.5, 1, 0.5}
    local wBaseScale = isEnabled and {sizeWPlate, 1, sizeWPlate} or {0.5, 1, 0.5}
    
    local mBagPos = isEnabled and {selfPos[1] - 3, selfPos[2] + 5, selfPos[3]} or {selfPos[1] - 3, selfPos[2] + 3, selfPos[3]}
    local aBagPos = isEnabled and {selfPos[1], selfPos[2] + 5, selfPos[3]} or {selfPos[1], selfPos[2] + 3, selfPos[3]}
    local vBasePos = isEnabled and {0, CONFIG.POSITIONS.VBASE_ENABLED_Y, 0} or {selfPos[1] + 3, selfPos[2] + 3, selfPos[3] - 1}
    local enableWPos = {selfPos[1], selfPos[2] + CONFIG.POSITIONS.WBASE_OFFSET_Y, selfPos[3] - CONFIG.POSITIONS.WBASE_OFFSET_Z_FACTOR * r2}
    local wBasePos = isEnabled and enableWPos or {selfPos[1] + 3, selfPos[2] + 3, selfPos[3] + 1}
    
    positionObject(mBag, mBagPos, mBagScale, not isEnabled)
    positionObject(aBag, aBagPos, aBagScale, not isEnabled)
    positionObject(vBase, vBasePos, vBaseScale, not isEnabled)
    positionObject(wBase, wBasePos, wBaseScale, not isEnabled)
end
function TogleEnable()
    if activeEdit then EditMode() return end
    if treeMap[1] != string.sub(aBag.getDescription(), 10) then reStart() end

    local selfPos = self.getPosition()
    if not vBaseOn then
        self.UI.setAttribute("mainPanel", "active", true)
        calculateRotationDirection()
        setObjectsInteractable({self, mBag, aBag, vBase, wBase}, false, true)
        positionObjectsForMode(selfPos, true)
        self.setRotation({x=0, y=0, z=0})
        broadcastToAll("Running Version: "..self.getDescription(), BROADCAST_COLORS.YELLOW)
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
        setObjectsInteractable({self, mBag, aBag, vBase, wBase}, true, false)
        positionObjectsForMode(selfPos, false)
        self.setPositionSmooth({selfPos[1], selfPos[2] + 0.1, selfPos[3]})
        wpx = nil
        reStart(self.UI.getAttribute("b1", "text")) Wait.time(|| SetUI(), 0.1)
        return
    end
    if tBag then ClearSet("true")
    else NoBase() end
    Wait.time(|| SetUI(), 0.1)
end

function PutVariable()
    calculateRotationDirection()
    if vBaseOn then vBase.interactable = false end

    tZone.setName("_OW_tZone")

    Wait.condition(function()
        baseWGUID = wBase.getGUID()
        local wBRot = wBase.getRotation()
        if wBRot[1] > 170 then r1 = 180 end
        if wBRot[3] > 170 then r3 = 180 end
        local desc = wBase.getDescription()
        if desc != "" and getObjectFromGUID(desc) then
            aBase = getObjectFromGUID(desc)
            _, _, _, r1, r3, pxy, r90, lnk = ParceData(desc)
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

    local selfPos, selfRot, selfBSize = self.getPosition() - {x=0, y=5, z=0}, self.getRotation(), self.getBoundsNormalized().size + {x=0, y=10, z=0}
    do
        local zoneForSBx = OWSpawnObject("ScriptingTrigger", selfPos, selfRot, selfBSize)
        Wait.condition(function()
        local zoneObj = zoneForSBx.getObjects()
        for i = 1, #zoneObj do
            if zoneObj[i].getName():find(CONFIG.ZONE_PREFIX) then
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
    local forText, logBut = "", "Init"
    if vBaseOn then
        if wBase.getDescription() != "" then logBut = "CLR" else logBut = "END" end
    end
    self.UI.setAttribute("b1", "text", logBut)

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
    local uiText = text ~= nil and text or "One World"
    self.UI.setAttribute("mTxt", "text", uiText)
    local b = ParceData(treeMap[treeMap[0]])
    if(not aBase or uiText == b) then
        self.UI.setAttribute("mTxt", "textColor", "White")
    elseif(pxy) then
        self.UI.setAttribute("mTxt", "textColor", "Green")
    else
        self.UI.setAttribute("mTxt", "textColor", "Grey")
    end
end

local function FitBase(limitW, limitH, baseSize, base)
    if isPVw() or not aBase or activeEdit then return end
    baseSize.x = r90 == 0 and (limitW/baseSize.x)*sizeWPlate or (limitH/baseSize.x)*sizeWPlate
    baseSize.y = 1
    baseSize.z = r90 == 0 and (limitH/baseSize.z)*sizeWPlate or (limitW/baseSize.z)*sizeWPlate
    base.setScale(baseSize)
    JotBase(string.format("{%f;%d;%f}", baseSize.x, 1, baseSize.z))
end
local function cbTObj()
    local limitW, limitH = 9.01, 5.35
    wBase = getObjectFromGUID(baseWGUID) wBase.interactable = false
    vBase = getObjectFromGUID(baseVGUID) vBase.interactable = false
    if nl then wBase.call("MakeLink") end
    Wait.Time(function()
        rotBase()
        local baseSize = wBase.getBoundsNormalized().size
        r90 = baseSize.z > baseSize.x*1.05 and 1 or 0
        if(r90 == 0 and (Round(baseSize.x, 2) > limitW or Round(baseSize.z, 2) > limitH) or
            r90 == 1 and (Round(baseSize.x, 2) > limitH or Round(baseSize.z, 2) > limitW)) then
            FitBase(limitW, limitH, baseSize, wBase)
        end
        local sizeZone = {vBase.getBoundsNormalized().size.x, 10, vBase.getBoundsNormalized().size.z}
        local posZone = vBase.getPosition() + {x=0, y=5, z=0}
        tZone.setPosition(posZone) tZone.setScale(sizeZone) tZone.setRotation(vBase.getRotation())
    end, 0.25)
end

function ClearSet(keepBase, delete)
    ButtonPack(delete, nil, nil, keepBase)
end

function JotBase(wScaleBase, vScaleBase)
    local e = string.char(10)
    local scr, locS = aBag.getLuaScript(), ""
    local findGUID = "-"..wBase.getDescription()..","
    for strok in scr:gmatch("[^\n]+") do
        if(not strok:find(findGUID)) then
            locS = locS..strok.."\n"
        end
    end
    local name = aBase.getName():sub(5)
    local strWScale = wScaleBase and wScaleBase or string.format("{%f;%d;%f}", wBase.getScale().x, 1, wBase.getScale().z)
    local strVScale = vScaleBase and vScaleBase or string.format("{%f;%d;%f}", vBase.getScale().x, 1, vBase.getScale().z)
    local parentFlag = pxy and 8 or 2
    --[[aBag.script_state = JSON.encode({
        ["saveInfo"] = locS..string.format("--%s,%s,%s,%s,%s,%s,%s,%s,%s",
        aBase.getGUID(), name, strWScale, strVScale, r1, r3, parentFlag, r90, (lnk ~= nil and lnk ~= "" and lnk.."," or ""))
    })
    print(JSON.decode(aBag.script_state).saveInfo)]]
    aBag.setLuaScript(
        locS..string.format("--%s,%s,%s,%s,%s,%s,%s,%s,%s",
        aBase.getGUID(), name, strWScale, strVScale, r1, r3, parentFlag, r90, (lnk ~= nil and lnk ~= "" and lnk.."," or ""))
    )
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
        broadcastToAll("Entering Parent View...", BROADCAST_COLORS.GREEN)
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
    rotBase()
    local selfPos = self.getPosition()
    wBase.setPosition({selfPos[1], selfPos[2] + 0.05, selfPos[3] - (CONFIG.POSITIONS.WBASE_OFFSET_Z_FACTOR * r2)})
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
    SetUIText(base.getName():sub(5))
    Wait.time(function()
        SetUI() cbTObj()
    end, 0.3)
end

function isPVw() if wpx then broadcastToAll("Action Canceled While in Parent View.", BROADCAST_COLORS.YELLOW) return true end end

function ParceData(bGuid)
    local h, k, e, scr = string.char(45), string.char(44), string.char(10), aBag.getLuaScript()
    local fBase = string.find(scr, k, string.find(scr, h..bGuid..k))
    if not fBase then if vBaseOn then broadcastToAll("No base map.", BROADCAST_COLORS.YELLOW) end return end
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
    local selfPos = self.getPosition() + {x=-5.5*r2, y=4, z=0}
    aBase.setPosition(selfPos)
    local e, k, bagName = string.char(10), string.char(44), string.sub(iBag.getName(), 5)
    local desc = iBag.getDescription() aBase.setName(CONFIG.ZONE_PREFIX..bagName)
    if(#desc == 6) then
        desc = desc.."{1.85;1;1.85},{25.0;1.0;25.0},0,0,2,0"
        iBag.setDescription(desc)
    elseif(not desc:find("{")) then
        desc = desc:sub(1, 6).."{1.85;1;1.85},{25.0;1.0;25.0},0,0,2,0"
        iBag.setDescription(desc)
    end
    local scr = aBag.getLuaScript()
    scr = scr.."\n--"..aBase.getGUID()..k..string.sub(aBase.getName(), 5)..string.sub(desc, 7)..","..e aBag.setLuaScript(scr)
    iBag.setDescription("")  iBag.setName("")  aBase.setDescription(iBag.guid)  
    getObjectFromGUID(getObjectFromGUID(currentBase).getDescription()).destruct() getObjectFromGUID(currentBase).destruct()  currentBase = nil
    broadcastToAll("Import Complete.", BROADCAST_COLORS.YELLOW) nl = aBase.getGUID() wBase.call("MakeLink")
    aBase.unlock() aBag.putObject(aBase) aBase = nil iBag.unlock() mBag.putObject(iBag) iBag = nil
end

function cbNABase(base)
    local selfPos = self.getPosition() + {x=-5.8*r2, y=3, z=0}
    base.setScale({0.5, 1, 0.5}) base.setName("SBx_Name of Zone")
    base.setPosition(selfPos)
end
function cbNMBag(request)
    mBag = spawnObject({type = "Bag"}) mBag.setGMNotes(self.getGUID()) mBag.setLuaScript(request.text)
    mBag.setDescription(CONFIG.OBJECT_NAMES.MBAG) mBag.setName(CONFIG.BAG_NAMES.DEFAULT) mBag.setColorTint({0.71, 0.25, 0.31})
    local selfPos, rotY = self.getPosition(), math.rad(self.getRotation().y)
    mBag.setPosition({selfPos[1] - 3*math.cos(rotY), selfPos[2] + 2.5, selfPos[3] + 3*math.sin(rotY)})
    mBag.setPositionSmooth({selfPos[1] - 3*math.cos(rotY), selfPos[2] + 1.5, selfPos[3] + 3*math.sin(rotY)})
end
function cbNABag(bag)
    bag.setDescription(CONFIG.OBJECT_NAMES.ABAG) bag.setName(CONFIG.BAG_NAMES.DEFAULT) bag.setColorTint({0.71, 0.25, 0.31})
    local selfPos = self.getPosition()
    bag.setPosition({selfPos[1], selfPos[2] + 2.5, selfPos[3]})
    bag.setPositionSmooth({selfPos[1], selfPos[2] + 1.5, selfPos[3]})
end

local function cbPutBase()
    nl = currentBase
    GetBase(currentBase)
    currentBase = nil
end
function PutBase(guid)
    aBase = getObjectFromGUID(guid) JotBase()
    aBase.setLuaScript("") aBase.setDescription("") wBase.setDescription("")
    if not treeMap[1] then treeMap[1] = guid aBag.setDescription("_OW_aBaG_"..treeMap[1]) treeMap[0] = 1 end
    currentBase = guid broadcastToAll("Packing Base...", BROADCAST_COLORS.YELLOW)
    Wait.time(|| cbPutBase(), 0.2)
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
    local v, f, logInfo = {}, nil, "Ending Parent View..."
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
            pxy, wpx = nil, nil
            SetUIText() wBase.setCustomObject(v) wBase.reload()
            Wait.time(|| cbTObj(), 0.2)
        else
            if tBag then
                broadcastToAll("Pack or Clear Zone to Enter Parent View.", BROADCAST_COLORS.YELLOW)
                return
            end
            v.image = aBase.getCustomObject().image
            pxy, logInfo = true, "Entering Parent View..."
            wpx = wBase.getDescription()
        end
    end
    if f then
        JotBase() vBase.setCustomObject(v) vBase.reload() Wait.time(|| cbTObj(), 0.2)
    end
    broadcastToAll(logInfo, BROADCAST_COLORS.GREEN)
    Wait.time(|| SetUI(), 0.1)
end

function ButtonHome()
    if(activeEdit) then return end
    if wpx then
        wpx = nil
        GetBase(treeMap[1])
        return
    end
    if not vBaseOn then return end
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
    if wpx then wpx = nil GetBase(treeMap[1]) return end
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
        broadcastToAll("The Current Zone is Busy...", BROADCAST_COLORS.YELLOW)
        return
    end
    if #tZone.getObjects() > 0 then
        for _, item in ipairs(tZone.getObjects()) do
            if item.getName() ~= CONFIG.OBJECT_NAMES.VBASE then
                local iPos = item.getPosition()
                item.setPosition({iPos[1], tZone.getBoundsNormalized().size.y, iPos[3]})
            end
        end
    end
    broadcastToAll("Recalling Zone Objects...", BROADCAST_COLORS.YELLOW)
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

local function shouldPackItem(item)
    local isNotVBase = item.getName() ~= CONFIG.OBJECT_NAMES.VBASE
    local isNotSpecialType = not string.find("FogOfWarTrigger@ScriptingTrigger@3DText", item.name)
    local isNotTaggedNoPack = not item.hasTag("noPack")
    return isNotVBase and isNotSpecialType and isNotTaggedNoPack
end
function ButtonPack(player, _, _, keepBase)
    if isPVw() then return end
    if not vBaseOn or not aBase then return end

    local preLoad = ""
    if player then
        ss = ""
        local iPos, iGuid, iLock, iRot
        local boundSizedTZone = tZone.getBoundsNormalized().size
        for _, item in ipairs(tZone.getObjects()) do
            iLock, iGuid, iPos = item.getLock() and 1 or 0, item.getGUID(), item.getPosition()
            if shouldPackItem(item) then
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
        broadcastToAll("Packing Zone...", BROADCAST_COLORS.YELLOW)
        local t = {}
        if(keepBase) then
            mBag.call("DoClear")
        else
            t = {
                type = "Bag", position = {0, 4, 0},
                callback_owner = mBag, callback = "DoPack"
            } spawnObject(t)
        end
        mapIsBuild = false
        UpdateSave()
    else
        broadcastToAll("(to empty a zone, use Delete)", BROADCAST_COLORS.GRAY)
        broadcastToAll("No Objects Found in Zone.", BROADCAST_COLORS.YELLOW)
    end
end

function ButtonDelete()
    if isPVw() then return  end
    if not vBaseOn or not aBase then return end
    if aBase.getLuaScript() != "" and not tBag then broadcastToAll("Deploy Zone to Delete.", BROADCAST_COLORS.YELLOW)  return end
    if tBag then
        currentBase = aBase.getGUID()
        ClearSet(nil, true) wBase.setDescription("")
        aBase.setLuaScript("")
        broadcastToAll("Packing Base...", BROADCAST_COLORS.YELLOW)
    else
        local guid = aBase.getGUID()
        if guid == treeMap[1] then broadcastToAll("Can't Delete Home, Edit Art Instead.", BROADCAST_COLORS.YELLOW) return end
        local e, k, h, scr = string.char(10), string.char(44), string.char(45), aBag.getLuaScript()
        treeMap[treeMap[0]] = nil
        treeMap[0] = treeMap[0] - 1
        local newS = ""
        for str in scr:gmatch("[^\n]+") do
        if(str:find(h..guid..k) == nil) then
            if(str:find(guid) == nil) then
            newS = newS..str.."\n"
            else
            for word in str:gmatch("[^,]+") do
                if(word:find(guid) == nil) then
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
    broadcastToAll("...Copy Complete.", BROADCAST_COLORS.YELLOW)
    local selfPos = self.getPosition() + {x=-5.7*r2, y=2.5, z=0}
    aBase.setRotation({0, 90, 0})  
    aBase.setPosition(selfPos) aBase.setLuaScript("") aBase.setDescription("")
    aBase.setName("SBx_Copy_"..string.sub(aBase.getName(), 5))
    aBase.unlock() SetUIText()
    Wait.time(|| SetUI(), 0.1)
end

function EditMode()
    if isPVw() then return end
    if not vBaseOn or wBase.getDescription() == "" then return end
    aBase = getObjectFromGUID(wBase.getDescription())
    if tBag then broadcastToAll("Pack or Clear Zone before Edit.", BROADCAST_COLORS.YELLOW)  return end
    if not activeEdit then
        activeEdit = 1
        local selfPos = self.getPosition() + {x=0, y=3, z=4.7*r2}
        broadcastToAll("Alter this Token: Name, Custom Art or Tint.", BROADCAST_COLORS.YELLOW)
        self.UI.setAttribute("mTxt", "text", "Exit Edit Mode")
        self.UI.setAttribute("mTxt", "textColor", "#f1b531")
        aBase.interactable = true aBase.unlock() aBase.setRotation({0, 0, 0})  
        aBase.setPosition(selfPos)
    else
        JotBase() StowBase() NoBase() SetUIText() activeEdit = nil
        broadcastToAll("Packing Base...", BROADCAST_COLORS.YELLOW)
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
    if not tBag then broadcastToAll("Deploy Zone to Export.", BROADCAST_COLORS.YELLOW) return end
    broadcastToAll("Bagging Export...", BROADCAST_COLORS.YELLOW)
    local t = {
        type = "Bag", position = self.getPosition()+{x=10,y=1,z=0},
        callback_owner = mBag, callback = "Export"
    } iBag = spawnObject(t)
end

function ButtonSeeAll()
    if not vBaseOn then return end
    broadcastToAll("Use the One World Logo.", BROADCAST_COLORS.YELLOW)
    if aBase then treeMap = {} treeMap[-1] = 1 treeMap[0] = 1 treeMap[1] = aBase.getGUID() return end
    local scr, t = aBag.getLuaScript(), {}
    for strok in scr:gmatch("[^\n]+") do
        for w in strok:gmatch("[^,]+") do
            if(#w > 3) then table.insert(t, w:sub(3)) end
            break
        end
    end
    treeMap = {} treeMap[-1] = 2 treeMap[0] = #t + 1 treeMap[1] = t[1]
    for i,v in ipairs(t) do
        treeMap[i + 1] = v
    end
end

function ButtonNew()
    local setting = {
        type = "Custom_Token", position = {0, -23, 0}, rotation = {0, 90, 0},
        callback_owner = self, callback = "cbNABase"
    } local o = spawnObject(setting)
    o.setCustomObject({image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/sample_token.png", thickness = 0.1})
end

function TMBaseSize()
    local baseSize = wBase.getBoundsNormalized().size
    local xInp = r90 == 0 and (9.01/baseSize.x)*18 or (5.35/baseSize.x)*18
    local zInp = r90 == 0 and (5.35/baseSize.z)*18 or (9.01/baseSize.z)*18
    local id = "vBase"
    self.UI.setAttribute(id.."X", "text", xInp)
    self.UI.setAttribute(id.."Z", "text", zInp)
    Wait.time(function()
        local strScale = string.format("{%s;1;%s}", self.UI.getAttribute(id.."X", "text"), self.UI.getAttribute(id.."Z", "text"))
        JotBase(nil, strScale)
        broadcastToAll("{en}Update the base to confirm the changes{ru}Обновите базу для подтверждения изменений", BROADCAST_COLORS.YELLOW)
        self.UI.setAttribute("b1", "text", "UPD")
        UpdateSave()
    end, 0.1)
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
        broadcastToAll("{en}Update the base to confirm the changes{ru}Обновите базу для подтверждения изменений", BROADCAST_COLORS.YELLOW)
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