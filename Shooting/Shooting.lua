function ChangeInputField(_, input, id)
    self.UI.setAttribute(id, "text", input)
end

function Shoot(player)
    printToAll("{en}Shoot "..player.steam_name.."{ru}Стреляет "..player.steam_name)
    local max, min, count = tonumber(#self.UI.getAttribute("max", "text") > 0 and self.UI.getAttribute("max", "text") or 100), tonumber(#self.UI.getAttribute("min", "text") > 0 and self.UI.getAttribute("min", "text") or 1), tonumber(#self.UI.getAttribute("count", "text") > 0 and self.UI.getAttribute("count", "text") or 1)
    for i = 1, count do
        printToAll("{ru}Результат: "..math.random(min, max).."{en}Result: "..math.random(min, max))
    end
end