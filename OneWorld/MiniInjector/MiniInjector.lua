injectEverythingAllowed, injectEverythingActive, updateEverythingActive, updateEverythingFrameCount, injectedSecondsLimiter = false, false, false, 0, 0
collisionProcessing = {}
OW_tZone = nil

options = {
    hideBar = false, hideAll = false, showAll = true,
    measureMove = false, alternateDiag = false, metricMode = false, playerChar = false, HP2Desc = false,
    hp = 10, mana = 0, extra = 0, initActive = false, initCurrentValue = 0, initCurrentRound = 1,
    initCurrentGUID = ""
}

initFigures, workingObjects = {}, {}
CONST_INJECT, CONST_REMOVE = "[00ff00]INJECT[-]", "[ff0000]REMOVE[-]"

local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            value = deepCopy(value)
        end
        copy[key] = value
    end
    return copy
end

function onSave()
    local save_state = JSON.encode({
        ping_init_minis = pingInitMinis, auto_calibrate_enabled = autoCalibrateEnabled, options = options,
    })
    return save_state
end

local function isExcludedClassName(className)
    local excludedClasses = {"MeasurementToken_Move", "InjectTokenMini", "DNDMiniInjector_Mini_Move", "MeasurementTool"}
    for _, excludedClass in ipairs(excludedClasses) do
        if className == excludedClass then
            return true
        end
    end
    return false
end

local function processHitObject(hitTable, object)
    if self.getRotationValue() == CONST_INJECT then
        local objClassName = object.getVar("className")
        if not isExcludedClassName(objClassName) then
            injectToken(object)
            injectedSecondsLimiter = 10
        end
    elseif self.getRotationValue() == CONST_REMOVE then
        if object.getVar("className") == "InjectTokenMini" then
            object.call("destroyMoveToken")
            object.script_state = ""
            object.script_code = ""
            object.setLuaScript("")
            object.reload()
        end
    else
        error("Invalid rotation.")
    end
end

local function handleCollisionInfo(collision_info)
    local object = collision_info.collision_object
    if object ~= nil then
        local hitList = Physics.cast({
            origin = object.getBounds().center, direction = {0, -1, 0}, type = 1, max_distance = 10, debug = false,
        })
        for _, hitTable in ipairs(hitList) do
            if hitTable ~= nil and hitTable.hit_object == self then
                processHitObject(hitTable, object)
                break
            end
        end
    end
end

local function getOneWorldScriptingZone()
    if OW_tZone then return end
    for _, obj in ipairs(getAllObjects()) do
        if obj.getName() == "_OW_tZone" then
            OW_tZone = obj
        end
    end
    print("Warning: OW scripting zone not found!", "#b15959")
end

local function getInjectingMiniatures()
    local miniatures = {}
    getOneWorldScriptingZone()
    if OW_tZone == nil then return end
    for _, objZone in ipairs(OW_tZone.getObjects()) do
        if objZone.getName() ~= "_OW_vBase" then
            table.insert(miniatures, objZone)
        end
    end
    return miniatures
end

local function addingInjectionsMini()
    for _, obj in ipairs(getInjectingMiniatures()) do
        if obj.getVar("className") ~= "InjectTokenMini" then
            print("[00ff00]Injecting[-] mini " .. obj.getName() .. ".")
            injectToken(obj)
        end
        coroutine.yield(0)
    end
    return 1
end

local function checkObjects()
    if injectedSecondsLimiter > 0 then
        injectedSecondsLimiter = injectedSecondsLimiter - 1
    end
    if injectedSecondsLimiter == 0 and #collisionProcessing > 0 then
        local collision_info = table.remove(collisionProcessing)
        handleCollisionInfo(collision_info)
    end

    if injectEverythingActive then
        startLuaCoroutine(self, "addingInjectionsMini")
        injectEverythingActive = false
        print("[00ff00]Inject EVERYTHING complete.[-]")
    end

    if updateEverythingActive then
        updateEverythingFrameCount = updateEverythingFrameCount + 1
        if updateEverythingFrameCount >= 5 then
            updateEverythingFrameCount = 0
            updateEverythingActive = false
            print("[00ff00]All minis updated.[-]")
            if options.initActive then
                Wait.time(rollInitiative, 1)
            end
        end
    end
end

function onLoad(save_state)
    if save_state ~= "" then
        local saved_data = JSON.decode(save_state)
        if saved_data ~= nil then
            if saved_data.options ~= nil then
                for opt, _ in pairs(saved_data.options) do
                    if saved_data.options[opt] ~= nil then
                        options[opt] = saved_data.options[opt]
                    end
                end
            end
            pingInitMinis = saved_data.ping_init_minis and saved_data.ping_init_minis or true
            autoCalibrateEnabled = saved_data.auto_calibrate_enabled and saved_data.auto_calibrate_enabled or false
        end
    end

    rebuildContextMenu()

    addHotkey("Initiative Forward", forwardInitiative, false)
    addHotkey("Initiative Backward", backwardInitiative, false)
    addHotkey("Initiative Refresh", refreshInitiative, false)
    addHotkey("Initiative Roll", rollInitiative, false)

    Wait.condition(|| toggleOnOff(true), function() return #workingObjects > 0 end, 3, || updateSettingUI())
    Wait.time(function() updateEverythingActive = true end, 4)
    Wait.time(|| checkObjects(), 0.2, -1)

    WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/MiniInjector/Miniature/InjectToken.lua",
        function(request)
            if request.is_error then
                log(request.error)
            else
                injectMiniLua = request.text
            end
        end
    )
    WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/MiniInjector/Miniature/InjectToken.xml",
        function(request)
            if request.is_error then
                log(request.error)
            else
                injectMiniXML = request.text
            end
        end
    )
end

local function updateUIAttribute(id, value)
    self.UI.setAttribute(id, "value", value)
    self.UI.setAttribute(id, "text", value == "true" and "✘" or "")
    self.UI.setAttribute(id, "textColor", "#FFFFFF")
end

function updateSettingUI()
    self.UI.setAttribute("hp", "text", options.hp)
    self.UI.setAttribute("mana", "text", options.mana)
    self.UI.setAttribute("extra", "text", options.extra)

    for opt, _ in pairs(options) do
        if opt == "measureMove" or opt == "alternateDiag" or opt == "playerChar" or opt == "hideBar" then
            updateUIAttribute(opt, tostring(options[opt]))
        end
    end
end

function rebuildContextMenu()
    self.clearContextMenu()
    self.addContextMenuItem(string.format("%s Ping Init Minis", pingInitMinis and "[X]" or "[ ]"), togglePingInitMinis)
    self.addContextMenuItem(string.format("%s Auto-Calibrate", autoCalibrateEnabled and "[X]" or "[ ]"), toggleAutoCalibrate)
    self.addContextMenuItem(string.format("%s Metric Mode", options.metricMode and "[X]" or "[ ]"), toggleMetricMode)
    self.addContextMenuItem("Inject mini", injectMini)
    self.addContextMenuItem(string.format("%s Show Mini UI", options.showAll and "[X]" or "[ ]"), toggleOnOff)
end

function toggleMetricMode()
    options.metricMode = not options.metricMode
    for _, obj in ipairs(workingObjects) do
        obj.call("toggleMetricMode")
    end
    rebuildContextMenu()
end

function togglePingInitMinis()
    pingInitMinis = not pingInitMinis
    rebuildContextMenu()
end

function toggleAutoCalibrate()
    autoCalibrateEnabled = not autoCalibrateEnabled
    if autoCalibrateEnabled then
        print("Automatic calibration ENABLED. Injected minis will automatically be calibrated to the current grid.")
    else
        print("Automatic calibration DISABLED.")
    end
    rebuildContextMenu()
end

function injectMini()
    if injectEverythingAllowed == false then
        print("Inject mini. This command performs Inject with all objects on the global map of OneWorld.")
        print("Warning: to make it work correctly, select a pre-made map in OneWorld (e.g. the starting map), set the thumbnails on it and then run Inject.")
        injectEverythingAllowed = true
        return
    end
    injectEverythingAllowed = false
    injectEverythingActive = true
end

function toggleCheckBox(player, value, id)
    if self.UI.getAttribute(id, "value") == "false" then
        self.UI.setAttribute(id, "value", "true")
        self.UI.setAttribute(id, "text", "✘")
        options[id] = true
    else
        self.UI.setAttribute(id, "value", "false")
        self.UI.setAttribute(id, "text", "")
        options[id] = false
    end
    self.UI.setAttribute(id, "textColor", "#FFFFFF")
    for _, obj in ipairs(workingObjects) do
        if id == "alternateDiag" then
            obj.call('toggleAlternateDiag')
        end
        if obj.getVar("player") then
            obj.UI.setAttribute("bars", "visibility", "")
        else
            if id == "hideBar" then
                obj.UI.setAttribute("bars", "visibility", options[id] and "Black" or "")
            end
        end
    end
end

function toggleHideBars(player, value, id)
    options.hideAll = not options.hideAll
    for _, obj in ipairs(workingObjects) do
        if options.hideAll then
            obj.UI.setAttribute("resourceBar", "active", "false")
            obj.UI.setAttribute("resourceBarS", "active", "false")
            obj.UI.setAttribute("extraBar", "active", "false")
        else
            obj.UI.setAttribute("resourceBar", "active", "true")
            local objTable = obj.getTable("options")
            if not objTable.hideMana then
                obj.UI.setAttribute("resourceBarS", "active", "true")
            end
            if not objTable.hideExtra then
                obj.UI.setAttribute("extraBar", "active", "true")
            end
        end
    end
end

function toggleOnOff(skipToggle)
    if skipToggle ~= true then
        options.showAll = not options.showAll
        rebuildContextMenu()
    end
    for _, obj in ipairs(workingObjects) do
        obj.UI.setAttribute("panel", "active", options.showAll and "true" or "false")
    end
end

function onEndEdit(player, value, id)
    if value ~= "" then
        options[id] = tonumber(value)
        self.UI.setAttribute(id, "text", value)
    end
end

function onCollisionEnter(collision_info)
    table.insert(collisionProcessing, collision_info)
end

local function setMiniVariable(object, stats, xml)
    local locOptions = {
        HP2Desc = options.HP2Desc, belowZero = false, aboveMax = false, heightModifier = 110, showBaseButtons = false, showBarButtons = false, hideHp = options.hp == 0, hideMana = options.mana == 0, hideExtra = options.extra == 0, incrementBy = 1, rotation = 90, initSettingsIncluded = true, initSettingsRolling = true, initSettingsMod = 0, initSettingsValue = 100, initRealActive = false, initRealValue = 0, initMockActive = false, initMockValue = 0
    }
    object.setVar("player", options.playerChar)
    object.setVar("measureMove", options.measureMove)
    object.setVar("alternateDiag", options.alternateDiag)
    object.setVar("metricMode", options.metricMode)
    object.call("setInjectVariables", {
        health = {value = options.hp, max = options.hp}, mana = {value = options.mana, max = options.mana}, extra = {value = options.extra, max = options.extra}, options = locOptions, xml = xml, statNames = stats,
    })
end

function injectToken(object)
    local assets = self.UI.getCustomAssets()
    local xml = injectMiniXML
    local stats = {}
    local xmlStats = ""
    for _, asset in pairs(assets) do
        stats[asset.name] = false
        xmlStats = xmlStats .. '<Button id="' .. asset.name .. '" color="#FFFFFF00" active="false"><Image image="' .. asset.name .. '" preserveAspect="true"></Image></Button>\n'
    end
    xml = xml:gsub("STATSIMAGE", xmlStats)
    xml = xml:gsub('<VerticalLayout id="bars" height="200">', '<VerticalLayout id="bars" height="' .. 200 + (options.mana == 0 and -100 or 0) + (options.extra ~= 0 and 100 or 0) .. '">')
    if not options.playerChar then
        if options.hideBar then
            xml = xml:gsub("id='bars' visibility=''", "id='bars' visibility='Black'")
        end
    end
    xml = xml:gsub('<Panel id="panel" position="0 0 -220"', '<Panel id="panel" position="0 0 ' .. object.getBounds().size.y / object.getScale().y * 110 .. '"')

    if not options.hideText and options.HP2Desc then
        object.setDescription(options.hp .. "/" .. options.hp)
    end

    object.setGMNotes(self.getGUID())
    object.setLuaScript(injectMiniLua)
    Wait.time(|| setMiniVariable(object, stats, xml), 0.5)
end

function getInitiativeFigures()
    initFigures = {}
    getOneWorldScriptingZone()
    if checkSZ == nil then return end
    for _, objZone in ipairs(OW_tZone.getObjects()) do
        if objZone.getVar("className") == "InjectTokenMini" then
            handleInitMiniature(objZone)
        end
    end
    local figureSorter = function(figA, figB)
        if figA.initValue ~= figB.initValue then
            return figA.initValue > figB.initValue
        end
        if figA.initMod ~= figB.initMod then
            return figA.initMod > figB.initMod
        end
        return figA.name < figB.name
    end
    table.sort(initFigures, figureSorter)
end

function handleInitMiniature(miniature)
    -- Grab miniature options
    local objTable = miniature.getTable("options")
    -- Only add minis that are initiative included
    if objTable.initSettingsIncluded then
        local player = miniature.getVar("player")
        local colorTint = miniature.getColorTint()
        if player then
            local miniHighlight = miniature.getVar("miniHighlight")
            if miniHighlight == "highlightWhite" then
                colorTint = Color.White
            elseif miniHighlight == "highlightBrown" then
                colorTint = Color.Brown
            elseif miniHighlight == "highlightRed" then
                colorTint = Color.Red
            elseif miniHighlight == "highlightOrange" then
                colorTint = Color.Orange
            elseif miniHighlight == "highlightYellow" then
                colorTint = Color.Yellow
            elseif miniHighlight == "highlightGreen" then
                colorTint = Color.Green
            elseif miniHighlight == "highlightTeal" then
                colorTint = Color.Teal
            elseif miniHighlight == "highlightBlue" then
                colorTint = Color.Blue
            elseif miniHighlight == "highlightPurple" then
                colorTint = Color.Purple
            elseif miniHighlight == "highlightPink" then
                colorTint = Color.Pink
            elseif miniHighlight == "highlightBlack" then
                colorTint = Color.Black
            end
        else
            colorTint = Color.White
        end
        local figure = {
            nameHealth = miniature.getName() .. " " .. miniature.UI.getAttribute("hpText", "Text"),
            guidValue = miniature.getGUID(),
            initValue = tonumber(miniature.call("getInitiative", options.initActive)),
            initText = "",
            initMod = tonumber(objTable.initSettingsMod),
            initRolling = objTable.initSettingsRolling,
            player = player,
            name = miniature.getName(),
            obj = miniature,
            options = objTable,
            health = miniature.getTable("health"),
            colorTint = colorTint,
            colorHex = tintToHex(colorTint)
        }
        local initText = tostring(figure.initValue) .. ' ['
        if figure.initMod == 0 then
            initText = initText .. '0]'
        elseif figure.initMod > 0 then
            initText = initText .. '+' .. figure.initMod .. ']'
        else
            initText = initText .. figure.initMod .. ']'
        end
        figure.initText = initText
        table.insert(initFigures, figure)
    end
end

function resetInitiative()
    options.initActive = false
    options.initCurrentValue = 0
    options.initCurrentRound = 1
    options.initCurrentGUID = ""
    getInitiativeFigures()
    for i, figure in ipairs(initFigures) do
        figure.obj.call('resetInitiative')
    end
    initFigures = {}
    rebuildUI()
    setNotes("")
end

function refreshInitiative(player)
    if player ~= nil and player.team == nil and player ~= "Black" then
        return
    end
    getInitiativeFigures()
    if options.initActive then
        updateInitPlayer(player)
    end
    rebuildUI()
end

function rollInitiative(player)
    if player ~= nil and player.team == nil and player ~= "Black" then
        return
    end
    options.initActive = true
    getInitiativeFigures()
    if not checkPlayersSet() then
        rebuildUI()
        return
    end
    if options.initCurrentValue == 0 and options.initCurrentGUID == "" then
        for _, figure in ipairs(initFigures) do
            options.initCurrentValue = figure.initValue
            options.initCurrentGUID = figure.guidValue
            break
        end
        options.initCurrentRound = 1
    else
        updateInitPlayer(player)
    end
    rebuildUI()
    setInitiativeNotes()
end

function updateInitPlayer(player)
    local foundInitFigure = false
    local changedInitFigure = false
    --find the current player
    for _, figure in ipairs(initFigures) do
        if figure.guidValue == options.initCurrentGUID then
            if player ~= nil and pingInitMinis then
                figureObj = getObjectFromGUID(options.initCurrentGUID)
                if player.team == nil then
                    -- We're a color, not a player, assign the player object
                    for _, loopPlayer in ipairs(Player.getPlayers()) do
                        if loopPlayer.color == player then
                           player = loopPlayer
                           break
                        end
                    end
                end
                player.pingTable(figureObj.getBounds().center)
            end
            -- no need for update, they are still present
            return
        end
    end
    -- if we couldn't find them by guid, just use initiative value
    if changedInitFigure == false and foundInitFigure == false then
        for _, figure in ipairs(initFigures) do
            if figure.initValue <= options.initCurrentValue and figure.guidValue ~= options.initCurrentGUID then
                options.initCurrentValue = figure.initValue
                options.initCurrentGUID = figure.guidValue
                changedInitFigure = true
                break
            end
        end
    end
    --If we still couldn't find one, loop back around to the top of the list
    if changedInitFigure == false then
        for _, figure in ipairs(initFigures) do
            options.initCurrentValue = figure.initValue
            options.initCurrentGUID = figure.guidValue
            changedInitFigure = true
            break
        end
        options.initCurrentRound = options.initCurrentRound + 1
    end
    if changedInitFigure and pingInitMinis and player ~= nil then
        figureObj = getObjectFromGUID(options.initCurrentGUID)
        if player.team == nil then
            -- We're a color, not a player, assign the player object
            for _, loopPlayer in ipairs(Player.getPlayers()) do
                if loopPlayer.color == player then
                   player = loopPlayer
                   break
                end
            end
        end
        player.pingTable(figureObj.getBounds().center)
    end
end

function forwardInitiative(player)
    if player ~= nil and player.team == nil and player ~= "Black" then
        return
    end
    if not options.initActive then
        print("Initiative must be active before navigating.")
        return
    end
    getInitiativeFigures()
    if not checkPlayersSet() then
        rebuildUI()
        return
    end

    updateInitPlayerForward(player)

    rebuildUI()
    setInitiativeNotes()
end

function updateInitPlayerForward(player)
    local foundInitFigure = false
    local changedInitFigure = false
    --find the next player
    for _, figure in ipairs(initFigures) do
        if figure.guidValue == options.initCurrentGUID then
            foundInitFigure = true
        elseif foundInitFigure then
            options.initCurrentValue = figure.initValue
            options.initCurrentGUID = figure.guidValue
            changedInitFigure = true
            break
        end
    end
    -- if we couldn't find them by guid, just use initiative value
    if changedInitFigure == false and foundInitFigure == false then
        for _, figure in ipairs(initFigures) do
            if figure.initValue <= options.initCurrentValue and figure.guidValue ~= options.initCurrentGUID then
                options.initCurrentValue = figure.initValue
                options.initCurrentGUID = figure.guidValue
                changedInitFigure = true
                break
            end
        end
    end
    --If we still couldn't find one, loop back around to the top of the list
    if changedInitFigure == false then
        for _, figure in ipairs(initFigures) do
            options.initCurrentValue = figure.initValue
            options.initCurrentGUID = figure.guidValue
            changedInitFigure = true
            break
        end
        options.initCurrentRound = options.initCurrentRound + 1
    end
    if changedInitFigure and pingInitMinis and player ~= nil then
        figureObj = getObjectFromGUID(options.initCurrentGUID)
        if player.team == nil then
            -- We're a color, not a player, assign the player object
            for _, loopPlayer in ipairs(Player.getPlayers()) do
                if loopPlayer.color == player then
                   player = loopPlayer
                   break
                end
            end
        end
        player.pingTable(figureObj.getBounds().center)
    end
end

function backwardInitiative(player)
    if player ~= nil and player.team == nil and player ~= "Black" then
        return
    end
    if not options.initActive then
        print("Initiative must be active before navigating.")
        return
    end
    getInitiativeFigures()
    if not checkPlayersSet() then
        rebuildUI()
        return
    end

    updateInitPlayerBackward(player)

    rebuildUI()
    setInitiativeNotes()
end

function updateInitPlayerBackward(player)
    local previousFigure = nil
    local foundInitFigure = false
    local changedInitFigure = false
    --find the previous player
    for _, figure in ipairs(initFigures) do
        if figure.guidValue == options.initCurrentGUID then
            foundInitFigure = true
            if previousFigure ~= nil then
                options.initCurrentValue = previousFigure.initValue
                options.initCurrentGUID = previousFigure.guidValue
                changedInitFigure = true
                break
            end
        else
            previousFigure = figure
        end
    end
    -- if we couldn't find them by guid, just use initiative value
    if changedInitFigure == false and foundInitFigure == false then
        for _, figure in ipairs(initFigures) do
            if figure.initValue >= options.initCurrentValue and previousFigure ~= nil then
                foundInitFigure = true
                options.initCurrentValue = previousFigure.initValue
                options.initCurrentGUID = previousFigure.guidValue
                changedInitFigure = true
                break
            else
                previousFigure = figure
            end
        end
    end
    --If we still couldn't find one, loop back around to the bottom of the list
    if changedInitFigure == false then
        options.initCurrentValue = previousFigure.initValue
        options.initCurrentGUID = previousFigure.guidValue
        changedInitFigure = true
        options.initCurrentRound = options.initCurrentRound - 1
    end
    if changedInitFigure and pingInitMinis and player ~= nil then
        figureObj = getObjectFromGUID(options.initCurrentGUID)
        if player.team == nil then
            -- We're a color, not a player, assign the player object
            for _, loopPlayer in ipairs(Player.getPlayers()) do
                if loopPlayer.color == player then
                   player = loopPlayer
                   break
                end
            end
        end
        player.pingTable(figureObj.getBounds().center)
    end
end

local function buildNoteString(figures)
    local noteString = {"[CFCFCF]-------- INITIATIVE --------\n-------- ROUND " .. options.initCurrentRound .. " ---------\n-----------------------------\n[-]"}
    for _, figure in ipairs(figures) do
        table.insert(noteString, getInitiativeString(figure))
    end
    table.insert(noteString, "[CFCFCF]-----------------------------[-]")
    return table.concat(noteString)
end

function setInitiativeNotes()
    local noteString = buildNoteString(initFigures)
    setNotes(noteString)
end

--returns the rendered initiative string for this figure
function getInitiativeString(figure)
    local figureColorA = "[" .. figure.colorHex .. "]"
    local figureColorB = "[-]"
    local initiativeMarker = ""
    if figure.guidValue == options.initCurrentGUID then
        initiativeMarker = "---->"
    end
    if figure.player == false then
        return "[FFFFFF]" .. initiativeMarker .. figure.name .. "     " .. figure.initValue .. "[-]\n"
    else

        return "[b][i]" .. figureColorA .. initiativeMarker .. figure.name .. "     " .. figure.initValue .. "[/b][/i]" .. figureColorB .. "\n"
    end
end

function checkPlayersSet()
    local noteCheck = ""
    for _, figure in ipairs(initFigures) do
        if (figure.player or figure.initRolling == false) and figure.initValue == 100 then
            print(figure.name .. " has not set their initiative.")
            noteCheck = noteCheck .. figure.name .. " has not set their initiative.\n"
        end
    end
    if noteCheck ~= "" then
        setNotes(noteCheck)
        return false
    end
    return true
end

function rebuildUI()
    local xmlUI = self.UI.getXmlTable()
    -- clear out existing figures
    xmlUI[3].children = {}

    local minilist = {
        tag='VerticalLayout',
        attributes={id='scroll', minHeight='200', width='1200', inertia=false, scrollSensitivity=4, color='#00000000', visibility='Black', rectAlignment='UpperCenter'},
        children = {
            {tag='VerticalLayout', attributes={childForceExpandHeight=false, contentSizeFitter='vertical', spacing='5', padding='5 5 5 5', visibility='Black', rectAlignment='UpperCenter'}, children={}}
        }
    }

    for _, figure in ipairs(initFigures) do
        local c = figure.colorTint
        local color = '#'..string.format('%02x', math.ceil(c.r * 255))..string.format('%02x', math.ceil(c.g * 255))..string.format('%02x', math.ceil(c.b * 255))

        local colorVar = '#202020'
        if options.initCurrentGUID == figure.guidValue then
            colorVar = '#505050'
        elseif figure.player then
            colorVar = '#401010'
        end

        local extraText = ''
        local currentHealth = figure.health.value
        local maxHealth = figure.health.max
        local perc = (maxHealth == 0) and 0 or (currentHealth * 1.0) / (maxHealth * 1.0)
        if (perc <= 0) then
            extraText = " (Dead)"
        elseif (perc <= 0.05) then
            extraText = " (Deaths Door)"
        elseif (perc <= 0.25) then
            extraText = " (Spicy)"
        elseif (perc <= 0.5) then
            extraText = " (Bloody)"
        elseif (perc <= 0.75) then
            extraText = " (Feeling it now Mr. Krabs?)"
        elseif (perc < 1.0) then
            extraText = " (Healthy)"
        else
            extraText = " (Untouched)"
        end
        extraText = striptags(figure.name)..extraText
        local percMax = tonumber(perc * 100.0)
        local miniui = {
            tag='verticallayout',
            attributes={
                color=colorVar,
                childForceExpandHeight=false,
                padding=5,
                spacing=5,
                flexibleHeight=0
            },
            children={
                {
                    tag='horizontallayout',
                    attributes={
                        preferredHeight = 120,
                        childForceExpandHeight=false,
                        childForceExpandWidth=false,
                        spacing=5
                    },
                    children={
                        {
                            tag='text',
                            attributes={
                                id=figure.guidValue ..'_header_init',
                                alignment='MiddleLeft',
                                preferredHeight='120',
                                text=figure.initText
                            }
                        },
                        {
                            tag='panel',
                            attributes={
                                color=color,
                                preferredWidth = 10,
                                flexibleWidth = 0,
                                preferredHeight='120'
                            }
                        },
                        {
                            tag='text',
                            attributes={
                                id=figure.guidValue ..'_header_title',
                                alignment='MiddleLeft',
                                preferredHeight='120',
                                preferredWidth=10000,
                                text=extraText
                            }
                        },
                    }
                },
                {
                    tag='horizontallayout',
                    attributes={
                        preferredHeight='120',
                        childForceExpandHeight=false,
                        childForceExpandWidth=false,
                        spacing=5
                    },
                    children={
                        {
                            tag='InputField',
                            attributes={
                                id=figure.guidValue ..'_input_change',
                                preferredHeight='120',
                                preferredWidth='260',
                                flexibleWidth=0,
                                alignment='MiddleCenter',
                                offsetXY='150 0',
                                color='rgb(0.3,0.3,0.3)',
                                textColor='rgb(1,1,1)',
                                characterValidation='Integer',
                                onEndEdit='barChangeDiff',
                                fontStyle='Bold'
                            }
                        },
                        {
                            tag='InputField',
                            attributes={
                                id=figure.guidValue ..'_input_current',
                                preferredHeight='120',
                                preferredWidth='260',
                                flexibleWidth=0,
                                alignment='MiddleCenter',
                                offsetXY='150 0',
                                text=currentHealth,
                                characterValidation='Integer',
                                onEndEdit='barChangeCurrent',
                                fontStyle='Bold'
                            }
                        },
                        {
                            tag='Button',
                            attributes={
                                id=figure.guidValue ..'_barReduce',
                                preferredWidth='60',
                                preferredHeight='120',
                                flexibleWidth=0,
                                image='ui_arrow_l2',
                                onClick='barReduce'
                            }
                        },
                        {
                            tag='panel',
                            attributes={
                                preferredHeight='120',
                                preferredWidth='600'
                            },
                            children={
                                {
                                    tag='progressbar',
                                    attributes={
                                        id=figure.guidValue ..'_bar',
                                        width='100%',
                                        percentage=percMax,
                                        fillImageColor='#FF0000',
                                        color='#00000080',
                                        textColor='transparent'
                                    }
                                }
                            }
                        },
                        {
                            tag='Button',
                            attributes={
                                id=figure.guidValue ..'_barIncrease',
                                preferredWidth='60',
                                preferredHeight='120',
                                image='ui_arrow_r2',
                                flexibleWidth=0,
                                onClick='barIncrease'
                            }
                        },
                        {
                            tag='InputField',
                            attributes={
                                id=figure.guidValue ..'_input_maximum',
                                preferredHeight='120',
                                preferredWidth='260',
                                text=maxHealth,
                                characterValidation='Integer',
                                onEndEdit='barChangeMaximum',
                                fontStyle='Bold'
                            }
                        }
                    }
                }
            }
        }

        table.insert(minilist.children[1].children, miniui)
    end

    local calcHeight = 186*#initFigures
    minilist.attributes.height = calcHeight
    minilist.attributes.minHeight = calcHeight
    table.insert(xmlUI[3].children, {
        tag='Defaults', children={
            {tag='Text', attributes={color='#cccccc', alignment='MiddleLeft', visibility='Black'}},
            {tag='InputField', attributes={preferredHeight='120', visibility='Black'}},
            {tag='ToggleButton', attributes={preferredHeight='120', colors='#ffcc33|#ffffff|#808080|#606060', selectedBackgroundColor='#dddddd', deselectedBackgroundColor='#999999', visibility='Black'}},
            {tag='Button', attributes={preferredHeight='120', colors='#dddddd|#ffffff|#808080|#606060', visibility='Black'}},
            {tag='Toggle', attributes={textColor='#cccccc', visibility='Black'}},
        }
    })
    table.insert(xmlUI[3].children, {tag='Panel', attributes={ height=calcHeight, width='1580', rectAlignment='UpperCenter'},
        children={
            {tag='VerticalLayout', attributes={childForceExpandHeight=false, minHeight='0', spacing=10, rectAlignment='UpperCenter'}, children={
                {tag='HorizontalLayout', attributes={preferredHeight=160, childForceExpandWidth=false, flexibleHeight=0, spacing=20, padding='10 10 10 10'}, children={}},
                minilist
            }}
        }
    })
    self.UI.setXmlTable(xmlUI)
end

function updateFromGuid(guid)
    local token = getObjectFromGUID(guid)
    if (token ~= nil) then
        local healthTable = token.getTable("health")
        local currentHealth = healthTable.value
        local maxHealth = healthTable.max
        local perc = (maxHealth == 0) and 0 or (currentHealth * 1.0) / (maxHealth * 1.0)
        local extraText = string.format(" %s", perc <= 0 and " (Dead)" or perc <= 0.05 and " (Deaths Door)" or perc <= 0.05 and " (Deaths Door)" or
            perc <= 0.25 and " (Spicy)" or perc <= 0.5 and " (Bloody)" or perc <= 0.75 and " (Feeling it now Mr. Krabs?)" or
            perc < 1 and " (Healthy)" or " (Untouched)")
        local percMax = tonumber(perc * 100.0)
        self.UI.setAttribute(guid.."_header_title", "text", striptags(token.getName())..extraText)
        self.UI.setAttribute(guid.."_input_current", "text", currentHealth)
        self.UI.setAttribute(guid.."_bar", "percentage", percMax)
        self.UI.setAttribute(guid.."_input_maximum", "text", maxHealth)
    end
end

function barChangeDiff(player, value, id)
    if value == "" then
        return
    end
    local args = {}
    for a in string.gmatch(id, '([^%_]+)') do
        table.insert(args,a)
    end
    local guid = args[1]
    local token = getObjectFromGUID(guid)
    if (token ~= nil) then
        token.call('adjustHP', value)
    end
    self.UI.setAttribute(id, 'text', '')
end

function barChangeCurrent(player, value, id)
    if value == "" then
        return
    end
    local args = {}
    for a in string.gmatch(id, '([^%_]+)') do
        table.insert(args,a)
    end
    local guid = args[1]
    local token = getObjectFromGUID(guid)
    if (token ~= nil) then
        token.call('setHP', value)
    end
end

function barChangeMaximum(player, value, id)
    if value == "" then
        return
    end
    local args = {}
    for a in string.gmatch(id, '([^%_]+)') do
        table.insert(args,a)
    end
    local guid = args[1]
    local token = getObjectFromGUID(guid)
    if (token ~= nil) then
        token.call('setHPMax', value)
    end
end

function barReduce(player, value, id)
    local guid = id:sub(1, -11)
    local miniature = getObjectFromGUID(guid)
    if miniature ~= nil then
        if value == "-1" then
            miniature.call('reduceHP')
        else
            miniature.call('adjustHP', -10)
        end
    end
end

function barIncrease(player, value, id)
    local guid = id:sub(1, -13)
    local miniature = getObjectFromGUID(guid)
    if miniature ~= nil then
        if value == "-1" then
            miniature.call('increaseHP')
        else
            miniature.call('adjustHP', 10)
        end
    end
end

function sanitize(str)
    return str:gsub('[<>]', '')
end

function striptags(str)
    str = sanitize(str)
    str = str:gsub('%[/?[iI]%]', '')
    str = str:gsub('%[/?[bB]%]', '')
    str = str:gsub('%[/?[uU]%]', '')
    str = str:gsub('%[/?[sS]%]', '')
    str = str:gsub('%[/?[sS][uU][bB]%]', '')
    str = str:gsub('%[/?[sS][uU][pP]%]', '')
    str = str:gsub('%[/?[sS][uU][pP]%]', '')
    str = str:gsub('%[/?%-%]', '')
    str = str:gsub('%[/?[a-fA-F0-9][a-fA-F0-9][a-fA-F0-9][a-fA-F0-9][a-fA-F0-9][a-fA-F0-9]%]', '')
    return str
end

--Converts a color tint to a hex code
function tintToHex(objColor)
    hexColor = ''
    for i=1,3 do
        hex = ''
        dec = objColor[i] * 255
        hex = string.format( "%2.2X",math.floor(dec+0.5))
        hexColor = hexColor..hex
    end
    return hexColor
end

local function checkWorkingObjects(obj)
    for i, wObj in ipairs(workingObjects) do
        if wObj.getGUID() == obj.getGUID() then
            return i
        end
    end
    return false
end
function addNewWorkingObjects(obj)
    if tostring(obj) ~= "null" and checkWorkingObjects(obj) == false then
        table.insert(workingObjects, obj)
    end
end
function removeOldWorkingObjects(obj)
    local id = checkWorkingObjects(obj)
    if id then
        table.remove(workingObjects, id)
    end
end