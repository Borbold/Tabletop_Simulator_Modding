local hexColor = {
    Black = "000000", White = "ffffff", Red = "ff0000", Green = "00ff00", Blue = "0000ff",
    Pink = "ffaeff", Yellow = "ffff0f", Purple = "ff0fff", Orange = "ffae0f", Brown = "ae400f",
    Teal = "0faeae"
}

function UpdateSave()
    local dataToSave = {
        ["saveThrow"] = saveThrow, ["tableDices"] = tableDices,
        ["buttonSaveThrows"] = buttonSaveThrows, ["buttonBonusThrows"] = buttonBonusThrows
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    saveThrow, bonusThrow = {}, {}
    countThrow, tableDices = 1, {4, 6, 20, 100}
    buttonSaveThrows = 30
    buttonBonusThrows = 5
    local loadedData = JSON.decode(savedData)
    if(loadedData) then
        saveThrow = loadedData.saveThrow or saveThrow
        tableDices = loadedData.tableDices or tableDices
        buttonSaveThrows = loadedData.buttonSaveThrows or buttonSaveThrows
        buttonBonusThrows = loadedData.buttonBonusThrows or buttonBonusThrows
    end

    Wait.time(|| CreateButtonSaveThrows(), 0.3)
    Wait.time(|| CreateButtonBonusThrows(), 0.5)
    Wait.time(|| DonwloadSaveThrow(), 0.7)
    diceThrow = #tableDices
    self.UI.setAttribute("diceThrow", "text", tableDices[diceThrow])
end

function ChangeBonusThrow(_, alt, id)
    local locId = tonumber(id:gsub("%D", ""), 10)
    bonusThrow[locId] = bonusThrow[locId] + (alt == "-1" and 1 or -1)
    self.UI.setAttribute(id, "text", bonusThrow[locId])
end

function ChangeCountThrow(_, alt, id)
    countThrow = countThrow + (alt == "-1" and 1 or -1)
    self.UI.setAttribute(id, "text", countThrow)
end

function ChangeDiceThrow(_, alt, id)
    diceThrow = diceThrow + (alt == "-1" and 1 or -1)
    if(diceThrow < 1) then diceThrow = #tableDices elseif(diceThrow > #tableDices) then diceThrow = 1 end
    self.UI.setAttribute(id, "text", tableDices[diceThrow])
end

function DonwloadSaveThrow()
    for name,throw in pairs(saveThrow) do
        self.UI.setAttribute(throw.idButton, "text", name)
    end
end

function SaveThrow(player, alt, id)
    local nameSaveButton = self.UI.getAttribute(id, "text") ~= "---" and self.UI.getAttribute(id, "text") or self.UI.getAttribute("nameSavedButton", "text")
    if(#nameSaveButton == 0) then print("Set a name for the button") return end

    if(saveThrow[nameSaveButton] == nil) then
        self.UI.setAttribute(id, "text", nameSaveButton)
        saveThrow[nameSaveButton] = {CT = countThrow, DT = diceThrow, BT = bonusThrow, idButton = id}
        self.UI.setAttribute("nameSavedButton", "text", "")
    else
        if(alt == "-1") then
            countThrow = saveThrow[nameSaveButton].CT
            diceThrow = saveThrow[nameSaveButton].DT
            bonusThrow = saveThrow[nameSaveButton].BT
            Throw(player, _, _, nameSaveButton)
        elseif(alt == '-2' and player.color == "Black") then
            self.UI.setAttribute(id, "text", "---")
            saveThrow[nameSaveButton] = nil
        end
    end
    UpdateSave()
    Reset()
end

function Throw(player, _, _, nameSaveButton)
    if(self.UI.getAttribute("whoThrow", "text") == "Throw GM" and player.color ~= "Black") then return end

    Wait.stopAll()
    local colorBrackes = "["..hexColor[player.color].."]---[-]"
    local nameThrow = nameSaveButton ~= nil and ": "..nameSaveButton..colorBrackes or colorBrackes
    printToAll(colorBrackes..player.steam_name..nameThrow)
    local totalAmount = 0
    for i = 1, countThrow do
        totalAmount = totalAmount + PrintThrow(i)
        if(i ~= countThrow) then
            printToAll(colorBrackes.."---"..colorBrackes)
        end
    end
    if(countThrow > 1) then
        printToAll(colorBrackes.."Total amount: "..totalAmount..colorBrackes)
    end
end

function PrintThrow(numberThrow)
    local naturalThrow = math.random(1, tableDices[diceThrow])
    local resText = {}
    table.insert(resText, countThrow == 1 and ("Throw: "..naturalThrow) or ("Throw "..numberThrow..": "..naturalThrow))

    local sumBonus = 0
    for i,b in ipairs(bonusThrow) do
        if(b ~= 0) then
            table.insert(resText, "Bonus "..i..": "..b)
            sumBonus = sumBonus + b
        end
    end
    if(sumBonus ~= 0) then
        table.insert(resText, "Sum bonus: "..sumBonus)
        table.insert(resText, "Equals throw: "..(naturalThrow + sumBonus))
    end

    if(self.UI.getAttribute("whoThrow", "text") == "Throw GM") then
        for i = 1, #resText do
            printToColor(resText[i], "Black")
        end
    else
        for i = 1, #resText do
            printToAll(resText[i])
        end
    end
    return (naturalThrow + sumBonus)
end

function CreateButtonSaveThrows()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    local saveButtons = xmlTable[2].children[2].children[2].children[2].children[1].children[1].children

    for i = 1, buttonSaveThrows do
        local saveButton = {
            tag = "Button",
            attributes = {
              id = "saveThrow"..i,
              class = "buttonSave"
            }
        }
        table.insert(saveButtons, saveButton)
    end
    self.UI.setXmlTable(xmlTable)
end

function CreateButtonBonusThrows()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    local bonusButtons = xmlTable[2].children[2].children[2].children[3].children[1].children[1].children

    for i = 1, buttonBonusThrows do
        table.insert(bonusThrow, 0)
        local bonusButton = {
            tag = "Button",
            attributes = {
              id = "bonusThrow"..i,
              class = "buttonBonus"
            }
        }
        table.insert(bonusButtons, bonusButton)
    end
    self.UI.setXmlTable(xmlTable)
end

function ChangeInputField(_, input, id)
    self.UI.setAttribute(id, "text", input)
end

function Reset()
    countThrow = 1
    self.UI.setAttribute("countThrow", "text", countThrow)
    bonusThrow = {}
    for i = 1, buttonBonusThrows do
        table.insert(bonusThrow, 0)
        self.UI.setAttribute("bonusThrow"..i, "text", 0)
    end
end

function ChangePermitThrow(_, _, id)
    local t = self.UI.getAttribute(id, "text")
    if(t == "Throw all") then
        self.UI.setAttribute(id, "text", "Throw GM")
    else
        self.UI.setAttribute(id, "text", "Throw all")
    end
end

function ShowHideSettingPanel()
    local active = self.UI.getAttribute("settingPanel", "active")
    self.UI.setAttribute("settingPanel", "active", active == "false" and "true" or "false")
end

function ChangeTableDices(_, input)
    tableDices = {}
    for w in input:gmatch("[^|]+") do
        table.insert(tableDices, w)
    end
    UpdateSave()
    diceThrow = #tableDices
    self.UI.setAttribute("diceThrow", "text", tableDices[diceThrow])
end

function ChangeSaveButton(_, input)
end

function ChangeBonusButton(_, input)
end

function ChangeColor(_, input, id)
    if(id:find("colorText")) then
        self.UI.setAttribute("countThrow", "textColor", "#"..input)
        self.UI.setAttribute("diceThrow", "textColor", "#"..input)
    elseif(id:find("colorPanel")) then
        self.UI.setAttribute("mainPanel", "color", "#"..input)
    end
end

function ChangeMemory(arg)
    local bChar = 0
    if(arg.tTag and saveThrow[arg.tTag]) then
        saveThrow[arg.tTag].BT[1] = saveThrow[arg.tChar].BT[1]
        saveThrow[arg.tTag].BT[2] = arg.bonus
    elseif(arg.tChar and saveThrow[arg.tChar]) then
        saveThrow[arg.tChar].BT[1] = arg.bonus
    end
    UpdateSave()
end

function Overshoot(arg)
    for i = 1, buttonSaveThrows do
        if(self.UI.getAttribute("saveThrow"..i, "text") == arg.tTag) then
            broadcastToAll("{en}"..arg.player.steam_name.." overshoot "..arg.tTag.."{ru}"..arg.player.steam_name.." перебросил "..arg.tTag, arg.player.color)
            SaveThrow(arg.player, "-1", "saveThrow"..i)
            return
        end
    end
end