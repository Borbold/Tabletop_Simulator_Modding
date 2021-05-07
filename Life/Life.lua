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
  Wait.time(function()
    Wait.time(|| Confer(savedData), 0.2)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  currentHP = loadedData.currentHP or 25
  maxHP = loadedData.maxHP or 50
  currentAP = loadedData.currentAP or 3
  maxAP = loadedData.maxAP or 10
  levelGUID = loadedData.levelGUID
  ChangeUI()
end
-- Здоровье
function MinusHP(player)
  ChangeHP(-1, player)
end
function PlusHP(player)
  ChangeHP(1, player)
end
function ChangeHP(value, player)
  if not CheckPlayer(player.color) then return end

  currentHP = currentHP + self.UI.getAttribute("ratioHP", "text")*value
  if currentHP > maxHP then currentHP = maxHP end
  if currentHP <= 0 then
    broadcastToAll("Димооон " .. args.player.steam_name .. " почти откинулся")
  end
  ChangeUI()
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
  startMaxHP = 15 + args.enum.Сила + args.enum.Выносливость*2
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
  ChangeMaxHP({currentLVL = 1, enum = enum}) ChangeMaxAP({enum = enum})
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

function RebuildAssets()
  local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/837975155631849472/ozod2.png'
  local lampOn = 'https://cdn.discordapp.com/attachments/800324103848198174/837859524814962738/lampon.png'
  local lampOff = 'https://cdn.discordapp.com/attachments/800324103848198174/837859531408277514/lampoff.png'

  local assets = {
    {name = 'uiBackGrou', url = backG},
    {name = 'uiLampOn', url = lampOn},
    {name = 'uiLampOff', url = lampOff},
  }
  self.UI.setCustomAssets(assets)
end
