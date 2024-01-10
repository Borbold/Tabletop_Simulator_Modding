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
    countMember = 5
    countRound = 1
    ChangeUI()
end

function NextStep(player)
    ChangeStep(1)
end
function ChangeStep(value)
    currentInitiative = currentInitiative + value
    if currentInitiative > countMember then
        currentInitiative = 1
        countRound = countRound + 1
    end
    MessageStep(
        self.UI.getAttribute("nameStep" .. currentInitiative, "text"),
        self.UI.getAttribute("nameStep" .. (currentInitiative + 1 < countMember and (currentInitiative + 1) or 1), "text")
    )
    ChangeUI()
end

function ChangeMember(_, input, _)
    countMember = tonumber(input)
    ChangeUI()
end

function StartInitiative()
    countRound, currentInitiative = 1, 1
    local locInit = {}
    for i = 1, countMember do
        locInit[i] = {
            self.UI.getAttribute("nameStep" .. i, "text"),
            tonumber(self.UI.getAttribute("reactionStep" .. i, "text"))
        }
    end
    local j, flag = 1, 0
    while true do
        if locInit[j][2] > locInit[j + 1][2] then
            self.UI.setAttribute("nameStep" .. j, "text", locInit[j + 1][1])
            self.UI.setAttribute("reactionStep" .. j, "text", locInit[j + 1][2])
            self.UI.setAttribute("nameStep" .. j + 1, "text", locInit[j][1])
            self.UI.setAttribute("reactionStep" .. j + 1, "text", locInit[j][2])
            local lInit = locInit[j]
            locInit[j] = locInit[j + 1]
            locInit[j + 1] = lInit
            flag = 1
        end
        j = j + 1
        if j == countMember then
            if flag == 0 then break else flag = 0 end
            j = 1
        end
    end
    Wait.time(|| ChangeStep(0), 0.25)
end

function ChangeUI()
    for i = 1, maxInitiative do
        if i == currentInitiative then
            self.UI.setAttribute("lamp" .. i, "image", "uiGreenBut")
        elseif i <= countMember then
            self.UI.setAttribute("lamp" .. i, "image", "uiRedBut")
        else
            self.UI.setAttribute("lamp" .. i, "image", "uiGrayBut")
        end
    end
    self.UI.setAttribute("countRound", "text", "Round:" .. countRound)
    self.UI.setAttribute("countMember", "text", countMember)
    UpdateSave()
end

function StepUP(player, _, id)
    if player.color != "Black" then print("Только GM") return end
    ChangeStepInitiative(id, -1)
end
function StepDown(player, _, id)
    if player.color != "Black" then print("Только GM") return end
    ChangeStepInitiative(id, 1)
end
function ChangeStepInitiative(id, where)
    local locInit = {}
    for i = 1, countMember do
        locInit[i] = {
            self.UI.getAttribute("nameStep" .. i, "text"),
            tonumber(self.UI.getAttribute("reactionStep" .. i, "text"))
        }
    end
    local j = tonumber(id:sub(5))
    if (j + where < countMember or where != -1) and (j > 1 or where != -1) and (j < countMember or where != 1) then
        self.UI.setAttribute("nameStep" .. j, "text", locInit[j + where][1])
        self.UI.setAttribute("reactionStep" .. j, "text", locInit[j + where][2])
        self.UI.setAttribute("nameStep" .. j + where, "text", locInit[j][1])
        self.UI.setAttribute("reactionStep" .. j + where, "text", locInit[j][2])
    end
end

function ChangeText(_, input, id)
    self.UI.setAttribute(id, "text", input)
end

function MessageStep(name1, name2)
    broadcastToAll("[948773]Ход переходит [0FFF74]" .. name1 .. " [948773]Следующий [0FFF74]" .. name2)
end

function Reset()
    currentInitiative = 1
    maxInitiative = 20
    countMember = 5
    countRound = 1
    ChangeUI()
end

function RebuildAssets()
    local backG = 'https://cdn.discordapp.com/attachments/800324103848198174/838062391127441428/brosok.png'
    local redBut = 'https://cdn.discordapp.com/attachments/800324103848198174/1193905025894854750/Unikalnaya.png'
    local greenBut = 'https://cdn.discordapp.com/attachments/800324103848198174/1193905026180075610/Unikalnaya2.png'
    local grayBut = "https://cdn.discordapp.com/attachments/800324103848198174/1193946708128825458/Unikalnaya3.png"
    local assets = {
      {name = 'uiBackGround', url = backG},
      {name = 'uiRedBut', url = redBut},
      {name = 'uiGreenBut', url = greenBut},
      {name = 'uiGrayBut', url = grayBut},
    }
    self.UI.setCustomAssets(assets)
end