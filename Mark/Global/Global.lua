function onLoad()
    --White Red Green Blue Brown Teal Yellow Orange Purple Pink
    originalXml = [[
    <Defaults>
        <TableLayout cellSpacing='2' />
        <Cell dontUseTableCellBackground='true' />
        <VerticalScrollView offsetXY='550 -220' height='520' width='800' color='#ffffffdd' scrollbarBackgroundColor='#000000dd'
            scrollbarImage='ScrollBarImage'
            verticalScrollbarVisibility='AutoHideAndExpandViewport' horizontalScrollbarVisibility='Permanent' />
        <Row preferredHeight='80' />
        <Text resizeTextForBestFit='true' resizeTextMaxSize='50'
            color='#e8d8b4' text='0' font='Fonts/Hanzi' />
    </Defaults>

    <Button image='ButtonStatus' visibility='White|Red|Green|Blue|Brown|Teal|Yellow|Orange|Purple|Pink'
        onClick='PanelLoad' offsetXY='855 -505' height='55' width='55' />
    <Button image='ButtonWeather' visibility='Black'
        onClick='WhatWeather' offsetXY='855 -505' height='55' width='55' />

    <VerticalScrollView id='panelWhite' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLWhite' >
            <NewRowSWhite />
        </TableLayout>
        <EndRowSWhite />
    </VerticalScrollView>

    <VerticalScrollView id='panelRed' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLRed' >
            <NewRowSRed />
        </TableLayout>
        <EndRowSRed />
    </VerticalScrollView>

    <VerticalScrollView id='panelBlue' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLBlue' >
            <NewRowSBlue />
        </TableLayout>
        <EndRowSBlue />
    </VerticalScrollView>

    <VerticalScrollView id='panelBrown' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLBrown' >
            <NewRowSBrown />
        </TableLayout>
        <EndRowSBrown />
    </VerticalScrollView>

    <VerticalScrollView id='panelOrange' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLOrange' >
            <NewRowSOrange />
        </TableLayout>
        <EndRowSOrange />
    </VerticalScrollView>

    <VerticalScrollView id='panelYellow' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLYellow' >
            <NewRowSYellow />
        </TableLayout>
        <EndRowSYellow />
    </VerticalScrollView>

    <VerticalScrollView id='panelTeal' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLTeal' >
            <NewRowSTeal />
        </TableLayout>
        <EndRowSTeal />
    </VerticalScrollView>

    <VerticalScrollView id='panelPurple' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLPurple' >
            <NewRowSPurple />
        </TableLayout>
        <EndRowSPurple />
    </VerticalScrollView>

    <VerticalScrollView id='panelGreen' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLGreen' >
            <NewRowSGreen />
        </TableLayout>
        <EndRowSGreen />
    </VerticalScrollView>

    <VerticalScrollView id='panelPink' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLPink' >
            <NewRowSPink />
        </TableLayout>
        <EndRowSPink />
    </VerticalScrollView>
    ]]
    self.UI.setXml(originalXml)
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
    local s = {"солнечно", "пасмурно", "допишите ещё"}
    weather = weather.." [ffff00]"..s[math.random(#s)]
    local w = {"ветренно", "очень ветренно", "нет ветра"}
    weather = weather.." [ffffff]"..w[math.random(#w)]
    local t = {"жарко", "холодно", "относительно тепло"}
    weather = weather.." [00ffff]"..t[math.random(#t)]
    broadcastToAll(weather)
end