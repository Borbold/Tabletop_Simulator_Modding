function onLoad(savedData)
    local loadedData = JSON.decode(savedData or "")
    self.UI.setAttribute("inputText", "text", self.getDescription())
    if(loadedData) then
        Wait.time(function()
            pen = self.UI.getCustomAssets()[2].url
            penCross = self.UI.getCustomAssets()[3].url
            self.UI.setAttribute("pen", "image", (loadedData.flag == "true") and pen or penCross)
            self.UI.setAttribute("inputText", "interactable", loadedData.flag)
        end, 0.75)
    end
end

function ChangeText(_, input)
    self.setDescription(input)
end

function ChangeInteract()
    local flag = self.UI.getAttribute("inputText", "interactable")
    if flag == "true" then flag = "false" else flag = "true" end
    self.UI.setAttribute("pen", "image", (flag == "true") and pen or penCross)
    self.UI.setAttribute("inputText", "interactable", flag)
    self.script_state = JSON.encode({["flag"] = flag})
end