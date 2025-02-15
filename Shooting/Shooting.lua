function ChangeInputField(_, input, id)
    self.UI.setAttribute(id, "text", input)
end

function Shoot(player)
    if(not self.UI.getAttribute("max", "text") or not self.UI.getAttribute("min", "text") or not self.UI.getAttribute("count", "text")) then return end
    printToAll("{en}Shoot "..player.steam_name.."{ru}Стреляет "..player.steam_name)
    local max, min, count = tonumber(#self.UI.getAttribute("max", "text") > 0 and self.UI.getAttribute("max", "text") or 100), tonumber(#self.UI.getAttribute("min", "text") > 0 and self.UI.getAttribute("min", "text") or 1), tonumber(#self.UI.getAttribute("count", "text") > 0 and self.UI.getAttribute("count", "text") or 1)
    local totalShoot = 0
    for i = 1, count do
        local shoot = math.random(min, max)
        printToAll(string.format("{ru}Результат %d: %d".."{en}Result %d: %d", i, shoot, i, shoot))
        totalShoot = totalShoot + shoot
    end
    printToAll("-------------------")
    printToAll("{ru}Общий результат: "..totalShoot.."{en}Total result: "..totalShoot)
end
