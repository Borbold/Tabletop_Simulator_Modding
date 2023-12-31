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
  writeGoodKarma, writeBadKarma = 0, 0
  goodKarma = {
    {value = 250, description = "Защитник\n+5 отношение", AC = 0},
    {value = 500, description = "Щит надежды\n+10 отношение, +2 КБ", AC = 2},
    {value = 750, description = "Страж пустошей\n+15 отношение, +4 КБ, +2 очка урона на попадание", AC = 4},
    {value = 1000, description = "Спаситель проклятых\n+20 отношение, +8 КБ, +3 очка урона на попадание", AC = 8}
  }
  badKarma = {
    {value = 250, description = "Предатель\n-5 отношение, +4 ОЗ", HP = 4},
    {value = 500, description = "Меч отчаяния\n-10 отношение, +8 ОЗ", HP = 8},
    {value = 750, description = "Бич пустошей\n-15 отношение, +14 ОЗ, +1 очка урона на попадание", HP = 14},
    {value = 1000, description = "Сатанинское отродье\n-20 отношение, +22 ОЗ, +2 очка урона на попадание", HP = 22}
  }
  colorPlayer = {
    ["White"] = {r = 1, g = 1, b = 1},
    ["Red"] = {r = 0.86, g = 0.1, b = 0.09},
    ["Blue"] = {r = 0.12, g = 0.53, b = 1},
    ["Green"] = {r = 0.19, g = 0.7, b = 0.17},
    ["Yellow"] = {r = 0.9, g = 0.9, b = 0.17},
    ["Orange"] = {r = 0.96, g = 0.39, b = 0.11},
    ["Brown"] = {r = 0.44, g = 0.23, b = 0.09},
    ["Purple"] = {r = 0.63, g = 0.12, b = 0.94},
    ["Pink"] = {r = 0.96, g = 0.44, b = 0.81},
    ["Teal"] = {r = 0.13, g = 0.69, b = 0.61},
    ["Black"] = {r = 0.25, g = 0.25, b = 0.25}
  }
  Wait.time(|| Confer(savedData), 0.4)
end

function Confer(savedData)
  RebuildAssets()
  countSpesial, countFraction = 7, 26
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData and loadedData.majorValue or {5, 5, 5, 5, 5, 5, 5}
  baffValue = loadedData and loadedData.baffValue or {0, 0, 0, 0, 0, 0, 0}
  debaffValue = loadedData and loadedData.debaffValue or {0, 0, 0, 0, 0, 0, 0}
  startValue = loadedData and loadedData.startValue or {5, 5, 5, 5, 5, 5, 5}
  reputationValue = loadedData and loadedData.reputationValue or FillingTable(0)
  maxSkillPoint = loadedData and loadedData.maxSkillPoint or 40
  karma = loadedData and loadedData.karma or 0
  currentLVL = loadedData and loadedData.currentLVL or 1
  levelGUID = loadedData and loadedData.levelGUID
  statusGUID = loadedData and loadedData.statusGUID
  lifeGUID = loadedData and loadedData.lifeGUID
  skillsGUID = loadedData and loadedData.skillsGUID
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
  if id:find("karma") then
    karma = karma - 1
    ChangeUI()
  else
    id = id:lower()
    local args = {
      value = -1, id = id:sub(6), playerColor = player.color
    }
    ChangeSkills(args)
  end
end
function Plus(player, value, id)
  if id:find("karma") then
    karma = karma + 1
    ChangeUI()
  else
    id = id:lower()
    local args = {
      value = 1, id = id:sub(5), playerColor = player.color
    }
    ChangeSkills(args)
  end
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
    if args.value == 1 and sumStartV + args.value > maxSkillPoint then return end

    startValue[id] = startValue[id] + args.value
  end

  for i = 1, countSpesial do
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
      Wait.time(function()
        self.UI.setAttribute("reputation"..i, "text", repa)
        if repa < -14 then
          self.UI.setAttribute("reputation"..i, "textColor", "#ff8773")
        elseif repa > 14 then
          self.UI.setAttribute("reputation"..i, "textColor", "#9487ff")
        else
          self.UI.setAttribute("reputation"..i, "textColor", "#948773")
        end
      end, 0.1)
    end
  else
    local currentSkillPoint = 0
    for i = 1, countSpesial do
      self.UI.setAttribute("major" .. i, "text", majorValue[i])
      self.UI.setAttribute("baff" .. i, "text", baffValue[i])
      self.UI.setAttribute("debaff" .. i, "text", debaffValue[i])
      self.UI.setAttribute("start" .. i, "text", startValue[i])
      currentSkillPoint = currentSkillPoint + startValue[i]
    end
    self.UI.setAttribute("rateDevelopment", "text", startValue[5]*2 + 5)
    self.UI.setAttribute("currentSkillPoint", "text", maxSkillPoint - currentSkillPoint)
    self.UI.setAttribute("maxSkillPoint", "text", maxSkillPoint)
    self.UI.setAttribute("karma", "text", karma)
    if karma < -249 then
      if writeBadKarma == 0 then
        if Player[GetNameColor()].steam_name then
          broadcastToAll(Player[GetNameColor()].steam_name .. " Пидор! Презирате его")
        else
          broadcastToAll(GetNameColor() .. " Пидор! Презирате его")
        end
      end
      self.UI.setAttribute("karma", "textColor", "#ff8773")
      self.UI.setAttribute("karma", "tooltip", GetToolTipKarma(0))
    elseif karma > 249 then
      if writeGoodKarma == 0 then
        if Player[GetNameColor()].steam_name then
          broadcastToAll(Player[GetNameColor()].steam_name .. " Молодец! Просто молодец")
        else
          broadcastToAll(GetNameColor() .. " Молодец! Просто молодец")
        end
      end
      self.UI.setAttribute("karma", "textColor", "#9487ff")
      self.UI.setAttribute("karma", "tooltip", GetToolTipKarma(1))
    else
      self.UI.setAttribute("karma", "textColor", "#948773")
      self.UI.setAttribute("karma", "tooltip", "Бонусов/Штрафов нет")
    end
    if not args.isLoad then
      ChangeDependentVariables()
    end
  end
  UpdateSave()
end
function GetToolTipKarma(good)
  local argsKarma = (good == 1 and goodKarma) or badKarma
  local toolTipKarma = argsKarma[1].description
  for i,v in ipairs(argsKarma) do
    if good == 1 then writeGoodKarma = i writeBadKarma = 0 else writeBadKarma = i writeGoodKarma = 0 end
    if i == #argsKarma then toolTipKarma = argsKarma[#argsKarma].description break end
    if math.abs(karma) >= v.value and (i < #argsKarma and math.abs(karma) < argsKarma[i + 1].value) then
      toolTipKarma = v.description
      break
    end
  end
  return toolTipKarma
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
  local argsKarma = {
    HP = writeBadKarma != 0 and badKarma[writeBadKarma].HP or 0,
    AC = writeGoodKarma != 0 and goodKarma[writeGoodKarma].AC or 0
  }
  local args = {enum = enum, karma = argsKarma,
    id = writeGoodKarma != 0 and "karma2" or "", -- Parameter of a character's armor class
    playerColor = "Black"
  }

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

function GetNameColor()
	local color = "Black"
  for iColor,_ in pairs(colorPlayer) do
    if(CheckColor(iColor)) then
	    color = iColor
      break
    end
  end
  return color
end
function CheckColor(color)
  local colorObject = {
    ["R"] = Round(self.getColorTint()[1], 2),
    ["G"] = Round(self.getColorTint()[2], 2),
    ["B"] = Round(self.getColorTint()[3], 2)
  }
	if(colorObject.R == colorPlayer[color].r and
     colorObject.G == colorPlayer[color].g and
     colorObject.B == colorPlayer[color].b) then
    return true
  else
    return false
  end
end
function Round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
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
