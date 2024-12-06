function onLoad()
    r1, r2, r3 = 0, 0, 0
    lnk, ss, prs, vbg, wbg = "", "", "", "", ""
    sizePlate = 25
    zz, gh, r90, iu = 0, 0.91, 0, 1
    wpx, pxy, aBase, nl, ub, ef = nil, nil, nil, nil, nil, nil
    cb, ba = {}, {}
    cbp = "x"
    mb = os.clock()
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

function iUnit()
  Global.setVar("oW4TTale", self.guid)
  if not findBags() then return false end
  if string.sub(cbp, 1, 1) != "x" then  udShow() return false  end
  local p = aBag.getPosition()
  if p[2] < -10 then
    Global.setVar("oWisOn", true) else Global.setVar("oWisOn", false)
  end
  broadcastToAll("(LOCK or continue from save)", {0.7, 0.7, 0.7})
  broadcastToAll("Initializing ONE WORLD...", {0.943, 0.745, 0.14})
  iu = nil
  return true
end

function tieObjects()
    local aoj = {}  aoj = getAllObjects()  local g = aoj[1]  local n = 1  Global.setVar("oW4TTale", self.guid)  local o = {}  local i = {}
    while g do
        if g.getDescription() == "_OW_tBaG" then if tBag then g.destruct() else  tBag = g  tBag.interactable = false  end  end
        if g.getName() == "_OW_xBaG" then if xBag then g.destruct() else xBag = g end  end
        if g.getName() == "_OW_cBase" then if cBase then g.destruct() else cBase = g end  end
        if g.getName() == "_OW_vBase" then if vBase then g.destruct() else vBase = g end  end
        if g.getName() == "_OW_mTxT" then g.destruct() end
        n = n+1  g = aoj[n]
    end  reStart()
    i.image = self.UI.getCustomAssets()[4].url  i.thickness = 0.1
    if not vBase then o.type = "Custom_Token"  o.position = {-9, -39, 9}  vBase = spawnObject(o)  vBase.setCustomObject(i)  end
    i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/cloud.png"  i.thickness = 0.5  i.merge_distance = 5  i.cast_shadows = false
    if not cBase then o.type = "Custom_Token"  o.position = {0, 85, 0}  cBase = spawnObject(o)  cBase.setCustomObject(i)  end
    Wait.time(|| goTime(), 0.5)
end

function goTime()
  local f = nil
  self.interactable = false  local r = self.getRotation()  if r[2] > 180 then r2 = -1 else r2 = 1  end
  if not vBase then f = 2 else  local s = vBase.getLuaScript()
    if string.sub(s, 3, 8) != vBase.guid then vBase.setLuaScript("--"..vBase.guid.."@"..string.sub(s, 10)) end
    vBase.setName("_OW_vBase")  vbg = vBase.guid
    if vBase.getPosition().y < -20 then  vBase.setScale({0.5, 1, 0.5})  local p = {}  p = self.getPosition()
      vBase.setPosition({p[1]+3, p[2]+3, p[3]-1})  vBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]-1})
    end
    if Global.getVar("oWisOn") then vBase.interactable = false end
  end
  if not wBase then f = 3 else
    wbg = wBase.guid
    r = wBase.getRotation()  if r[1] > 170 then r1 = 180 end  if r[3] > 170 then r3 = 180 end
    local g = wBase.getDescription()
    if g != "" then  if getObjectFromGUID(g) then local d
      aBase = getObjectFromGUID(g)  d, r1, r3, pxy, r90, lnk = parceData({g})  wBase.call("setLinks")
    end  end
    if Global.getVar("oWisOn") then wBase.interactable = false end
  end
  if not cBase then f = 5 else
    cBase.lock()  cBase.setScale({0, 0 ,0}) cBase.setPosition({0, 85, 0})
    cBase.setName("_OW_cBase")  cBase.interactable = false
  end
  if f then  Wait.time(|| goTime(), 0.5) return  else  setBtn()  setTxt()  end
end

function btnEnable()  if os.clock()-mb < 1.1 then broadcastToAll("working...", {0.943, 0.745, 0.14})  return  else  chkIUnit()  end  end
function chkIUnit()
  if iu then
    if iUnit() then
      mb = os.clock()
      cbp = nil
      tieObjects()
    end
  else
    tglEnable()
  end
end
function tglEnable()
    if ef then btnEdit()  return  end
    if not findBags() then return  end
    local p  if ba[1] != string.sub(aBag.getDescription(), 10) then reStart() end
    if not Global.getVar("oWisOn") then
        self.UI.setAttribute("b2", "active", true)
        p = self.getPosition()  local r = self.getRotation()  if r[2] > 180 then r2 = -1 else r2 = 1  end
        self.interactable = false  self.lock()  self.setPosition({p[1], p[2]+0.1, p[3]})
        self.setRotation({0, (2-r2)*90, 0})  self.setScale({2.2,1,2.2})
        mBag.lock()  mBag.setScale({0, 0, 0})  mBag.setPosition({-3,-50, 3})  mBag.interactable = false
        aBag.lock()  aBag.setScale({0, 0, 0})  aBag.setPosition({-3,-55, -3}) aBag.interactable = false
        vBase.interactable = false  vBase.lock()  vBase.setScale({sizePlate, 1, sizePlate})  vBase.setPosition({0, gh, 0})
        wBase.interactable = false  wBase.lock()  wBase.setScale({1.85, 1, 1.85})  wBase.setPosition({p[1], p[2]+0.105, p[3]-(0.77*r2)})
        broadcastToAll("Running Version: "..self.getDescription(), {0.943, 0.745, 0.14})  wBase.setVar("o", 1)  Wait.time(|| popWB(), 0.5)
        Global.setVar("oWisOn", true)  setTxt()  r1 = 0  r3= 0  r90 = 0  rotBase()  setBtn()  return    end
    if not aBase then
        mb = os.clock()  
        Global.setVar("oWisOn", false)  p = self.getPosition()
        self.UI.setAttribute("b2", "active", false)
        self.interactable = true  self.unlock()  self.setPositionSmooth({p[1], p[2]+0.1, p[3]})
        mBag.unlock()  mBag.setScale({1, 1, 1})  mBag.setPosition({p[1]-3, p[2]+3, p[3]})  mBag.setPositionSmooth({p[1]-3, p[2]+2.5, p[3]})
        aBag.unlock()  aBag.setScale({1, 1, 1})  aBag.setPosition({p[1], p[2]+3, p[3]})  aBag.setPositionSmooth({p[1], p[2]+2.5, p[3]})
        mBag.interactable = true  aBag.interactable = true  vBase.interactable = true  vBase.unlock()  vBase.setScale({0.5, 1, 0.5})
        vBase.setPosition({p[1]+3, p[2]+3, p[3]-1})  vBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]-1})
        wBase.interactable = true  wBase.unlock()  wBase.setScale({0.5, 1, 0.5})
        wBase.setPosition({p[1]+3, p[2]+3, p[3]+1})  wBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]+1})
        wpx = nil  reStart()  setBtn()  return    end
    if tBag then clrSet() else noBase() end  setBtn()  setTxt()
end

function reStart()
  cb = {}  prs = ""  ss = ""  Wait.time(|| newXBag(), 0.5)
  ba = {}  ba[1] = string.sub(aBag.getDescription(), 10)  ba[0] = 1  if ba[1] == "" then ba[1] = nil  ba[0] = 0  end  ba[-1] = ba[0]
  local aoj = {}  aoj = getAllObjects()  local g = aoj[1]  local n = 1
  while g do
    if string.sub(g.getName(), 1, 4) == "SBx_" then local w = g.getPosition()
      if Global.getVar("oWisOn") and g.guid == wBase.getDescription() then
        if g.guid == ba[1] then ba[2] = ba[1]  ba[0] = 2  ba[-1] = 2  else
          ba[2] = ba[1]  ba[3] = g.guid  ba[0] = 3  ba[-1] = 3
        end  w[2] = 1
      end
      if w[2] > 50 then g.destruct() end
    end  n = n+1  g = aoj[n]
  end
end

function setBtn()
  local forTool, forText, g = "", "", "LOCK"
  if Global.getVar("oWisOn") then
    if wBase.getDescription() != "" then g = "CLR" else g = "END" end
  end
  self.UI.setAttribute("b1", "text", g)

  forTool = "Reset"
  if r90 == 1 then forText = "↵".." ." elseif r90 == 2 then forText = "↕".." ." else forTool = "FitFrame" end
  self.UI.setAttribute("b5", "text", forText)
  self.UI.setAttribute("b5", "tooltip", forTool)
  
  forText = "" 
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
      self.UI.setAttribute("b9", "active", true) if tBag then forText = "sync" else forText = "BUILD" end
    end
  end
  self.UI.setAttribute("b9", "text", forText)
end

function setTxt(a)
  local g = a ~= nil and a or "One World"
  self.UI.setAttribute("mTxt", "text", g)
  self.UI.setAttribute("mTxt", "textColor", "White")
end

function findBags()
    mBag = nil  aBag = nil wBase = nil  local m = 3  local a = 3  local p = {}
    local aoj = {}  aoj = getAllObjects()  local g, s, n  n = 1  s = ""  g = aoj[1]
    while g do
      if g.getDescription() == "_OW_mBaG" then
        if mBag then p = self.getPosition()
          if mBag != "e" then  mBag.unlock()  mBag.setScale({1, 1, 1})
            mBag.setPosition({p[1]-3, p[2]+3, p[3]})  mBag.setPositionSmooth({p[1]-3, p[2]+2.5, p[3]})  mBag = "e"
          end
          g.setPosition({p[1]-3, p[2]+3, p[3]-m})  g.setPositionSmooth({p[1]-3, p[2]+2.5, p[3]-m})  m = m+3
        else mBag = g  if mBag.getPosition().y < -10 then mBag.interactable = false end  end
      end
      if string.sub(g.getDescription(), 1, 8) == "_OW_aBaG" then
        if aBag then p = self.getPosition()
          if aBag != "e" then  aBag.unlock()  aBag.setScale({1, 1, 1})
            aBag.setPosition({p[1], p[2]+3, p[3]})  aBag.setPositionSmooth({p[1], p[2]+2.5, p[3]})  aBag = "e"
          end
          g.setPosition({p[1], p[2]+3, p[3]-a})  g.setPositionSmooth({p[1], p[2]+2.5, p[3]-a})  a = a+3
        else aBag = g  if aBag.getPosition().y < -10 then aBag.interactable = false end  end
      end
      if g.getName() == "_OW_wBase" then wBase = g end
      n = n+1  g = aoj[n]
    end
    if not mBag then broadcastToAll("Missing Zone Object Bag.", {0.943, 0.745, 0.14})  newMBag()  return false  end
    if not aBag then broadcastToAll("Missing Base Token Bag.", {0.943, 0.745, 0.14})  newABag()  return false  end
    if mBag == "e" or aBag == "e" then broadcastToAll("Bag Count Error.", {0.943, 0.745, 0.14})  return false  end
    if not wBase then s = s.." Missing Hub View Token."
      WebRequest.get("https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/wBaseLua.txt", self, "newWBase")
    end
    if mBag.getName() == "Same_Name_Here" or aBag.getName() == "Same_Name_Here" then s = s.." ReName Your Bags." end
    if mBag.getName() != aBag.getName() then s = s.." Unmatched Bag Names." end
    if s != "" then  broadcastToAll(s, {0.943, 0.745, 0.14})  return false
      else return true end
end
function newWBase(a)
  local o = {}  o.type = "Custom_Token"  o.position = {9, -43, -9}  o.callback = "cbWBase"  o.callback_owner = self
  local i = {}  i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg"  i.thickness = 0.1
  ss = a.text  wBase = spawnObject(o)  wBase.setCustomObject(i)
end
function cbWBase(a)
  local p = {}  p = self.getPosition()  a.setLuaScript(ss)  ss = ""  a.setName("_OW_wBase")
  a.setScale({0.5, 1, 0.5})  a.setPosition({p[1]+3, p[2]+3, p[3]+1})  a.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]+1})
end

function cbTObj()
    local f = 0
    wBase = getObjectFromGUID(wbg)  vBase = getObjectFromGUID(vbg)  wBase.interactable = false  vBase.interactable = false
    if aBase then
      if vBase.getCustomObject().image == aBase.getCustomObject().image then  vBase.setColorTint(aBase.getColorTint())  f = f+1  end
      if wBase.getCustomObject().image == aBase.getCustomObject().image then  wBase.setColorTint(aBase.getColorTint())  f = f+2  end
    end
    gh = 0.91  if vBase.getCustomObject().image == self.UI.getCustomAssets()[4].url then gh = -0.91 end
    if wpx == nil or wpx == wBase.getDescription() then wBase.call("setLinks") end
    if nl then wBase.call("makeLink") end  self.setRotation({0, (2-r2)*90, 0})  rotBase()
end

function popWB()  wBase.setVar("o", nil) end
function btnHorz()  if isPVw() then return  end  if aBase then r1 = 180 - r1  rotBase()  jotBase()  end  end
function btnVert()  if isPVw() then return  end  if aBase then r3 = 180 - r3  rotBase()  jotBase()  end  end

function btnFit()  if isPVw() or not aBase or ef then return  end
  if tBag then broadcastToAll("Pack or Clear Zone before Edit.", {0.943, 0.745, 0.14})  return  end
  if r90 != 0 then  r90 = 0  vBase.setScale({sizePlate, 1, sizePlate})  wBase.setScale({1.85, 1, 1.85})  aBase.setScale({0.5, 1, 0.5})
  else  local x = vBase.getBoundsNormalized().size.x  local z = vBase.getBoundsNormalized().size.z
    if z > x * 1.05 then  r90 = 1  x = 102 / x  z = 173 / z else  r90 = 2  x = 173 / x  z = 102 / z  end
    if r90 == 2 and x == 1 and z == 1 then r90 = 0 end
    vBase.setScale({sizePlate*x, 1, sizePlate*z})  wBase.setScale({1.85*x, 1, 1.85*z})  aBase.setScale({18.09*x/36, 1, 18.09*z/36})
  end  jotBase()  stowBase()  noBase()  setBtn()  setTxt()  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
end

function rotBase()
  local n = 0  if r90 == 1 then n = 90 end  vBase.setPosition({0, gh, 0})  vBase.setRotation({r1, n, r3})
  if wpx == nil or wpx == wBase.getDescription() then  wBase.setRotation({r1, n, r3})  wBase.call("setLinks")  end
end

function btnProxy()
  if not Global.getVar("oWisOn") or not aBase then return end
  local v = {}  f = nil  local g = "Ending Parent View..."
  if pxy then
    if wpx then
      if wpx == wBase.getDescription() then
        pxy = nil  f = 1  v.image = aBase.getCustomObject().image  vBase.setPosition({0, gh, 0})
      end  wpx = nil
    else
      pxy = nil  f = 1  v.image = aBase.getCustomObject().image  vBase.setPosition({0, gh, 0})
    end
  else
    if wpx then
      wpx = nil  v.image = aBase.getCustomObject().image  bn, r1, r3, pxy, r90, lnk = parceData({aBase.guid})  pxy = nil
      setTxt()  wBase.setCustomObject(v)  wBase.reload()  Wait.time(|| cbTObj(), 0.5)
    else
      if tBag then  broadcastToAll("Pack or Clear Zone to Enter Parent View.", {0.943, 0.745, 0.14})  return  end
      pxy = 8  f = 1  v.image = aBase.getCustomObject().image  vBase.setPosition({0, -0.91, 0})
      wpx = wBase.getDescription()  g = "Entering Parent View..."
    end
  end
  if f then  jotBase()  vBase.setCustomObject(v)  vBase.reload()  Wait.time(|| cbTObj(), 0.5)  end
  setBtn()  broadcastToAll(g, {0.286, 0.623, 0.118})
end

function btnPack()
    if isPVw() then return  end
    if not Global.getVar("oWisOn") or not aBase then return end
    if ss != "" or prs != "" then broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  return end
    if not findBags() then return  end  if tBag then dumpSet() end  local l = vBase.getLuaScript()
    n = 1  local p, f, u, r, m  local s = ""  aoj = getAllObjects()  g = aoj[1]  local a = string.char(10)  local k = string.char(44)
    while g do
        p = g.getPosition()  f = g.getGUID()  u = 0  if g.getLock() then u = 1 end
        if math.abs(p[3]) < 26 and math.abs(p[1]) < 44 and math.abs(p[2]) < 26 then
            if string.find("059864@3761d8@ff9bc3@2deca3@649822", f) then m = 1 end
            if not string.find("FogOfWarTrigger@ScriptingTrigger@3DText", g.name) and not string.find(l, f) then
              ss = ss..g.guid  r = g.getRotation()  s = s.."--"..f..k..p[1]..k..p[2]..k..p[3]..k..r[1]..k..r[2]..k..r[3]..k..u..a
            end
        end  n = n+1  g = aoj[n]
    end  z2 = 1
    if ss != "" then
      if m then ss = ""  broadcastToAll("Pack Canceled. Remove SkyBox Tool.", {0.943, 0.745, 0.14})
      else aBase.setLuaScript(s)  broadcastToAll("Packing Zone...", {0.943, 0.745, 0.14})
        local t = {}  t.type = "Bag"  t.position = {0, 4, 0}  t.callback = "doPack"  t.callback_owner = self  spawnObject(t)
      end
    else
      broadcastToAll("(to empty a zone, use Delete)", {0.7, 0.7, 0.7})
      broadcastToAll("No Objects Found in Zone.", {0.943, 0.745, 0.14})
    end
end
function doPack(a)
  local i  for i = 0, string.len(ss)/6-1 do  a.putObject(getObjectFromGUID(string.sub(ss, i*6+1, i*6+6)))  end
  aBase.setDescription(a.guid)  iBag = a  Wait.time(|| cbPack(), 0.5)
end
function cbPack()
    if ss == "" then    Wait.time(|| endPack(), 0.5) end  local i, g
    for i = 0, string.len(ss)/6-1 do  g = string.sub(ss, i*6+1, i*6+6)
      if not getObjectFromGUID(g) then ss = string.sub(ss, 1, i*6)..string.sub(ss, i*6+7) end
    end  if ss == "" then return end
    z2 = z2 + 1  if z2/10 == math.modf(z2/10) then broadcastToAll("Pass"..(z2/10).."...", {0.943, 0.745, 0.14})  end
    if z2 > 68 then broadcastToAll("Manual Inspection Required.", {0.943, 0.745, 0.14})
      for i = 0, string.len(ss)/6-1 do  g = string.sub(ss, i*6+1, i*6+6)
        getObjectFromGUID(g).resting = true  getObjectFromGUID(g).setPosition({0, 3, 0})
      end  ss = ""
    end
end
function endPack()
  
  if iBag then mBag.putObject(iBag)  iBag = nil  end
  jotBase()  stowBase()  noBase()  setBtn()  setTxt()  broadcastToAll("Packing Complete.", {0.943, 0.745, 0.14})
end

function jotBase()
    local e = string.char(10)  local k = string.char(44)  local h = string.char(45)  local x
    local s = aBag.getLuaScript()  if s == "" then s = "--" end  local n = string.len(s)
    if n < 6 then aBag.setDescription("_OW_aBaG_"..aBase.guid) end  if pxy then x = 8 else x = 2 end
    while string.sub(s, n) != "-" do  s = string.sub(s, 1, n-1)  n = n-1  end
    n = string.find(s, h..wBase.getDescription()..k)
    if n then  local m = string.find(s, e, n)  s = string.sub(s, 1, n-2)..string.sub(s, m+1)  end
    local g = string.sub(aBase.getName(), 5)  g = string.gsub(g, k, ";")
    if r90 != 1 then  if math.abs(wBase.getScale().x - wBase.getScale().z) > 0.01 then r90 = 2 else r90 = 0 end  end
    s = s..aBase.guid..k..g..k..r1..k..r3..k..x..k..r90..k..lnk..e..h..h  aBag.setLuaScript(s)
end

function stowBase()
  local t = {}  t.guid = aBase.guid  t.position = {0, -15, 0}  t.callback = "oldBase"  t.smooth = false  t.callback_owner = self
  sclBase(aBase)  aBag.takeObject(t)  aBase.unlock()  aBag.putObject(aBase)  Wait.time(|| newXBag(), 0.5)  aBase = nil
end  function oldBase(a)  a.destruct()  end

function noBase()
  r1 = 0  r3 = 0  r90 = 0  rotBase()  wBase.setDescription("")  aBase = nil  lnk = ""
  wBase.setScale({1.85, 1, 1.85})  vBase.setScale({sizePlate, 1, sizePlate})  local c = {}  c.image = self.UI.getCustomAssets()[4].url
  vBase.setCustomObject(c)  vBase.reload()  wBase.setCustomObject(c)  wBase.reload()  wpx = nil  pxy = nil  Wait.time(|| cbTObj(), 0.5)
end

function putBase(a)
  aBase = getObjectFromGUID(a[1])  jotBase()
  aBase.setLuaScript("")  aBase.setDescription("")  aBag.putObject(aBase)  wBase.setDescription("")
  if not ba[1] then  ba[1] = a[1]  aBag.setDescription("_OW_aBaG_"..ba[1])  ba[0] = 1  end
  Wait.time(|| newXBag(), 0.5)  Wait.time(|| cbPutBase(), 0.5)  cbp = a[1]  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
end
function cbPutBase()
  nl = cbp  getBase({cbp})  cbp = nil
end

function newXBag()
  if xBag then xBag.destruct() end  o = {}  o.position = {-3, -48.5, -3}  xBag = aBag.clone(o)
  xBag.lock()  xBag.interactable = false  xBag.setScale({0, 0 ,0}) xBag.setPosition({-3, -48.5, -3})
  xBag.setDescription("")  xBag.setName("_OW_xBaG")  xBag.setLuaScript("")
end

function getBase(a)
    ub = nil
    if not Global.getVar("oWisOn") or a[1] == wBase.getDescription() then return end
    if tBag then clrSet() end  wBase.setDescription("")  aBase = nil
    local g = a[1]  local t = lnk  bn, r1, r3, pxy, r90, lnk = parceData({g})  if bn == nil then return end
    if pxy and not wpx then  wpx = g  broadcastToAll("Entering Parent View...", {0.286, 0.623, 0.118})
    else if wpx then lnk = t end  end
    if getObjectFromGUID(g) then cbGetBase(getObjectFromGUID(g))  return end
    local t = {}  t.guid = g  t.position = {0,-3, 0}  t.rotation = {0, 0, 0}  t.smooth = false
    t.callback = "cbGetBase"  t.callback_owner = self xBag.takeObject(t)
end
function cbGetBase(a)
    local locPos = self.getPosition()
    a.setPosition({locPos.x, locPos.y - 0.5, locPos.z})  a.lock()  a.interactable = false aBase = a
    wBase.setDescription(a.guid)  local p = self.getPosition()  wBase.setPosition({p[1], p[2]+0.05, p[3]+(0.77*r2)})
    rotBase()  setTxt()  setBtn()  rollBack({a.guid})  local v = {}
    if wpx and wpx != wBase.getDescription() then  v.image = aBase.getCustomObject().image  vBase.setPosition({0, gh, 0})
    else  local n = sizePlate/1.85  local x = a.getScale().x  local z = a.getScale().z
      if x == z then x = sizePlate  z = sizePlate  else  x = x * 36  z = z * 36  end  wBase.setScale({x/n, 1, z/n})
      local w = {}  w.image = aBase.getCustomObject().image  wBase.setCustomObject(w)  wBase.reload()
      if pxy then v.image = aBase.getCustomObject().image  vBase.setPosition({0, -0.91, 0})  vBase.setScale({sizePlate, 1, sizePlate})
      else  vBase.setScale({x, 1, z})  v.image = aBase.getCustomObject().image  vBase.setPosition({0, gh, 0})  end
    end
    vBase.setCustomObject(v)  vBase.reload()  Wait.time(|| cbTObj(), 0.5)
    setTxt(a.getName():sub(5))
end

function isPVw()  if wpx then broadcastToAll("Action Canceled While in Parent View.", {0.943, 0.745, 0.14})  return true  end  end

function parceData(a)
  local h = string.char(45)  local k = string.char(44)  local e = string.char(10)  local s = aBag.getLuaScript()
  local g = a[1] local n = string.find(s, k, string.find(s, h..g..k))  local m = n
  if not n then broadcastToAll("Missing Base.", {0.943, 0.745, 0.14})  return end
  local d = {}  local i
  for i = 1, 5 do  n = string.find(s, k, m+1)  d[i] = string.sub(s, m+1, n-1)  m = n  end
  n = string.find(s, e, m+1)  d[6] = string.sub(s, m+1, n-1)  if d[6] == nil then d[6] = "" end
  d[4] = tonumber(d[4])  if d[4] == 0 then d[4] = 8 elseif d[4] == 1 or d[4] == 2 then d[4] = nil end  --[[ convert old data --]]
  if wpx and wpx != g then d[4] = nil end
  return string.gsub(d[1], ";", ","), tonumber(d[2]), tonumber(d[3]), d[4], tonumber(d[5]), d[6]
end

function clrSet(a)
    if tBag then  tBag.destruct()  tBag = nil  end
    local p = {}  local o = {}  local s = aBase.getLuaScript() local n = 0
    while n+5 < string.len(s) do
        o = getObjectFromGUID(string.sub(s, n+3, n+8))
        if o then  p = o.getPosition()
          if a or math.abs(p[3]) < 26 and math.abs(p[1]) < 44 and math.abs(p[2]) < 26 then o.destruct() end
        end  n = string.find(s, string.char(10), n+3)
    end
end

function btnSelect()
    if ef then btnEdit()  return  end
    if not Global.getVar("oWisOn") or not aBase then return end
    if ub then  getBase({ub})  ub = nil  setBtn()  return  end
    if ba[-1] != ba[0] then  getBase({ba[ba[-1] ]}) end
    local b = parceData({ba[ba[-1]]}) setTxt(b)
end

function btnHome()
  if wpx then
    wpx = nil
    getBase({ba[1]})
    return
  end
  if ef then
    btnEdit()
    return
  end
  if not Global.getVar("oWisOn") then
    return 
  end
  ub = nil  setBtn()
  if ba[0] < 2 or not aBase then
    if ba[1] then
      getBase({ba[1]})
    end
    return
  end
  ba[-1] = ba[-1]+1
  mvPoint()
end
function btnBack()
  if wpx then  wpx = nil  getBase({ba[1]})  return end
  if ef then btnEdit()  return end
  if not Global.getVar("oWisOn") then return end  ub = nil  setBtn()
  if ba[0] < 3 then btnHome()  return  end
  if not aBase then  getBase({ba[ba[0]]}) return end
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
  local b = parceData({ba[ba[-1]]})
  setTxt(b)
  setBtn()
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

function btnLink()
  if isPVw() then return  end
  if not Global.getVar("oWisOn") or not aBase then return end
  if ub and ba[-1] == ba[0] and string.sub(aBase.getName(), 5) != self.UI.getAttribute("mTxt", "text") then
    local n = string.find(lnk, "@"..ub)
    while n do  lnk = string.sub(lnk, 1, n-5)..string.sub(lnk, n+8)  n = string.find(lnk, "@"..ub)  end
    nl = ub  ub = nil  setTxt()  setBtn()  jotBase()  wBase.call("setLinks")
  else nl = aBase.guid end  wBase.call("makeLink")  ub = nil
end

function btnEdit()
  if isPVw() then return  end
  if not Global.getVar("oWisOn") or wBase.getDescription() == "" or cb[1] then return  end
  aBase = getObjectFromGUID(wBase.getDescription())
  if tBag then broadcastToAll("Pack or Clear Zone before Edit.", {0.943, 0.745, 0.14})  return  end
  if not ef then
    ef = 1  local p = self.getPosition()
    broadcastToAll("Alter this Token: Name, Custom Art or Tint.", {0.943, 0.745, 0.14})
    self.UI.setAttribute("mTxt", "text", "Exit Edit Mode")
    self.UI.setAttribute("mTxt", "textColor", "#f1b531")
    aBase.interactable = true  aBase.unlock()  aBase.setRotation({0, 0, 0})  sclBase(aBase)
    aBase.setPosition({p[1], p[2]+3, p[3]+(4.7*r2)})  aBase.setPositionSmooth({p[1], p[2]+2.5, p[3]+(4.7*r2)})
  else
    jotBase()  stowBase()  noBase()  setBtn()  setTxt()  ef = nil  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})  end
end  function sclBase(a)  if a.getScale().x == a.getScale().z then a.setScale({0.5, 1, 0.5})  end  end

function btnCopy()
  if isPVw() then return  end
  if not Global.getVar("oWisOn") or not aBase or not findBags() then return end
  if ss != "" or prs != "" or cb[1] then  broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  return  end
  prs = aBase.getLuaScript()  local n  local a = {}  local o = {}  local p = {}
  if tBag and prs != "" then
    broadcastToAll("Mapping Objects...", {0.943, 0.745, 0.14})
    prs = string.gsub(prs, string.char(10), string.char(44))  n = string.find(prs, "%-%-")
    while n do  a = getObjectFromGUID(string.sub(prs, n+2, n+7))  n = n+9
      if a then  a.setLock(true)  p = a.getPosition()  a.setPosition({p[1], p[2]-66, p[3]})  end
      n = string.find(prs, "%-%-", n)
    end
  end  a = nil  n = string.find(prs, "%-%-")
  if n then prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))  end
  if a then  p = a.getPosition()  o.position = {p[1], p[2]+66, p[3]}  cbp = a.clone(o)  end  Wait.time(|| cb2Copy(), 0.5)
end
function cb2Copy()
  local a = {}  local o = {}  local p = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  p = a.getPosition()  cbp.setPosition({p[1], p[2]+66, p[3]})  end  local n = string.find(prs, "%-%-")
  if not n then  
    prs = ""  cbp = nil  broadcastToAll("...Copy Complete.", {0.943, 0.745, 0.14})  Wait.time(|| cb3Copy(), 0.5)  return
  end
  prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  p = a.getPosition()  o.position = {p[1], p[2]+66, p[3]}  cbp = a.clone(o)  end
end
function cb3Copy()
  clrSet(1)  local p = {}  p.position = {6, -28, 6}  aBase = aBase.clone(p)  Wait.time(|| cb4Copy(), 0.5)
end
function cb4Copy()  
  local x = self.getPosition()  x[1] = x[1]-(5.7 * r2)  aBase.setRotation({0, 90, 0})  sclBase(aBase)
  aBase.setPosition({x[1], x[2]+2.5, x[3]})  aBase.setPositionSmooth({x[1], x[2]+2, x[3]})  aBase.setLuaScript("")
  aBase.setName("SBx_Copy_"..string.sub(aBase.getName(), 5))  aBase.setDescription("")
  aBase.unlock()  noBase()  setBtn()  setTxt()
end

function btnDelete()
    if isPVw() then return  end
    if not Global.getVar("oWisOn") or not aBase then return end
    if aBase.getLuaScript() != "" and not tBag then broadcastToAll("Deploy Zone to Delete.", {0.943, 0.745, 0.14})  return end
    if tBag then  cbp = aBase.guid
      dumpSet()  clrSet()  aBase.setLuaScript("")  stowBase()  wBase.setDescription("")
      Wait.time(|| cb2Delete(), 0.5)  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
    else  local g = aBase.guid
      if g == ba[1] then broadcastToAll("Can't Delete Home, Edit Art Instead.", {0.943, 0.745, 0.14})  return  end
      local e = string.char(10)  local k = string.char(44)  local h = string.char(45)  local o = {}
      local s = aBag.getLuaScript()  local n = string.find(s, h..g..k)
      if n then  local m = string.find(s, e, n)  s = string.sub(s, 1, n-2)..string.sub(s, m+1)  end
      ba[ba[0] ] = nil  ba[0] = ba[0]-1  aBase.destruct()  noBase()  n = string.find(s, "@"..g..k)
      while n do  s = string.sub(s, 1, n-5)..string.sub(s, n+8)  n = string.find(s, "@"..g..k)  end
      aBag.setLuaScript(s)  o.smooth = false  o.callback = "cbDelete"  o.callback_owner = self
      o.guid = g  o.position = {12, -21, -14}  aBag.takeObject(o)
    end  setBtn()  setTxt()
end  function cbDelete(a)  a.destruct()  end
function cb2Delete() getBase({cbp})  cbp = nil  end

function btnExport()
  if isPVw() then return  end
  if not Global.getVar("oWisOn") or not aBase then return end
  if not tBag then broadcastToAll("Deploy Zone to Export.", {0.943, 0.745, 0.14})  return    else tBag.destruct()  tBag = nil  end
  broadcastToAll("Bagging Export...", {0.943, 0.745, 0.14})
  local t = {}  t.position = {-7, -23, -4}  eBase = aBase.clone(t)
  t.type = "Bag"  t.position = {0, 4, 0}  iBag = spawnObject(t)  Wait.time(|| cbExport(), 0.5)
end
function cbExport()
  iBag.setName("OW"..string.sub(aBase.getName(), 3))  local s = aBase.getLuaScript() local n = 0
  while n+5 < string.len(s) do
      local g = string.sub(s, n+3, n+8)
      if getObjectFromGUID(g) then iBag.putObject(getObjectFromGUID(g)) end
      n = string.find(s, string.char(10), n+3)
  end  local k = string.char(44)  s = eBase.guid..k..r1..k..r3..",2,"..r90
  iBag.setDescription(s)  eBase.setDescription(iBag.guid)  iBag.putObject(eBase)  eBase = nil  iBag = nil  setBtn()
end

function preImport(a)
  if cbp then local g = string.sub(cbp, 1, 2)
    if g == "i_" or g == "c_" then  if g == "c_" then a = a[1] end
      g = string.sub(cbp, 3)  a.setDescription(g)  g = getObjectFromGUID(g).getLuaScript()
      if string.sub(g, string.len(g)-1) != string.char(13)..string.char(10) then g = g..string.char(13)..string.char(10) end
      a.setLuaScript(g)
    end
  end  a.lock()  sclBase(a)  local t = {}  t.position = {3, -29, -7}
  iBag = getObjectFromGUID(a.getDescription()).clone(t)  cbp = a.guid  Wait.time(|| doImport(), 0.5)
end
function doImport()
  local t = {}  t.position = {0, -3, 0}  aBase = getObjectFromGUID(cbp).clone(t)
  iBag.setPosition({3, -39, -7})  iBag.lock()  Wait.time(|| cbImport(), 0.5)
end
function cbImport()
  local p = self.getPosition()  p[1] = p[1]-(5.5 * r2)
  aBase.setPosition({p[1], p[2]+4, p[3]})  aBase.setPositionSmooth({p[1], p[2]+1, p[3]})
  Wait.time(|| cbImport(), 0.5)
  local j = aBase.getPosition()  if j[2] > p[2]+3.5 then  return  end  
  local e = string.char(10)  local k = string.char(44)
  local s = string.sub(iBag.getName(), 5)  aBase.setName("SBx_"..s)
  local g = iBag.getDescription()  if string.len(g) == 6 then  g = g..",0,0,2,0"  iBag.setDescription(g)  end
  s = aBag.getLuaScript()  local n = string.len(s)  if string.sub(s, n) == e then s = string.sub(s, 1, n-1) end  if s == "" then s = "--" end
  s = s..aBase.guid..k..string.sub(aBase.getName(), 5)..string.sub(g, 7)..","..e.."--"  aBag.setLuaScript(s)
  iBag.setDescription("")  iBag.setName("")  aBase.setDescription(iBag.guid)  sclBase(aBase)
  getObjectFromGUID(getObjectFromGUID(cbp).getDescription()).destruct()  getObjectFromGUID(cbp).destruct()  cbp = nil
  broadcastToAll("Import Complete.", {0.943, 0.745, 0.14})  nl = aBase.guid  wBase.call("makeLink")
  aBase.unlock()  aBag.putObject(aBase)  aBase = nil  iBag.unlock()  mBag.putObject(iBag)  iBag = nil  Wait.time(|| newXBag(), 0.5)
end

function btnSeeAll()
    if not Global.getVar("oWisOn") then return end
    broadcastToAll("(scroll <Z-A>, all zones)", {0.7, 0.7, 0.7})  broadcastToAll("Use the One World Logo.", {0.943, 0.745, 0.14})
    if aBase then ba = {}  ba[-1] = 1  ba[0] = 1  ba[1] = aBase.guid  return  end
    local i, ii, g  local s = aBag.getLuaScript()  local e = string.char(10)  local t = {}  local ct = 0  local n = string.find(s, e)
    while string.len(s) > 6 do  ct = ct+1  t[ct] = string.sub(s, 1, n)  s = string.sub(s, n+1)  n = string.find(s, e)  end  s = ""
    for i = 2, ct do
      for ii = i, 2, -1 do
        if string.sub(t[ii], 10) < string.sub(t[ii-1], 10) then g = t[ii]  t[ii] = t[ii-1]  t[ii-1] = g  end
      end
    end  ba = {}  ba[-1] = 2  ba[0] = ct+1  ba[1] = string.sub(t[1], 3, 8)
    for i = 1, ct do  ba[i+1] = string.sub(t[i], 3, 8)  s = s..t[i]  end  s = s.."--"  aBag.setLuaScript(s)
end

function btnNew()
  if os.clock()-mb < 0.7 then  mb = mb-1    newMBag()  newABag()  tglEnable()
      broadcastToAll("(remove 1 pair from the table)", {0.7, 0.7, 0.7})  broadcastToAll("ReName these 2 Bags.", {0.943, 0.745, 0.14})
    else  mb = os.clock()  Wait.time(|| sglClick(), 0.5)
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
function newMBag()
  local p = {}  p.type = "Bag"  p.position = {10, -4, 0}  p.callback = "cbNMBag"  p.callback_owner = self  spawnObject(p)
end
function cbNMBag(a)  mBag = a
  p = self.getPosition()  a.setDescription("_OW_mBaG")  a.setName("Same_Name_Here")  a.setColorTint({0.713, 0.247, 0.313})
  a.setPosition({p[1]-3, p[2]+3, p[3]+(4.7*r2)})  a.setPositionSmooth({p[1]-3, p[2]+2.5, p[3]+(5*r2)})
end
function newABag()
  local p = {}  p.type = "Bag"  p.position = {0, -7, 10}  p.callback = "cbNABag"  p.callback_owner = self  spawnObject(p)
end
function cbNABag(a)
  p = self.getPosition()  a.setDescription("_OW_aBaG")  a.setName("Same_Name_Here")  a.setColorTint({0.713, 0.247, 0.313})
  a.setPosition({p[1], p[2]+3, p[3]+(4.7*r2)})  a.setPositionSmooth({p[1], p[2]+2.5, p[3]+(5*r2)})
end

function bagBackup()
    if not findBags() then return  end  if tBag then tBag.destruct() end
    tBag = mBag  tBag.interactable = false
    local c = {}  c.position = {3,-55, 3}  mBag.clone(c)  mBag.setDescription("_OW_tBaG")  mBag = nil
end

function dumpSet()
  if not tBag or not findBags() then return end
  mBag.destruct()  tBag.setDescription("_OW_mBaG")  mBag = tBag  tBag = nil
end

function netSync()
  if ss != "" or prs != "" then  broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  return  end
  if not findBags() then return  end
  broadcastToAll("Attempting to Sync NetCode...", {0.943, 0.745, 0.14})
  prs = aBase.getLuaScript()  if prs == "" then return end
  prs = string.gsub(prs, string.char(10), string.char(44))  prs = string.sub(prs, string.find(prs, "%-%-")+2)
  local a = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  cbp = a.getScale()  a.setScale({0, 0, 0})  end  Wait.time(|| cbNSync(), 0.5)
end
function cbNSync()
  local a = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))  if a then a.setScale(cbp) end  local n = string.find(prs, "%-%-")
  if not n then    prs = ""  cbp = nil  broadcastToAll("...Zone Objects Reset.", {0.943, 0.745, 0.14})  return  end
  prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  cbp = a.getScale()  a.setScale({0, 0, 0})  end
end

function btnBuild()
    if ef then btnEdit()  return  end
    if cbp then  if string.sub(cbp, 1, 3) == "xv." then  newCode()  return  end  end
    if not Global.getVar("oWisOn") or not aBase then return end
    if tBag then  netSync()  return  end
    if aBase.getDescription() == "" then return end
    if ss != "" or prs != "" then
      broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  return    end
    if not findBags() then return  end
    broadcastToAll("Recalling Zone Objects...", {0.943, 0.745, 0.14})  bagBackup()  local t = {}  t.smooth = false
    t.guid = aBase.getDescription()  t.position = {-2, -46, 7}  t.callback = "cbBuild"  t.callback_owner = self  tBag.takeObject(t)
end  function cbBuild(a)  iBag = a  a.lock()  doBuild()  end

function doBuild()
  local v = {}  v = iBag.getObjects()  prs = aBase.getLuaScript()
  if prs == "" or not v[1] then return end  cBase.setScale({33, 1, 38})
  prs = string.gsub(prs, string.char(10), string.char(44))
  local x, y, z  local ct = 1  local n  local dc = 0  local o = {}  local t = {}  ss = ""  zz = 0  cbp = ""
  while v[ct] do
    n = string.find(prs, "-"..v[ct].guid..",")
    if n then  o = getObjectFromGUID(v[ct].guid)
      if o then  isDupe(o)  dc = dc+1  else
        t.guid = v[ct].guid  n = n+8  zz = zz+1
        x, n = snipIt({n})  y, n = snipIt({n})  z, n = snipIt({n})  t.position = {x, 110, z}
        x, n = snipIt({n})  y, n = snipIt({n})  z, n = snipIt({n})  t.rotation = {x, y, z}
        t.callback = "unPack"  t.callback_owner = self  t.smooth = false  iBag.takeObject(t)
      end
    end  ct = ct + 1
  end  if zz > 0 then Wait.time(|| queZone(), 0.5) end
  if dc > 0 then broadcastToAll("Caution, Duplicate GUID ("..dc..") will be treated as Zone Objects.", {0.7, 0.7, 0.7}) end
end  function isDupe(o)  o.setLock(false)  local p = o.getPosition()  o.setPositionSmooth({p[1], p[2]+3, p[3]})  end

function snipIt(a)  local e = string.find(prs, string.char(44), a[1])  return string.sub(prs, a[1], e-1), e+1  end

function unPack(a)  ss = ss..a.guid  a.setLock(false)  end  --a.setName("")  a.setDescription("")  end

function queZone()
  if zz == 0 then    cbp = nil  zz = nil  prs = ""  Wait.time(|| pickLocks(), 0.5)  return  end
  local g, s  local a, b, c, x, y, z, n, t  local r = {}  local p = {}  local o = {}
  for t = 1, string.len(ss)/6 do
    g = string.sub(ss, 1, 6)  s = string.sub(ss, 7)  o = getObjectFromGUID(g)
    if not o then
      if string.find(cbp, "M"..g) then  zz = zz-1  ss = s  print("Missing Object...")
      else  cbp = cbp.."M"..g  ss = s..g  end  return
    end
    p = o.getPosition()  if p[2] < 95 then  o.setLock(true) else o.setPositionSmooth({p[1], 90, p[3]}) end
    if o.resting and p[2] < 108 then  o.setLock(true)
      n = string.find(prs, "-"..g..",")  r = o.getRotation()
      if not n then  print("Excess Object...")  o.setLock(false)  o.setPosition({0, 8, 0})  g = nil  else  n = n+8
        y, n = snipIt({n})  z, n = snipIt({n})  x, n = snipIt({n})  o.setPosition({y, z, x})  a = y  b = z  c = x
        y, n = snipIt({n})  z, n = snipIt({n})  x, n = snipIt({n})  o.setRotation({y, z, x})  o.resting = true
        if math.abs(p[1]-a) < 0.0005 and math.abs(p[2]-b) < 0.0005 and math.abs(p[3]-c) < 0.0005 and
          math.abs(r[1]-y) < 0.0005 and math.abs(r[2]-z) < 0.0005 and math.abs(r[3]-x) < 0.0005 then g = nil
        else  if string.find(cbp, "X"..g) then  g = nil  print("Failed Alignment...")  else cbp = cbp.."X"..g end
        end
      end
    end  if g then ss = s..g else  ss = s  zz = zz-1  end
  end
end

function pickLocks()
    local s = aBase.getLuaScript() local n = 0  cBase.setScale({0, 0, 0})
    while n+5 < string.len(s) do
        local g = string.sub(s, n+3, n+8)  n = string.find(s, string.char(10), n+3)
        if getObjectFromGUID(g) and string.sub(s, n-1, n-1) == "0" then getObjectFromGUID(g).unlock() end
    end  findBags()
    broadcastToAll("Finished Building.", {0.943, 0.745, 0.14})  setBtn()  if iBag then iBag.destruct()  iBag = nil  end
end