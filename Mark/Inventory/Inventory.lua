local pointsPos = {
    сила = {
        {x = 1.47, z = -1.98}, {x = 1.38, z = -1.98}, {x = 1.28, z = -1.98}, {x = 1.19, z = -1.98}, {x = 1.10, z = -1.98},
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
    MartialArts = "ловкость", Survival = "восприятие", LocalKnowledge = "интелект",
    ForeignLanguage = "интелект", Medicine = "интелект", Science = "интелект",
    Cooking = "восприятие", Herbalism = "восприятие", Observation = "восприятие",
    Orientation = "восприятие", FirstAid = "восприятие", Mechanics = "интелект",
    Armor = "сила", Gunsmith = "сила", Interrogation = "сила",
    Livestock = "восприятие", Leadership = "харизма", Acting = "харизма",
    Speechcraft = "харизма", Art = "восприятие", Trade = "харизма", Gambling = "ловкость"
}

local flagCollision = false
function onLoad()
    Wait.time(|| Confer(savedData), 0.4)
end
function Confer(savedData)
    snaps = self.getSnapPoints()
    throw = getObjectFromGUID(self.getGMNotes())
    flagCollision = true

    local id = 1
    for word in self.getDescription():gmatch("%S+") do
        self.UI.setAttribute("Bonus"..id, "text", word)
        id = id + 1
    end
end

function onCollisionEnter(info)
    if flagCollision == false then return end
    PrintBlack("Hello on")

    local lTag = info.collision_object.getTags()[1]
    if lTag ~= nil then --Skills
        local locStateId = info.collision_object.getStateId()
        for t,c in pairs(pointSkills) do
            if lTag == t then
                local arg = {tTag = lTag, bonus = CalculateBonus(5 + locStateId), tChar = c}
                throw.call("ChangeMemory", arg)
                return
            end
        end
    else --Characteristics
        local locPos = self.positionToLocal(info.collision_object.getPosition())
        if locPos.y > 0 then
            for _,point in ipairs(snaps) do
                if CheckPos(locPos, point.position) then
                    for tChar,values in pairs(pointsPos) do
                        for index,value in ipairs(values) do
                            if value.x == Round(point.position.x, 2) and value.z == Round(point.position.z, 2) then
                                local arg = {tChar = tChar, bonus = CalculateBonus(index)}
                                throw.call("ChangeMemory", arg)

                                for t,c in pairs(pointSkills) do
                                    if tChar == c then
                                        local arg = {tTag = t, bonus = -1, tChar = c}
                                        throw.call("ChangeMemory", arg)
                                    end
                                end
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

function onCollisionExit()
    PrintBlack("Hello off")
end

function PrintBlack(text)
    if Player["Black"] and Player["Black"].steam_id then
        broadcastToColor(text, "Black")
    end
end

function ChangeBonus(_, input, id)
    local loc, locDesc = "Bonus", {}
    local id = tonumber(id:sub(loc:len() + 1))
    for word in self.getDescription():gmatch("%S+") do
        table.insert(locDesc, word)
    end
    locDesc[id] = input
    local newDesc = ""
    for i,str in ipairs(locDesc) do
        newDesc = newDesc .. str
        if i == 6 then break end
        newDesc = newDesc .. "\n"
    end
    self.setDescription(newDesc)
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