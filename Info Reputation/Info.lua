function UpdateSave()
  local dataToSave = {
    ["majorValue"] = majorValue, ["maxSkillPoint"] = maxSkillPoint,
    ["baffValue"] = baffValue, ["levelGUID"] = levelGUID,
    ["debaffValue"] = debaffValue, ["karma"] = karma,
    ["startValue"] = startValue,
    ["statusGUID"] = statusGUID, ["lifeGUID"] = lifeGUID, ["skillsGUID"] = skillsGUID,
    ["currentLVL"] = currentLVL,
    ["reputationValue"] = reputationValue,
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    Wait.time(|| Confer(savedData), 0.25)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  countFraction = 26
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or {5, 5, 5, 5, 5, 5, 5}
  baffValue = loadedData.baffValue or {0, 0, 0, 0, 0, 0, 0}
  debaffValue = loadedData.debaffValue or {0, 0, 0, 0, 0, 0, 0}
  startValue = loadedData.startValue or {5, 5, 5, 5, 5, 5, 5}
  reputationValue = loadedData.reputationValue or FillingTable(0)
  maxSkillPoint = loadedData.maxSkillPoint or 40
  karma = loadedData.karma or 0
  currentLVL = loadedData.currentLVL or 1
  levelGUID = loadedData.levelGUID
  statusGUID = loadedData.statusGUID
  lifeGUID = loadedData.lifeGUID
  skillsGUID = loadedData.skillsGUID
  ChangeUI({isLoad = true})
  ChangeUI({page = "secondPage"})
  SetBasicInformation()
end
function FillingTable(value)
  local locTable = {}
  for i = 1, countFraction do
    table.insert(locTable, value)
  end
  return locTable
end
-- Базовая инфа
function InputBasicInformation(player, input, id)
  if not CheckPlayer(player.color) then return end

  for word in input:gmatch("%S+") do
    input = word
    break
  end

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
  SetBasicInformation()
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
  
  local id = args.id
  if id:sub(0, #id - 1) == "baff" then
    id = tonumber(id:sub(5))
    baffValue[id] = baffValue[id] + args.value
  elseif id:sub(0, #id - 1) == "debaff" then
    id = tonumber(id:sub(7))
    debaffValue[id] = debaffValue[id] + args.value
  elseif id:sub(0, #id - 1) == "start" then
    id = tonumber(id:sub(6))

    local sumStartV = 0
    for _,v in ipairs(startValue) do
      sumStartV = sumStartV + v
    end
    if sumStartV + args.value > maxSkillPoint then return end

    startValue[id] = startValue[id] + args.value
  end

  for i = 1, 7 do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i]
  end
  ChangeUI()
end
-- Репутация
function InputReputation(player, input, id)
  if not CheckPlayer(player.color) then return end
  
  id = tonumber(id:sub(11))
  input = input ~= "" and input or "0"
  reputationValue[id] = tonumber(input)
  
  ChangeUI({page = "secondPage"})
end

function ChangeUI(args)
  args = args or {}
  if args.page == "secondPage" then
    for i,repa in ipairs(reputationValue) do
      self.UI.setAttribute("reputation"..i, "text", repa)
      if repa < -14 then
        self.UI.setAttribute("reputation"..i, "textColor", "#ff8773")
      elseif repa > 14 then
        self.UI.setAttribute("reputation"..i, "textColor", "#9487ff")
      else
        self.UI.setAttribute("reputation"..i, "textColor", "#948773")
      end
    end
  else
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
    self.UI.setAttribute("karma", "text", karma)
    if karma < -249 then
      broadcastToAll(args.player.steam_name " Пидор! Презирйте его")
      self.UI.setAttribute("karma", "textColor", "#ff8773")
    elseif karma > 249 then
      broadcastToAll(args.player.steam_name " Молодец! Просто молодец")
      self.UI.setAttribute("karma", "textColor", "#9487ff")
    else
      self.UI.setAttribute("karma", "textColor", "#948773")
    end
    if not args.isLoad then
      ChangeDependentVariables()
    end
  end
  UpdateSave()
end

function ChangeMaxSkillPoint(player, input)
  if input == "" then return end
  maxSkillPoint = tonumber(input)
  ChangeUI()
end

function ChangeKarma(player, input)
  if not CheckPlayer(player.color) then return end
  if input == "" then input = "0" end
  karma = tonumber(input)
  ChangeUI({player = player})
end

function ChangeDependentVariables(params)
  currentLVL = params and params.currentLVL or currentLVL
  
  local enum = {
    Сила = majorValue[1],
    Восприятие = majorValue[2],
    Выносливость = majorValue[3],
    Харизма = majorValue[4],
    Интелект = majorValue[5],
    Ловкость = majorValue[6],
    Удача = majorValue[7],
  }
  local args = {enum = enum}

  statusGUID = statusGUID or SearchDie("Status")
  getObjectFromGUID(statusGUID).call("SetTableValue", args)

  skillsGUID = skillsGUID or SearchDie("Skills")
  args["freeSkillPoints"] = (majorValue[5]*2 + 5)*currentLVL
  getObjectFromGUID(skillsGUID).call("SetTableValue", args)
  
  lifeGUID = lifeGUID or SearchDie("Life")
  args["currentLVL"] = currentLVL
  getObjectFromGUID(lifeGUID).call("SetTableValue", args)
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

function Reset(player)
  majorValue = {5, 5, 5, 5, 5, 5, 5}
  baffValue = {0, 0, 0, 0, 0, 0, 0}
  debaffValue = {0, 0, 0, 0, 0, 0, 0}
  startValue = {5, 5, 5, 5, 5, 5, 5}
  reputationValue = FillingTable(0)
  maxSkillPoint = 40
  for i = 1, 7 do
    InputBasicInformation(player, "...", tostring(i))
  end
  SetBasicInformation()
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

function RebuildAssets()
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838061145720881162/info1.png'
  local backGR = 'https://cdn.discordapp.com/attachments/800324103848198174/839809839848751114/reput3.png'
  local assets = {
    {name = 'uiBackGr', url = backG},
    {name = 'uiBackGR', url = backGR},
  }
  self.UI.setCustomAssets(assets)
end
