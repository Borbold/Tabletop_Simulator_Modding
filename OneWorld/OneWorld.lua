function UpdateSave()
  local dataToSave = {
    ["tSizeVPlates"] = tSizeVPlates,
    ["aBagGUID"] = aBag and aBag.getGUID() or nil, ["mBagGUID"] = mBag and mBag.getGUID() or nil,
    ["vBaseGUID"] = vBase and vBase.getGUID() or nil, ["wBaseGUID"] = wBase and wBase.getGUID() or nil,
    ["tZoneGUID"] = tZone and tZone.getGUID() or nil
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  local loadedData = JSON.decode(savedData or "")
  tSizeVPlates = loadedData and loadedData.tSizeVPlates or {}
  if(loadedData) then
    aBag = loadedData.aBagGUID and getObjectFromGUID(loadedData.aBagGUID) or nil
    mBag = loadedData.mBagGUID and getObjectFromGUID(loadedData.mBagGUID) or nil
    vBase = loadedData.vBaseGUID and getObjectFromGUID(loadedData.vBaseGUID) or nil
    wBase = loadedData.wBaseGUID and getObjectFromGUID(loadedData.wBaseGUID) or nil
    tZone = loadedData.tZoneGUID and getObjectFromGUID(loadedData.tZoneGUID) or nil
  end

  r1, r2, r3 = 0, 0, 0
  lnk, ss, prs, baseVGUID, baseWGUID = "", "", "", "", ""
  sizeVPlate, sizeWPlate = 25, 1.85
  r90 = 0, 0
  wpx, pxy, aBase, nl, linkToMap, butActive = nil, nil, nil, nil, nil, nil
  ba = {}
  currentBase = "x"
  prevTime = os.clock()
end

function SelectMap()
  if butActive then EditMode() return end
  if not vBaseOn or not aBase then return end
  if linkToMap then GetBase({linkToMap}) linkToMap = nil Wait.time(|| SetUI(), 0.1) return end
  if ba[-1] != ba[0] then GetBase({ba[ba[-1]]}) SetUIText(ParceData({ba[ba[-1]]})) end
end

function RecreateObjects(allObj)
  for _,g in ipairs(allObj) do
    if g.getName() == "_OW_vBase" then vBase = g end
  end
  reStart()
  local o, i = {}, {}
  i.image = self.UI.getCustomAssets()[4].url  i.thickness = 0.1
  if not vBase then
    local p = self.getPosition()
    o.type = "Custom_Token" o.scale = {0.5, 1, 0.5} o.position = {p[1] + 3, p[2] + 2.5, p[3] - 1}
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
function EnableOneWorld(_, _, id)
  if(aBag == null) then aBag = nil end if(mBag == null) then mBag = nil end
  if(vBase == null) then vBase = nil end if(wBase == null) then wBase = nil end

  if(self.UI.getAttribute(id, "text") == "Init") then
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
function InitUnit(allObj)
  Wait.time(|| RecreateObjects(allObj), 0.2)
  if(not FindBags(allObj)) then return false end
  local s = ""
  if mBag.getName() == "Same_Name_Here" or aBag.getName() == "Same_Name_Here" then s = s.." ReName Your Bags." end
  if mBag.getName() != aBag.getName() then s = s.." Unmatched Bag Names." end
  if(#s > 0) then broadcastToAll(s, {0.943, 0.745, 0.14}) return false end
  if(currentBase) then
    if(string.sub(currentBase, 1, 1) != "x") then udShow() return false end
    local p = aBag.getPosition()
    if p[2] < -10 then vBaseOn = true
    else vBaseOn = false end
    broadcastToAll("(LOCK or continue from save)", {0.7, 0.7, 0.7})
    broadcastToAll("Initializing ONE WORLD...", {0.943, 0.745, 0.14})
    currentBase = nil
  end
  return true
end
function TogleEnable()
  if butActive then EditMode() return end
  if ba[1] != string.sub(aBag.getDescription(), 10) then reStart() end

  local p = self.getPosition()
  if not vBaseOn then
    self.UI.setAttribute("mainPanel", "active", true)
    local r = self.getRotation()  if r[2] > 180 then r2 = -1 else r2 = 1  end
    self.interactable = false self.lock()
    self.setRotation({0, (2-r2)*90, 0})  self.setScale({2.2,1,2.2})
    mBag.lock()  mBag.setScale({0, 0, 0})  mBag.setPosition({-3,-50, 3})  mBag.interactable = false
    aBag.lock()  aBag.setScale({0, 0, 0})  aBag.setPosition({-3,-55, -3}) aBag.interactable = false
    vBase.interactable = false  vBase.lock() vBase.setScale({sizeVPlate, 1, sizeVPlate}) vBase.setPosition({0, 0.91, 0})
    wBase.interactable = false  wBase.lock() wBase.setScale({sizeWPlate, 1, sizeWPlate}) wBase.setPosition({p[1], p[2]+0.105, p[3]+(0.77*r2)})
    broadcastToAll("Running Version: "..self.getDescription(), {0.943, 0.745, 0.14})
    vBaseOn = true SetUIText()
    r1, r3, r90 = 0, 0, 0
    rotBase() Wait.time(|| SetUI(), 0.1)
    return
  end
  if not aBase then
    self.UI.setAttribute("mainPanel", "active", false)
    self.UI.setAttribute("b2", "text", "←")
    self.UI.setAttribute("editMenuPanel", "active", false)
    vBaseOn = false
    self.interactable = true self.unlock() self.setPositionSmooth({p[1], p[2]+0.1, p[3]})
    mBag.unlock() mBag.setScale({1, 1, 1}) mBag.setPosition({p[1]-3, p[2]+3, p[3]}) mBag.setPositionSmooth({p[1]-3, p[2]+2.5, p[3]})
    aBag.unlock() aBag.setScale({1, 1, 1}) aBag.setPosition({p[1], p[2]+3, p[3]}) aBag.setPositionSmooth({p[1], p[2]+2.5, p[3]})
    mBag.interactable = true aBag.interactable = true vBase.interactable = true vBase.unlock() vBase.setScale({0.5, 1, 0.5})
    vBase.setPosition({p[1]+3, p[2]+3, p[3]-1}) vBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]-1})
    wBase.interactable = true  wBase.unlock() wBase.setScale({0.5, 1, 0.5})
    wBase.setPosition({p[1]+3, p[2]+3, p[3]+1}) wBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]+1})
    wpx = nil
    reStart(self.UI.getAttribute("b1", "text")) Wait.time(|| SetUI(), 0.1)
    return
  end
  if tBag then ClearSet()
  else NoBase() end
  Wait.time(|| SetUI(), 0.1) SetUIText()
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

function PutVariable()
  local r = self.getRotation()
  if r[2] > 180 then
    r2 = -1
  else
    r2 = 1
  end

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
      _, scalewBase, r1, r3, pxy, r90, lnk = ParceData({g})
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
  prs, ss = "", ""
  ba = {} ba[1] = string.sub(aBag.getDescription(), 10) ba[0] = 1
  if ba[1] == "" then ba[1] = nil ba[0] = 0 end
  ba[-1] = ba[0]

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
            if zoneObj[i].guid == ba[1] then
              ba[2] = ba[1]  ba[0] = 2  ba[-1] = 2
            else
              ba[2] = ba[1]  ba[3] = zoneObj[i].guid  ba[0] = 3  ba[-1] = 3
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
  self.UI.setAttribute("b6", "tooltip", "Parent")

  for i = 1, 8 do
    self.UI.setAttribute("EMP"..i, "active", false)
  end
  if(aBase) then
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
      if tBag then
        forText = "sync"
      else
        forText = "BUILD"
      end
      self.UI.setAttribute("b9", "active", true)
      self.UI.setAttribute("b9", "text", forText)
    end
  end

  if(linkToMap) then
    self.UI.setAttribute("EMP1", "text", "unLink")
  else
    self.UI.setAttribute("EMP1", "text", "Link")
  end
end

function SetUIText(a)
  local g = a ~= nil and a or "One World"
  self.UI.setAttribute("mTxt", "text", g)
  local b = ParceData({ba[ba[0]]})
  if(not aBase or g == b) then
    self.UI.setAttribute("mTxt", "textColor", "White")
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
    broadcastToAll("Missing bags. Zone Object Bag and(or) Base Token Bag", {0.943, 0.745, 0.14})
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
  local p = self.getPosition()
  local o = {
    type = "Custom_Token", position = {p[1] + 3, p[2] + 2.5, p[3] + 1},
    scale = {0.5, 1, 0.5}
  }
  wBase = spawnObject(o) wBase.setGMNotes(self.getGUID())
  local i = {
    image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg", thickness = 0.1
  }
  wBase.setCustomObject(i)
  wBase.setLuaScript(request.text) wBase.setName("_OW_wBase")
end

function cbTObj()
  wBase = getObjectFromGUID(baseWGUID) wBase.interactable = false
  vBase = getObjectFromGUID(baseVGUID) vBase.interactable = false
  if nl then wBase.call("MakeLink") end
  self.setRotation({0, (2 - r2)*90, 0})
  rotBase()
  local sizeZone = {vBase.getBoundsNormalized().size.x, 10, vBase.getBoundsNormalized().size.z}
  local posZone = vBase.getPosition() + {x=0, y=5, z=0}
  tZone.setPosition(posZone) tZone.setScale(sizeZone) tZone.setRotation(vBase.getRotation())
  
  Wait.time(function()
    local boundsSize = wBase.getBoundsNormalized().size
    if(r90 == 0 and (boundsSize.x > 9.01 or boundsSize.z > 5.35) or
        r90 == 90 and (boundsSize.x > 5.35 or boundsSize.z > 9.01)) then
      FitBase()
    end
  end, 0.01, 4)
end

function ButtonHorz() if isPVw() then return end if aBase then r1 = 180 - r1 + r90 rotBase() JotBase() end end
function ButtonVert() if isPVw() then return end if aBase then r3 = 180 - r3 rotBase() JotBase() end end

function FitBase()
  if isPVw() or not aBase or butActive then return end
  local baseSize = wBase.getBoundsNormalized().size baseSize.y = 1
  if baseSize.z > baseSize.x*1.05 then r90 = 90
  else r90 = 0 end
  baseSize.x = r90 == 0 and (9.01/baseSize.x)*sizeWPlate or (5.35/baseSize.x)*sizeWPlate
  baseSize.z = r90 == 0 and (5.35/baseSize.z)*sizeWPlate or (9.01/baseSize.z)*sizeWPlate
  wBase.setScale(baseSize)
  JotBase(string.format("{%f;%d;%f}", baseSize.x, 1, baseSize.z))
end

function SettingSizeBase()
  self.UI.setAttribute("settingSizes", "active",
    self.UI.getAttribute("settingSizes", "active") == "false" and "true" or "false")
end
function ChangeSettingSize(player, input, id)
  self.UI.setAttribute(id, "text", input)
  id = id:sub(1, #id - 1)
  Wait.time(function()
    local strScale = string.format("{%s;1;%s}", self.UI.getAttribute(id.."X", "text"), self.UI.getAttribute(id.."Z", "text"))
    if(id:find("wBase")) then JotBase(strScale) end
    if(id:find("vBase")) then tSizeVPlates[aBase.getGUID()] = {} for w in strScale:gmatch("[^(;{})]+") do table.insert(tSizeVPlates[aBase.getGUID()], tonumber(w)) end end
    broadcastToAll("{en}Update the base to confirm the changes{ru}Обновите базу для подтверждения изменений", {0.943, 0.745, 0.14})
    self.UI.setAttribute("b1", "text", "UPD")
    UpdateSave()
  end, 0.1)
end

function rotBase()
  vBase.setRotation({0, r1, r3})
  if wpx == nil or wpx == wBase.getDescription() then wBase.setRotation({0, r1, r3}) wBase.call("SetLinks") end
end

function ButtonProxy()
  if not vBaseOn or not aBase then return end
  local v, f, g = {}, nil, "Ending Parent View..."
  if pxy then
    if wpx then
      if wpx == wBase.getDescription() then
        pxy = nil  f = 1  v.image = aBase.getCustomObject().image 
      end  wpx = nil
    else
      pxy = nil  f = 1  v.image = aBase.getCustomObject().image 
    end
  else
    if wpx then
      wpx = nil  v.image = aBase.getCustomObject().image bn, scalewBase, r1, r3, pxy, r90, lnk = ParceData({aBase.getGUID()})  pxy = nil
      SetUIText()  wBase.setCustomObject(v)  wBase.reload()  Wait.time(|| cbTObj(), 0.2)
    else
      if tBag then  broadcastToAll("Pack or Clear Zone to Enter Parent View.", {0.943, 0.745, 0.14})  return  end
      pxy = 8  f = 1  v.image = aBase.getCustomObject().image 
      wpx = wBase.getDescription()  g = "Entering Parent View..."
    end
  end
  if f then
    JotBase() vBase.setCustomObject(v) vBase.reload() Wait.time(|| cbTObj(), 0.2)
  end
  broadcastToAll(g, {0.286, 0.623, 0.118})
  Wait.time(|| SetUI(), 0.1)
end

function ButtonPack()
  if isPVw() then return  end
  if not vBaseOn or not aBase then return end
  if ss != "" or prs != "" then broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14}) return end
  local p, f, u, r, m  local s = "" allObj = tZone.getObjects() local a, k = string.char(10), string.char(44)
  for _,g in ipairs(allObj) do
      p = g.getPosition() f = g.getGUID() u = 0
      if g.getLock() then u = 1 end
      if g.name ~= "_OW_vBase" then
          if string.find("059864@3761d8@ff9bc3@2deca3@649822", f) then m = 1 end
          if not string.find("FogOfWarTrigger@ScriptingTrigger@3DText", g.name) and not string.find(vBase.getGUID(), f) then
            ss = ss..g.guid  r = g.getRotation()  s = s.."--"..f..k..p[1]..k..p[2]..k..p[3]..k..r[1]..k..r[2]..k..r[3]..k..u..a
          end
      end
  end
  if ss != "" then
    if m then ss = ""  broadcastToAll("Pack Canceled. Remove SkyBox Tool.", {0.943, 0.745, 0.14})
    else
      tBag = false
      aBase.setLuaScript(s)
      broadcastToAll("Packing Zone...", {0.943, 0.745, 0.14})
      local t = {
        type = "Bag", position = {0, 4, 0},
        callback_owner = mBag, callback = "DoPack"
      } spawnObject(t)
    end
  else
    broadcastToAll("(to empty a zone, use Delete)", {0.7, 0.7, 0.7})
    broadcastToAll("No Objects Found in Zone.", {0.943, 0.745, 0.14})
  end
end

function JotBase(jotScaleW)
  local e, h = string.char(10), string.char(45)
  local x
  local s = aBag.getLuaScript()
  if s == "" then s = "--" end
  local n = string.len(s)
  if n < 6 then aBag.setDescription("_OW_aBaG_"..aBase.getGUID()) end
  if pxy then x = 8 else x = 2 end
  while string.sub(s, n) != "-" do  s = string.sub(s, 1, n-1)  n = n-1  end
  n = string.find(s, h..wBase.getDescription()..",")
  if n then s = string.sub(s, 1, n - 2)..string.sub(s, string.find(s, e, n) + 1) end
  local name = string.sub(aBase.getName(), 5)  name = string.gsub(name, ",", ";")
  if r90 != 1 then
    if math.abs(wBase.getScale().x - wBase.getScale().z) > 0.01 then
      r90 = 2
    else
      r90 = 0
    end
  end
  local strScale = jotScaleW and jotScaleW or string.format("{%f;%d;%f}", wBase.getScale().x, 1, wBase.getScale().z)
  aBag.setLuaScript(s..string.format("%s,%s,%s,%s,%s,%s,%s,%s\n--", aBase.getGUID(), name, strScale, r1, r3, x, r90, (lnk ~= nil and lnk ~= "" and lnk.."," or "")))
end

function StowBase()
  aBase.unlock()
  aBag.putObject(aBase)
  aBase = nil
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
  Wait.time(|| cbTObj(), 0.2)
end

function GetBase(a)
  linkToMap = nil
  if not vBaseOn or a[1] == wBase.getDescription() then return end
  if tBag then ClearSet() end
  wBase.setDescription("")
  bn, scalewBase, r1, r3, pxy, r90, lnk = ParceData({a[1]})
  wBase.setScale(scalewBase)
  if(aBase and tSizeVPlates[aBase.getGUID()]) then vBase.setScale(tSizeVPlates[aBase.getGUID()]) end
  aBase = nil
  if bn == nil then return end
  if pxy and not wpx then wpx = a[1] broadcastToAll("Entering Parent View...", {0.286, 0.623, 0.118}) end
  if getObjectFromGUID(a[1]) then cbGetBase(getObjectFromGUID(a[1])) return end
  
  local t = {} t.guid = a[1] t.position = {0,-3, 0} t.rotation = {0, 0, 0} t.smooth = false
  t.callback = "cbGetBase" t.callback_owner = self
  aBag.takeObject(t)
  UpdateSave()
end
function cbGetBase(a)
  local locPos = self.getPosition()
  a.setPosition({locPos.x, locPos.y - 0.5, locPos.z})  a.lock()  a.interactable = false aBase = a
  wBase.setDescription(a.guid)
  local p = self.getPosition() wBase.setPosition({p[1], p[2] + 0.05, p[3] + (0.77*r2)})
  rotBase() SetUIText() rollBack({a.guid})
  wBase.setCustomObject({image = a.getCustomObject().image}) wBase.reload()
  vBase.setCustomObject({image = a.getCustomObject().image}) vBase.reload()
  SetUIText(a.getName():sub(5))
  Wait.time(function()
    SetUI() cbTObj()
  end, 0.3)
end

function isPVw()  if wpx then broadcastToAll("Action Canceled While in Parent View.", {0.943, 0.745, 0.14})  return true  end  end

function ParceData(a)
  local h, k, e, s = string.char(45), string.char(44), string.char(10), aBag.getLuaScript()
  local g, n = a[1], string.find(s, k, string.find(s, h..a[1]..k))
  local m = n
  if not n then broadcastToAll("No base map.", {0.943, 0.745, 0.14})  return end
  local d, dFlag = {}, false
  for w in aBag.getLuaScript():gmatch("[^,--{}]+") do
    if(dFlag) then
      if(w == "\n") then break end
      table.insert(d, w)
    end
    if(a[1] == w) then dFlag = true end
  end
  for i = 8, #d do
    d[7] = d[7]..","..d[i]
  end
  d[5] = tonumber(d[5])
  if d[5] == 0 then d[5] = 8
  elseif d[5] == 1 or d[5] == 2 then d[5] = nil end
  if wpx and wpx != g then d[5] = nil end

  local scalewBase, i = {}, 1
  for w in d[2]:gmatch("[^(;)]+") do
    if(i == 1) then scalewBase.x = tonumber(w) end
    if(i == 2) then scalewBase.y = tonumber(w) end
    if(i == 3) then scalewBase.z = tonumber(w) end
    i = i + 1
  end
  return string.gsub(d[1], ";", ","), scalewBase, tonumber(d[3]), tonumber(d[4]), d[5], tonumber(d[6]), d[7]
end

function ClearSet()
  ss, prs = "", ""
  ButtonPack()
end

function ButtonHome()
  if wpx then
    wpx = nil
    GetBase({ba[1]})
    return
  end
  if butActive then
    EditMode()
    return
  end
  if not vBaseOn then
    return 
  end
  linkToMap = nil Wait.time(|| SetUI(), 0.1)
  if ba[0] < 2 or not aBase then
    if ba[1] then
      GetBase({ba[1]})
    end
    return
  end
  ba[-1] = ba[-1] + 1
  mvPoint()
end
function ButtonBack()
  if wpx then  wpx = nil  GetBase({ba[1]})  return end
  if butActive then EditMode()  return end
  if not vBaseOn then return end  linkToMap = nil  Wait.time(|| SetUI(), 0.1)
  if ba[0] < 3 then ButtonHome()  return  end
  if not aBase then  GetBase({ba[ba[0]]}) return end
  ba[-1] = ba[-1]-1
  mvPoint()
end
function mvPoint()
  if ba[-1] < 2 then
    ba[-1] = ba[0]
  end
  if ba[-1] > ba[0] then
    ba[-1] = 2
  end
  SetUIText(ParceData({ba[ba[-1]]}))
  Wait.time(|| SetUI(), 0.1)
  if aBase and ba[-1] == ba[0] then
    self.UI.setAttribute("mTxt", "textColor", "#b15959")
  end
end

function rollBack(a)
  local i  local n = 0
  for i = 2, ba[0] do  if ba[i] == a[1] then n = i  break  end  end
  if n == 0 then ba[0] = ba[0]+1
  else for i = n, ba[0] do  ba[i] = ba[i+1]  end  end  ba[ba[0] ] = a[1]  ba[-1] = ba[0]
end

function ButtonLink()
  if isPVw() then return end
  if not vBaseOn or not aBase then return end
  if linkToMap and ba[-1] == ba[0] and string.sub(aBase.getName(), 5) != self.UI.getAttribute("mTxt", "text") then
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

function EditMode()
  if isPVw() then return end
  if not vBaseOn or wBase.getDescription() == "" then return end
  aBase = getObjectFromGUID(wBase.getDescription())
  if tBag then broadcastToAll("Pack or Clear Zone before Edit.", {0.943, 0.745, 0.14})  return end
  if not butActive then
    butActive = 1  local p = self.getPosition()
    broadcastToAll("Alter this Token: Name, Custom Art or Tint.", {0.943, 0.745, 0.14})
    self.UI.setAttribute("mTxt", "text", "Exit Edit Mode")
    self.UI.setAttribute("mTxt", "textColor", "#f1b531")
    aBase.interactable = true  aBase.unlock()  aBase.setRotation({0, 0, 0})  
    aBase.setPosition({p[1], p[2]+3, p[3]+(4.7*r2)})  aBase.setPositionSmooth({p[1], p[2]+2.5, p[3]+(4.7*r2)})
  else
    JotBase()  StowBase()  NoBase()  Wait.time(|| SetUI(), 0.1)  SetUIText()  butActive = nil  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14}) end
end

function ButtonCopy()
  if isPVw() then return  end
  if not vBaseOn or not aBase then return end
  if ss != "" or prs != "" then  broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  return  end
  prs = aBase.getLuaScript()  local n  local a = {}  local o = {}  local p = {}
  if tBag and prs != "" then
    broadcastToAll("Mapping Objects...", {0.943, 0.745, 0.14})
    prs = string.gsub(prs, string.char(10), string.char(44))  n = string.find(prs, "%-%-")
    while n do  a = getObjectFromGUID(string.sub(prs, n+2, n+7))  n = n+9
      if a then  a.lock() p = a.getPosition()  a.setPosition({p[1], p[2]-66, p[3]})  end
      n = string.find(prs, "%-%-", n)
    end
  end  a = nil  n = string.find(prs, "%-%-")
  if n then prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))  end
  if a then  p = a.getPosition()  o.position = {p[1], p[2]+66, p[3]}  currentBase = a.clone(o)  end  Wait.time(|| cb2Copy(), 0.2)
end
function cb2Copy()
  local a = {}  local o = {}  local p = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  p = a.getPosition()  currentBase.setPosition({p[1], p[2]+66, p[3]})  end  local n = string.find(prs, "%-%-")
  if not n then  
    prs = ""  currentBase = nil  broadcastToAll("...Copy Complete.", {0.943, 0.745, 0.14})  Wait.time(|| cb3Copy(), 0.2)  return
  end
  prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  p = a.getPosition()  o.position = {p[1], p[2]+66, p[3]}  currentBase = a.clone(o)  end
end
function cb3Copy()
  ClearSet()  local p = {}  p.position = {6, -28, 6}  aBase = aBase.clone(p)  Wait.time(|| cb4Copy(), 0.2)
end
function cb4Copy()  
  local x = self.getPosition()  x[1] = x[1]-(5.7 * r2)  aBase.setRotation({0, 90, 0})  
  aBase.setPosition({x[1], x[2]+2.5, x[3]})  aBase.setPositionSmooth({x[1], x[2]+2, x[3]})  aBase.setLuaScript("")
  aBase.setName("SBx_Copy_"..string.sub(aBase.getName(), 5))  aBase.setDescription("")
  aBase.unlock()  NoBase()  Wait.time(|| SetUI(), 0.1)  SetUIText()
end

function ButtonDelete()
  if isPVw() then return  end
  if not vBaseOn or not aBase then return end
  if aBase.getLuaScript() != "" and not tBag then broadcastToAll("Deploy Zone to Delete.", {0.943, 0.745, 0.14})  return end
  if tBag then
    currentBase = aBase.getGUID()
    ss, prs = "", ""
    ClearSet() wBase.setDescription("")
    aBase.setLuaScript("")
    broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
  else
    local g = aBase.getGUID()
    if g == ba[1] then broadcastToAll("Can't Delete Home, Edit Art Instead.", {0.943, 0.745, 0.14}) return end
    local e, k, h, s = string.char(10), string.char(44), string.char(45), aBag.getLuaScript()
    ba[ba[0]] = nil
    ba[0] = ba[0] - 1
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

function ButtonExport()
  if isPVw() then return  end
  if not vBaseOn or not aBase then return end
  if not tBag then broadcastToAll("Deploy Zone to Export.", {0.943, 0.745, 0.14})  return
  else tBag = false end
  broadcastToAll("Bagging Export...", {0.943, 0.745, 0.14})
  local t = {
    type = "Bag", position = self.getPosition()+{x=10,y=1,z=0},
    callback_owner = mBag, callback = "Export"
  } iBag = spawnObject(t)
  ss, prs = "", ""
  Wait.time(|| ClearSet(), 0.2)
end

function CbImport()
  local p = self.getPosition()
  p[1] = p[1] - (5.5*r2)
  aBase.setPosition({p[1], p[2] + 4, p[3]})
  aBase.setPositionSmooth({p[1], p[2] + 1, p[3]})
  local e, k, s = string.char(10), string.char(44), string.sub(iBag.getName(), 5)
  local g = iBag.getDescription() aBase.setName("SBx_"..s)
  if(#g == 6) then
    g = g.."{1.85;1;1.85},0,0,2,0"
    iBag.setDescription(g)
  elseif(not g:find("{")) then
    g = g:sub(1, 6).."{1.85;1;1.85},0,0,2,0"
    iBag.setDescription(g)
  end
  s = aBag.getLuaScript() local n = string.len(s)  if string.sub(s, n) == e then s = string.sub(s, 1, n-1) end  if s == "" then s = "--" end
  s = s..aBase.getGUID()..k..string.sub(aBase.getName(), 5)..string.sub(g, 7)..","..e.."--"  aBag.setLuaScript(s)
  iBag.setDescription("")  iBag.setName("")  aBase.setDescription(iBag.guid)  
  getObjectFromGUID(getObjectFromGUID(currentBase).getDescription()).destruct()  getObjectFromGUID(currentBase).destruct()  currentBase = nil
  broadcastToAll("Import Complete.", {0.943, 0.745, 0.14})  nl = aBase.getGUID()  wBase.call("MakeLink")
  aBase.unlock()  aBag.putObject(aBase)  aBase = nil  iBag.unlock()  mBag.putObject(iBag)  iBag = nil
end

function ButtonSeeAll()
    if not vBaseOn then return end
    broadcastToAll("(scroll <Z-A>, all zones)", {0.7, 0.7, 0.7})  broadcastToAll("Use the One World Logo.", {0.943, 0.745, 0.14})
    if aBase then ba = {}  ba[-1] = 1  ba[0] = 1  ba[1] = aBase.getGUID()  return  end
    local i, ii, g  local s = aBag.getLuaScript()  local e = string.char(10)  local t = {}  local ct = 0  local n = string.find(s, e)
    while string.len(s) > 6 do  ct = ct+1  t[ct] = string.sub(s, 1, n)  s = string.sub(s, n+1)  n = string.find(s, e)  end  s = ""
    for i = 2, ct do
      for ii = i, 2, -1 do
        if string.sub(t[ii], 10) < string.sub(t[ii-1], 10) then g = t[ii]  t[ii] = t[ii-1]  t[ii-1] = g  end
      end
    end  ba = {}  ba[-1] = 2  ba[0] = ct+1  ba[1] = string.sub(t[1], 3, 8)
    for i = 1, ct do  ba[i+1] = string.sub(t[i], 3, 8)  s = s..t[i]  end  s = s.."--"  aBag.setLuaScript(s)
end

function ButtonNew()
  if os.clock() - prevTime < 0.7 then
    prevTime = prevTime - 1
    CreateStartBags()
    TogleEnable()
    broadcastToAll("(remove 1 pair from the table)", {0.7, 0.7, 0.7})
    broadcastToAll("ReName these 2 Bags.", {0.943, 0.745, 0.14})
  else
    prevTime = os.clock()
    Wait.time(|| sglClick(), 0.2)
  end
end
function sglClick()
  local p = {}  p.type = "Custom_Token"  p.position = {0, -23, 0}  p.rotation = {0, 90, 0}  p.callback = "cbNABase"
  p.callback_owner = self  local o = spawnObject(p)  local i = {}
  i.thickness = 0.1  i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/sample_token.png"  o.setCustomObject(i)
end
function cbNABase(a)
  local p = self.getPosition()  a.setScale({0.5, 1, 0.5})  a.setName("SBx_Name of Zone")
  p[1] = p[1]-(5.8 * r2)  a.setPosition({p[1], p[2]+3, p[3]})  a.setPositionSmooth({p[1], p[2]+2.5, p[3]})
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
  local p = self.getPosition()
  mBag.setPosition({p[1] - 3, p[2] + 2.5, p[3]+(5*r2)})
end
function cbNABag(a)
  a.setDescription("_OW_aBaG") a.setName("Same_Name_Here") a.setColorTint({0.713, 0.247, 0.313})
  local p = self.getPosition()
  a.setPosition({p[1], p[2] + 2.5, p[3]+(5*r2)})
end

function netSync()
  if ss != "" or prs != "" then  broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  return  end
  broadcastToAll("Attempting to Sync NetCode...", {0.943, 0.745, 0.14})
  prs = aBase.getLuaScript()
  if prs == "" then return end
  ButtonPack()
  prs = string.gsub(prs, string.char(10), string.char(44))  prs = string.sub(prs, string.find(prs, "%-%-")+2)
  local a = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  currentBase = a.getScale()  a.setScale({0, 0, 0})  end  Wait.time(|| cbNSync(), 0.2)
end
function cbNSync()
  local a = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))  if a then a.setScale(currentBase) end  local n = string.find(prs, "%-%-")
  if not n then    prs = ""  currentBase = nil  broadcastToAll("...Zone Objects Reset.", {0.943, 0.745, 0.14})  return  end
  prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  currentBase = a.getScale()  a.setScale({0, 0, 0})  end
end

function ButtonBuild()
  if butActive then EditMode() return end
  if currentBase then if string.sub(currentBase, 1, 3) == "xv." then newCode() return end end
  if not vBaseOn or not aBase then return end
  if tBag then netSync() return end
  if aBase.getDescription() == "" then return end
  if ss != "" or prs != "" then
    broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})
    return
  end
  broadcastToAll("Recalling Zone Objects...", {0.943, 0.745, 0.14})
  tBag = true
  local t = {
    smooth = false, guid = aBase.getDescription(), position = {-2, -46, 7},
    callback = "CreateBugBuild", callback_owner = mBag
  }
  mBag.takeObject(t)
end

function PutBase(guid)
  aBase = getObjectFromGUID(guid) JotBase()
  aBase.setLuaScript("") aBase.setDescription("") wBase.setDescription("")
  if not ba[1] then ba[1] = guid aBag.setDescription("_OW_aBaG_"..ba[1]) ba[0] = 1 end
  currentBase = guid broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
  Wait.time(|| cbPutBase(), 0.2)
end
function cbPutBase()
  nl = currentBase
  GetBase({currentBase})
  currentBase = nil
end