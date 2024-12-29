local sciptLinkPlate = [[
l1, l3, lh, u, sX, sY = nil, nil, nil, nil, nil, nil
function onPickedUp()
  u = self.held_by_color l1 = nil l3 = nil
  if math.abs(Player[u].lift_height - 0.03) > 0.005 then
    lh = Player[u].lift_height
  end
  Player[u].lift_height = 0.03
end

function onDropped()
  local x = getObjectFromGUID(self.getGMNotes()).getPosition()
  local p, s = self.getPosition(), self.getScale()
  self.setPosition({p[1], x[2] + 0.3, p[3]})
  self.setPositionSmooth({p[1], x[2], p[3]})
  l1 = p[1] l3 = p[3]
  sX = math.ceil(s.x*180) sY = math.ceil(s.z*180)
end

function onCollisionEnter()
  if u and lh then
    Player[u].lift_height = lh u = nil lh = nil
  end
end

function onDestroy()
  if u and lh then
    Player[u].lift_height = lh u = nil lh = nil
  end
end
]]

function onLoad()
  o = nil
  oneWorld = getObjectFromGUID(self.getGMNotes())
end

function onCollisionEnter(a)
  if(not oneWorld or not oneWorld.getVar("vBaseOn") or o == a.collision_object) then return end
  o = a.collision_object
  local g = string.sub(o.getName(), 1, 4) if g == "SET_" then g = "OWx_" end
  local i = "https://steamusercontent-a.akamaihd.net/ugc/13045573010340250/36C6D007CDC8304626495A82A96511E910CC301B/"
  if self.getDescription() == "" and g == "SBx_" and o.name == "Custom_Token" then NewBase()
    elseif self.getDescription() == "" and g == "OWx_" and o.name == "Bag" then DoImport()
    elseif self.getDescription() != "" and o.getCustomObject().image == i then AddLink()
    else
      if g == "SBx_" or g == "OWx_" then
        broadcastToAll("!! Clear Hub to Import !!", {0.95, 0.95, 0.95})
      else
        local v, s, n = oneWorld.getVar("vBase"), v.getLuaScript(), string.len(s)
        while string.sub(s, n) != "@" do
          s = string.sub(s, 1, n - 1)
          n = n - 1
        end
        g = o.guid
        local b, q, n = "", "DO NOT PACK: ", string.find(s, g)
        if g then b = " ("..g..")" end
        if n then q = "WILL PACK: " s = string.sub(s, 1, n-1)..string.sub(s, n+7) else s = s..g.."@" end
        v.setLuaScript(s) broadcastToAll(q..a.collision_object.name..b, {0.943, 0.745, 0.14})
      end
  end
end

function NewBase()
  local s = oneWorld.getVar("aBag").getLuaScript()
  if string.find(s, o.getGUID()) then broadcastToAll("Duplicate GUID.", {0.943, 0.745, 0.14})
  else oneWorld.call("PutBase", o.getGUID()) end
end

function DoImport()
  if oneWorld.getVar("aBag").getDescription() == "_OW_aBaG" then
    broadcastToAll("!! Can Not Import to an Empty World !!", {0.95, 0.95, 0.95})
    return
  end
  if string.sub(o.getName(), 1, 4) == "SET_" then
    o.setDescription("")  local v = {}  v = o.getObjects()  local n = 1
    while v[n] do
      if string.sub(v[n].name, 1, 4) == "SBx_" then
        oneWorld.setVar("currentBase", "i_"..o.guid)  o.setDescription(v[n].guid)
        break
      end
      n = n + 1
    end
    if o.getDescription() == "" then
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
    position = {-10, -45, 0}, guid = string.sub(o.getDescription(), 1, 6),
    callback = "PreImport", callback_owner = oneWorld.getVar("mBag"), smooth = false
  }
  o.takeObject(t)
end
function cbCTBase(a)
  oneWorld.setVar("currentBase", "c_"..o.getGUID())
  o.setDescription(a.getGUID()) a.setName("SBx_"..string.sub(o.getName(), 5))
  oneWorld.getVar("mBag").call("PreImport", a)
end

function AddLink()
  if oneWorld.call("isPVw") then o.destruct() return end
  local s = oneWorld.getVar("aBag").getLuaScript()
  if(o.getDescription() == self.getDescription()) then
    o.destruct()
    broadcastToAll("Link to Self or duplicate Link", {0.943, 0.745, 0.14})
    return
  end
  local l1, l3, sX, sY, p = o.getVar("l1"), o.getVar("l3"), o.getVar("sX"), o.getVar("sY"), self.getPosition()
  local h, v = 4.8, 8.5
  local r1, r3 = oneWorld.getVar("r1"), oneWorld.getVar("r3")
  local x, y = (l3 - p[3] + h/2)*100/h, (l1 - p[1] + v/2)*100/v
  if(oneWorld.getVar("r90") == 1) then
    x = (l1 - p[1] + h/2)*100/h
    y = (l3 - p[3] + v/2)*100/v
  end
  x = Round(x, 2) y = Round(y, 2)
  local lnk = oneWorld.getVar("lnk")
  lnk = lnk ~= nil and lnk ~= "" and lnk.."," or ""
  local newLnk = string.format("%s(%f;%f)(%f;%f)@%s", lnk, x, y, sX, sY, o.getDescription())
  oneWorld.setVar("lnk", newLnk)
  o.destruct()
  oneWorld.call("JotBase")
  SetLinks()
end

function SetLinks()
  local t = oneWorld.getVar("lnk")
  if(t == nil) then return end
  
  local rot = self.getRotation().z == 0 and 1 or -1
  local xmlTable = {
    {
      tag = "Panel",
      attributes = {
        position = "0 0 "..(-6*rot),
        width = "500",
        height = "300",
        rotation = "0 "..self.getRotation().z.." 0"
      },
      children = {}
    }
  }

  if self.getDescription() == "" then return end
  local r1, r3 = oneWorld.getVar("r1"), oneWorld.getVar("r3")
  local v, h = (1.85/self.getScale().z)*4.6, (1.85/self.getScale().x)*2.6
  if(oneWorld.getVar("r90") == 1) then v, h = (1.85/self.getScale().x)*4.6, (1.85/self.getScale().z)*2.6 end
  for str in t:gmatch("[%(%d.%d;%d.%d%)]*@") do
    local x, y, sX, sY
    local words = {}
    for w in str:gmatch("[^(;@,)]+") do
      table.insert(words, w)
    end
    x = (tonumber(words[1])*h/100 - (h/2 - 0.016))*100
    y = ((v/2 - 0.018) - tonumber(words[2])*v/100)*100
    sX, sY = tonumber(words[3]), tonumber(words[4])

    local newButton = {
      tag = "Button",
      attributes = {
        id = "link"..(#xmlTable[1].children + 1),
        image = "https://steamusercontent-a.akamaihd.net/ugc/13045573010340250/36C6D007CDC8304626495A82A96511E910CC301B/",
        width = sX,
        height = sY,
        offsetXY = (-y*rot).." "..x,
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
  local o = spawnObject(p)  local i = {}  i.thickness = 0.01
  i.image = "https://steamusercontent-a.akamaihd.net/ugc/13045573010340250/36C6D007CDC8304626495A82A96511E910CC301B/"  o.setCustomObject(i)
end
function cbMLink(a) a.setDescription(oneWorld.getVar("nl"))
  local bn = oneWorld.call("ParceData", {oneWorld.getVar("nl")})  a.setName(bn) oneWorld.setVar("nl", nil)
  a.setLuaScript(sciptLinkPlate) a.setGMNotes(self.getGMNotes())
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
  local bn = string.sub(oneWorld.call("ParceData", {l}), 1, 21)
  if bn != oneWorld.UI.getAttribute("mTxt", "text") then oneWorld.call("SetUIText", bn) oneWorld.setVar("linkToMap", l) oneWorld.call("SetUI")
  else oneWorld.call("GetBase", {l}) end
end

function ButtonLink(_, _, id) GetLink(tonumber(id:gsub("%D", ""), 10)) end
function Round(num, idp)
  return math.ceil(num*(10^idp))/10^idp
end