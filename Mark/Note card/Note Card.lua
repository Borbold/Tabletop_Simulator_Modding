function onLoad()
    self.UI.setAttribute("inputText", "text", self.getDescription())
    pen = "https://steamusercontent-a.akamaihd.net/ugc/2459620193695094291/2311C4100E304D920086612B2683D0CC0D2BC7D2/"
    penCross = "https://steamusercontent-a.akamaihd.net/ugc/2459620193695104429/00284B55F15B76E73B117C48F6D2C6920C8D5FFE/"
end

function ChangeText(_, input)
    self.setDescription(input)
end

function ChangeInteract()
    local flag = self.UI.getAttribute("inputText", "interactable")
    if flag == "true" then flag = "false" else flag = "true" end
    self.UI.setAttribute("pen", "image", (flag == "true") and pen or penCross)
    self.UI.setAttribute("inputText", "interactable", flag)
end