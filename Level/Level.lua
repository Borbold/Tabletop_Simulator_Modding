function UpdateSave()
  local dataToSave = {
    ["currentLVL"] = currentLVL, ["currentEXP"] = currentEXP,
    ["infoGUID"] = infoGUID, ["lifeGUID"] = lifeGUID, ["statusGUID"] = statusGUID, ["skillsGUID"] = skillsGUID,
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
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
      ["Teal"] = {r = 0.13, g = 0.69, b = 0.61}
    }
    Wait.time(|| Confer(savedData), 0.2)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  resetDie = {}
  resetDie[1], resetDie[2], resetDie[3], resetDie[4] = ResetInfo, ResetLife, ResetStatus, ResetStatus
  local loadedData = JSON.decode(savedData or "")
  currentLVL = loadedData and loadedData.currentLVL or 1
  currentEXP = loadedData and loadedData.currentEXP or 0
  infoGUID = loadedData.infoGUID
  lifeGUID = loadedData.lifeGUID
  statusGUID = loadedData.statusGUID
  skillsGUID = loadedData.skillsGUID
  maxEXP = currentLVL*50
  ChangeUI()
end
-- Уровень
function MinusLVL(player)
  ChangeLVL(-1, _, player.color)
end
function PlusLVL(player)
  ChangeLVL(1, _, player.color)
end
function ChangeLVL(value, remainingEXP, playerColor)
  local args = {playerColor = playerColor}
  if not CheckPlayer(args) then return end

  currentLVL = currentLVL + value
  if currentLVL <= 0 then currentLVL = 1 end
  maxEXP = currentLVL*50
  if remainingEXP then currentEXP = remainingEXP end
  ChangeUI()
end
-- Опыт
function MinusEXP(player)
  ChangeEXP(-1, player.color)
end
function PlusEXP(player)
  ChangeEXP(1, player.color)
end
function ChangeEXP(value, playerColor)
  local args = {playerColor = playerColor}
  if not CheckPlayer(args) then return end

  currentEXP = currentEXP + self.UI.getAttribute("ratioEXP", "text")*value
  if currentEXP < maxEXP and currentEXP >= 0 then
    ChangeUI()
  else
    if currentEXP < 0 then
      ChangeLVL(-1, (currentLVL - 1)*50 + currentEXP, playerColor)
    elseif currentEXP > 0 then
      ChangeLVL(1, currentEXP - maxEXP, playerColor)
    end
  end
end
-- Подключение и сброс плашки Info
function ResetInfo(player)
  if not infoGUID then infoGUID = SearchDie("Info") end
  getObjectFromGUID(infoGUID).call("Reset", player)
end
-- Подключение и сброс плашки Life
function ResetLife(player)
  if not lifeGUID then lifeGUID = SearchDie("Life") end
  getObjectFromGUID(lifeGUID).call("Reset", player)
end
-- Подключение и сброс плашки Status
function ResetStatus(player)
  if not statusGUID then statusGUID = SearchDie("Status") end
  getObjectFromGUID(statusGUID).call("Reset", player)
end
-- Подключение и сброс плашки Skills
function ResetStatus(player)
  if not skillsGUID then skillsGUID = SearchDie("Skills") end
  getObjectFromGUID(skillsGUID).call("Reset", player)
end
function SearchDie(name)
  for _,obj in pairs(getObjects()) do
    if obj.getName() == name and obj.getColorTint() == self.getColorTint() then
      return obj.getGUID()
    end
  end
end

function Reset(player)
  local args = {playerColor = player.color, onlyGM = true}
  if CheckPlayer(args) then
    for _,reset in ipairs(resetDie) do
      reset(player)
    end
    currentLVL, currentEXP = 1, 0
    ChangeUI()
  end
end
function ChangeUI()
  local avarageValue = currentEXP*100/maxEXP

  self.UI.setAttribute("LVL", "text", currentLVL)
  self.UI.setAttribute("EXP", "text", currentEXP .. "/" .. maxEXP)
  local newPositionFillImage = (avarageValue - 100)/100*self.UI.getAttribute("barEXP", "width")
  self.UI.setAttribute("fillProgressBarImage", "offsetXY", newPositionFillImage .. " 0")
  UpdateSave()
end

function InputRatioEXP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("ratioEXP", "text", input)
end

function CheckPlayer(args)
  if DenoteSth(args) then return true end
  broadcastToColor("Не тр-рогай СвечУу-у!!! Пидор", args.playerColor, {1, 0.52, 0.45})
end
function DenoteSth(args)
  if args.playerColor == "Black" then return true
  elseif args.onlyGM then return false end

  for iColor,_ in pairs(colorPlayer) do
    if CheckColor(iColor) and iColor == args.playerColor then
      return true
    end
  end
end
function CheckColor(color)
  local colorObject = {
    ["R"] = Round(self.getColorTint()[1], 2),
    ["G"] = Round(self.getColorTint()[2], 2),
    ["B"] = Round(self.getColorTint()[3], 2)
  }
  if colorObject.R == colorPlayer[color].r and
     colorObject.G == colorPlayer[color].g and
     colorObject.B == colorPlayer[color].b then
    return true
  end
end
function Round(num, idp)
  return math.ceil(num*(10^idp))/10^idp
end

function ChangeMaxHP()
  -- TODO: Переделать прием данных
  getObjectFromGUID(skillsGUID).call("ChangeMaxHP", {currentLVL = currentLVL})
end

function RebuildAssets()
  local root = 'https://raw.githubusercontent.com/RobMayer/TTSLibrary/master/ui/'
  local rootIn = 'https://img2.freepng.ru/20180418/hlw/kisspng-computer-icons-adventure-hotel-luggage-5ad725017cc0f8.903043971524049153511.jpg'
  local rootB = 'https://img2.freepng.ru/20180320/tze/kisspng-artist-s-book-scalable-vector-graphics-clip-art-gray-books-cliparts-5ab10db5d03c32.1930740015215528218529.jpg'
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/837975149025296424/lvl2.png'
  local plus = 'https://cdn.discordapp.com/attachments/800324103848198174/836251236700258344/plus.png'
  local minus = 'https://cdn.discordapp.com/attachments/800324103848198174/836251227884486676/minus.png'
  local reset = 'https://cdn.discordapp.com/attachments/800324103848198174/836632332978094130/resetl1.png'
  local barBackG = 'https://cdn.discordapp.com/attachments/800324103848198174/836612498161270784/bar1.png'
  local barFillImage = 'https://cdn.discordapp.com/attachments/800324103848198174/836613933031882752/barline1.png'

  local assets = {
    {name = 'uiGear', url = root .. 'gear.png'},
    {name = 'uiClose', url = root .. 'close.png'},
    {name = 'uiPlus', url = plus},
    {name = 'uiMinus', url = minus},
    {name = 'uiBars', url = root .. 'bars.png'},
    {name = 'uiInventory', url = rootIn},
    {name = 'uiBook', url = rootB},
    {name = 'uiBackG', url = backG},
    {name = 'uiReset', url = reset},
    {name = 'uiBarBackG', url = barBackG},
    {name = 'uiBarFillImage', url = barFillImage},
  }
  self.UI.setCustomAssets(assets)
end
