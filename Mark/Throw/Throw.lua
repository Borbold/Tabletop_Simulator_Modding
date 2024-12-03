function onLoad()
    osTime = os.time()
    saveThrow = {}
    countThrow = 1
    tableDices = {4, 6, 20, 100}
    diceThrow = #tableDices
    bonusThrow = {}
end

function ChangeCountThrow(_, alt, id)
    countThrow = countThrow + (alt == "-1" and 1 or -1)
    self.UI.setAttribute(id, "text", countThrow)
end

function ChangeDiceThrow(_, alt, id)
    diceThrow = diceThrow + (alt == "-1" and 1 or -1)
    if(diceThrow < 1) then diceThrow = #tableDices elseif(diceThrow > #tableDices) then diceThrow = 1 end
    self.UI.setAttribute(id, "text", tableDices[diceThrow])
end

function SaveThrow(_, alt, id)
    if(saveThrow["Test"] == nil) then
        self.UI.setAttribute(id, "text", "Test")
        saveThrow["Test"] = {CT = countThrow, DT = diceThrow, BT = bonusThrow}
    else
        if(alt == "-1") then
            countThrow = saveThrow["Test"].CT
            diceThrow = saveThrow["Test"].DT
            bonusThrow = saveThrow["Test"].BT
            Throw()
        elseif(alt == '-2') then
            self.UI.setAttribute(id, "text", "---")
            saveThrow["Test"] = nil
        end
    end
end

function Throw()
    Wait.stopAll()
    for i = 1, countThrow do
        if(math.floor(osTime) ~= math.floor(os.time())) then
            PrintThrow(i)
        else
            Wait.time(|| PrintThrow(i), 1 + (i - (countThrow > 1 and 2 or 1)))
        end
    end
    osTime = os.time()
end

function PrintThrow(numberThrow)
    math.randomseed(os.time())
    local naturalThrow = math.random(1, tableDices[diceThrow])
    broadcastToAll(countThrow == 1 and ("Throw: "..naturalThrow) or ("Throw "..numberThrow..": "..naturalThrow))
    if(#bonusThrow > 0) then
        local sumBonus = 0
        for i,b in ipairs(bonusThrow) do
            broadcastToAll("Bonus "..i..": "..b)
            sumBonus = sumBonus + b
        end
        broadcastToAll("Sum bonus: "..sumBonus)
        broadcastToAll("Equals throw: "..(naturalThrow + sumBonus))
    end
end