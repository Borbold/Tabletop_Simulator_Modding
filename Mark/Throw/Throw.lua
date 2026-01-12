local hexColor = {
    Black = "000000", White = "ffffff", Red = "ff0000", Green = "00ff00", Blue = "0000ff",
    Pink = "ffaeff", Yellow = "ffff0f", Purple = "af0fff", Orange = "ffae0f", Brown = "ae400f",
    Teal = "0faeae"
}

function UpdateSave()
    local dataToSave = {
        ["saveThrow"] = saveThrow, ["tableDices"] = tableDices,
        ["buttonSaveThrows"] = buttonSaveThrows, ["buttonBonusThrows"] = buttonBonusThrows,
        ["saveColorText"] = saveColorText
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    saveThrow, bonusThrow = {}, {}
    countThrow, tableDices = 1, {8, 20, 100}
    buttonSaveThrows, maxBottunSave = 42, 42
    buttonBonusThrows = 5
    saveColorText = "000000"
    local loadedData = JSON.decode(savedData)
    if(loadedData) then
        saveThrow = loadedData.saveThrow or saveThrow
        tableDices = loadedData.tableDices or tableDices
        buttonSaveThrows = loadedData.buttonSaveThrows or buttonSaveThrows
        buttonBonusThrows = loadedData.buttonBonusThrows or buttonBonusThrows
        saveColorText = loadedData.saveColorText or saveColorText
    end

    Wait.time(|| CreateButtonBonusThrows(), 0.2)
    Wait.time(|| CreateButtonSaveThrows(), 0.5)
    if(saveColorText) then Wait.time(|| ChangeColor(_, saveColorText, "colorText"), 0.6) end
    diceThrow = #tableDices
    self.UI.setAttribute("diceThrow", "text", tableDices[diceThrow])
end

function ChangeBonusThrow(_, input, id)
    local locId = tonumber(id:gsub("%D", ""), 10)
    bonusThrow[locId] = tonumber(input)
    self.UI.setAttribute(id, "text", bonusThrow[locId])
end

function ChangeCountThrow(_, alt, id)
    countThrow = countThrow + (alt == "-1" and 1 or -1)
    self.UI.setAttribute(id, "text", countThrow)
    ChangeColor(_, saveColorText, "colorText")
end

function ChangeDiceThrow(_, alt, id)
    diceThrow = diceThrow + (alt == "-1" and 1 or -1)
    if(diceThrow < 1) then diceThrow = #tableDices elseif(diceThrow > #tableDices) then diceThrow = 1 end
    self.UI.setAttribute(id, "text", tableDices[diceThrow])
    ChangeColor(_, saveColorText, "colorText")
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
    ChangeColor(_, saveColorText, "colorText")
end

function Throw(player, _, _, nameSaveButton)
    local howThrow = self.UI.getAttribute("howThrow", "text")
    local colorBrackes = "["..hexColor[player.color].."]---[-]"
    local nameThrow = nameSaveButton ~= nil and ": "..nameSaveButton..colorBrackes or colorBrackes
    ForWhoPrintThrow(howThrow, "["..hexColor[player.color].."]---"..player.steam_name..nameThrow.."[-]", player.color)
    ForWhoPrintThrow(howThrow, string.format("Roll: D%d", tableDices[diceThrow]), player.color)
    local totalAmount = 0
    for i = 1, countThrow do
        totalAmount = totalAmount + PrintThrow(howThrow, i, player.color)
        if(i ~= countThrow) then
            ForWhoPrintThrow(howThrow, colorBrackes.."---"..colorBrackes, player.color)
        end
    end
    if(countThrow > 1) then
        ForWhoPrintThrow(howThrow, colorBrackes.."Total amount: "..totalAmount..colorBrackes, player.color)
    end
end

function PrintThrow(howThrow, numberThrow, playerColor)
    local naturalThrow = math.random(1, tableDices[diceThrow])
    local resText = {}
    table.insert(resText, 
        countThrow == 1 and string.format("Thorw: %d", naturalThrow) or string.format("Throw %d: %d", numberThrow, naturalThrow))

    local sumBonus = 0
    for i,b in ipairs(bonusThrow) do
        if(b ~= 0) then
            table.insert(resText, "Bonus "..i..": "..b)
            sumBonus = sumBonus + b
        end
    end
    if(sumBonus ~= 0) then
        table.insert(resText, "Equals throw: "..(naturalThrow + sumBonus))
    end

    for i = 1, #resText do
        ForWhoPrintThrow(howThrow, resText[i], playerColor)
    end
    return (naturalThrow + sumBonus)
end

function ForWhoPrintThrow(howThrow, text, playerColor)
    if(howThrow == "GM and I") then
        printToColor(text, playerColor)
        if(Player["Black"].steam_name) then
            printToColor(text, "Black")
        end
    elseif(howThrow == "GM") then
        if(Player["Black"].steam_name) then
            printToColor(text, "Black")
        end
    elseif(howThrow == "All") then
        printToAll(text)
    end
end

function CreateButtonSaveThrows()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    local saveButtons = xmlTable[2].children[2].children[2].children[2].children[1].children[1].children

    for i = 1, maxBottunSave do
        local saveButton = {
            tag = "Button",
            attributes = {
              id = "saveThrow"..i,
              class = "buttonSave"
            }
        }
        for name,throw in pairs(saveThrow) do
            if(saveButton.attributes.id == throw.idButton) then saveButton.attributes.text = name end
        end
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
            tag = "InputField",
            attributes = {
              id = "bonusThrow"..i,
              class = "inputBonus"
            }
        }
        table.insert(bonusButtons, bonusButton)
    end
    self.UI.setXmlTable(xmlTable)
end

function ChangeInputField(_, input, id)
    self.UI.setAttribute(id, "text", input)
    ChangeColor(_, saveColorText, "colorText")
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
    if(t == "All") then
        self.UI.setAttribute(id, "text", "GM and I")
    elseif(t == "GM and I") then
        self.UI.setAttribute(id, "text", "GM")
    elseif(t == "GM") then
        self.UI.setAttribute(id, "text", "All")
    end
    ChangeColor(_, saveColorText, "colorText")
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
        self.UI.setAttribute("nameSavedButton", "textColor", "#"..input)
        self.UI.setAttribute("reset", "textColor", "#"..input)
        self.UI.setAttribute("howThrow", "textColor", "#"..input)
        self.UI.setAttribute("throw", "textColor", "#"..input)
        for i = 1, buttonBonusThrows do
            self.UI.setAttribute("bonusThrow"..i, "textColor", "#"..input)
        end
        for i = 1, maxBottunSave do
            self.UI.setAttribute("saveThrow"..i, "textColor", "#"..input)
        end
        saveColorText = input
    elseif(id:find("colorPanel")) then
        self.UI.setAttribute("mainPanel", "color", "#"..input)
    end
    UpdateSave()
end

function ChangeMemory(arg)
    if(arg.tTag and saveThrow[arg.tTag]) then
        saveThrow[arg.tTag].BT[1] = saveThrow[arg.tChar].BT[1]
        saveThrow[arg.tTag].BT[2] = arg.bonus ~= -1 and arg.bonus or saveThrow[arg.tTag].BT[2]
    elseif(arg.tChar and saveThrow[arg.tChar]) then
        if(arg.condition) then
            saveThrow[arg.tChar].BT[3] = arg.bonus
        else
            saveThrow[arg.tChar].BT[1] = arg.bonus ~= -1 and arg.bonus or saveThrow[arg.tChar].BT[1]
        end
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

function ChangeLongText(_, input, id)
    if(#input > 2) then
        self.UI.setAttribute(id, "resizeTextMaxSize", 85)
    else
        self.UI.setAttribute(id, "resizeTextMaxSize", 200)
    end
    self.UI.setAttribute(id, "text", input)
end
