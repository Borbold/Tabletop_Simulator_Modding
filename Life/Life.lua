function UpdateSave()
  local dataToSave = {
    ["levelGUID"] = levelGUID, ["infoGUID"] = infoGUID,
    ["currentHP"] = currentHP, ["maxHP"] = maxHP,
    ["currentAP"] = currentAP, ["maxAP"] = maxAP,
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
  infoGUID = loadedData.infoGUID
  GetInfoMajorValue()
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

function ChangeMaxHP(player, input)
  if not CheckPlayer(player.color, true) then return end

  if input == "" then input = "0" end
  maxHP = tonumber(input)
  ChangeUI()
end
function ChangeMaxAP(player, input)
  if not CheckPlayer(player.color, true) then return end

  if input == "" then input = "0" end
  maxAP = tonumber(input)
  maxAP = maxAP <= 20 and maxAP or 20
  ChangeUI()
end

function InputRatioHP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("ratioHP", "text", input)
end
function InputRatioAP(player, input)
  if input == "" then input = "0" end
  self.UI.setAttribute("ratioAP", "text", input)
end

function GetInfoMajorValue()
  if not levelGUID then SearchLevel("Level") end
  if not infoGUID then SearchLevel("Info") end
  infoMajorValue = getObjectFromGUID(infoGUID).call("GetMajorValue", args)
end
function CheckPlayer(playerColor, onlyGM)
  if not levelGUID then SearchDie("Level") end
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
  currentHP, currentAP = 25, 3
  maxHP, maxAP = 50, 10
  ChangeUI()
end
function ChangeUI()
  self.UI.setAttribute("currentHP", "text", currentHP)
  self.UI.setAttribute("maxHP", "text", maxHP)
  local avarageValue = currentHP*100/maxHP
  self.UI.setAttribute("HP", "text", avarageValue .. "%")
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
