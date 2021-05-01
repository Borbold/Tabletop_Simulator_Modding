function UpdateSave()
  local dataToSave = {
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
  majorValue = loadedData.majorValue or {5, 5, 5, 5, 5, 5, 5}
  baffValue = loadedData.baffValue or {0, 0, 0, 0, 0, 0, 0}
  debaffValue = loadedData.debaffValue or {0, 0, 0, 0, 0, 0, 0}
  startValue = loadedData.startValue or {5, 5, 5, 5, 5, 5, 5}
  maxSkillPoint = loadedData.maxSkillPoint or 40
  ChangeUI()
  SetBasicInformation()
end
-- Базовая инфа
function InputBasicInformation(player, input, id)
  local currentDescription = {}
  for word in self.getDescription():gmatch("%S+") do
    table.insert(currentDescription, word)
  end

  local newDescription = ""
  newDescription = newDescription .. (id:find("1") and input or currentDescription[1] or "...") .. "\n"
  newDescription = newDescription .. (id:find("2") and input or currentDescription[2] or "...") .. "\n"
  newDescription = newDescription .. (id:find("3") and input or currentDescription[3] or "...") .. "\n"
  newDescription = newDescription .. (id:find("4") and input or currentDescription[4] or "...") .. "\n"
  newDescription = newDescription .. (id:find("5") and input or currentDescription[5] or "...") .. "\n"
  newDescription = newDescription .. (id:find("6") and input or currentDescription[6] or "...") .. "\n"
  newDescription = newDescription .. (id:find("7") and input or currentDescription[7] or "...") .. "\n"
  self.setDescription(newDescription)
end
function SetBasicInformation()
  local currentDescription = {}
  for word in self.getDescription():gmatch("%S+") do
    table.insert(currentDescription, word)
  end
  for i,w in ipairs(currentDescription) do
    if #w > 0 then
      self.UI.setAttribute("info" .. i, "text", w)
    end
  end
end
-- Навыки
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

    local sumStartV = 0
    for _,v in ipairs(startValue) do
      sumStartV = sumStartV + v
    end
    if sumStartV + value > maxSkillPoint then return end

    startValue[id] = startValue[id] + value
  end

  for i = 1, 7 do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i]
  end

  ChangeUI()
end

function ChangeUI()
  local currentSkillPoint = 0
  for i = 1, 7 do
    self.UI.setAttribute("major" .. i, "text", majorValue[i])
    self.UI.setAttribute("baff" .. i, "text", baffValue[i])
    self.UI.setAttribute("debaff" .. i, "text", debaffValue[i])
    self.UI.setAttribute("start" .. i, "text", startValue[i])
    currentSkillPoint = currentSkillPoint + startValue[i]
  end
  self.UI.setAttribute("rateDevelopment", "text", majorValue[5]*2 + 5)
  self.UI.setAttribute("currentSkillPoint", "text", maxSkillPoint - currentSkillPoint)
  self.UI.setAttribute("maxSkillPoint", "text", maxSkillPoint)
  UpdateSave()
end

function ChangeMaxSkillPoint(player, input)
  if input == "" then return end
  maxSkillPoint = tonumber(input)
  ChangeUI()
end

function RebuildAssets()
  local root = 'https://raw.githubusercontent.com/RobMayer/TTSLibrary/master/ui/'
  local rootIn = 'https://img2.freepng.ru/20180418/hlw/kisspng-computer-icons-adventure-hotel-luggage-5ad725017cc0f8.903043971524049153511.jpg'
  local rootB = 'https://img2.freepng.ru/20180320/tze/kisspng-artist-s-book-scalable-vector-graphics-clip-art-gray-books-cliparts-5ab10db5d03c32.1930740015215528218529.jpg'
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/836970662971047986/info.png'
  local plus = 'https://cdn.discordapp.com/attachments/800324103848198174/836251236700258344/plus.png'
  local minus = 'https://cdn.discordapp.com/attachments/800324103848198174/836251227884486676/minus.png'

  local assets = {
    {name = 'uiGear', url = root .. 'gear.png'},
    {name = 'uiClose', url = root .. 'close.png'},
    {name = 'uiPlus', url = plus},
    {name = 'uiMinus', url = minus},
    {name = 'uiBars', url = root .. 'bars.png'},
    {name = 'uiInventory', url = rootIn},
    {name = 'uiBook', url = rootB},
    {name = 'uiBackGro', url = backG},
  }
  self.UI.setCustomAssets(assets)
end