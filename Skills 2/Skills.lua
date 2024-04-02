function UpdateSave()
  local dataToSave = {
    ["majorValue"] = majorValue, ["favoritSkills"] = favoritSkills,
    ["baffValue"] = baffValue, ["freeSkillPoints"] = freeSkillPoints,
    ["debaffValue"] = debaffValue,
    ["startValue"] = startValue, ["startValue2"] = startValue2,
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(|| Confer(savedData), 0.8)
end

function Confer(savedData)
  RebuildAssets()
  countSkills = 19
  local loadedData = JSON.decode(savedData or "")
  outfitBonus = FillingTable(0)
  majorValue = loadedData and loadedData.majorValue or FillingTable(0)
  baffValue = loadedData and loadedData.baffValue or FillingTable(0)
  debaffValue = loadedData and loadedData.debaffValue or FillingTable(0)
  startValue = loadedData and loadedData.startValue or FillingTable(0)
  startValue2 = loadedData and loadedData.startValue2 or FillingTable(0)
  favoritSkills = loadedData and loadedData.favoritSkills or FillingTable(0)
  freeSkillPoints = loadedData and loadedData.freeSkillPoints or 0
  ChangeUI()
  ChangeUI({page = "secondPage"})
end
function FillingTable(value)
  local locTable = {}
  for i = 1, countSkills do
    table.insert(locTable, value)
  end
  return locTable
end
-- Скилы
function Minus(player, _, id)
  id = id:lower()
  local args = {
    value = -1, id = id:sub(6), playerColor = player.color
  }
  ChangeSkills(args)
end
function Plus(player, _, id)
  id = id:lower()
  local args = {
    value = 1, id = id:sub(5), playerColor = player.color
  }
  ChangeSkills(args)
end
function ChangeSkills(args)
  if not CheckPlayer(args.playerColor) then return end

  local id = args.id or ""
  if id:find("debaff") then
    id = tonumber(id:sub(7))
    debaffValue[id] = debaffValue[id] + args.value
    ChangeUI({page = "secondPage"})
  elseif id:find("baff") then
    id = tonumber(id:sub(5))
    baffValue[id] = baffValue[id] + args.value
    ChangeUI({page = "secondPage"})
  elseif id:find("start") then
    id = tonumber(id:sub(6))
    startValue[id] = startValue[id] + args.value
  elseif id:find("outfit") then
    id = tonumber(id:sub(7))
    outfitBonus[id] = tonumber(args.value)
  end

  for i = 1, countSkills do
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i] + startValue[i]*favoritSkills[i] + outfitBonus[i]
  end

  if args.value then
    ChangeUI()
  end
end

function ChangeUI(args)
  args = args or {}
  if args.page == "secondPage" then
    for i = 1, countSkills do
      Wait.time(function()
        self.UI.setAttribute("baff" .. i, "text", baffValue[i])
        self.UI.setAttribute("debaff" .. i, "text", debaffValue[i])
      end, 0.01)
    end
  else
    local currentFreeSkillPoint = freeSkillPoints
    for i = 1, countSkills do
      Wait.time(function()
        local locStartValue, wTotalScore = startValue[i], 0
        local totalScore = majorValue[i] + startValue2[i] + favoritSkills[i]*20
        self.UI.setAttribute("major" .. i, "text", totalScore)
        self.UI.setAttribute("start" .. i, "text", startValue[i])
        self.UI.setAttribute("specialSkill" .. i, "active", tostring(favoritSkills[i] == 1))

        wTotalScore = totalScore
        while wTotalScore > 101 do
          locStartValue = locStartValue + 1
          wTotalScore = wTotalScore - (1 + favoritSkills[i])
        end
        wTotalScore = totalScore
        while wTotalScore > 128 do
          locStartValue = locStartValue + 1
          wTotalScore = wTotalScore - (1 + favoritSkills[i])
        end
        wTotalScore = totalScore
        while wTotalScore > 151 do
          locStartValue = locStartValue + 1
          wTotalScore = wTotalScore - (1 + favoritSkills[i])
        end
        wTotalScore = totalScore
        while wTotalScore > 176 do
          locStartValue = locStartValue + 1
          wTotalScore = wTotalScore - (1 + favoritSkills[i])
        end
        wTotalScore = totalScore
        while wTotalScore > 201 do
          locStartValue = locStartValue + 1
          wTotalScore = wTotalScore - (1 + favoritSkills[i])
        end
        wTotalScore = totalScore
        while wTotalScore > 300 do
          locStartValue = locStartValue + 1
          wTotalScore = wTotalScore - (1 + favoritSkills[i])
        end
        currentFreeSkillPoint = currentFreeSkillPoint - locStartValue
      end, 0.01)
    end
    Wait.time(function()
      self.UI.setAttribute("freeSkillPoints", "text", "Свободные очки навыков: " .. currentFreeSkillPoint)
    end, 0.011)
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

function SetFavoritSkills(player, alt_click, id)
  if not CheckPlayer(player.color) then return end
  
  id = tonumber(id:sub(8))
  if alt_click == "-1" then
    favoritSkills[id] = 1
  elseif alt_click == "-2" then
    favoritSkills[id] = 0
  end
  
  local args = {
    value = '0', playerColor = player.color
  }
  ChangeSkills(args)
end

function SetTableValue(args)
  startValue2[1] = 5 + args.enum.Ловкость*4
  startValue2[2] = args.enum.Ловкость*2 + args.bonusMutant
  startValue2[3] = args.enum.Ловкость*2
  startValue2[4] = 5 + args.enum.Ловкость*4
  startValue2[5] = 30 + (args.enum.Ловкость + args.enum.Сила)*2
  startValue2[6] = 20 + (args.enum.Ловкость + args.enum.Сила)*2
  startValue2[7] = args.enum.Ловкость*4
  startValue2[8] = (args.enum.Восприятие + args.enum.Интелект)*2
  startValue2[9] = 5*((args.enum.Восприятие + args.enum.Интелект)/3)
  startValue2[10] = (args.enum.Восприятие + args.enum.Ловкость)*2
  startValue2[11] = 5 + args.enum.Ловкость*3
  startValue2[12] = 10 + args.enum.Ловкость + args.enum.Восприятие
  startValue2[13] = args.enum.Ловкость*3
  startValue2[14] = 10 + args.enum.Ловкость + args.enum.Восприятие
  startValue2[15] = args.enum.Интелект*4
  startValue2[16] = (args.enum.Интелект + args.enum.Восприятие)*3
  startValue2[17] = args.enum.Харизма*5
  startValue2[18] = args.enum.Харизма*4
  startValue2[19] = args.enum.Удача*5

  freeSkillPoints = args.freeSkillPoints

  local args = {}
  for i = 1, countSkills do
    startValue2[i] = math.floor(startValue2[i])
    args = {
      playerColor = "Black"
    }
    ChangeSkills(args)
  end
  ChangeUI()
end

function Reset(player)
  majorValue = FillingTable(0)
  baffValue = FillingTable(0)
  debaffValue = FillingTable(0)
  startValue = FillingTable(0)
  startValue2 = FillingTable(0)
  favoritSkills = FillingTable(0)
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
  local backG = 'https://i.imgur.com/4KZbrYG.png'
  local stars = 'https://i.imgur.com/omMOtqc.png'
  local assets = {
    {name = 'uiBackGroun', url = backG},
    {name = 'uiStars', url = stars}
  }
  self.UI.setCustomAssets(assets)
end