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
  countSkills = 20
  local loadedData = JSON.decode(savedData or "")
  majorValue = loadedData.majorValue or FillingTable(0)
  baffValue = loadedData.baffValue or FillingTable(0)
  debaffValue = loadedData.debaffValue or FillingTable(0)
  startValue = loadedData.startValue or FillingTable(0)
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
    majorValue[i] = baffValue[i] - debaffValue[i] + startValue[i]
  end

  ChangeUI()
end

function ChangeUI()
  for i = 1, countSkills do
    self.UI.setAttribute("major" .. i, "text", majorValue[i])
    self.UI.setAttribute("start" .. i, "text", startValue[i])
  end

  UpdateSave()
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

function SetTableValue(args)
  majorValue[1] = 5 + args.majorValue[6]*4
  majorValue[2] = args.majorValue[6]*2
  majorValue[3] = args.majorValue[6]*2
  majorValue[4] = 5 + args.majorValue[6]*4
  majorValue[5] = 30 + (args.majorValue[6] + args.majorValue[1])*2
  majorValue[6] = 20 + (args.majorValue[6] + args.majorValue[1])*2
  majorValue[7] = args.majorValue[6]*4
  majorValue[8] = (args.majorValue[2] + args.majorValue[5])*2
  majorValue[9] = 5*((args.majorValue[2] + args.majorValue[5])/3)
  majorValue[10] = (args.majorValue[3] + args.majorValue[5])*2
  majorValue[11] = (args.majorValue[1] + args.majorValue[6])*2
  majorValue[12] = 5 + args.majorValue[6]*3
  majorValue[13] = 10 + args.majorValue[6] + args.majorValue[1]
  majorValue[14] = args.majorValue[6]*3
  majorValue[15] = 10 + args.majorValue[6] + args.majorValue[1]
  majorValue[16] = 20 + args.majorValue[1]*2 + args.majorValue[7]/2
  majorValue[17] = args.majorValue[5]*4
  majorValue[18] = (args.majorValue[5] + args.majorValue[1])*3
  majorValue[19] = args.majorValue[4]*5
  majorValue[20] = args.majorValue[7]*5

  for i = 1, countSkills do
    majorValue[i] = math.floor(majorValue[i])
  end
  ChangeUI()
end

function Reset(player)
  majorValue = FillingTable(0)
  baffValue = FillingTable(0)
  debaffValue = FillingTable(0)
  startValue = FillingTable(0)
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
