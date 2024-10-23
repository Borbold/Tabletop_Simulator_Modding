creatureA, creatureB = "[C0C0C0]", "[-]"
playerA, playerB = "[b]", "[b]"

creatureColor = {1,1,1}
playerColor = {1,1,1}

tokenScaleFactor = 0.6

function UpdateSave()
    local dataToSave = {
        ["tInitiative"] = tInitiative
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    self.createButton({
        click_function='addCreature', function_owner=self,
        position={1.2,0,0}, height=250, width=400
    })
    self.createButton({
        click_function='addPlayer', function_owner=self,
        position={-1.2,0,0}, height=250, width=400
    })
    self.createButton({
        click_function='rollInitiative', function_owner=self,
        position={0,0,1.11}, height=300, width=900
    })

    math.randomseed(os.time())
    Wait.time(|| Confer(savedData), 0.2)
end
function Confer(savedData)
    local loadedData = JSON.decode(savedData or "")
    tInitiative = loadedData and loadedData.tInitiative or {}
end

function addCreature() spawnToken("Creature") end
function addPlayer() spawnToken("Player") end

function spawnToken(type)
    local tokenURL = "http://i.imgur.com/Dnvewm6.png"
    local scriptAddition = " tokenType='Player'"
    if type == "Creature" then
        tokenURL = "http://i.imgur.com/6K4azAx.png"
        scriptAddition = " tokenType='Creature'"
    end

    local pos = self.getPosition()
    local newToken = spawnObject({
        type="Custom_Token",
        position={pos.x, pos.y+3, pos.z},
        rotation=self.getRotation(),
        scale={tokenScaleFactor,1,tokenScaleFactor},
        callback="addNameToToken",
        callback_owner=self,
        params={type}
    })
    newToken.setCustomObject({
        image=tokenURL
    })
    newToken.setLuaScript("function onSave() saved_data = JSON.encode({count}) return saved_data end function onload(saved_data) if saved_data ~= '' then count = JSON.decode(saved_data)[1] else count=0 end self.createButton({label=count, click_function='none', function_owner=self,position={0,0.1,0.05}, height=0,width=0, font_size=500}) self.createButton({click_function='add', function_owner=self,position={1.2,0,0}, height=300, width=300}) self.createButton({click_function='sub', function_owner=self,position={-1.2,0,0}, height=300, width=300}) end function add() count = count + 1 self.editButton({index=0, label=count}) end function sub() count = count - 1 self.editButton({index=0, label=count}) end" .. scriptAddition)
    table.insert(tInitiative, newToken.getGUID())
    UpdateSave()
end

function addNameToToken(token, params)
    local type = params[1]
    token.setName(type .. math.random(1,100))
    if type == "Creature" then
        token.setColorTint(creatureColor)
    else
        token.setColorTint(playerColor)
    end
end

function rollInitiative()
    local tokenList = {}
    for _, guid in ipairs(tInitiative) do
        obj = getObjectFromGUID(guid)
        local typeCheck = obj.getVar("tokenType")
        if typeCheck == "Player" or typeCheck == "Creature" then
            local name = obj.getName()
            local mod = obj.getVar("count")
            local roll = math.random(1,20) + mod
            local t = {obj=obj, name=name, mod=mod, roll=roll, type=typeCheck}
            table.insert(tokenList, t)
        end
    end

    sortTable_Descending(tokenList, "roll")

    local noteString = ""
    for i, entry in ipairs(tokenList) do
        if entry.type == "Creature" then
            noteString = noteString .. creatureA
        else
            noteString = noteString .. playerA
        end

        noteString = noteString .. entry.name .. " (" .. entry.mod .. ")     " .. entry.roll

        if entry.type == "Creature" then
            noteString = noteString .. creatureB .. "\n"
        else
            noteString = noteString .. playerB .. "\n"
        end
    end
    setNotes(noteString)
end

function sortTable_Descending(tableToSort, categoryName)
    local sort_func = function(a,b) return a[categoryName] > b[categoryName] end
    table.sort(tableToSort, sort_func)
end
