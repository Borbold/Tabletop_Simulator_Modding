function onLoad()
    originalXml = self.UI.getXml()
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