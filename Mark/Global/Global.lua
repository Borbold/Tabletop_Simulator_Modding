function onLoad()
    originalXml = self.UI.getXml()
end

function UpdateInformation(putObjects)
    local color = #putObjects > 0 and putObjects[1].color or "White"
    local allXml = originalXml

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
    local searchStringLength = #searchString

    local indexFirst = allXml:find(searchString)

    local startXml = allXml:sub(1, indexFirst + searchStringLength)
    local endXml = allXml:sub(indexFirst + searchStringLength)
    allXml = startXml .. newType .. endXml

    self.UI.setXml(allXml)
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