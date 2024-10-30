function onLoad()
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

    <Button image='ButtonImage'
        onClick='PanelLoad' offsetXY='855 -505' height='55' width='55' />

    <VerticalScrollView id='panelGreen' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLGreen' >
            <NewRowSGreen />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelRed' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLRed' >
            <NewRowSRed />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelBrown' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLBrown' >
            <NewRowSBrown />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelOrange' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLOrange' >
            <NewRowSOrange />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelYellow' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLYellow' >
            <NewRowSYellow />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelTeal' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLTeal' >
            <NewRowSTeal />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelPurple' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLPurple' >
            <NewRowSPurple />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelWhite' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLWhite' >
            <NewRowSWhite />
        </TableLayout>
    </VerticalScrollView>

    <VerticalScrollView id='panelPink' active='false' image='https://steamusercontent-a.akamaihd.net/ugc/2501279124985480702/BCD413BC3C75A5B14EC6CD6563D27A192E3B3E5A/'>
        <TableLayout id='TLPink' >
            <NewRowSPink />
        </TableLayout>
    </VerticalScrollView>
    ]]
    self.UI.setXml(originalXml)
end

function UpdateInformation(putObjects)
    local color = #putObjects > 0 and putObjects[1].color or "White"
    local allXml = self.UI.getXml()

    local newType = ""
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

    local searchString = "<NewRowS"..color.." />"
    local endString = "</TableLayout>"

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