function UpdateSave()

end

function onLoad()
    originalXml = self.UI.getXml()
end

function AddNewInformation(arg)
    local allXml = originalXml

    local newType = ""
    newType = newType .. [[
    <Row id=']]..arg.color..[[1' preferredHeight='100'>
        <Cell columnSpan='5'>
            <Text id='name]].."1"..[[' text=']]..arg.name..[['/>
        </Cell>
        <Cell columnSpan='10'>
            <Text id='description]].."1"..[[' text=']]..arg.description..[['/>
        </Cell>
    </Row>
    ]]

    local searchString = "<NewRowS />"
    local searchStringLength = #searchString

    local indexFirst = allXml:find(searchString)

    local startXml = allXml:sub(1, indexFirst + searchStringLength)
    local endXml = allXml:sub(indexFirst + searchStringLength)
    allXml = startXml .. newType .. endXml

    self.UI.setXml(allXml)
    Wait.time(|| UpdateSave(), 0.2)
end

function RemoveNewInformation(arg)
    self.UI.setAttribute("White1", "active", "false")
    Wait.time(|| UpdateSave(), 0.2)
end

function PanelOne(player)
    local panel = "panel"..player.color
    if(self.UI.getAttribute(panel, "active") == "false") then
        self.UI.setAttribute(panel, "active", "true")
        self.UI.setAttribute(panel, "visibility", player.color)
    else
        self.UI.setAttribute(panel, "active", "false")
    end
end