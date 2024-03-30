function UpdateSave()
  local dataToSave = {
    ["currentLVL"] = currentLVL, ["currentEXP"] = currentEXP,
    ["infoGUID"] = infoGUID
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  colorPlayer = {
    ["White"] = {r = 1, g = 1, b = 1},
    ["Red"] = {r = 0.86, g = 0.1, b = 0.1},
    ["Blue"] = {r = 0.12, g = 0.53, b = 1},
    ["Green"] = {r = 0.2, g = 0.71, b = 0.17},
    ["Yellow"] = {r = 0.91, g = 0.9, b = 0.18},
    ["Orange"] = {r = 0.96, g = 0.4, b = 0.12},
    ["Brown"] = {r = 0.45, g = 0.24, b = 0.09},
    ["Purple"] = {r = 0.63, g = 0.13, b = 0.95},
    ["Pink"] = {r = 0.96, g = 0.44, b = 0.81},
    ["Teal"] = {r = 0.13, g = 0.7, b = 0.61}
  }
  Wait.time(|| Confer(savedData), 0.01)
end

function Confer(savedData)
  RebuildAssets()
  resetDieGUID = {"Info", "Life", "Status", "Skills"}
  local loadedData = JSON.decode(savedData or "")
  currentLVL = loadedData and loadedData.currentLVL or 1
  currentEXP = loadedData and loadedData.currentEXP or 0
  infoGUID = loadedData and loadedData.infoGUID or nil
  maxEXP = currentLVL*((currentLVL - 2)*75 + 200)
  ChangeUI({isLoad = true})
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

  local locCurLVL = currentLVL
  currentLVL = currentLVL + value
  if currentLVL > locCurLVL then
    if Player[GetNameColor()].steam_name then
      broadcastToAll(Player[GetNameColor()].steam_name .. " поднял уровень, держи пирожок.")
    else
      broadcastToAll(GetNameColor() .. " поднял уровень, держи пирожок.")
    end
  end
  if currentLVL <= 0 then currentLVL = 1 end
  if currentLVL >= 100 then currentLVL = 100 end
  maxEXP = currentLVL*((currentLVL - 2)*75 + 200)
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

  local bonusEXP = tonumber(self.UI.getAttribute("bonusEXP", "text"))
  if bonusEXP ~= 0 then
    bonusEXP = self.UI.getAttribute("ratioEXP", "text")*bonusEXP/100
  end
  currentEXP = currentEXP + self.UI.getAttribute("ratioEXP", "text")*value + bonusEXP
  if currentEXP < maxEXP and currentEXP >= 0 then
    ChangeUI()
  else
    if currentEXP < 0 then
      ChangeLVL(-1, (currentLVL - 1)*((currentLVL - 3)*75 + 200) + currentEXP, playerColor)
    elseif currentEXP > 0 then
      while currentEXP > maxEXP do
        ChangeLVL(1, currentEXP - maxEXP, playerColor)
      end
    end
  end
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
    for _,name in ipairs(resetDieGUID) do
      getObjectFromGUID(SearchDie(name)).call("Reset", player)
    end
    currentLVL, currentEXP = 1, 0
    ChangeUI()
  end
end
function ChangeUI(args)
  args = args or {}
  local avarageValue = currentEXP*100/maxEXP

  self.UI.setAttribute("LVL", "text", currentLVL)
  self.UI.setAttribute("EXP", "text", currentEXP .. "/" .. maxEXP)
  local newPositionFillImage = (avarageValue - 100)/100*self.UI.getAttribute("barEXP", "width")
  self.UI.setAttribute("fillProgressBarImage", "offsetXY", newPositionFillImage .. " 0")
  if not args.isLoad then
    ChangeBoundValues()
  end
  UpdateSave()
end

function InputRatioEXP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("ratioEXP", "text", input)
end
function ChangeBonusEXP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("bonusEXP", "text", input)
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
  if colorObject.R == colorPlayer[color].r and
     colorObject.G == colorPlayer[color].g and
     colorObject.B == colorPlayer[color].b then
    return true
  end
end
function Round(num, idp)
  return math.ceil(num*(10^idp))/10^idp
end

function ChangeBoundValues()
  infoGUID = infoGUID or SearchDie("Info")
  Wait.time(function()
    getObjectFromGUID(infoGUID).call("ChangeDependentVariables", {currentLVL = currentLVL})
  end, 0.05)
end

function RebuildAssets()
  local root = 'https://raw.githubusercontent.com/RobMayer/TTSLibrary/master/ui/'
  local rootIn = 'https://img2.freepng.ru/20180418/hlw/kisspng-computer-icons-adventure-hotel-luggage-5ad725017cc0f8.903043971524049153511.jpg'
  local rootB = 'https://img2.freepng.ru/20180320/tze/kisspng-artist-s-book-scalable-vector-graphics-clip-art-gray-books-cliparts-5ab10db5d03c32.1930740015215528218529.jpg'
  local backG = 'https://i.imgur.com/0u6jlfA.png'
  local plus = 'https://i.imgur.com/FVpd1Z3.png'
  local minus = 'https://i.imgur.com/MkuVvIf.png'
  local reset = 'https://i.imgur.com/QEBPtkg.png'
  local barBackG = 'https://i.imgur.com/ONikyq9.png'
  local barFillIm = 'https://i.imgur.com/hwVz4k8.png'
  local arrow = 'https://i.imgur.com/1qwPgtk.png'

  local assets = {
    {name = 'uiGear', url = arrow},
    {name = 'uiClose', url = root .. 'close.png'},
    {name = 'uiPlus', url = plus},
    {name = 'uiMinus', url = minus},
    {name = 'uiBars', url = root .. 'bars.png'},
    {name = 'uiInventory', url = rootIn},
    {name = 'uiBook', url = rootB},
    {name = 'uiBackG', url = backG},
    {name = 'uiReset', url = reset},
    {name = 'uiBarBackG', url = barBackG},
    {name = 'uiBarFillImage', url = barFillIm},
  }
  self.UI.setCustomAssets(assets)
end
