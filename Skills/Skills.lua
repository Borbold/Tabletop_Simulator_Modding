function UpdateSave()
  local dataToSave = {
    ["majorValue"] = majorValue,
    ["baffValue"] = baffValue,
    ["debaffValue"] = debaffValue,
    ["startValue"] = startValue,
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    Wait.time(|| Confer(savedData), 0.2)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or FillingTable(5)
  baffValue = loadedData.baffValue or FillingTable(0)
  debaffValue = loadedData.debaffValue or FillingTable(0)
  startValue = loadedData.startValue or FillingTable(5)
  ChangeUI()
end
function FillingTable(value)
  local locTable = {}
  for i = 1, 20 do
    table.insert(locTable, value)
  end
  return locTable
end
-- Скилы
function Minus(player, value, id)
  id = id:lower()
  ChangeSkills(-1, id:sub(6))
end
function Plus(player, value, id)
  id = id:lower()
  ChangeSkills(1, id:sub(5))
end
function ChangeSkills(value, id)
  if id:sub(0, #id - 1) == "baff" then
    id = tonumber(id:sub(5))
    baffValue[id] = baffValue[id] + value
  elseif id:sub(0, #id - 1) == "debaff" then
    id = tonumber(id:sub(7))
    debaffValue[id] = debaffValue[id] + value
  elseif id:sub(0, #id - 1) == "start" then
    id = tonumber(id:sub(6))
  end

  for i = 1, 7 do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i]
  end

  ChangeUI()
end

function ChangeUI()
  for i = 1, 20 do
    self.UI.setAttribute("major" .. i, "text", majorValue[i])
    self.UI.setAttribute("start" .. i, "text", startValue[i])
  end

  UpdateSave()
end

function Reset(player)
  majorValue = FillingTable(5)
  baffValue = FillingTable(0)
  debaffValue = FillingTable(0)
  startValue = FillingTable(5)
  ChangeUI()
end

function RebuildAssets()
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838068682998415380/navyki22.png'
  local stars = 'https://cdn.discordapp.com/attachments/800324103848198174/838075678124408872/stare.png'
  local assets = {
    {name = 'uiBackGroun', url = backG},
    {name = 'uiStars', url = stars}
  }
  self.UI.setCustomAssets(assets)
end
