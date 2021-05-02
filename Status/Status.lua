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
  maxInfoStatus = {1000, 1000, 1000, 1000, 1000, 1000}
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or {5, 5, 5, 5, 5, 5, 5, 5}
  baffValue = loadedData.baffValue or {0, 0, 0, 0, 0, 0, 0, 0}
  debaffValue = loadedData.debaffValue or {0, 0, 0, 0, 0, 0, 0, 0}
  startValue = loadedData.startValue or {5, 5, 5, 5, 5, 5, 5, 5}
  ChangeUI()
  SetStatusInformation()
end
-- Статусная информация
function InputStatusInformation(player, input, id)
  local currentDescription = {}
  for word in self.getDescription():gmatch("%S+") do
    table.insert(currentDescription, word)
  end

  local newDescription = ""
  newDescription = newDescription .. (id:find("1") and input or currentDescription[1] or "0") .. "\n"
  newDescription = newDescription .. (id:find("2") and input or currentDescription[2] or "0") .. "\n"
  newDescription = newDescription .. (id:find("3") and input or currentDescription[3] or "0") .. "\n"
  newDescription = newDescription .. (id:find("4") and input or currentDescription[4] or "0") .. "\n"
  newDescription = newDescription .. (id:find("5") and input or currentDescription[5] or "0") .. "\n"
  newDescription = newDescription .. (id:find("6") and input or currentDescription[6] or "0") .. "\n"
  self.setDescription(newDescription)
  SetStatusInformation()
end
function SetStatusInformation()
  local currentDescription = {}
  for word in self.getDescription():gmatch("%S+") do
    table.insert(currentDescription, word)
  end
  for i,w in ipairs(currentDescription) do
    if #w > 0 then
      self.UI.setAttribute("inputInfo" .. i, "text", w)
      self.UI.setAttribute("info" .. i, "text", "/" .. maxInfoStatus[i])
    end
  end
end
-- Статус
function Minus(player, value, id)
  id = id:lower()
  ChangeStatus(-1, id:sub(6))
end
function Plus(player, value, id)
  id = id:lower()
  ChangeStatus(1, id:sub(5))
end
function ChangeStatus(value, id)
  if id:sub(0, #id - 1) == "baff" then
    id = tonumber(id:sub(5))
    baffValue[id] = baffValue[id] + value
  elseif id:sub(0, #id - 1) == "debaff" then
    id = tonumber(id:sub(7))
    debaffValue[id] = debaffValue[id] + value
  elseif id:sub(0, #id - 1) == "start" then
    id = tonumber(id:sub(6))
    startValue[id] = startValue[id] + value
  end

  for i = 1, 8 do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i]
  end

  ChangeUI()
end

function ChangeUI()
  for i = 1, 8 do
    self.UI.setAttribute("major" .. i, "text", majorValue[i])
    self.UI.setAttribute("baff" .. i, "text", baffValue[i])
    self.UI.setAttribute("debaff" .. i, "text", debaffValue[i])
    self.UI.setAttribute("start" .. i, "text", startValue[i])
  end
  UpdateSave()
end

function Reset(player)
  majorValue = {5, 5, 5, 5, 5, 5, 5, 5}
  baffValue = {0, 0, 0, 0, 0, 0, 0, 0}
  debaffValue = {0, 0, 0, 0, 0, 0, 0, 0}
  startValue = {5, 5, 5, 5, 5, 5, 5, 5}
  for i = 1, 6 do
    InputStatusInformation(player, "0", tostring(i))
  end
  SetStatusInformation()
  ChangeUI()
end

function RebuildAssets()
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838078518155411466/status2.png'
  local assets = {
    {name = 'uiBackGro', url = backG},
  }
  self.UI.setCustomAssets(assets)
end
