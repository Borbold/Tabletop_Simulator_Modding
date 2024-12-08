function DeleteBuffButtons()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    xmlTable[2].children[1].children = {}
    self.UI.setXmlTable(xmlTable)
end

function CreateBuffButtons(putObjects)
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    local buffButtons = xmlTable[2].children[1].children

    for i = 1, #putObjects do
        local buffButton = {
            tag = "Image",
            attributes = {
                id = "I"..i,
                image = putObjects[i].image
            }
        }
        table.insert(buffButtons, buffButton)
    end
    self.UI.setXmlTable(xmlTable)
end

function UpdateInformation(putObjects)
    Wait.time(|| DeleteBuffButtons(putObjects), 0.15)
    if putObjects[1].name == nil then return end
    Wait.time(|| CreateBuffButtons(putObjects), 0.2)
end