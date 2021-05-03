function UpdateSave()
  local dataToSave = {
    ["majorValue"] = majorValue, ["favoritSkills"] = favoritSkills,
    ["baffValue"] = baffValue, ["freeSkillPoints"] = freeSkillPoints,
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
  countSkills = 20
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or FillingTable(0)
  baffValue = loadedData.baffValue or FillingTable(0)
  debaffValue = loadedData.debaffValue or FillingTable(0)
  startValue = loadedData.startValue or FillingTable(0)
  favoritSkills = loadedData.favoritSkills or FillingTable(0)
  freeSkillPoints = loadedData.freeSkillPoints or 0
  ChangeUI()
end
function FillingTable(value)
  local locTable = {}
  for i = 1, countSkills do
    table.insert(locTable, value)
  end
  return locTable
end
-- Скилы
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

  id = tonumber(id:sub(6))
  startValue[id] = startValue[id] + value
  for i = 1, countSkills do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i] + startValue[i]*favoritSkills[i]
  end

  ChangeUI()
end

function ChangeUI()
  for i = 1, countSkills do
    self.UI.setAttribute("major" .. i, "text", majorValue[i] + favoritSkills[i]*20)
    self.UI.setAttribute("start" .. i, "text", startValue[i])
    self.UI.setAttribute("specialSkill" .. i, "active", tostring(favoritSkills[i] == 1))
  end

  local currentFreeSkillPoint = freeSkillPoints
  for i = 1, countSkills do
    if startValue[i] <= 101 then
      currentFreeSkillPoint = currentFreeSkillPoint - startValue[i]
    elseif startValue[i] > 101 and startValue[i] <= 128 then
      currentFreeSkillPoint = currentFreeSkillPoint - startValue[i]*2
    elseif startValue[i] > 128 and startValue[i] <= 151 then
      currentFreeSkillPoint = currentFreeSkillPoint - startValue[i]*3
    elseif startValue[i] > 151 and startValue[i] <= 176 then
      currentFreeSkillPoint = currentFreeSkillPoint - startValue[i]*4
    elseif startValue[i] > 176 and startValue[i] <= 201 then
      currentFreeSkillPoint = currentFreeSkillPoint - startValue[i]*5
    elseif startValue[i] > 201 and startValue[i] <= 300 then
      currentFreeSkillPoint = currentFreeSkillPoint - startValue[i]*6
    end
  end
  self.UI.setAttribute("freeSkillPoints", "text", "Свободные очки навыков: " .. currentFreeSkillPoint)

  UpdateSave()
end

function SetFavoritSkills(player, alt_click, id)
  if not CheckPlayer(player.color) then return end
  id = tonumber(id:sub(8))
  if alt_click == "-1" then
    favoritSkills[id] = 1
  elseif alt_click == "-2" then
    favoritSkills[id] = 0
  end
  ChangeUI()
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
  baffValue[1] = 5 + args.majorValue[6]*4
  baffValue[2] = args.majorValue[6]*2
  baffValue[3] = args.majorValue[6]*2
  baffValue[4] = 5 + args.majorValue[6]*4
  baffValue[5] = 30 + (args.majorValue[6] + args.majorValue[1])*2
  baffValue[6] = 20 + (args.majorValue[6] + args.majorValue[1])*2
  baffValue[7] = args.majorValue[6]*4
  baffValue[8] = (args.majorValue[2] + args.majorValue[5])*2
  baffValue[9] = 5*((args.majorValue[2] + args.majorValue[5])/3)
  baffValue[10] = (args.majorValue[3] + args.majorValue[5])*2
  baffValue[11] = (args.majorValue[1] + args.majorValue[6])*2
  baffValue[12] = 5 + args.majorValue[6]*3
  baffValue[13] = 10 + args.majorValue[6] + args.majorValue[1]
  baffValue[14] = args.majorValue[6]*3
  baffValue[15] = 10 + args.majorValue[6] + args.majorValue[1]
  baffValue[16] = 20 + args.majorValue[1]*2 + args.majorValue[7]/2
  baffValue[17] = args.majorValue[5]*4
  baffValue[18] = (args.majorValue[5] + args.majorValue[1])*3
  baffValue[19] = args.majorValue[4]*5
  baffValue[20] = args.majorValue[7]*5

  freeSkillPoints = args.freeSkillPoints

  for i = 1, countSkills do
    baffValue[i] = math.floor(majorValue[i])
  end
  ChangeUI()
end

function Reset(player)
  majorValue = FillingTable(0)
  baffValue = FillingTable(0)
  debaffValue = FillingTable(0)
  startValue = FillingTable(0)
  favoritSkills = FillingTable(0)
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
