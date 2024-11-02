function UpdateInformation(putObjects)
    for i,o in ipairs(putObjects) do
        print("Hello ", putObjects.image)
        self.UI.setAttribute("I"..i, "image", putObjects.image)
        --self.UI.setAttribute("I"..i, "color", "#ffffffff")
    end
end