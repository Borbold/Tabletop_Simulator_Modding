function UpdateSave()
  local dataToSave = {
    ["majorValue"] = majorValue, ["maxSkillPoint"] = maxSkillPoint,
    ["baffValue"] = baffValue, ["levelGUID"] = levelGUID,
    ["debaffValue"] = debaffValue, ["karma"] = karma,
    ["startValue"] = startValue, ["statusGUID"] = statusGUID, ["lifeGUID"] = lifeGUID,
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
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or {5, 5, 5, 5, 5, 5, 5}
  baffValue = loadedData.baffValue or {0, 0, 0, 0, 0, 0, 0}
  debaffValue = loadedData.debaffValue or {0, 0, 0, 0, 0, 0, 0}
  startValue = loadedData.startValue or {5, 5, 5, 5, 5, 5, 5}
  maxSkillPoint = loadedData.maxSkillPoint or 40
  karma = loadedData.karma or 0
  levelGUID = loadedData.levelGUID
  statusGUID = loadedData.statusGUID
  lifeGUID = loadedData.lifeGUID
  ChangeUI()
  SetBasicInformation()
  ChangeDependentVariables()
end
-- Базовая инфа
function InputBasicInformation(player, input, id)
  if not CheckPlayer(player.color) then return end

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
  ChangeSkills(-1, id:sub(6), player.color)
end
function Plus(player, value, id)
  id = id:lower()
  ChangeSkills(1, id:sub(5), player.color)
end
function ChangeSkills(value, id, playerColor)
  if not CheckPlayer(playerColor) then return end

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
  ChangeDependentVariables()
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
  self.UI.setAttribute("karma", "text", karma)
  if karma < -249 then
    self.UI.setAttribute("karma", "textColor", "#ff8773")
  elseif karma > 249 then
    self.UI.setAttribute("karma", "textColor", "#9487ff")
  else
    self.UI.setAttribute("karma", "textColor", "#948773")
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
  ChangeUI()
end

function ChangeDependentVariables()
  if not statusGUID then statusGUID = SearchDie("Status") end
  local args = {
    majorValue = majorValue
  }
  getObjectFromGUID(statusGUID).call("SetTableValue", args)
  
  if not levelGUID then levelGUID = SearchDie("Level") end
  if not lifeGUID then lifeGUID = SearchDie("Life") end
  args = {
    majorValue = majorValue,
    currentLVL = getObjectFromGUID(levelGUID).call("GetCurrentLVL"),
  }
  getObjectFromGUID(lifeGUID).call("SetTableValue", args)
end

function CheckPlayer(playerColor, onlyGM)
  if not levelGUID then levelGUID = SearchDie("Level") end
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
  maxSkillPoint = 40
  for i = 1, 7 do
    InputBasicInformation(player, "...", tostring(i))
  end
  SetBasicInformation()
  ChangeUI()
end

function RebuildAssets()
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838061145720881162/info1.png'
  local assets = {
    {name = 'uiBackGr', url = backG},
  }
  self.UI.setCustomAssets(assets)
end
