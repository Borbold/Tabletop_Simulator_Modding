local pointsPos = {
    сила = {
        {x = 1.47, z = -1.98}, {x = 1.38, z = -1.98}, {x = 1.28, z = -1.98}, {x = 1.19, z = -1.98}, {x = 1.1, z = -1.98},
        {x = 1.01, z = -1.98}, {x = 0.92, z = -1.98}, {x = 0.83, z = -1.98}, {x = 0.73, z = -1.98}, {x = 0.62, z = -1.98},
        {x = 1.46, z = -1.91}, {x = 1.39, z = -1.91}, {x = 1.29, z = -1.91}, {x = 1.2, z = -1.9}, {x = 1.1, z = -1.9},
        {x = 1, z = -1.9}, {x = 0.92, z = -1.9}, {x = 0.82, z = -1.91}, {x = 0.72, z = -1.91}, {x = 0.62, z = -1.91},
    },
    восприятие = {
        {x = 1.47, z = -1.81}, {x = 1.39, z = -1.81}, {x = 1.29, z = -1.81}, {x = 1.19, z = -1.81}, {x = 1.1, z = -1.81},
        {x = 1.01, z = -1.81}, {x = 0.92, z = -1.81}, {x = 0.83, z = -1.82}, {x = 0.73, z = -1.81}, {x = 0.62, z = -1.81},
        {x = 1.46, z = -1.74}, {x = 1.38, z = -1.74}, {x = 1.28, z = -1.74}, {x = 1.19, z = -1.74}, {x = 1.1, z = -1.74},
        {x = 1.01, z = -1.74}, {x = 0.91, z = -1.74}, {x = 0.83, z = -1.74}, {x = 0.72, z = -1.74}, {x = 0.62, z = -1.74},
    },
    выносливость = {
        {x = 1.47, z = -1.65}, {x = 1.39, z = -1.64}, {x = 1.29, z = -1.65}, {x = 1.19, z = -1.65}, {x = 1.1, z = -1.65},
        {x = 1.01, z = -1.64}, {x = 0.92, z = -1.65}, {x = 0.83, z = -1.65}, {x = 0.72, z = -1.65}, {x = 0.62, z = -1.65},
        {x = 1.47, z = -1.57}, {x = 1.38, z = -1.57}, {x = 1.28, z = -1.57}, {x = 1.2, z = -1.57}, {x = 1.1, z = -1.58},
        {x = 1.01, z = -1.57}, {x = 0.92, z = -1.57}, {x = 0.83, z = -1.58}, {x = 0.73, z = -1.58}, {x = 0.62, z = -1.58},
    },
    харизма = {
        {x = 1.47, z = -1.48}, {x = 1.39, z = -1.48}, {x = 1.29, z = -1.48}, {x = 1.19, z = -1.48}, {x = 1.1, z = -1.48},
        {x = 1.01, z = -1.48}, {x = 0.92, z = -1.48}, {x = 0.83, z = -1.48}, {x = 0.73, z = -1.48}, {x = 0.62, z = -1.48},
        {x = 1.46, z = -1.41}, {x = 1.38, z = -1.4}, {x = 1.28, z = -1.41}, {x = 1.19, z = -1.41}, {x = 1.1, z = -1.41},
        {x = 1.01, z = -1.41}, {x = 0.92, z = -1.41}, {x = 0.83, z = -1.41}, {x = 0.72, z = -1.41}, {x = 0.62, z = -1.41},
    },
    интеллект = {
        {x = 1.47, z = -1.32}, {x = 1.39, z = -1.31}, {x = 1.29, z = -1.32}, {x = 1.19, z = -1.31}, {x = 1.1, z = -1.32},
        {x = 1.01, z = -1.31}, {x = 0.92, z = -1.31}, {x = 0.83, z = -1.32}, {x = 0.73, z = -1.31}, {x = 0.62, z = -1.31},
        {x = 1.47, z = -1.24}, {x = 1.38, z = -1.24}, {x = 1.28, z = -1.24}, {x = 1.2, z = -1.24}, {x = 1.1, z = -1.24},
        {x = 1.01, z = -1.24}, {x = 0.92, z = -1.24}, {x = 0.82, z = -1.24}, {x = 0.73, z = -1.25}, {x = 0.62, z = -1.24},
    },
    ловкость = {
        {x = 1.47, z = -1.14}, {x = 1.39, z = -1.15}, {x = 1.29, z = -1.15}, {x = 1.2, z = -1.15}, {x = 1.1, z = -1.15},
        {x = 1.01, z = -1.15}, {x = 0.92, z = -1.15}, {x = 0.83, z = -1.15}, {x = 0.73, z = -1.15}, {x = 0.62, z = -1.15},
        {x = 1.46, z = -1.08}, {x = 1.38, z = -1.07}, {x = 1.28, z = -1.08}, {x = 1.19, z = -1.07}, {x = 1.1, z = -1.08},
        {x = 1.01, z = -1.07}, {x = 0.92, z = -1.08}, {x = 0.82, z = -1.08}, {x = 0.73, z = -1.08}, {x = 0.62, z = -1.08},
    },
}
local pointSkills = {
    Weightlifting = "сила", Riding = "ловкость", Theft = "ловкость",
    Athletics = "ловкость", Disguise = "восприятие", Shooting = "восприятие",
    Evasion = "ловкость", Fencing = "ловкость", Blocking = "сила",
    MartialArts = "ловкость", Survival = "восприятие", LocalKnowledge = "интеллект",
    ForeignLanguage = "интеллект", Medicine = "интеллект", Science = "интеллект",
    Cooking = "восприятие", Herbalism = "восприятие", Observation = "восприятие",
    Orientation = "восприятие", FirstAid = "восприятие", Mechanics = "интеллект",
    Armor = "сила", Gunsmith = "сила", Interrogation = "сила",
    Livestock = "восприятие", Leadership = "харизма", Acting = "харизма",
    Speechcraft = "харизма", Art = "восприятие", Trade = "харизма", Gambling = "ловкость"
}
local pointOvershoot = {
    {x = 1.51, z = 1.28}, {x = 1.20, z = 1.28}, {x = 0.92, z = 1.28},
    {x = 0.60, z = 1.28}, {x = 0.30, z = 1.28}, {x = 0, z = 1.28},
    {x = -0.30, z = 1.28}, {x = -0.60, z = 1.28}, {x = -0.90, z = 1.28},
    {x = -1.20, z = 1.28}, {x = -1.50, z = 1.28}
}
local pointBackpack = {
    {x = -0.61, z = -1.98}, {x = -0.8, z = -1.98}, {x = -0.99, z = -1.97},
    {x = -1.18, z = -1.97}, {x = -1.37, z = -1.98}, {x = -1.56, z = -1.98},
    {x = -0.61, z = -1.79}, {x = -0.8, z = -1.79}, {x = -0.99, z = -1.79},
    {x = -1.18, z = -1.79}, {x = -1.37, z = -1.79}, {x = -1.56, z = -1.79},
    {x = -0.61, z = -1.51}, {x = -0.8, z = -1.51}, {x = -0.99, z = -1.51},
    {x = -1.18, z = -1.51}, {x = -1.37, z = -1.51}, {x = -1.56, z = -1.51},
    {x = -0.61, z = -1.32}, {x = -0.8, z = -1.32}, {x = -0.99, z = -1.32},
    {x = -1.18, z = -1.32}, {x = -1.37, z = -1.32}, {x = -1.57, z = -1.32},
    {x = -0.61, z = -1.13}, {x = -0.8, z = -1.13}, {x = -0.99, z = -1.13},
    {x = -1.18, z = -1.13}, {x = -1.37, z = -1.13}, {x = -1.56, z = -1.13},
    {x = -1.47, z = -1.51}, {x = -1.47, z = -1.32}, {x = -1.47, z = -1.13}
}
local pointBelt = {
    {x = 0.25, z = -0.13}, {x = -0.24, z = -0.13}, {x = 0.27, z = 0.23},
    {x = -0.24, z = 0.23}, {x = 0.25, z = 0.59}, {x = -0.24, z = 0.58}
}
local pointWearables = {
    {x = 0.38, z = -1.95}, {x = 0.13, z = -1.96}, {x = -0.13, z = -1.95},
    {x = -0.38, z = -1.95}, {x = 0.39, z = -1.69}, {x = -0.38, z = -1.7},
    {x = 0.38, z = -1.44}, {x = -0.38, z = -1.44}, {x = 0.38, z = -1.19},
    {x = -0.38, z = -1.19}, {x = 0.38, z = -0.93}, {x = 0.13, z = -0.93},
    {x = -0.13, z = -0.93}, {x = -0.38, z = -0.93}, {x = 0.38, z = -0.68},
    {x = 0.13, z = -0.67}, {x = -0.13, z = -0.68}, {x = -0.38, z = -0.68},
    {x = 0.38, z = -0.42}, {x = 0.13, z = -0.42}, {x = -0.12, z = -0.42},
    {x = -0.38, z = -0.42}
}

function UpdateSave()
    local dataToSave = {
        ["limbValues"] = limbValues, ["limbMaxValue"] = limbMaxValue, ["bonusValue"] = bonusValue,
        ["state"] = state, ["textColor"] = textColor
      }
      local savedData = JSON.encode(dataToSave)
      self.script_state = savedData
end

local flagCollision = false
function onLoad(savedData)
    Wait.time(|| Confer(savedData), 0.3)
end
function Confer(savedData)
    flagCollision = true
    snaps = self.getSnapPoints()
    throw = getObjectFromGUID(self.getGMNotes())

    local loadedData = JSON.decode(savedData or "")
    if loadedData then
        limbValues = loadedData.limbValues or {Head = 50, Body = 50, lHand = 50, rHand = 50, lLeg = 50, rLeg = 50}
        limbMaxValue = loadedData.limbMaxValue or {75, 150, 50, 50, 50, 50}
        bonusValue = loadedData.bonusValue or {0,0,0,0,0,0}
        state = loadedData.state or {Hunger = 0, Thirst = 0, Fatigue = 0, Intoxication = 0}
        textColor = loadedData.textColor or "ffffff"
        ChangeColorNumber(nil, textColor)
    end
    
    for i,b in ipairs(bonusValue) do
        self.UI.setAttribute("TBonus"..i, "text", b)
    end
    for i,l in pairs(limbValues) do
        self.UI.setAttribute(i, "text", l)
    end
    for i,l in pairs(limbMaxValue) do
        self.UI.setAttribute("lm"..i, "text", "/"..l)
    end
    for i,l in pairs(state) do
        self.UI.setAttribute(i, "text", l)
        self.UI.setAttribute(i, "textColor", self.UI.getAttribute(i, "textColor"))
    end
end

function onCollisionEnter(info)
    if flagCollision == false then Wait.time(|| ChangeCountOvershoot(info.collision_object, self.positionToLocal(info.collision_object.getPosition())), 0.8) return end

    local obj = info.collision_object
    local locPos = self.positionToLocal(obj.getPosition())
    if locPos.y > 0 then
        if(ChangeScaleObject(obj, locPos, {0.24, 0.1, 0.24}, pointBackpack)) then return end
        if(ChangeScaleObject(obj, locPos, {0.4, 0.1, 0.4}, pointBelt)) then return end
        if(ChangeScaleObject(obj, locPos, {0.28, 0.1, 0.28}, pointWearables)) then return end

        local lTag = obj.getTags()[1]
        if lTag ~= nil then --Skills
            ChangeCountOvershoot(obj, locPos)
            local bonusSkill = CalculateBonus(5 + obj.getStateId())
            local arg = {tTag = lTag, bonus = bonusSkill, tChar = pointSkills[lTag]}
            throw.call("ChangeMemory", arg)
        else --Characteristics
            for _,point in ipairs(snaps) do
                if CheckPos(locPos, point.position) then
                    for tChar,values in pairs(pointsPos) do
                        for index,value in ipairs(values) do
                            if value.x == Round(point.position.x, 2) and value.z == Round(point.position.z, 2) then
                                local arg = {tChar = tChar, bonus = CalculateBonus(index)}
                                throw.call("ChangeMemory", arg)
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

function ChangeScaleObject(obj, locPos, scale, snapPos)
    for _,point in ipairs(snaps) do
        if CheckPos(locPos, point.position) then
            for i,p in ipairs(snapPos) do
                if CheckPos(p, point.position) then
                    obj.setScale(scale)
                    return true
                end
            end
        end
    end
end

function ChangeCountOvershoot(obj, locPos)
    for _,point in ipairs(snaps) do
        if CheckPos(locPos, point.position) then
            for i,p in ipairs(pointOvershoot) do
                if CheckPos(p, point.position) then
                    self.UI.setAttribute("OS"..i, "text", obj.getStateId())
                    self.UI.setAttribute("OS"..i, "value", obj.getTags()[1])
                    self.UI.setAttribute("OS"..i, "textColor", self.UI.getAttribute("OS"..i, "textColor"))
                end
            end
        end
    end
end

function ChangeState(player, alt, id)
    local current = self.UI.getAttribute(id, "text")
    state[id] = alt == "-2" and current - 1 or current + 1
    self.UI.setAttribute(id, "text", state[id])
    self.UI.setAttribute(id, "textColor", self.UI.getAttribute(id, "textColor"))
    ChangeBonusForState(player, id, state[id])
    UpdateSave()
end
function ChangeBonusForState(player, id, state)
    if state >= 4 then
        local text = id == "Hunger" and "голодает" or id == "Thirst" and "хочет пить" or id == "Fatigue" and "хочет спать" or "перепил"
        broadcastToAll("Кажется кто-то " .. text)
        local tChar = id == "Hunger" and "сила" or id == "Thirst" and "ловкость" or id == "Fatigue" and "интеллект"
        local arg = {tChar = tChar, bonus = state < 7 and -10 or -20, state = true}
        throw.call("ChangeMemory", arg)
    else
        local tChar = id == "Hunger" and "сила" or id == "Thirst" and "ловкость" or id == "Fatigue" and "интеллект"
        local arg = {tChar = tChar, bonus = 0, state = true}
        throw.call("ChangeMemory", arg)
    end
end

function ChangeBonus(_, input, id)
    local l = "Bonus"
    bonusValue[tonumber(id:sub(l:len() + 1))] = input
    UpdateSave()
end
function ChangeText(_, input, id)
    self.UI.setAttribute("T"..id, "text", input)
end

function Overshoot(player, alt, id)
    if self.UI.getAttribute(id, "text") == "0" then return end

    local current = self.UI.getAttribute(id, "text")
    self.UI.setAttribute(id, "text", alt == "-2" and current + 1 or current - 1)
    self.UI.setAttribute(id, "textColor", self.UI.getAttribute(id, "textColor"))
    if alt == "-2" or alt == "-3" then return end
    local arg = {tTag = self.UI.getAttribute(id, "value"), player = player}
    throw.call("Overshoot", arg)
end

function ChangeOD(player, input, id)
    self.UI.setAttribute(id, "text", input)
end

function ChangeLimb(player, input, id)
    if(id:find("lmV")) then
        id = tonumber(id:gsub("%D", ""), 10)
        self.UI.setAttribute("lm"..id, "text", "/"..input)
        limbMaxValue[id] = input
    else
        self.UI.setAttribute(id, "text", input)
        limbValues[id] = input
    end
    UpdateSave()
end

function CheckPos(pos1, pos2)
    if Round(pos1.x, 2) == Round(pos2.x, 2) and Round(pos1.z, 2) == Round(pos2.z, 2) then
        return true
    end
    return false
end
function Round(num, idp)
    return math.ceil(num*(10^idp))/10^idp
end

function CalculateBonus(index)
    return (index - 5)*5
end

function ShowHideSettingPanel()
    local active = self.UI.getAttribute("settingPanel", "active")
    self.UI.setAttribute("settingPanel", "active", active == "false" and "true" or "false")
end

function ChangeColorNumber(_, input)
    if(#input < 6) then for i = #input, 6 do input = input.."0" end end
    textColor = "#"..input
    self.UI.setAttribute("OD", "textColor", textColor)
    self.UI.setAttribute("Head", "textColor", textColor)
    self.UI.setAttribute("Body", "textColor", textColor)
    self.UI.setAttribute("lHand", "textColor", textColor)
    self.UI.setAttribute("rHand", "textColor", textColor)
    self.UI.setAttribute("lLeg", "textColor", textColor)
    self.UI.setAttribute("rLeg", "textColor", textColor)
    for i = 1, 6 do
        self.UI.setAttribute("lm"..i, "color", textColor)
    end
    for i = 1, 6 do
        self.UI.setAttribute("TBonus"..i, "color", textColor)
    end
    for i = 1, 11 do
        self.UI.setAttribute("os"..i, "textColor", textColor)
    end
    UpdateSave(textColor)
end