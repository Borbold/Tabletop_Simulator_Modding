function UpdateSave()
    local dataToSave = {
        ["maxValue"] = maxValue,
        ["fildForAmmunitions"] = fildForAmmunitions
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    hexArray = {
        ["a"] = 10, ["b"] = 11, ["c"] = 12, ["d"] = 13, ["e"] = 14, ["f"] = 15,
    }

    selectTypeId = -1
    Wait.time(|| Confer(savedData), 0.5)
end
function Confer(savedData)
    originalXml = self.UI.getXml()
    local loadedData = JSON.decode(savedData)
    if(loadedData) then
        maxValue = loadedData.maxValue or 1
        fildForAmmunitions = loadedData.fildForAmmunitions or {}
        SetNewAmmunitionType(_, _, _, true)
        self.UI.setValue("maxText", maxValue)
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
    self.UI.setValue("maxText", maxValue)
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
        table.insert(fildForAmmunitions, {name = "", color = "e8d8b4", value = 0})
    end

    if #fildForAmmunitions == 1 then
        Wait.time(|| SelectTypeAmmunition(nil, nil, "buttonS1"), 0.3)
        fildForAmmunitions[1].name = self.getName()
    end

    local allXml = originalXml

    local newType = ""
    for i,v in ipairs(fildForAmmunitions) do
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
    for i,v in ipairs(fildForAmmunitions) do
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
    selectTypeId = -1
end

function EnlargeHeightPanel()
    if(#fildForAmmunitions > 4) then
        local newHeightPanel = #fildForAmmunitions*75 + 18
        Wait.time(|| self.UI.setAttribute("TLSet", "height", newHeightPanel), 0.2)
        Wait.time(|| self.UI.setAttribute("TLUse", "height", newHeightPanel), 0.2)
    end
end

function SetInputTypeAmmunition(_, input, id)
    local numId = StringInNumber(id)
    if(id:find("name")) then
        self.UI.setAttribute(id, "text", input)
        fildForAmmunitions[numId].name = input
        self.UI.setValue("nameT"..numId, input)
    elseif(id:find("color")) then
        self.UI.setAttribute(id, "text", input)
        fildForAmmunitions[numId].color = input
        self.UI.setAttribute("nameT"..numId, "color", "#"..input)
    end
    Wait.time(|| UpdateSave(), 0.2)
end

function SetValueAmmunition(_, input, id)
    if(not input or input == "") then return end

    local numId = StringInNumber(id)
    if(id:find("value")) then
        local currentValue = 0
        for i,v in ipairs(fildForAmmunitions) do
            if(numId ~= i) then
                currentValue = currentValue + v.value
            end
        end
        if(tonumber(input) + currentValue > maxValue) then
            broadcastToAll(tGMNotes[2])
            self.UI.setAttribute("value"..numId, "text", 0)
            return
        end

        fildForAmmunitions[numId].value = tonumber(input)
    elseif(id:find("buttonP")) then
        local currentValue = 0
        for _,v in ipairs(fildForAmmunitions) do
            currentValue = currentValue + v.value
        end
            if(tonumber(input) + currentValue > maxValue) then
            broadcastToAll(tGMNotes[2])
            return
        end

        fildForAmmunitions[numId].value = fildForAmmunitions[numId].value + tonumber(input)
        self.UI.setAttribute("value"..numId, "text", fildForAmmunitions[numId].value)
    elseif(id:find("buttonM")) then
        if(fildForAmmunitions[numId].value + tonumber(input) < 0) then
            broadcastToAll(tGMNotes[3])
            return
        end

        local colorRGB, index = {r = 0, b = 0, g = 0}, 1
        local locTableHex = {r = "", g = "", b = ""}
        fildForAmmunitions[numId].color = fildForAmmunitions[numId].color:lower()
        locTableHex.r = fildForAmmunitions[numId].color:sub(1, 2)
        locTableHex.g = fildForAmmunitions[numId].color:sub(3, 4)
        locTableHex.b = fildForAmmunitions[numId].color:sub(5, 6)
        for i,c in pairs(locTableHex) do
            local locC = hexArray[c:sub(1, 1)] or c:sub(1, 1)
            colorRGB[i] = colorRGB[i] + 16*tonumber((locC ~= "" and locC) or 0)
            locC = hexArray[c:sub(2, 2)] or c:sub(2, 2)
            colorRGB[i] = colorRGB[i] + tonumber((locC ~= "" and locC) or 0)
            colorRGB[i] = colorRGB[i]/255
        end

        broadcastToAll(tGMNotes[1].." " .. fildForAmmunitions[numId].name, colorRGB)
        fildForAmmunitions[numId].value = fildForAmmunitions[numId].value + tonumber(input)
        self.UI.setAttribute("value"..numId, "text", fildForAmmunitions[numId].value)
    end
    UpdateSave()
end

function Reset()
    maxValue, selectTypeId = 1, -1
    fildForAmmunitions = {}
    self.UI.setXml(originalXml)
    UpdateSave()
end

function SelectTypeAmmunition(_, _, id)
    id = tostring(StringInNumber(id))
    local locId = (selectTypeId > 0 and selectTypeId) or ""
    self.UI.setAttribute("buttonM"..locId, "active", "true")
    self.UI.setAttribute("buttonM"..locId, "id", "buttonM"..id)
    selectTypeId = tonumber(id)
    UpdateSave()
end

function StringInNumber(str)
    return tonumber(str:gsub("%D", ""), 10)
end