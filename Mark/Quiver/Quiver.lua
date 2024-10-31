function UpdateSave()
    self.UI.setValue("maxText", maxValue)
    local dataToSave = {
        ["maxValue"] = maxValue, ["countAmunition"] = countAmunition,
        ["fildForAmmunitions"] = fildForAmmunitions
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    hexArray = {
        ["a"] = 10, ["b"] = 11, ["c"] = 12, ["d"] = 13, ["e"] = 14, ["f"] = 15,
    }

    maxValue, countAmunition, selectTypeId = 1, 1, -1
    fildForAmmunitions = {}
    Wait.time(|| Confer(savedData), 0.5)
    end
    function Confer(savedData)
    originalXml = self.UI.getXml()
    if(savedData ~= "") then
        local loadedData = JSON.decode(savedData)
        maxValue = loadedData.maxValue or 1
        countAmunition = loadedData.countAmunition or 1
        fildForAmmunitions = loadedData.fildForAmmunitions or {}
        SetNewAmmunitionType(_, _, _, true)
    end
    
    tGMNotes = {}
    for w in self.getGMNotes():gmatch("[^\n]+") do
        table.insert(tGMNotes, w)
    end
end

function PanelTool()
    if(self.UI.getAttribute("panelTool", "active") == "false") then
        self.UI.show("panelTool")
        self.UI.show("panelClose")
    else
        self.UI.hide("panelTool")
        self.UI.hide("panelClose")
    end
    Wait.time(UpdateSave, 0.2)
end

function PanelTool2()
    if(self.UI.getAttribute("panelTool2", "active") == "false") then
        self.UI.show("panelTool2")
    else
        self.UI.hide("panelTool2")
    end
    Wait.time(UpdateSave, 0.2)
end

function SetInputMax(_, input, id)
    input = tonumber(input)
    maxValue = input
    Wait.time(UpdateSave, 0.2)
end

function PlusValue(_, _, id)
    SetValueAmmunition(_, 1, id)
end
function MinusValue(_, _, id)
    SetValueAmmunition(_, -1, id)
end

function SetNewAmmunitionType(_, _, _, isOnLoad)
    if(not isOnLoad) then
        fildForAmmunitions[tostring(countAmunition)] = {name = "", color = "e8d8b4", value = 0}
        countAmunition = countAmunition + 1
    end

    local allXml = originalXml

    local newType = ""
    for i,v in pairs(fildForAmmunitions) do
        newType = newType .. [[
        <Row>
            <Cell columnSpan='1'>
                <InputField id='name]]..i..[[' class='inputType' placeholder='Name' text=']]..v.name..[['/>
            </Cell>
            <Cell columnSpan='1'>
                <InputField id='color]]..i..[[' class='inputType' placeholder='#color' characterLimit='6'
                    characterValidation='Alphanumeric' text=']]..v.color..[['/>
            </Cell>
        </Row>
        ]]
    end

    local searchString = "<NewRowS />"
    local searchStringLength = #searchString

    local indexFirst = allXml:find(searchString)

    local startXml = allXml:sub(1, indexFirst + searchStringLength)
    local endXml = allXml:sub(indexFirst + searchStringLength)
    allXml = startXml .. newType .. endXml
    --------------------------------------------------------------------------------
    newType = ""
    for i,v in pairs(fildForAmmunitions) do
        newType = newType .. [[
        <Row>
            <Cell columnSpan='9'>
                <Text id='nameT]]..i..[[' text=']]..v.name..[[' color='#]]..v.color..[['/>
            </Cell>
            <Cell columnSpan='5'>
                <InputField id='value]]..i..[[' class='inputValue' text=']]..v.value..[[' />
            </Cell>
            <Cell columnSpan='3'>
                <Button id='buttonS]]..i..[[' image='uiCube' onClick='SelectTypeAmmunition'/>
            </Cell>
            <Cell columnSpan='3'>
                <Button id='buttonP]]..i..[[' image='uiPlus' onClick='PlusValue'/>
            </Cell>
        </Row>
        ]]
    end

    searchString = "<NewRowC />"
    searchStringLength = #searchString

    indexFirst = allXml:find(searchString)

    startXml = allXml:sub(1, indexFirst + searchStringLength)
    endXml = allXml:sub(indexFirst + searchStringLength)

    startXml = startXml .. newType .. endXml
    self.UI.setXml(startXml)
    EnlargeHeightPanel()

    Wait.time(function()
        if countAmunition == 2 then
            SelectTypeAmmunition(nil, nil, "buttonS1")
            fildForAmmunitions['1'].name = self.getName()
        end
    end, 0.2)
end

function EnlargeHeightPanel()
    if(countAmunition > 7) then
        --preferredHeight=25
        local newHeightPanel = countAmunition*75 + 27
        Wait.time(|| self.UI.setAttribute("TLSet", "height", newHeightPanel), 0.2)
        Wait.time(|| self.UI.setAttribute("TLUse", "height", newHeightPanel), 0.2)
    end
end

function SetInputTypeAmmunition(_, input, id)
    if(id:find("name")) then
        self.UI.setAttribute(id, "text", input)
        id = id:sub(5, #id)
        fildForAmmunitions[id].name = input
        self.UI.setValue("nameT"..id, input)
    elseif(id:find("color")) then
        self.UI.setAttribute(id, "text", input)
        id = id:sub(6, #id)
        fildForAmmunitions[id].color = input
        self.UI.setAttribute("nameT"..id, "color", "#"..input)
    end
    Wait.time(|| UpdateSave(), 0.2)
end

function SetValueAmmunition(_, input, id)
    if(not input or input == "") then return end

    if(id:find("value")) then
        id = id:sub(6, #id)

        local currentValue = 0
        for i,v in pairs(fildForAmmunitions) do
            if(id ~= i) then
                currentValue = currentValue + v.value
            end
        end
        if(tonumber(input) + currentValue > maxValue) then
            broadcastToAll(tGMNotes[2])
            self.UI.setAttribute("value"..id, "text", 0)
            return
        end

        fildForAmmunitions[id].value = tonumber(input)
    elseif(id:find("buttonP")) then
        id = id:sub(8, #id)

        local currentValue = 0
        for _,v in pairs(fildForAmmunitions) do
            currentValue = currentValue + v.value
        end
            if(tonumber(input) + currentValue > maxValue) then
            broadcastToAll(tGMNotes[2])
            return
        end

        fildForAmmunitions[id].value = fildForAmmunitions[id].value + tonumber(input)
        self.UI.setAttribute("value"..id, "text", fildForAmmunitions[id].value)
    elseif(id:find("buttonM")) then
        id = id:sub(8, #id)

        if(fildForAmmunitions[id].value + tonumber(input) < 0) then
            broadcastToAll(tGMNotes[3])
            return
        end

        local colorRGB, index = {r = 0, b = 0, g = 0}, 1
        local locTableHex = {r = "", g = "", b = ""}
        fildForAmmunitions[id].color = fildForAmmunitions[id].color:lower()
        locTableHex.r = fildForAmmunitions[id].color:sub(1, 2)
        locTableHex.g = fildForAmmunitions[id].color:sub(3, 4)
        locTableHex.b = fildForAmmunitions[id].color:sub(5, 6)
        for i,c in pairs(locTableHex) do
            local locC = hexArray[c:sub(1, 1)] or c:sub(1, 1)
            colorRGB[i] = colorRGB[i] + 16*tonumber((locC ~= "" and locC) or 0)
            locC = hexArray[c:sub(2, 2)] or c:sub(2, 2)
            colorRGB[i] = colorRGB[i] + tonumber((locC ~= "" and locC) or 0)
            colorRGB[i] = colorRGB[i]/255
        end

        broadcastToAll(tGMNotes[1].." " .. fildForAmmunitions[id].name, colorRGB)
        fildForAmmunitions[id].value = fildForAmmunitions[id].value + tonumber(input)
        self.UI.setAttribute("value"..id, "text", fildForAmmunitions[id].value)
    end
    UpdateSave()
end

function Reset()
    maxValue, countAmunition, selectTypeId = 1, 1, -1
    fildForAmmunitions = {}
    self.UI.setXml(originalXml)
    UpdateSave()
end

function SelectTypeAmmunition(_, _, id)
    if(id:find("buttonS")) then
        id = id:sub(8, #id)
        local locId = (selectTypeId > 0 and selectTypeId) or ""
        self.UI.setAttribute("buttonM"..locId, "active", "true")
        self.UI.setAttribute("buttonM"..locId, "id", "buttonM"..id)
        selectTypeId = tonumber(id)
    end
    UpdateSave()
end