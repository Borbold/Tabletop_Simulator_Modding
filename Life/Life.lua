function UpdateSave()
  local dataToSave = {
    ["levelGUID"] = levelGUID,
    ["currentHP"] = currentHP, ["maxHP"] = maxHP,
    ["currentAP"] = currentAP, ["maxAP"] = maxAP,
    ["currentLVL"] = currentLVL
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
    ["Teal"] = {r = 0.13, g = 0.7, b = 0.61},
    ["Black"] = {r = 0.25, g = 0.25, b = 0.25}
  }
  Wait.time(|| Confer(savedData), 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  currentHP = loadedData and loadedData.currentHP or 25
  maxHP = loadedData and loadedData.maxHP or 50
  currentAP = loadedData and loadedData.currentAP or 3
  maxAP = loadedData and loadedData.maxAP or 10
  levelGUID = loadedData and loadedData.levelGUID
  ChangeUI()
end
-- Здоровье
function MinusHP(player)
  ChangeHP(-1, player.color)
end
function PlusHP(player)
  ChangeHP(1, player.color)
end
function ChangeHP(value, playerColor)
  if not CheckPlayer(playerColor) then return end

  currentHP = currentHP + self.UI.getAttribute("ratioHP", "text")*value
  if currentHP > maxHP then currentHP = maxHP end
  if currentHP <= 0 then
    if Player[GetNameColor()].steam_name then
      broadcastToAll("Димооон " .. Player[GetNameColor()].steam_name .. " почти откинулся")
    else
      broadcastToAll("Димооон " .. GetNameColor() .. " почти откинулся")
    end
  end
  ChangeUI()
end
function CheckCurrentHP(args)
  local wordsCond = {}
  for word in args.condition:gmatch("%S+") do
    table.insert(wordsCond, word)
  end
  if wordsCond[2] == "<" then
    return currentHP*100/maxHP < wordsCond[3]
  end
end
-- Очки действий
function MinusAP(player)
  ChangeAP(-1, player.color)
end
function PlusAP(player)
  ChangeAP(1, player.color)
end
function ChangeAP(value, playerColor)
  if not CheckPlayer(playerColor) then return end

  currentAP = currentAP + self.UI.getAttribute("ratioAP", "text")*value
  if currentAP < 0 then currentAP = 0
  elseif currentAP > maxAP then currentAP = maxAP end
  ChangeUI()
end

function ChangeMaxHP(args)
  startMaxHP = 15 + args.enum.Сила + args.enum.Выносливость*2 + args.karma.HP
  if args.currentLVL == 1 then
    maxHP = startMaxHP
  else
    maxHP = startMaxHP + (math.floor(args.enum.Выносливость/2) + 2)*args.currentLVL
  end
  if not args.dontUpdate then
    ChangeUI()
  end
end
function ChangeMaxAP(args)
  maxAP = 5 + math.floor(args.enum.Ловкость/2)
  if not args.dontUpdate then
    ChangeUI()
  end
end

function InputRatioHP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("ratioHP", "text", input)
end
function InputRatioAP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("ratioAP", "text", input)
end

function SetTableValue(args)
  args["dontUpdate"] = true
  ChangeMaxHP(args) ChangeMaxAP(args)
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

function Reset(player)
  currentHP, currentAP = 15, 3
  startMaxHP = 50
  local enum = {
    Сила = 5,
    Выносливость = 5,
    Ловкость = 5
  }
  ChangeMaxHP({currentLVL = 1, enum = enum, karma = {HP = 0}}) ChangeMaxAP({enum = enum})
end
function ChangeUI()
  self.UI.setAttribute("currentHP", "text", currentHP .. "/" .. maxHP)
  local avarageValue = currentHP*100/maxHP
  self.UI.setAttribute("HP", "text", math.ceil(avarageValue) .. "%")
  self.UI.setAttribute("barHP", "percentage", avarageValue)

  self.UI.setAttribute("currentAP", "text", currentAP)
  self.UI.setAttribute("maxAP", "text", maxAP)
  for i = 1, 20 do
    if i <= currentAP then
      self.UI.setAttribute("lamp" .. i, "image", "uiLampOn")
    elseif i > currentAP and i <= maxAP then
      self.UI.setAttribute("lamp" .. i, "image", "uiLampOff")
      self.UI.setAttribute("lamp" .. i, "color", "#ffffff")
    elseif i > maxAP then
      self.UI.setAttribute("lamp" .. i, "image", "uiLampOff")
      self.UI.setAttribute("lamp" .. i, "color", "#ffffff44")
    end
  end
  UpdateSave()
end

function MaxValue(player, _, id)
  if id == "GmaxHP" then
    ChangeHP(maxHP, player.color)
  elseif id == "GmaxAP" then
    ChangeAP(maxHP, player.color)
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
  local backG = 'https://i.imgur.com/9DZklHJ.png'
  local lampOn = 'https://i.imgur.com/FkVbHlI.png'
  local lampOff = 'https://i.imgur.com/jHcDIon.png'

  local assets = {
    {name = 'uiBackGrou', url = backG},
    {name = 'uiLampOn', url = lampOn},
    {name = 'uiLampOff', url = lampOff},
  }
  self.UI.setCustomAssets(assets)
end
