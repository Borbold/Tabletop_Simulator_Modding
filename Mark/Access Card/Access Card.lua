function onLoad()
    self.UI.setAttribute("inputText", "text", self.getDescription())
end

function AccessPassword(_, input)
    self.UI.setAttribute("inputText", "text", input)
    if  self.getGMNotes():len() == 0 then return end

    if input == self.getGMNotes() then
        broadcastToAll("Пароль верен")
        return
    end
    broadcastToAll("Упс... Кажется вы ошиблись")
end

function ChangePassword()
    self.setGMNotes(self.UI.getAttribute("inputText", "text"))
    self.UI.setAttribute("inputText", "text", "")
end