function UpdateSave()
  local dataToSave = {
    ["majorValue"] = majorValue, ["limbValue"] = limbValue,
    ["baffValue"] = baffValue, ["DTValue"] = DTValue,
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
  countLimb, countStatus = 8, 8
  maxInfoStatus = {1000, 1000, 1000, 1000, 1000, 1000}
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or {0, 0, 0, 0, 0, 0, 0, 0}
  baffValue = loadedData.baffValue or {0, 0, 0, 0, 0, 0, 0, 0}
  debaffValue = loadedData.debaffValue or {0, 0, 0, 0, 0, 0, 0, 0}
  startValue = loadedData.startValue or {0, 0, 0, 0, 0, 0, 0, 0}
  limbValue = loadedData.limbValue or {100, 100, 100, 100, 100, 100, 100, 100}
  DTValue = loadedData.DTValue or {0, 0, 0, 0, 0, 0, 0, 0}
  ChangeUI()
  ChangeUI({page = "secondPage"})
  SetStatusInformation()
end
-- Статусная информация
function InputStatusInformation(player, input, id)
  if not CheckPlayer(player.color) then return end

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
  local args = {
    value = -1, id = id:sub(6), playerColor = player.color
  }
  ChangeSkills(args)
end
function Plus(player, value, id)
  id = id:lower()
  local args = {
    value = 1, id = id:sub(5), playerColor = player.color
  }
  ChangeSkills(args)
end
function ChangeSkills(args)
  if not CheckPlayer(args.playerColor) then return end

  local id = args.id or ""
  if id:sub(0, #id - 1) == "baff" then
    id = tonumber(id:sub(5))
    baffValue[id] = baffValue[id] + args.value
  elseif id:sub(0, #id - 1) == "debaff" then
    id = tonumber(id:sub(7))
    debaffValue[id] = debaffValue[id] + args.value
  elseif id:sub(0, #id - 1) == "start" then
    id = tonumber(id:sub(6))
    startValue[id] = startValue[id] + args.value
  end

  for i = 1, countStatus do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i]
  end

  if args.value then
    ChangeUI()
  end
end
-- Конечности
function MinusL(player, value, id)
  id = id:lower()
  ChangeLimb(-1, id:sub(8), player.color)
end
function PlusL(player, value, id)
  id = id:lower()
  ChangeLimb(1, id:sub(7), player.color)
end
function ChangeLimb(value, id, playerColor)
  if not CheckPlayer(playerColor) then return end

  id = tonumber(id)
  if limbValue[id] + self.UI.getAttribute("ratioLimb", "text")*value <= 100 and
     limbValue[id] + self.UI.getAttribute("ratioLimb", "text")*value >= 0 then
    limbValue[id] = limbValue[id] + self.UI.getAttribute("ratioLimb", "text")*value
  end
  self.UI.setAttribute("limb_" .. id, "percentage", limbValue[id])
  self.UI.setAttribute("text_limb_" .. id, "text", limbValue[id])
end
-- ПУ конечностей
function ChangeSkillsDT(args)
  if not CheckPlayer(args.playerColor) then return end

  local id = args.id or ""
  if id:sub(0, #id - 1) == "baff" then
    id = tonumber(id:sub(5))
    DTValue[id] = DTValue[id] + args.value
  elseif id:sub(0, #id - 1) == "debaff" then
    id = tonumber(id:sub(7))
    DTValue[id] = DTValue[id] - args.value
  end
  
  if args.value then
    ChangeUI({page = "secondPage"})
  end
end

function ChangeUI(args)
  args = args or {}
  if args.page == "secondPage" then
    for i = 1, countLimb do
      Wait.time(function()
        self.UI.setAttribute("limb_" .. i, "percentage", limbValue[i])
        self.UI.setAttribute("limb_T_" .. i, "text", DTValue[i])
        self.UI.setAttribute("text_limb_" .. i, "text", limbValue[i])
      end, 0.01)
    end
  else
    for i = 1, countStatus do
      Wait.time(function()
        self.UI.setAttribute("major" .. i, "text", majorValue[i])
        self.UI.setAttribute("baff" .. i, "text", baffValue[i])
        self.UI.setAttribute("debaff" .. i, "text", debaffValue[i])
        self.UI.setAttribute("start" .. i, "text", startValue[i])
      end, 0.01)
    end
  end
  UpdateSave()
end

function CheckPlayer(playerColor, onlyGM)
  levelGUID = levelGUID or SearchDie("Level")
  local args = {playerColor = playerColor, onlyGM = onlyGM}
  if getObjectFromGUID(levelGUID).call("CheckPlayer", args) then return true end
end
function SearchDie(name)
  for _,obj in pairs(getObjects()) do
    if obj.getName() == name and obj.getColorTint() == self.getColorTint() then
      return obj.getGUID()
    end
  end
end

function SetTableValue(args)
  startValue[1] = args.enum.Восприятие*2
  startValue[2] = args.enum.Ловкость
  startValue[6] = args.enum.Выносливость*2
  startValue[7] = args.enum.Выносливость*5
  startValue[8] = args.enum.Удача

  local args = {}
  for i = 1, countStatus do
    startValue[i] = math.floor(startValue[i])
    args = {
      playerColor = "Black"
    }
    ChangeSkills(args)
  end
  ChangeUI()
end

function Reset(player)
  majorValue = {0, 0, 0, 0, 0, 0, 0, 0}
  baffValue = {0, 0, 0, 0, 0, 0, 0, 0}
  debaffValue = {0, 0, 0, 0, 0, 0, 0, 0}
  startValue = {0, 0, 0, 0, 0, 0, 0, 0}
  limbValue = {100, 100, 100, 100, 100, 100, 100, 100}
  for i = 1, 6 do
    InputStatusInformation(player, "0", tostring(i))
  end
  SetStatusInformation()
  ChangeUI()
  ChangeUI({page = "secondPage"})
end

function ChangePage()
  if self.UI.getAttribute("firstPage", "active") == "true" then
    self.UI.setAttribute("firstPage", "active", "false")
    self.UI.setAttribute("secondPage", "active", "true")
  elseif self.UI.getAttribute("secondPage", "active") == "true" then
    self.UI.setAttribute("firstPage", "active", "true")
    self.UI.setAttribute("secondPage", "active", "false")
  end
end

function ChangeInput(player, input)
  if not CheckPlayer(player.color) then return end
  input = input ~= "" and input or "0"
  self.UI.setAttribute("ratioLimb", "text", input)
  UpdateSave()
end

function RebuildAssets()
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838703500652314685/statusykr.png'
  local backGL = 'https://cdn.discordapp.com/attachments/800324103848198174/840615412852719636/konechnosti2.png'
  local assets = {
    {name = 'uiBackGro', url = backG},
    {name = 'uiBackGL', url = backGL}
  }
  self.UI.setCustomAssets(assets)
end
