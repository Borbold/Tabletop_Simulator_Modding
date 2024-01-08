function UpdateSave()
    local dataToSave = {
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
  end

function onLoad(savedData)
    Wait.time(|| Confer(savedData), 2)
end

function Confer(savedData)
    RebuildAssets()
    local loadedData = JSON.decode(savedData or "")
    currentInitiative = 1
    maxInitiative = 20
    countRound = 1
    ChangeUI()
end

function NextStep(player)
    ChangeStep(1)
end
function ChangeStep(value)
    currentInitiative = currentInitiative + value
    if currentInitiative > maxInitiative then
        currentInitiative = 1
        countRound = countRound + 1
    end
    ChangeUI()
end

function ChangeUI()
    for i = 1, 20 do
        if i == currentInitiative then
            self.UI.setAttribute("lamp" .. i, "image", "uiGreenBut")
        else
            self.UI.setAttribute("lamp" .. i, "image", "uiRedBut")
        end
    end
    self.UI.setAttribute("countRound", "text", "Round:" .. countRound)
    UpdateSave()
end

function RebuildAssets()
    local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838062391127441428/brosok.png'
    local redBut = 'https://cdn.discordapp.com/attachments/800324103848198174/1193905025894854750/Unikalnaya.png'
    local greenBut = 'https://cdn.discordapp.com/attachments/800324103848198174/1193905026180075610/Unikalnaya2.png'
    local assets = {
      {name = 'uiBackGround', url = backG},
      {name = 'uiRedBut', url = redBut},
      {name = 'uiGreenBut', url = greenBut},
    }
    self.UI.setCustomAssets(assets)
end