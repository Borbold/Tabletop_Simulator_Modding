function UpdateSave()
  local dataToSave = {
    ["levelGUID"] = levelGUID,
    ["currentHP"] = currentHP, ["maxHP"] = maxHP,
    ["currentAP"] = currentAP, ["maxAP"] = maxAP,
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
      ["Teal"] = {r = 0.13, g = 0.69, b = 0.61},
      ["Black"] = {r = 0.25, g = 0.25, b = 0.25}
    }
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

function SearchInfo()
  if not levelGUID then SearchLevel() end
  if not infoGUID then infoGUID = getObjectFromGUID(levelGUID).call("SearchDie", "Info") end
end
function CheckPlayer(playerColor, onlyGM)
  if not levelGUID then SearchLevel() end
  local args = {playerColor = playerColor, onlyGM = onlyGM}
  if getObjectFromGUID(levelGUID).call("CheckPlayer", args) then return true end
end
function SearchLevel()
  for _,obj in pairs(getObjects()) do
    if obj.getName() == "Level" and obj.getColorTint() == self.getColorTint() then
      levelGUID = obj.getGUID()
      return
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
