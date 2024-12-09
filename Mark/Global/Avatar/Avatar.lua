function onLoad()
    self.addContextMenuItem("On or Off scroll bar", OnOffScrollbar)
end

function OnOffScrollbar()
    local f = self.UI.getAttribute("contextMenu", "noScrollbars")
    if(f == "false") then
        self.UI.setAttribute("contextMenu", "noScrollbars", "true")
    else
        self.UI.setAttribute("contextMenu", "noScrollbars", "false")
    end
    Wait.time(|| DeleteBuffButtons(), 0.15)
end

function DeleteBuffButtons()
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    xmlTable[2].children[1].children[1].children = {}
    self.UI.setXmlTable(xmlTable)
end

function CreateBuffButtons(putObjects)
    local xmlTable = {}
    xmlTable = self.UI.getXmlTable()
    local buffButtons = xmlTable[2].children[1].children[1].children

    for i = 1, #putObjects do
        local buffButton = {
            tag = "Button",
            attributes = {
                id = putObjects[i].guid,
                image = putObjects[i].image,
                onClick = "RemoveBuff",
                raycastTarget = "true",
                textColor = "#ffffff00",
                text = putObjects[i].name
            }
        }
        table.insert(buffButtons, buffButton)
    end
    self.UI.setXmlTable(xmlTable)
end

function UpdateInformation(putObjects)
    Wait.time(|| DeleteBuffButtons(), 0.15)
    if #putObjects == 0 then return end
    Wait.time(|| CreateBuffButtons(putObjects), 0.2)
end

function RemoveBuff(_, alt, guid)
    if(alt == "-1") then
        getObjectFromGUID(self.getVar("InfoObjectGUID")).call("RemoveBuff", guid)
    else
        printToAll(self.UI.getAttribute(guid, "text"))
    end
end