function UpdateInformation(putObjects)
    for i = 1, 8 do
        self.UI.setAttribute("I"..i, "image", "")
        self.UI.setAttribute("I"..i, "color", "#ffffff00")
    end
    if putObjects[1].name == nil then return end
    for i = 1, #putObjects do
        self.UI.setAttribute("I"..i, "image", putObjects[i].image)
        self.UI.setAttribute("I"..i, "color", "#ffffffff")
    end
end