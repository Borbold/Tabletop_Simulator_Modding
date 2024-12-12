--[[ l1 = nil  l3 = nil  lh = nil  u = nil

function onPickedUp()  u = self.held_by_color  l1 = nil  l3 = nil
  if math.abs(Player[u].lift_height - 0.03) > 0.005 then lh = Player[u].lift_height  end  Player[u].lift_height = 0.03
end

function onDropped()
  local x = getObjectFromGUID(Global.getVar("oW4TTale")).getPosition()
  local p = self.getPosition()  self.setPosition({p[1], x[2]+0.3, p[3]})  self.setPositionSmooth({p[1], x[2], p[3]})  l1 = p[1] l3 = p[3]
end

function onCollisionEnter()  if u and lh then Player[u].lift_height = lh  u = nil  lh = nil  end  end

function onDestroy()  if u and lh then Player[u].lift_height = lh  u = nil  lh = nil  end  end --oW_4TT ]]

-- ^^^  DO NOT ALTER OR REMOVE THESE LINES ABOVE  ^^^

o = nil

function onCollisionEnter(a)
    if not Global.getVar("oWisOn") or o == a.collision_object or o == 1 then return end
    o = a.collision_object  local ow = getObjectFromGUID(Global.getVar("oW4TTale"))
    local g = string.sub(o.getName(), 1, 4)  if g == "SET_" then g = "OWx_" end
    local i = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/x.png"
    if self.getDescription() == "" and g == "SBx_" and o.name == "Custom_Token" then newBase()
      elseif self.getDescription() == "" and g == "OWx_" and o.name == "Bag" then doImport()
      elseif self.getDescription() != "" and o.getCustomObject().image == i then addLink()
      else
        if g == "SBx_" or g == "OWx_" then broadcastToAll("!! Clear Hub to Import !!", {0.95, 0.95, 0.95})
        else local v = ow.getVar("vBase")  local s = v.getLuaScript()  local n = string.len(s)
          while string.sub(s, n) != "@" do  s = string.sub(s, 1, n-1)  n = n-1  end
          g = o.guid  local n = string.find(s, g)  local b = ""  local q = "DO NOT PACK: "  if g then b = " ("..g..")" end
          if n then  q = "WILL PACK: "  s = string.sub(s, 1, n-1)..string.sub(s, n+7)  else  s = s..g.."@"  end
          v.setLuaScript(s)  broadcastToAll(q..a.collision_object.name..b, {0.943, 0.745, 0.14})
        end
    end
    Wait.time(|| ow.call("popWB"), 0.2)
end

function newBase()
  local ow = getObjectFromGUID(Global.getVar("oW4TTale"))  local s = ow.getVar("aBag").getLuaScript()
  if string.find(s, "-"..o.guid ..",") then broadcastToAll("Duplicate GUID.", {0.943, 0.745, 0.14})
    else ow.call("putBase", {o.guid}) end
end

function doImport()
  local ow = getObjectFromGUID(Global.getVar("oW4TTale"))
  if ow.getVar("aBag").getDescription() == "_OW_aBaG" then
    broadcastToAll("!! Can Not Import to an Empty World !!", {0.95, 0.95, 0.95})  return end
  if string.sub(o.getName(), 1, 4) == "SET_" then
    o.setDescription("")  local v = {}  v = o.getObjects()  local n = 1
    while v[n] do
      if string.sub(v[n].name, 1, 4) == "SBx_" then
        ow.setVar("currentBase", "i_"..o.guid)  o.setDescription(v[n].guid)  break
      end n = n+1
    end
    if o.getDescription() == "" then broadcastToAll("Creating Hidden Base...", {0.943, 0.745, 0.14})
      local t = {}  t.position = {-10, -45, 0}  t.callback = "cbCTBase"  t.callback_owner = self  local i = {}
      i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/table_wood.jpg"  i.thickness = 0.1
      t.type = "Custom_Token"  local o = {}  o = spawnObject(t)  o.setCustomObject(i)  return    end
  end
  broadcastToAll("Importing Art...", {0.943, 0.745, 0.14})  local t = {}  t.position = {-10, -45, 0}
  t.guid = string.sub(o.getDescription(), 1, 6)  t.callback = "preImport"
  t.callback_owner = ow  t.smooth = false  o.takeObject(t)
end
function cbCTBase(a)
  local ow = getObjectFromGUID(Global.getVar("oW4TTale"))  ow.setVar("currentBase", "c_"..o.guid)
  o.setDescription(a.guid)  a.setName("SBx_"..string.sub(o.getName(), 5))  ow.call("preImport", {a})
end

function addLink()
  local ow = getObjectFromGUID(Global.getVar("oW4TTale"))
  if ow.call("isPVw") then  o.destruct()  return end
  if o.getDescription() == self.getDescription() then
    o.destruct()  broadcastToAll("Link to Self.", {0.943, 0.745, 0.14})  return end
  local l1 = o.getVar("l1")  local l3 = o.getVar("l3")  local p = {}
  if not l1 then  p = o.getPosition()  l1 = p[1]  l3 = p[3]  end
  p = self.getPosition()  local h = 4.8  local v = 8.5
  local r1 = ow.getVar("r1")  local r3 = ow.getVar("r3")
  if p[2] < 1 then broadcastToAll("For Better Control, Raise HUB to Table.", {0.95, 0.95, 0.95})  end
  local y = math.modf((l1-p[1]+v/2)*100/v)  if y < 0 then y = 0 elseif y > 99 then y = 99 end
  local x = math.modf((l3-p[3]+h/2)*100/h)  if x < 0 then x = 0 elseif x > 99 then x = 99 end
  if r1 == 180 then x = 99 - x end  if r3 == 180 then y = 99 - y end  local n = y
  if ow.getVar("r90") == 1 then  y = 99 - x  x = n  end
  y = string.sub("0"..y, string.len(y))  x = string.sub("0"..x, string.len(x))
  ow.setVar("lnk", ow.getVar("lnk")..x..y.."@"..o.getDescription()..",")  o.destruct()  ow.call("jotBase")  setLinks()
end

function setLinks()
    self.clearButtons()  if self.getDescription() == "" then return end
    ow = getObjectFromGUID(Global.getVar("oW4TTale"))
    local r1 = ow.getVar("r1")  local r3 = ow.getVar("r3")  local t = ow.getVar("lnk")  local i, v, h, n
    if ow.getVar("r90") == 1 then h = self.getScale().x / 1.85 * 4.65  v = self.getScale().z / 1.85 * 2.63
    else v = self.getScale().z / 1.85 * 4.65  h = self.getScale().x / 1.85 * 2.63  end
    n = 0  local r = 1  if r1 + r3 == 180 then r = -1 end
    local btn = {}  btn.function_owner = self  btn.label = " + "  btn.font_size = 150
    if r == -1 then n = 180 end  btn.rotation = {0, 45, n}  btn.width = 100  btn.height = 100
    for i = 0, string.len(t)/12-1 do  n = i*12+1
        local x = tonumber(string.sub(t, n, n+1))*h/100 - (h/2-0.016)
        local y = (v/2-0.018) - tonumber(string.sub(t, n+2, n+3))*v/100  btn.position = {y, 0.055*r, x}
        btn.click_function = "btnLink"..i  self.createButton(btn)
    end
end

function makeLink()
    local r2 = getObjectFromGUID(Global.getVar("oW4TTale")).getVar("r2")  local x = self.getPosition()
    x[1] = x[1]-(5.5 * r2)  x[2]=x[2]+2.5  local p = {}  p.type = "Custom_Token"  p.position = {x[1], x[2], x[3]}
    p.rotation = {0, 90, 0}  p.scale = {0.1, 0.1, 0.1}  p.callback = "cbMLink"  p.callback_owner = self
    local o = spawnObject(p)  local i = {}  i.thickness = 0.01
    i.image = "https://raw.githubusercontent.com/ColColonCleaner/TTSOneWorld/main/x.png"  o.setCustomObject(i)
end
function cbMLink(a)
    local ow = getObjectFromGUID(Global.getVar("oW4TTale"))  a.setDescription(ow.getVar("nl"))
    local bn = ow.call("parceData", {ow.getVar("nl")})  a.setName(bn)  ow.setVar("nl", nil)
    local s = self.getLuaScript()  s = string.sub(s, 6, string.find(s, "oW_4TT")-4)  a.setLuaScript(s)
end

function getLink(a)
    local ow = getObjectFromGUID(Global.getVar("oW4TTale"))
    if ow.getVar("butActive") then ow.call("EditMode") return end
    local l = string.sub(ow.getVar("lnk"), a[1]*12+6, a[1]*12+11)
    local bn = string.sub(ow.call("parceData", {l}), 1, 21)
    if bn != ow.UI.getAttribute("mTxt", "text") then ow.call("SetUIText", bn) ow.setVar("linkToMap", l) ow.call("SetUI")
    else ow.call("GetBase", {l}) end
end

function btnLink0() getLink({0}) end  function btnLink10() getLink({10}) end  function btnLink20() getLink({20}) end  function btnLink30() getLink({30}) end
function btnLink1() getLink({1}) end  function btnLink11() getLink({11}) end  function btnLink21() getLink({21}) end  function btnLink31() getLink({31}) end
function btnLink2() getLink({2}) end  function btnLink12() getLink({12}) end  function btnLink22() getLink({22}) end  function btnLink32() getLink({32}) end
function btnLink3() getLink({3}) end  function btnLink13() getLink({13}) end  function btnLink23() getLink({23}) end  function btnLink33() getLink({33}) end
function btnLink4() getLink({4}) end  function btnLink14() getLink({14}) end  function btnLink24() getLink({24}) end  function btnLink34() getLink({34}) end
function btnLink5() getLink({5}) end  function btnLink15() getLink({15}) end  function btnLink25() getLink({25}) end  function btnLink35() getLink({35}) end
function btnLink6() getLink({6}) end  function btnLink16() getLink({16}) end  function btnLink26() getLink({26}) end  function btnLink36() getLink({36}) end
function btnLink7() getLink({7}) end  function btnLink17() getLink({17}) end  function btnLink27() getLink({27}) end  function btnLink37() getLink({37}) end
function btnLink8() getLink({8}) end  function btnLink18() getLink({18}) end  function btnLink28() getLink({28}) end  function btnLink38() getLink({38}) end
function btnLink9() getLink({9}) end  function btnLink19() getLink({19}) end  function btnLink29() getLink({29}) end  function btnLink39() getLink({39}) end

function btnLink40() getLink({40}) end  function btnLink50() getLink({50}) end  function btnLink60() getLink({60}) end  function btnLink70() getLink({70}) end
function btnLink41() getLink({41}) end  function btnLink51() getLink({51}) end  function btnLink61() getLink({61}) end  function btnLink71() getLink({71}) end
function btnLink42() getLink({42}) end  function btnLink52() getLink({52}) end  function btnLink62() getLink({62}) end  function btnLink72() getLink({72}) end
function btnLink43() getLink({43}) end  function btnLink53() getLink({53}) end  function btnLink63() getLink({63}) end  function btnLink73() getLink({73}) end
function btnLink44() getLink({44}) end  function btnLink54() getLink({54}) end  function btnLink64() getLink({64}) end  function btnLink74() getLink({74}) end
function btnLink45() getLink({45}) end  function btnLink55() getLink({55}) end  function btnLink65() getLink({65}) end  function btnLink75() getLink({75}) end
function btnLink46() getLink({46}) end  function btnLink56() getLink({56}) end  function btnLink66() getLink({66}) end  function btnLink76() getLink({76}) end
function btnLink47() getLink({47}) end  function btnLink57() getLink({57}) end  function btnLink67() getLink({67}) end  function btnLink77() getLink({77}) end
function btnLink48() getLink({48}) end  function btnLink58() getLink({58}) end  function btnLink68() getLink({68}) end  function btnLink78() getLink({78}) end
function btnLink49() getLink({49}) end  function btnLink59() getLink({59}) end  function btnLink69() getLink({69}) end  function btnLink79() getLink({79}) end