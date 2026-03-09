local function calculateHeightString(string)
    local lenghtString = #string
    if(lenghtString <= 190) then lenghtString = 190 end
    return 26*(lenghtString/34)
end

function onLoad(savedData)
    local loadedData = JSON.decode(savedData or "")
    self.UI.setAttribute("inputText", "text", self.getGMNotes())
    if(loadedData) then
        Wait.time(function()
            pen = self.UI.getCustomAssets()[2].url
            penCross = self.UI.getCustomAssets()[3].url
            self.UI.setAttribute("pen", "image", (loadedData.flag == "true") and pen or penCross)
            self.UI.setAttribute("inputText", "interactable", loadedData.flag)
            self.UI.setAttribute("inputText", "raycastTarget", loadedData.flag)
            self.UI.setAttribute("textZone", "height", calculateHeightString(self.getGMNotes()))
        end, 0.75)
    end
end

function ChangeText(_, input)
    self.UI.setAttribute("textZone", "height", calculateHeightString(input))
    self.setGMNotes(input)
end

function ChangeInteract()
    local flag = self.UI.getAttribute("inputText", "interactable")
    if flag == "true" then flag = "false" else flag = "true" end
    self.UI.setAttribute("pen", "image", (flag == "true") and pen or penCross)
    self.UI.setAttribute("inputText", "interactable", flag)
    self.UI.setAttribute("inputText", "raycastTarget", flag)
    self.script_state = JSON.encode({["flag"] = flag})
end