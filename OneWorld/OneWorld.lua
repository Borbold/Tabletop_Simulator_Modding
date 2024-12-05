function update()  if cb[1] then cbc = cbc + 1  self.call(cb[1]) end  end
function cbOn(a)
  if a[1] == cb[1] then cbc = 0  do return end  end
  local n = 1  while cb[n] do  n = n+1  end  cb[n] = a[1]  if n == 1 then cbc = 0 end
end
function cbOff()  cb[1] = nil  local n = 2  while cb[n] do  cb[n-1] = cb[n]  n = n+1  end  cb[n-1] = nil  end

function onLoad()
    r1, r2, r3 = 0, 0, 0
    lnk, ss, prs, vbg, wbg, mtg = "", "", "", "", "", ""
    sizePlate = 25
    zz, zz2, gh, r90, cbc, iu = 0, 0, 0.91, 0, 0, 1
    wpx, pxy, aBase, nl, ub, ef = nil, nil, nil, nil, nil, nil
    cb, ba = {}, {}
    cbp, hb = "x", "<"
    mb = os.clock()
    doButtons()
end

function doButtons()
    local btn = {}  btn.function_owner = self
    btn.click_function = "btnEnable"  btn.position = {1.88, 0, 2.01}  btn.width = 240  btn.height = 140  btn.font_size = 110
      btn.label = "i"  btn.rotation = {0, 0, 0}  self.createButton(btn)
    btn.click_function = "btnHide"  btn.position = {-1.62, -0.05, -1.95 }  btn.width = 200  btn.height = 120  btn.font_size = 100
      btn.label = hb.."  ."  btn.tooltip = "Menu"  self.createButton(btn)
    btn.click_function = "btnVert"  btn.position = {-1.64, -0.05, 1.81 }  btn.width = 250  btn.height = 100  btn.font_size = 120
      btn.label = "..."  btn.rotation = {0, 90, 0}  btn.tooltip = ""  self.createButton(btn)
    btn.click_function = "btnHorz"  btn.position = {-1.3, -0.05, 2.14}  btn.width = 250  btn.height = 100
      btn.label = "..."  btn.rotation = {0, 0, 0}  self.createButton(btn)
    btn.click_function = "btnFit"  btn.position = {-1.65, -0.05, 1.41}  btn.width = 120  btn.height = 130  btn.font_size = 100
      btn.label = "" btn.rotation = {0, 0, 0}  btn.tooltip = "FitFrame"  self.createButton(btn)  -- "\ u {21b5}"  -- "\ u {2195}"
    btn.click_function = "btnProxy"  btn.position = {-0.9, -0.05, 2.14}  btn.width = 120  btn.height = 130  btn.font_size = 120
      btn.label = ""  btn.rotation = {0, 180, 0}    btn.tooltip = "Parent" self.createButton(btn)  btn.label = ""
    btn.click_function = "btnHome"  btn.position = {1.44, -0.05, -1.78}  btn.width = 165  btn.height = 320
      btn.tooltip = "Next"  self.createButton(btn)
    btn.click_function = "btnBack"  btn.position = {1.14, -0.05, -1.78}  btn.width = 165  btn.height = 320
      btn.tooltip = "Last"  self.createButton(btn)
    btn.click_function = "btnSelect"  btn.position = {1.29, -0.05, 0}  btn.width = 300  btn.height = 1000
      btn.tooltip = ""  self.createButton(btn)
    btn.click_function = "btnBuild"  btn.position = {1.82, 0, -1.72}  btn.width = 0  btn.height = 0  btn.font_size = 100
      btn.label = ""  btn.rotation = {0, 90, 0}  self.createButton(btn)
end

function btnHide()
  if not Global.getVar("oWisOn") or ef then do return  end  end
  if hb == "<" then  local btn = {}  local n = 0  local w = 0.84  local i = 0.345
    hb = ">"  btn.function_owner = self  btn.rotation = {0, 0, 0}  btn.width = 0  btn.height = 0  btn.font_size = 100
    btn.click_function = "btnNew"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnSeeAll"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnExport"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnDelete"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnCopy"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnEdit"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnLink"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  n = n+1
    btn.click_function = "btnPack"  btn.position = {-2.15, 0, w-n*i}  self.createButton(btn)  cbOn({"hldBtn"})
  else hb = "<"  local i
    for i = 10, 17 do  self.removeButton(i)  end
  end
  local b = {}  b.index = 1  b.label = hb.."  ."  self.editButton(b)
end  function hldBtn()  if cbc < 20 then do return end  end  cbOff()  setBtn()  end

function iUnit()
  Global.setVar("oW4TTale", self.guid)
  if not findBags() then return false end
  if string.sub(cbp, 1, 1) != "x" then  udShow()  return false  end
  upGrade()  local p = aBag.getPosition()
  if p[2] < -10 then Global.setVar("oWisOn", true) else Global.setVar("oWisOn", false) end
  broadcastToAll("(LOCK or continue from save)", {0.7, 0.7, 0.7})
  broadcastToAll("Initializing ONE WORLD...", {0.943, 0.745, 0.14})
  iu = nil  return true
end

function upGrade()
  local s = aBag.getLuaScript()  if s == "" then do return end  end
  local n, i  local m = 1  local k = string.char(44)  local e = string.char(10)  local t  local g = ""
  -- Add ParentView
  for i = 1, 4 do  n = string.find(s, k, m)  m = n+1  end
  if string.sub(s, n+2, n+2) != k then  n = string.find(s, e)
    while string.len(s) > 6 do
      t = string.sub(s, 1, n)  s = string.sub(s, n+1)  m = 1
      for i = 1, 4 do  n = string.find(t, k, m)  m = n+1  end
      t = string.sub(t, 1, n).."1"..k..string.sub(t, n+1)  g = g..t  n = string.find(s, e)
    end  aBag.setLuaScript(g..s)
  end  m = 1  g = ""
  -- Add Portait 90
  for i = 1, 5 do  n = string.find(s, k, m)  m = n+1  end
  if string.sub(s, n+2, n+2) != k then  n = string.find(s, e)
    while string.len(s) > 6 do
      t = string.sub(s, 1, n)  s = string.sub(s, n+1)  m = 1
      for i = 1, 5 do  n = string.find(t, k, m)  m = n+1  end
      t = string.sub(t, 1, n).."0"..k..string.sub(t, n+1)  g = g..t  n = string.find(s, e)
    end  aBag.setLuaScript(g..s)
  end  g = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/1world_18.png"
  if self.getCustomObject().image != g then  local c = {}  c.image = g  self.setCustomObject(c)  self.reload()  end
end

function tieObjects()
    local aoj = {}  aoj = getAllObjects()  local g = aoj[1]  local n = 1  Global.setVar("oW4TTale", self.guid)  local o = {}  local i = {}
    while g do
        if g.getDescription() == "_OW_tBaG" then if tBag then g.destruct() else  tBag = g  tBag.interactable = false  end  end
        if g.getName() == "_OW_xBaG" then if xBag then g.destruct() else xBag = g end  end
        if g.getName() == "_OW_sBase" then if sBase then g.destruct() else sBase = g end  end
        if g.getName() == "_OW_cBase" then if cBase then g.destruct() else cBase = g end  end
        if g.getName() == "_OW_vBase" then if vBase then g.destruct() else vBase = g end  end
        if g.getName() == "_OW_mTxT" then g.destruct() end
        n = n+1  g = aoj[n]
    end  reStart()
    i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg"  i.thickness = 0.1
    if not vBase then o.type = "Custom_Token"  o.position = {-9, -39, 9}  vBase = spawnObject(o)  vBase.setCustomObject(i)  end
    if not sBase then o.type = "Custom_Token"  o.position = {-9, -41, 9}  sBase = spawnObject(o)  sBase.setCustomObject(i)  end
    i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/cloud.png"  i.thickness = 0.5  i.merge_distance = 5  i.cast_shadows = false
    if not cBase then o.type = "Custom_Token"  o.position = {0, 85, 0}  cBase = spawnObject(o)  cBase.setCustomObject(i)  end
    if not mTxt then o.type = "3DText"  o.position = {0, -3, 0}  o.scale = {0.1, 0.1, 0.1}  mTxt  = spawnObject(o)  end  cbOn({"goTime"})
end

function goTime()  if cbc < 3 then do return end  end  cbOff()  local f = nil
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
  if not sBase then f = 4 else
    sBase.lock()  sBase.setScale({0, 0 ,0}) sBase.setPosition({-9, -39, 9})
    sBase.setName("_OW_sBase")  sBase.interactable = false
  end
  if not cBase then f = 5 else
    cBase.lock()  cBase.setScale({0, 0 ,0}) cBase.setPosition({0, 85, 0})
    cBase.setName("_OW_cBase")  cBase.interactable = false
  end
  if not mTxt then  f = 6 else
    mtg = mTxt.guid  mTxt.setName("_OW_mTxT")  mTxt.interactable = false
  end
  if f then  cbOn({"goTime"}) do return end  else  setBtn()  setTxt()  end
end

function btnEnable()  if os.clock()-mb < 1.1 then broadcastToAll("working...", {0.943, 0.745, 0.14})  do return end  else  chkIUnit()  end  end
function chkIUnit()  if iu then  if iUnit() then mb = os.clock()  cbp = nil  tieObjects() end  else tglEnable() end  end
function tglEnable()
    if ef then btnEdit()  do return end  end
    if not findBags() then do return end  end
    local p  if ba[1] != string.sub(aBag.getDescription(), 10) then reStart() end
    if not Global.getVar("oWisOn") then
        p = self.getPosition()  local r = self.getRotation()  if r[2] > 180 then r2 = -1 else r2 = 1  end
        self.interactable = false  self.lock()  self.setPosition({p[1], p[2]+0.1, p[3]})
        self.setRotation({0, (2-r2)*90, 0})  self.setScale({2.2,1,2.2})
        mBag.lock()  mBag.setScale({0, 0, 0})  mBag.setPosition({-3,-50, 3})  mBag.interactable = false
        aBag.lock()  aBag.setScale({0, 0, 0})  aBag.setPosition({-3,-55, -3}) aBag.interactable = false
        vBase.interactable = false  vBase.lock()  vBase.setScale({sizePlate, 1, sizePlate})  vBase.setPosition({0, gh, 0})
        wBase.interactable = false  wBase.lock()  wBase.setScale({1.85, 1, 1.85})  wBase.setPosition({p[1], p[2]+0.105, p[3]-(0.77*r2)})
        broadcastToAll("Running Version: "..self.getDescription(), {0.943, 0.745, 0.14})  wBase.setVar("o", 1)  cbOn({"popWB"})
        Global.setVar("oWisOn", true)  setTxt()  r1 = 0  r3= 0  r90 = 0  rotBase()  setBtn()  do return  end
    end
    if not aBase then  mb = os.clock()  if hb == ">" then btnHide() end  Global.setVar("oWisOn", false)  p = self.getPosition()
        self.interactable = true  self.unlock()  self.setPositionSmooth({p[1], p[2]+0.1, p[3]})
        mBag.unlock()  mBag.setScale({1, 1, 1})  mBag.setPosition({p[1]-3, p[2]+3, p[3]})  mBag.setPositionSmooth({p[1]-3, p[2]+2.5, p[3]})
        aBag.unlock()  aBag.setScale({1, 1, 1})  aBag.setPosition({p[1], p[2]+3, p[3]})  aBag.setPositionSmooth({p[1], p[2]+2.5, p[3]})
        mBag.interactable = true  aBag.interactable = true  vBase.interactable = true  vBase.unlock()  vBase.setScale({0.5, 1, 0.5})
        vBase.setPosition({p[1]+3, p[2]+3, p[3]-1})  vBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]-1})
        wBase.interactable = true  wBase.unlock()  wBase.setScale({0.5, 1, 0.5})
        wBase.setPosition({p[1]+3, p[2]+3, p[3]+1})  wBase.setPositionSmooth({p[1]+3, p[2]+2.5, p[3]+1})
        mTxt.setPosition({77, 77, 77})  mTxt.TextTool.setValue("")  mTxt.setScale({0, 0, 0})
        wpx = nil  reStart()  setBtn()  do return  end
    end
    if tBag then clrSet() else noBase() end  setBtn()  setTxt()
end

function reStart()
  cb = {}  prs = ""  ss = ""  cbOn({"newXBag"})
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
  local i  local btn = {}  local g = "LOCK"  btn.font_size = 65
  if Global.getVar("oWisOn") then btn.font_size = 80
    if wBase.getDescription() != "" then g = "CLR" else g = "END" end
  end  btn.index = 0  btn.label = g  self.editButton(btn)
  btn.index = 4  btn.label = ""  btn.font_size = 100  btn.tooltip = "Reset"
  if r90 == 1 then btn.label = "↵".." ." elseif r90 == 2 then btn.label = "↕".." ." else btn.tooltip = "FitFrame" end
  self.editButton(btn)  btn.index = 5  btn.label = ""  btn.font_size = 120
  if wpx or pxy then btn.label = "*" end  btn.tooltip = "Parent"  self.editButton(btn)  btn.tooltip = ""
  if hb == ">" then  btn.font_size = 100
    local s = "New,SeeAll,Export,Delete,Copy,Edit,Link,Pack,"
    for i = 10, 17 do  local w = 500  local h = 170
      local n = string.find(s, ",")  g = string.sub(s, 1, n-1)  s = string.sub(s, n+1)
      if aBase and i < 12 then w = 0  h = 0 g = "" end
      if not aBase and i > 11 then w = 0  h = 0 g = "" end
      if i == 16 then
        g = "Link"  local s = mTxt.TextTool.getValue()
        if aBase then s = string.sub(aBase.getName(), 5) end
        if ub and ba[-1] == ba[0] and s != mTxt.TextTool.getValue() then g = "unLink" end
        if not aBase then g = "-" end
      end
      btn.label = g  btn.index = i  btn.width = w  btn.height = h  self.editButton(btn)
    end
  end
  btn.width = 0  btn.height = 0 btn.label = ""  btn.index = 9
  if aBase then
    if aBase.getLuaScript() != "" and not pxy and string.sub(aBase.getName(), 5) == mTxt.TextTool.getValue() then
      btn.width = 400  btn.height = 180  if tBag then btn.label = "sync" else btn.label = "BUILD" end
    end
  end  self.editButton(btn)
end

function setTxt()
  if not Global.getVar("oWisOn") then do return  end  end
  mTxt = getObjectFromGUID(mtg)
  local g = "One World"  if wBase.getDescription() != "" then g = string.sub(aBase.getName(), 5, sizePlate)  end  showTxt({g})
end  function showTxt(a)  g = a[1]
  if a[2] then mTxt.TextTool.setFontColor({0.3, 0.3, 0.3})
    elseif wpx == nil or wpx == wBase.getDescription() then mTxt.TextTool.setFontColor({0.542, 0.176, 0.176})
    else mTxt.TextTool.setFontColor({0.249, 0.344, 0.152})  end
  local n = string.len(g)  if n < 6 then n = 6 end  n = 64-((n-6)*(24/20))  local x  = (n-40)*0.0204  local y = 0.7-(x*1.2)
  mTxt.TextTool.setFontSize(n)  mTxt.TextTool.setValue(g)  mTxt.setScale({1+x, 1+y, 1})
  local p = self.getPosition()  mTxt.setPosition({p[1]+(0.7*r2), p[2]+0.059, p[3]+(3.3*r2)})  mTxt.setRotation({90, (90*r2), 90})
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
    if cbc > 10 and getObjectFromGUID(wbg) and getObjectFromGUID(vbg) then cbOff() else do return end end  local f = 0
    wBase = getObjectFromGUID(wbg)  vBase = getObjectFromGUID(vbg)  wBase.interactable = false  vBase.interactable = false
    if aBase then
      if vBase.getCustomObject().image == aBase.getCustomObject().image then  vBase.setColorTint(aBase.getColorTint())  f = f+1  end
      if wBase.getCustomObject().image == aBase.getCustomObject().image then  wBase.setColorTint(aBase.getColorTint())  f = f+2  end
    end
    if f == 0 or f == 2 then vBase.setColorTint(sBase.getColorTint()) end  if f < 2 then wBase.setColorTint(sBase.getColorTint()) end
    gh = 0.91  if vBase.getCustomObject().image == sBase.getCustomObject().image then gh = -0.91 end
    if wpx == nil or wpx == wBase.getDescription() then wBase.call("setLinks") end
    if nl then wBase.call("makeLink") end  self.setRotation({0, (2-r2)*90, 0})  rotBase()
end

function popWB() if cbc > 20 then  cbOff()  wBase.setVar("o", nil)  end  end
function btnHorz()  if isPVw() then do return end  end  if aBase then r1 = 180 - r1  rotBase()  jotBase()  end  end
function btnVert()  if isPVw() then do return end  end  if aBase then r3 = 180 - r3  rotBase()  jotBase()  end  end

function btnFit()  if isPVw() or not aBase or ef then do return end  end
  if tBag then broadcastToAll("Pack or Clear Zone before Edit.", {0.943, 0.745, 0.14})  do return end  end
  if r90 != 0 then  r90 = 0  vBase.setScale({sizePlate, 1, sizePlate})  wBase.setScale({1.85, 1, 1.85})  aBase.setScale({0.5, 1, 0.5})
  else  local x = vBase.getBoundsNormalized().size.x  local z = vBase.getBoundsNormalized().size.z
    if z > x * 1.05 then  r90 = 1  x = 52 / x  z = 88 / z else  r90 = 2  x = 88 / x  z = 52 / z  end
    if r90 == 2 and x == 1 and z == 1 then r90 = 0 end
    vBase.setScale({sizePlate*x, 1, sizePlate*z})  wBase.setScale({1.85*x, 1, 1.85*z})  aBase.setScale({18.09*x/36, 1, 18.09*z/36})
  end  jotBase()  stowBase()  noBase()  setBtn()  setTxt()  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
end

function rotBase()
  local n = 0  if r90 == 1 then n = 90 end  vBase.setPosition({0, gh, 0})  vBase.setRotation({r1, n, r3})
  if wpx == nil or wpx == wBase.getDescription() then  wBase.setRotation({r1, n, r3})  wBase.call("setLinks")  end
end

function btnProxy()
  if not Global.getVar("oWisOn") or not aBase then do return  end  end
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
      setTxt()  wBase.setCustomObject(v)  wBase.reload()  cbOn({"cbTObj"})
    else
      if tBag then  broadcastToAll("Pack or Clear Zone to Enter Parent View.", {0.943, 0.745, 0.14})  do return end  end
      pxy = 8  f = 1  v.image = sBase.getCustomObject().image  vBase.setPosition({0, -0.91, 0})
      wpx = wBase.getDescription()  g = "Entering Parent View..."
    end
  end
  if f then  jotBase()  vBase.setCustomObject(v)  vBase.reload()  cbOn({"cbTObj"})  end
  setBtn()  broadcastToAll(g, {0.286, 0.623, 0.118})
end

function btnPack()
    if isPVw() then do return end  end
    if not Global.getVar("oWisOn") or not aBase then do return  end  end
    if ss != "" or prs != "" then broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  do return  end  end
    if not findBags() then do return end  end  if tBag then dumpSet() end  local l = vBase.getLuaScript()
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
  aBase.setDescription(a.guid)  iBag = a  cbOn({"cbPack"})
end
function cbPack()  if cbc < 12 then do return  end  end
    if ss == "" then  cbOff()  cbOn({"endPack"}) end  local i, g
    for i = 0, string.len(ss)/6-1 do  g = string.sub(ss, i*6+1, i*6+6)
      if not getObjectFromGUID(g) then ss = string.sub(ss, 1, i*6)..string.sub(ss, i*6+7) end
    end  if ss == "" then do return  end  end
    cbc = 0  z2 = z2 + 1  if z2/10 == math.modf(z2/10) then broadcastToAll("Pass"..(z2/10).."...", {0.943, 0.745, 0.14})  end
    if z2 > 68 then broadcastToAll("Manual Inspection Required.", {0.943, 0.745, 0.14})
      for i = 0, string.len(ss)/6-1 do  g = string.sub(ss, i*6+1, i*6+6)
        getObjectFromGUID(g).resting = true  getObjectFromGUID(g).setPosition({0, 3, 0})
      end  ss = ""
    end
end
function endPack()  if cbc < 45 then do return end  end  cbOff()
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
  sclBase(aBase)  aBag.takeObject(t)  aBase.unlock()  aBag.putObject(aBase)  cbOn({"newXBag"})  aBase = nil
end  function oldBase(a)  a.destruct()  end

function noBase()
  r1 = 0  r3 = 0  r90 = 0  rotBase()  wBase.setDescription("")  aBase = nil  lnk = ""
  wBase.setScale({1.85, 1, 1.85})  vBase.setScale({sizePlate, 1, sizePlate})  local c = {}  c.image = sBase.getCustomObject().image
  vBase.setCustomObject(c)  vBase.reload()  wBase.setCustomObject(c)  wBase.reload()  wpx = nil  pxy = nil  cbOn({"cbTObj"})
end

function putBase(a)
  aBase = getObjectFromGUID(a[1])  jotBase()
  aBase.setLuaScript("")  aBase.setDescription("")  aBag.putObject(aBase)  wBase.setDescription("")
  if not ba[1] then  ba[1] = a[1]  aBag.setDescription("_OW_aBaG_"..ba[1])  ba[0] = 1  end
  cbOn({"newXBag"})  cbOn({"cbPutBase"})  cbp = a[1]  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
end
function cbPutBase()
  if cbc < 120 then do return  end  end  cbOff()  nl = cbp  getBase({cbp})  cbp = nil
end

function newXBag()  if cbc > 12 then cbc = 6 end
  if cbc < 6 then do return  end  end
  if cbc == 6 then if xBag then xBag.destruct() end  o = {}  o.position = {-3, -48.5, -3}  xBag = aBag.clone(o)  end
  if cbc < 12 then do return  end  end  cbOff()
  xBag.lock()  xBag.interactable = false  xBag.setScale({0, 0 ,0}) xBag.setPosition({-3, -48.5, -3})
  xBag.setDescription("")  xBag.setName("_OW_xBaG")  xBag.setLuaScript("")
end

function getBase(a)  ub = nil
    if not Global.getVar("oWisOn") or a[1] == wBase.getDescription() then do return  end  end
    if tBag then clrSet() end  wBase.setDescription("")  aBase = nil
    local g = a[1]  local t = lnk  bn, r1, r3, pxy, r90, lnk = parceData({g})  if bn == nil then do return  end  end
    if pxy and not wpx then  wpx = g  broadcastToAll("Entering Parent View...", {0.286, 0.623, 0.118})
    else if wpx then lnk = t end  end
    if getObjectFromGUID(g) then cbGetBase(getObjectFromGUID(g))  do return  end  end
    local t = {}  t.guid = g  t.position = {0,-3, 0}  t.rotation = {0, 0, 0}  t.smooth = false
    t.callback = "cbGetBase"  t.callback_owner = self  xBag.takeObject(t)
end
function cbGetBase(a)
    local locPos = self.getPosition()
    a.setPosition({locPos.x, locPos.y - 0.5, locPos.z})  a.lock()  a.interactable = false aBase = a
    wBase.setDescription(a.guid)  local p = self.getPosition()  wBase.setPosition({p[1], p[2]+0.005, p[3]-(0.77*r2)})
    rotBase()  setTxt()  setBtn()  rollBack({a.guid})  local v = {}
    if wpx and wpx != wBase.getDescription() then  v.image = aBase.getCustomObject().image  vBase.setPosition({0, gh, 0})
    else  local n = sizePlate/1.85  local x = a.getScale().x  local z = a.getScale().z
      if x == z then x = sizePlate  z = sizePlate  else  x = x * 36  z = z * 36  end  wBase.setScale({x/n, 1, z/n})
      local w = {}  w.image = aBase.getCustomObject().image  wBase.setCustomObject(w)  wBase.reload()
      if pxy then v.image = sBase.getCustomObject().image  vBase.setPosition({0, -0.91, 0})  vBase.setScale({sizePlate, 1, sizePlate})
      else  vBase.setScale({x, 1, z})  v.image = aBase.getCustomObject().image  vBase.setPosition({0, gh, 0})  end
    end
    vBase.setCustomObject(v)  vBase.reload()  cbOn({"cbTObj"})
end

function isPVw()  if wpx then broadcastToAll("Action Canceled While in Parent View.", {0.943, 0.745, 0.14})  return true  end  end

function parceData(a)
  local h = string.char(45)  local k = string.char(44)  local e = string.char(10)  local s = aBag.getLuaScript()
  local g = a[1] local n = string.find(s, k, string.find(s, h..g..k))  local m = n
  if not n then broadcastToAll("Missing Base.", {0.943, 0.745, 0.14})  do return  end  end
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
    if ef then btnEdit()  do return end  end
    if not Global.getVar("oWisOn") or not aBase then do return  end  end
    if ub then  getBase({ub})  ub = nil  setBtn()  do return end  end
    if ba[-1] != ba[0] then  getBase({ba[ba[-1] ]}) end
end

function btnHome()
  if wpx then  wpx = nil  getBase({ba[1]})  do return end  end
  if ef then btnEdit()  do return end  end
  if not Global.getVar("oWisOn") then do return end  end  ub = nil  setBtn()
  if ba[0] < 2 or not aBase then
    if ba[1] then  getBase({ba[1]})  end  do return end
  end  ba[-1] = ba[-1]+1  mvPoint()
end
function btnBack()
  if wpx then  wpx = nil  getBase({ba[1]})  do return end  end
  if ef then btnEdit()  do return end  end
  if not Global.getVar("oWisOn") then do return end  end  ub = nil  setBtn()
  if ba[0] < 3 then btnHome()  do return  end  end
  if not aBase then  getBase({ba[ba[0] ]})  do return end  end
  ba[-1] = ba[-1]-1  mvPoint()
end
function mvPoint()
  if ba[-1] < 2 then ba[-1] = ba[0] end  if ba[-1] > ba[0] then ba[-1] = 2 end
  local b = parceData({ba[ba[-1] ]})  showTxt({b, 1})  setBtn()
  if aBase and ba[-1] == ba[0] then mTxt.TextTool.setFontColor({0.542, 0.176, 0.176}) end
end

function rollBack(a)
  local i  local n = 0
  for i = 2, ba[0] do  if ba[i] == a[1] then n = i  break  end  end
  if n == 0 then ba[0] = ba[0]+1
  else for i = n, ba[0] do  ba[i] = ba[i+1]  end  end  ba[ba[0] ] = a[1]  ba[-1] = ba[0]
end

function btnLink()
  if isPVw() then do return end  end
  if not Global.getVar("oWisOn") or not aBase then do return  end  end
  if ub and ba[-1] == ba[0] and string.sub(aBase.getName(), 5) != mTxt.TextTool.getValue() then
    local n = string.find(lnk, "@"..ub)
    while n do  lnk = string.sub(lnk, 1, n-5)..string.sub(lnk, n+8)  n = string.find(lnk, "@"..ub)  end
    nl = ub  ub = nil  setTxt()  setBtn()  jotBase()  wBase.call("setLinks")
  else nl = aBase.guid end  wBase.call("makeLink")  ub = nil
end

function btnEdit()
  if isPVw() then do return end  end
  if not Global.getVar("oWisOn") or wBase.getDescription() == "" or cb[1] then do return end  end
  aBase = getObjectFromGUID(wBase.getDescription())
  if tBag then broadcastToAll("Pack or Clear Zone before Edit.", {0.943, 0.745, 0.14})  do return end  end
  if not ef then
    btnHide()  ef = 1  local p = self.getPosition()
    broadcastToAll("Alter this Token: Name, Custom Art or Tint.", {0.943, 0.745, 0.14})
    mTxt.TextTool.setFontColor({0.534, 0.486, 0.089})
    mTxt.TextTool.setFontSize(65)  mTxt.TextTool.setValue("Exit Edit Mode")  mTxt.setScale({1, 1, 1.6})
    aBase.interactable = true  aBase.unlock()  aBase.setRotation({0, 0, 0})  sclBase(aBase)
    aBase.setPosition({p[1], p[2]+3, p[3]+(4.7*r2)})  aBase.setPositionSmooth({p[1], p[2]+2.5, p[3]+(4.7*r2)})
  else
    jotBase()  stowBase()  noBase()  setBtn()  setTxt()  ef = nil  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})  end
end  function sclBase(a)  if a.getScale().x == a.getScale().z then a.setScale({0.5, 1, 0.5})  end  end

function btnCopy()
  if isPVw() then do return end  end
  if not Global.getVar("oWisOn") or not aBase or not findBags() then do return  end  end
  if ss != "" or prs != "" or cb[1] then  broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  do return end  end
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
  if a then  p = a.getPosition()  o.position = {p[1], p[2]+66, p[3]}  cbp = a.clone(o)  end  cbOn({"cb2Copy"})
end
function cb2Copy()  if cbc < 5 then do return end  end
  local a = {}  local o = {}  local p = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  p = a.getPosition()  cbp.setPosition({p[1], p[2]+66, p[3]})  end  local n = string.find(prs, "%-%-")
  if not n then  cbOff()
    prs = ""  cbp = nil  broadcastToAll("...Copy Complete.", {0.943, 0.745, 0.14})  cbOn({"cb3Copy"})  do return end
  end
  prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  p = a.getPosition()  o.position = {p[1], p[2]+66, p[3]}  cbp = a.clone(o)  end
end
function cb3Copy() if cbc < 5 then do return end  end cbOff()
  clrSet(1)  local p = {}  p.position = {6, -28, 6}  aBase = aBase.clone(p)  cbOn({"cb4Copy"})
end
function cb4Copy() if cbc < sizePlate then do return end  end  cbOff()
  local x = self.getPosition()  x[1] = x[1]-(5.7 * r2)  aBase.setRotation({0, 90, 0})  sclBase(aBase)
  aBase.setPosition({x[1], x[2]+2.5, x[3]})  aBase.setPositionSmooth({x[1], x[2]+2, x[3]})  aBase.setLuaScript("")
  aBase.setName("SBx_Copy_"..string.sub(aBase.getName(), 5))  aBase.setDescription("")
  aBase.unlock()  noBase()  setBtn()  setTxt()
end

function btnDelete()
    if isPVw() then do return end  end
    if not Global.getVar("oWisOn") or not aBase then do return  end  end
    if aBase.getLuaScript() != "" and not tBag then broadcastToAll("Deploy Zone to Delete.", {0.943, 0.745, 0.14})  do return  end  end
    if tBag then  cbp = aBase.guid
      dumpSet()  clrSet()  aBase.setLuaScript("")  stowBase()  wBase.setDescription("")
      cbOn({"cb2Delete"})  broadcastToAll("Packing Base...", {0.943, 0.745, 0.14})
    else  local g = aBase.guid
      if g == ba[1] then broadcastToAll("Can't Delete Home, Edit Art Instead.", {0.943, 0.745, 0.14})  do return end  end
      local e = string.char(10)  local k = string.char(44)  local h = string.char(45)  local o = {}
      local s = aBag.getLuaScript()  local n = string.find(s, h..g..k)
      if n then  local m = string.find(s, e, n)  s = string.sub(s, 1, n-2)..string.sub(s, m+1)  end
      ba[ba[0] ] = nil  ba[0] = ba[0]-1  aBase.destruct()  noBase()  n = string.find(s, "@"..g..k)
      while n do  s = string.sub(s, 1, n-5)..string.sub(s, n+8)  n = string.find(s, "@"..g..k)  end
      aBag.setLuaScript(s)  o.smooth = false  o.callback = "cbDelete"  o.callback_owner = self
      o.guid = g  o.position = {12, -21, -14}  aBag.takeObject(o)
    end  setBtn()  setTxt()
end  function cbDelete(a)  a.destruct()  end
function cb2Delete()  if cbc < 120 then do return  end  end  cbOff()  getBase({cbp})  cbp = nil  end

function btnExport()
  if isPVw() then do return end  end
  if not Global.getVar("oWisOn") or not aBase then do return  end  end
  if not tBag then broadcastToAll("Deploy Zone to Export.", {0.943, 0.745, 0.14})  do return  end
    else tBag.destruct()  tBag = nil  end
  broadcastToAll("Bagging Export...", {0.943, 0.745, 0.14})
  local t = {}  t.position = {-7, -23, -4}  eBase = aBase.clone(t)
  t.type = "Bag"  t.position = {0, 4, 0}  iBag = spawnObject(t)  cbOn({"cbExport"})
end
function cbExport()  if cbc < 10 then do return end  end  cbOff()
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
  iBag = getObjectFromGUID(a.getDescription()).clone(t)  cbp = a.guid  cbOn({"doImport"})
end
function doImport()  if cbc < sizePlate then do return end  end  cbOff()
  local t = {}  t.position = {0, -3, 0}  aBase = getObjectFromGUID(cbp).clone(t)
  iBag.setPosition({3, -39, -7})  iBag.lock()  cbOn({"cbImport"})
end
function cbImport()  if cbc < sizePlate then do return end  end
  local p = self.getPosition()  p[1] = p[1]-(5.5 * r2)
  if cbc == 10 then aBase.setPosition({p[1], p[2]+4, p[3]})  aBase.setPositionSmooth({p[1], p[2]+1, p[3]})  end
  if cbc > 60 then cbOn({"cbImport"})  do return end  end
  local j = aBase.getPosition()  if j[2] > p[2]+3.5 then  do return end  end  cbOff()
  local e = string.char(10)  local k = string.char(44)
  local s = string.sub(iBag.getName(), 5)  aBase.setName("SBx_"..s)
  local g = iBag.getDescription()  if string.len(g) == 6 then  g = g..",0,0,2,0"  iBag.setDescription(g)  end
  s = aBag.getLuaScript()  local n = string.len(s)  if string.sub(s, n) == e then s = string.sub(s, 1, n-1) end  if s == "" then s = "--" end
  s = s..aBase.guid..k..string.sub(aBase.getName(), 5)..string.sub(g, 7)..","..e.."--"  aBag.setLuaScript(s)
  iBag.setDescription("")  iBag.setName("")  aBase.setDescription(iBag.guid)  sclBase(aBase)
  getObjectFromGUID(getObjectFromGUID(cbp).getDescription()).destruct()  getObjectFromGUID(cbp).destruct()  cbp = nil
  broadcastToAll("Import Complete.", {0.943, 0.745, 0.14})  nl = aBase.guid  wBase.call("makeLink")
  aBase.unlock()  aBag.putObject(aBase)  aBase = nil  iBag.unlock()  mBag.putObject(iBag)  iBag = nil  cbOn({"newXBag"})
end

function btnSeeAll()
    if not Global.getVar("oWisOn") then do return  end  end
    broadcastToAll("(scroll <Z-A>, all zones)", {0.7, 0.7, 0.7})  broadcastToAll("Use the One World Logo.", {0.943, 0.745, 0.14})
    if aBase then ba = {}  ba[-1] = 1  ba[0] = 1  ba[1] = aBase.guid  do return end  end
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
  if os.clock()-mb < 0.7 then  mb = mb-1  cbOff()  newMBag()  newABag()  tglEnable()
      broadcastToAll("(remove 1 pair from the table)", {0.7, 0.7, 0.7})  broadcastToAll("ReName these 2 Bags.", {0.943, 0.745, 0.14})
    else  mb = os.clock()  cbOn({"sglClick"})
  end
end
function sglClick()  if os.clock()-mb < 0.8 then do return end end  cbOff()
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
    if not findBags() then do return end  end  if tBag then tBag.destruct() end
    tBag = mBag  tBag.interactable = false
    local c = {}  c.position = {3,-55, 3}  mBag.clone(c)  mBag.setDescription("_OW_tBaG")  mBag = nil
end

function dumpSet()
  if not tBag or not findBags() then do return  end  end
  mBag.destruct()  tBag.setDescription("_OW_mBaG")  mBag = tBag  tBag = nil
end

function netSync()
  if ss != "" or prs != "" then  broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  do return end  end
  if not findBags() then do return end  end
  broadcastToAll("Attempting to Sync NetCode...", {0.943, 0.745, 0.14})
  prs = aBase.getLuaScript()  if prs == "" then do return  end  end
  prs = string.gsub(prs, string.char(10), string.char(44))  prs = string.sub(prs, string.find(prs, "%-%-")+2)
  local a = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  cbp = a.getScale()  a.setScale({0, 0, 0})  end  cbOn({"cbNSync"})
end
function cbNSync()  if cbc < 5 then do return end  end
  local a = {}  a = getObjectFromGUID(string.sub(prs, 1, 6))  if a then a.setScale(cbp) end  local n = string.find(prs, "%-%-")
  if not n then  cbOff()  prs = ""  cbp = nil  broadcastToAll("...Zone Objects Reset.", {0.943, 0.745, 0.14})  do return end  end
  prs = string.sub(prs, n+2)  a = getObjectFromGUID(string.sub(prs, 1, 6))
  if a then  cbp = a.getScale()  a.setScale({0, 0, 0})  end
end

function btnBuild()
    if ef then btnEdit()  do return end  end
    if cbp then  if string.sub(cbp, 1, 3) == "xv." then  newCode()  do return end  end  end
    if not Global.getVar("oWisOn") or not aBase then do return  end  end
    if tBag then  netSync()  do return end  end
    if aBase.getDescription() == "" then do return  end  end
    if ss != "" or prs != "" then
      broadcastToAll("The Current Zone is Busy...", {0.943, 0.745, 0.14})  do return  end
    end
    if not findBags() then do return end  end
    broadcastToAll("Recalling Zone Objects...", {0.943, 0.745, 0.14})  bagBackup()  local t = {}  t.smooth = false
    t.guid = aBase.getDescription()  t.position = {-2, -46, 7}  t.callback = "cbBuild"  t.callback_owner = self  tBag.takeObject(t)
end  function cbBuild(a)  iBag = a  a.lock()  doBuild()  end

function doBuild()
  local v = {}  v = iBag.getObjects()  prs = aBase.getLuaScript()
  if prs == "" or not v[1] then do return  end  end  cBase.setScale({33, 1, 38})
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
  end  if zz > 0 then cbOn({"queZone"}) end
  if dc > 0 then broadcastToAll("Caution, Duplicate GUID ("..dc..") will be treated as Zone Objects.", {0.7, 0.7, 0.7}) end
end  function isDupe(o)  o.setLock(false)  local p = o.getPosition()  o.setPositionSmooth({p[1], p[2]+3, p[3]})  end

function snipIt(a)  local e = string.find(prs, string.char(44), a[1])  return string.sub(prs, a[1], e-1), e+1  end

function unPack(a)  ss = ss..a.guid  a.setLock(false)  end  --a.setName("")  a.setDescription("")  end

function queZone()  if cbc < 5 then do return  end  end
  if zz == 0 then  cbOff()  cbp = nil  zz = nil  prs = ""  cbOn({"pickLocks"})  do return end  end
  local g, s  local a, b, c, x, y, z, n, t  local r = {}  local p = {}  local o = {}
  for t = 1, string.len(ss)/6 do
    g = string.sub(ss, 1, 6)  s = string.sub(ss, 7)  o = getObjectFromGUID(g)
    if not o then
      if string.find(cbp, "M"..g) then  zz = zz-1  ss = s  print("Missing Object...")
      else  cbp = cbp.."M"..g  ss = s..g  end  do return end
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
  end  --cBase.setName(zz)  cBase.setDescription(ss)  cBase.interactable = true
end

function pickLocks()
    if cbc < 10 then do return  end  end  cbOff()
    local s = aBase.getLuaScript() local n = 0  cBase.setScale({0, 0, 0})
    while n+5 < string.len(s) do
        local g = string.sub(s, n+3, n+8)  n = string.find(s, string.char(10), n+3)
        if getObjectFromGUID(g) and string.sub(s, n-1, n-1) == "0" then getObjectFromGUID(g).unlock() end
    end  findBags()
    broadcastToAll("Finished Building.", {0.943, 0.745, 0.14})  setBtn()  if iBag then iBag.destruct()  iBag = nil  end
end