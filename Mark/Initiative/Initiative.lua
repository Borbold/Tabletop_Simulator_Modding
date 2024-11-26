function UpdateSave()
    local dataToSave = {
        ["currentInitiative"] = currentInitiative, ["countMember"] = countMember,
        ["countRound"] = countRound
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
  end

function onLoad(savedData)
    diedCharacter = {}
    Wait.time(|| Confer(savedData), 0.4)
end

function Confer(savedData)
    local loadedData = JSON.decode(savedData or "")
    currentInitiative = loadedData and loadedData.currentInitiative or 1
    countMember = loadedData and loadedData.countMember or 1
    countRound = loadedData and loadedData.countRound or 1
    addHotkey("Step forward initiative", function(playerColor) if(playerColor == "Black") then ChangeStep(1) end end)
    addHotkey("Step back initiative", function(playerColor) if(playerColor == "Black") then ChangeStep(-1) end end)
    Wait.time(|| XMLReplacement(), 0.2)
end

function BackStep(player)
    if(player.color != "Black") then print("Только GM") return end
    ChangeStep(-1)
end
function NextStep(player)
    if(player.color != "Black") then print("Только GM") return end
    ChangeStep(1)
end
function ChangeStep(value)
    while(self.UI.getAttribute("lamp"..(currentInitiative + value), "image") == "uiRedBut") do
        currentInitiative = currentInitiative + value
        if(currentInitiative > countMember) then break end
    end

    currentInitiative = currentInitiative + value
    if(currentInitiative > countMember) then
        currentInitiative = 1
        countRound = countRound + 1
    elseif(currentInitiative < 1) then
        currentInitiative = 1
    end
    local nextInit = (((currentInitiative + math.abs(value)) <= countMember and (currentInitiative + math.abs(value))) or 1)
    while(self.UI.getAttribute("lamp"..(nextInit), "image") == "uiRedBut") do
        nextInit = (((nextInit + math.abs(value)) <= countMember and (nextInit + math.abs(value))) or 1)
        if(nextInit > countMember) then break end
    end
    local name1 = self.UI.getAttribute("nameStep"..currentInitiative, "text") ~= "" and self.UI.getAttribute("nameStep"..currentInitiative, "text") or currentInitiative
    local name2 = self.UI.getAttribute("nameStep"..nextInit, "text") ~= "" and self.UI.getAttribute("nameStep"..nextInit, "text") or nextInit
    MessageStep(name1, name2)
    ChangeUI()
end

function MessageStep(name1, name2)
    local info = "[948773]{ru}Ход переходит [0FFF74]%s [948773]Следующий [0FFF74]%s{en}Move passed [0FFF74]%s [948773]Next [0FFF74]%s"
    broadcastToAll(info:format(name1, name2, name1, name2))
end

function ChangeMember(_, input, _)
    countMember = tonumber(input)
    self.UI.setAttribute("countMember", "text", countMember)
    Wait.time(|| XMLReplacement(), 0.1)
end

function StartInitiative()
    countRound, currentInitiative = 1, 1
    local locInit = {}
    for i = 1, countMember do
        locInit[i] = {
            self.UI.getAttribute("nameStep" .. i, "text") or " ",
            tonumber(self.UI.getAttribute("reactionStep" .. i, "text")) or 1
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
    for i = 1, countMember do
        if(i == currentInitiative) then
            self.UI.setAttribute("lamp" .. i, "image", "uiGreenBut")
        elseif(diedCharacter[i]) then
            self.UI.setAttribute("lamp" .. i, "image", "uiRedBut")
        else
            self.UI.setAttribute("lamp" .. i, "image", "uiGrayBut")
        end
    end
    self.UI.setAttribute("countRound", "text", "Round:" .. countRound)
    self.UI.setAttribute("countMember", "text", countMember)
    UpdateSave()
end

function ChangeText(_, input, id)
    self.UI.setAttribute(id, "text", input)
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

function Reset()
    countMember, countRound, currentInitiative = 1, 1, 1
    self.UI.setAttribute("countMember", "text", countMember)
    ChangeUI()
    Wait.time(|| XMLReplacement(), 0.1)
end

function RemoveCharacter(_, alt, id)
    diedCharacter[StringInNumber(id)] = alt == "-1" and true or false
    ChangeUI()
end

function GetInfoTimeReinforcment(args)
    self.UI.setAttribute("timeR1", "tooltip", "Бибик:\n" .. args["desc"])
    self.UI.setAttribute("timeR1", "text", args["time"])
    self.UI.setAttribute("timeR1", "image", "uiGreenBut")
end

function XMLReplacement()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    XMLReplacementDelete(xmlTable)
    diedCharacter = {}
    for i = 1, countMember do
        XMLReplacementAdd(xmlTable)
        table.insert(diedCharacter, false)
    end
    Wait.time(|| self.UI.setXmlTable(xmlTable), 0.25)
    Wait.time(|| EnlargeHeightPanelStat(), 0.5)
end
function XMLReplacementDelete(xmlTable)
    local tableLayoutInitiative = xmlTable[2].children[1].children[3].children[1].children[1].children[1].children
    for i = 1, #tableLayoutInitiative do
        table.remove(tableLayoutInitiative, 1)
    end
end
function XMLReplacementAdd(xmlTable)
    local tableLayoutInitiative = xmlTable[2].children[1].children[3].children[1].children[1].children[1].children
    local newInitCharacter = {
        tag = "Row",
        attributes = {
          preferredHeight = 50
        },
        children = {
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "7"
                },
                children = {
                    {
                        tag = "Text",
                        attributes = {
                            text = "1"
                        }
                    }
                }
            },
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "5"
                },
                children = {
                    {
                        tag = "Image",
                        attributes = {
                            class = "lamp",
                            id = "lamp",
                            image = "uiGrayBut"
                        }
                    }
                }
            },
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "10"
                },
                children = {
                    {
                        tag = "InputField",
                        attributes = {
                            class = "changedText",
                            id = "nameStep",
                            placeholder = "Name",
                            text = ""
                        }
                    }
                }
            },
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "10"
                },
                children = {
                    {
                        tag = "InputField",
                        attributes = {
                            class = "changedText",
                            id = "reactionStep",
                            placeholder = "Reaction",
                            characterValidation = "Integer"
                        }
                    }
                }
            },
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "5"
                },
                children = {
                {
                    tag = "Button",
                    attributes = {
                        id = "step",
                        onClick = "StepUP",
                        class = "textButton",
                        text = "↑"
                    }
                }
                }
            },
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "5"
                },
                children = {
                {
                    tag = "Button",
                    attributes = {
                        id = "step",
                        onClick = "StepDown",
                        class = "textButton",
                        text = "↓"
                    }
                }
                }
            },
            {
                tag = "Cell",
                attributes = {
                    columnSpan = "5"
                },
                children = {
                    {
                        tag = "Button",
                        attributes = {
                            id = "remove",
                            onClick = "RemoveCharacter",
                            class = "textButton",
                            text = "X",
                            textColor = "Red"
                        }
                    }
                }
            }
        }
    }
    newInitCharacter.children[1].children[1].attributes.text = #tableLayoutInitiative + 1
    for i = 2, 7 do
        newInitCharacter.children[i].children[1].attributes.id = newInitCharacter.children[i].children[1].attributes.id..(#tableLayoutInitiative + 1)
    end

    table.insert(tableLayoutInitiative, newInitCharacter)
end

function EnlargeHeightPanelStat()
    if(countMember > 13) then
        local cellSpacing = self.UI.getAttribute("tableLayoutInitiative", "cellSpacing")
        local preferredHeight = 50 -- preferredHeight variable newInitCharacter
        local newHeightPanel = countMember*preferredHeight + countMember*cellSpacing
        Wait.time(|| self.UI.setAttribute("tableLayoutInitiative", "height", newHeightPanel), 0.2)
    end
    ChangeUI()
end
function StringInNumber(str)
    return tonumber(str:gsub("%D", ""), 10)
end