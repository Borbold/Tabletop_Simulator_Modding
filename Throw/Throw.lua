function UpdateSave()
  local dataToSave = {
    ["successful"] = successful, ["baff"] = baff,
    ["countThrow"] = countThrow, ["deBaff"] = deBaff,
    ["maxValue"] = maxValue,
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(|| Confer(savedData), 2)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  successful = loadedData and loadedData.successful or {}
  baff = loadedData and loadedData.baff or {}
  deBaff = loadedData and loadedData.deBaff or {}
  maxValue = loadedData and loadedData.maxValue or {}
  countThrow = loadedData and loadedData.countThrow or {}
  ChangeUI()
end

function ChangeUI()
  for i = 1, 10 do
    self.UI.setAttribute("successful" .. i, "text", successful[i])
    self.UI.setAttribute("baff" .. i, "text", baff[i])
    self.UI.setAttribute("deBaff" .. i, "text", deBaff[i])
    self.UI.setAttribute("maxValue" .. i, "text", maxValue[i])
    self.UI.setAttribute("countThrow" .. i, "text", countThrow[i])
  end

  UpdateSave()
end

function ChangeValue(player, input, id)
  input = input == "" and "0" or input

  if id:find("successful") then
    id = tonumber(id:sub(11))
    successful[id] = tonumber(input)
  elseif id:find("baff") then
    id = tonumber(id:sub(5))
    baff[id] = tonumber(input)
  elseif id:find("deBaff") then
    id = tonumber(id:sub(7))
    deBaff[id] = tonumber(input)
  elseif id:find("maxValue") then
    id = tonumber(id:sub(9))
    maxValue[id] = tonumber(input)
  elseif id:find("countThrow") then
    id = tonumber(id:sub(11))
    countThrow[id] = tonumber(input)
  end

  ChangeUI()
end

function Throw(player, _, id)
  id = tonumber(id:sub(6))
  if not successful[id] or
     not baff[id] or
     not deBaff[id] or
     not maxValue[id] or
     not countThrow[id] then
    broadcastToAll("Не хватает значений")
    return
  end

  printToAll("Игрок " .. player.steam_name, player.color)
  printToAll("----------------", player.color)
  for i = 1, countThrow[id] do
    local locValueThrow = math.ceil(math.random(1, maxValue[id]*100)/100)
    local locMaxValue = successful[id] + baff[id] - deBaff[id]
    local flag = locValueThrow < locMaxValue
    printToAll("[948f7f]Бросок: " .. i)

    local res1 = flag and (locValueThrow .. "<" .. locMaxValue) or
                          (locValueThrow .. ">=" .. locMaxValue)
    broadcastToAll(flag and "Удачный: " .. res1 or "Провальный: " .. res1, flag and "Green" or "Red")

    local res2 = string.format("[948f7f]Выпавшее число: %s [ffffff]([00aa00]%s[ffffff])([aa0000]%s[ffffff]) [af8f7f]Максимальное: %s",
                              locValueThrow, baff[id], deBaff[id], maxValue[id])
    printToAll(res2)
  end
  printToAll("----------------", player.color)
end

function RebuildAssets()
  local backG = 'https://i.imgur.com/tYaqJqA.png'
  local dice = 'https://i.imgur.com/yjMpj2E.png'
  local assets = {
    {name = 'uiBackGround', url = backG},
    {name = 'uiDice', url = dice},
  }
  self.UI.setCustomAssets(assets)
end