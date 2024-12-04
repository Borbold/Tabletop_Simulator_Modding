local hexColor = {
    Black = "000000", White = "ffffff", Red = "ff0000", Green = "00ff00", Blue = "0000ff",
    Pink = "ffaeff", Yellow = "ffff0f", Purple = "ff0fff", Orange = "ffae0f", Brown = "ae400f",
    Teal = "0faeae"
}

function onLoad()
    osTime = os.time()
    saveThrow = {}
    countThrow = 1
    tableDices = {4, 6, 20, 100}
    diceThrow = #tableDices
    buttonSaveThrows = 30
    Wait.time(|| CreateButtonSaveThrows(), 0.5)
    buttonBonusThrows = 5
    bonusThrow = {}
    for i = 1, buttonBonusThrows do
        table.insert(bonusThrow, 0)
    end
    Wait.time(|| CreateButtonBonusThrows(), 0.8)
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

function SaveThrow(player, alt, id)
    local nameSaveButton = self.UI.getAttribute(id, "text") ~= "---" and self.UI.getAttribute(id, "text") or self.UI.getAttribute("nameSavedButton", "text")
    if(#nameSaveButton == 0) then print("Set a name for the button") return end

    if(saveThrow[nameSaveButton] == nil) then
        self.UI.setAttribute(id, "text", nameSaveButton)
        saveThrow[nameSaveButton] = {CT = countThrow, DT = diceThrow, BT = bonusThrow}
        self.UI.setAttribute("nameSavedButton", "text", "")
    else
        if(alt == "-1") then
            countThrow = saveThrow[nameSaveButton].CT
            diceThrow = saveThrow[nameSaveButton].DT
            bonusThrow = saveThrow[nameSaveButton].BT
            Throw(player, _, _, nameSaveButton)
        elseif(alt == '-2') then
            self.UI.setAttribute(id, "text", "---")
            saveThrow[nameSaveButton] = nil
        end
    end
end

function Throw(player, _, _, nameSaveButton)
    if(self.UI.getAttribute("whoThrow", "text") == "Throw GM" and player.color ~= "Black") then return end

    Wait.stopAll()
    local colorBrackes = "["..hexColor[player.color].."]---[-]"
    local nameThrow = nameSaveButton ~= nil and ": "..nameSaveButton..colorBrackes or colorBrackes
    printToAll(colorBrackes..player.steam_name..nameThrow)
    for i = 1, countThrow do
        if(math.floor(osTime) ~= math.floor(os.time())) then
            PrintThrow(i)
        else
            Wait.time(|| PrintThrow(i), 1 + (i - (countThrow > 1 and 2 or 1)))
        end
    end
    osTime = os.time()
end

function PrintThrow(numberThrow)
    math.randomseed(os.time())
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
end

function CreateButtonSaveThrows()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    local saveButtons = xmlTable[2].children[1].children[2].children[2].children[1].children[1].children

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
    local bonusButtons = xmlTable[2].children[1].children[2].children[3].children[1].children[1].children

    for i = 1, buttonBonusThrows do
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