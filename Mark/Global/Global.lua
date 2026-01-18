local maxInsOD = {
    ["White"] = 3, ["Red"] = 3, ["Green"] = 3, ["Blue"] = 3, ["Brown"] = 3, ["Teal"] = 3,
    ["Yellow"] = 3, ["Orange"] = 3, ["Purple"] = 3, ["Pink"] = 3
}
local instanseOD = {
    ["White"] = 3, ["Red"] = 3, ["Green"] = 3, ["Blue"] = 3, ["Brown"] = 3, ["Teal"] = 3,
    ["Yellow"] = 3, ["Orange"] = 3, ["Purple"] = 3, ["Pink"] = 3
}
function ChangeOD(player, alt)
    local pC = player.color
    instanseOD[pC] = alt == "-1" and instanseOD[pC] - 1 or alt == "-2" and instanseOD[pC] + 1 or maxInsOD[pC]
    self.UI.setAttribute("OD_" .. pC, "text", instanseOD[pC])
end

function onLoad()
    plColors_Table = {"Black","White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
    panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
    originalXml = self.UI.getXml()
    for i,v in pairs(instanseOD) do
        self.UI.setAttribute("OD_" .. i, "text", v)
    end
end

function UpdateInformation(putObjects)
    local color = putObjects[1].color
    local allXml = self.UI.getXml()

    local newType = ""
    if putObjects[1].name then
        for i,arg in ipairs(putObjects) do
            newType = newType .. [[
            <Row id=']]..arg.color..i..[['>
                <Cell columnSpan='5'>
                    <Text id='name]]..i..[[' text=']]..arg.name..[['/>
                </Cell>
                <Cell columnSpan='10'>
                    <Text id='description]]..i..[[' text=']]..arg.description..[['/>
                </Cell>
            </Row>
            ]]
        end
    end

    local searchString = "<NewRowS"..color.." />"
    local endString = "<EndRowS"..color.." />"

    local indexFirst = allXml:find(searchString) + #searchString
    local indexOrigin = originalXml:find(searchString) + #searchString

    local startXml = allXml:sub(1, indexFirst)
    local middleXml = originalXml:sub(indexOrigin, indexOrigin + originalXml:sub(indexOrigin):find(endString) + #endString)
    local endXml = allXml:sub(indexFirst + allXml:sub(indexFirst):find(endString) + #endString)
    allXml = startXml..newType..middleXml..endXml

    self.UI.setXml(allXml)
    EnlargeHeightPanel(color, #putObjects)
end

function PanelLoad(player)
    local panel = "panel"..player.color
    if(self.UI.getAttribute(panel, "active") == "false") then
        self.UI.setAttribute(panel, "active", "true")
        self.UI.setAttribute(panel, "visibility", player.color)
    else
        self.UI.setAttribute(panel, "active", "false")
    end
end

function EnlargeHeightPanel(color, countRow)
    if(countRow > 6) then
        --preferredHeight=80
        local newHeightPanel = countRow*80 + 16
        Wait.time(|| self.UI.setAttribute("TL"..color, "height", newHeightPanel), 0.2)
    end
end

function WhatWeather()
    local weather = "[a6a6a6]Прогноз на сегодня:[-] "
    local s = {"солнечно", "облачно", "пасмурно", "туманно", "дождь/снег", "слабый дождь/снег", "сильный дождь/снег"}
    weather = weather.." [ffff00]"..s[math.random(#s)]
    local w = {"ветренно", "очень ветренно", "нет ветра", "ураган", "смерчь"}
    weather = weather.." [ffffff]"..w[math.random(#w)]
    weather = weather.." [00ffff]".."температура воздуха[-] ощущается как "..math.random(-30, 30)
    broadcastToAll(weather)
end

local function UI_xmlElementUpdate(xml_ID, xml_attribute, input_string)
    if self.UI.getAttribute(xml_ID, xml_attribute) ~= input_string then
        self.UI.setAttribute(xml_ID, xml_attribute, input_string)
    end
end
local function nFromPlClr(clr)
    for i = 1, 11 do
        if clr == plColors_Table[i] then
            return i
        end
    end
end
function colorToggleProjector(pl,vl,thisID)
    if nFromPlClr(pl.color) == 1 and vl == "-2" then
        panelVisibility_projector[nFromPlClr(pl.color)] = not panelVisibility_projector[nFromPlClr(pl.color)]
        if panelVisibility_projector[1] then
            panelVisibility_projector = {true,true,true,true,true,true,true,true,true,true,true}
            UI_xmlElementUpdate("projectorImage","visibility","Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink")
        else
            panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
            UI_xmlElementUpdate("projectorImage","visibility","noone")
        end
    else
        panelVisibility_projector[nFromPlClr(pl.color)] = not panelVisibility_projector[nFromPlClr(pl.color)]
        editModeVisibilityStr = "noone"
        isNoOne = true
        for i = 1, 11 do
            if panelVisibility_projector[i] then
                isNoOne = false
                editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
            end
        end
        if not isNoOne then
            editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
        end
        UI_xmlElementUpdate("projectorImage","visibility",editModeVisibilityStr)
    end
end
function onObjectRandomize(object, player_color)
    if panelVisibility_projector[1] then
        if player_color == "Black" and object.getCustomObject().image ~= nil then
            object.setVelocity({0,0,0})
            UI_xmlElementUpdate("projectorImage", "image", object.getCustomObject().image)
            UI_xmlElementUpdate("projectorImage", "tooltip", object.getName())
        end
    end
end