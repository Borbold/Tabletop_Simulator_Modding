className = "MiniInjector"
versionNumber = "4.7.9"
finishedLoading = false
debuggingEnabled = false
pingInitMinis = true
autostartOneWorld = true
initTableOnly = true
hideUpsideDownMinis = true
autoCalibrateEnabled = false
injectEverythingAllowed = false
injectEverythingActive = false
injectEverythingFrameCount = 0
updateEverythingActive = false
updateEverythingFrameCount = 0
updateEverythingIndex = 1
injectedFrameLimiter = 0
collisionProcessing = {}

options = {
    hideText = false,
    editText = false,
    hideBar = false,
    hideAll = false,
    showAll = true,
    measureMove = false,
    alternateDiag = false,
    metricMode = false,
    playerChar = false,
    HP2Desc = false,
    hp = 10,
    mana = 10,
    extra = 0,
    initActive = false,
    initCurrentValue = 0,
    initCurrentRound = 1,
    initCurrentGUID = ""
}

initFigures = {}

-- Function to perform a deep copy of a table
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
        debugging_enabled = debuggingEnabled,
        ping_init_minis = pingInitMinis,
        autostart_oneworld = autostartOneWorld,
        init_table_only = initTableOnly,
        auto_calibrate_enabled = autoCalibrateEnabled,
        options = options,
    })
    return save_state
end

local function checkObjects()
    if injectedFrameLimiter > 0 then
        injectedFrameLimiter = injectedFrameLimiter - 1
    end
    if injectedFrameLimiter == 0 and #collisionProcessing > 0 then
        local collision_info = table.remove(collisionProcessing)
        local object = collision_info.collision_object
        if object ~= nil then
            local hitList = Physics.cast({
                origin       = object.getBounds().center,
                direction    = {0,-1,0},
                type         = 1,
                max_distance = 10,
                debug        = false,
            })
            local attemptCount = 1
            for _, hitTable in ipairs(hitList) do
                -- This hit makes sure the injector is the first object directly below the mini
                if hitTable ~= nil and hitTable.hit_object == self then
                    if self.getRotationValue() == "[00ff00]INJECT[-]" then
                        objClassName = object.getVar("className")
                        if objClassName ~= "MiniInjector" and
                           objClassName ~= "MeasurementToken" and
                           objClassName ~= "MeasurementToken_Move" and
                           objClassName ~= "DNDMiniInjector_Mini" and
                           objClassName ~= "DNDMiniInjector_Mini_Move" and
                           objClassName ~= "MeasurementTool" then
                            if debuggingEnabled == true then
                                print("[00ff00]Injecting[-] mini " .. object.getName() .. ".")
                            end
                            injectToken(object)
                            injectedFrameLimiter = 60
                            break
                        end
                    elseif self.getRotationValue() == "[ff0000]REMOVE[-]" then
                        if object.getVar("className") == "MeasurementToken" or object.getVar("className") == "DNDMiniInjector_Mini" then
                            if debuggingEnabled == true then
                                print("[ff0000]Removing[-] injection from " .. object.getName() .. ".")
                            end
                            object.call("destroyMoveToken")
                            object.script_state = ""
                            object.script_code = ""
                            object.setLuaScript("")
                            object.reload()
                            break
                        end
                    else
                        error("Invalid rotation.")
                        break
                    end
                else
                    attemptCount = attemptCount + 1
                    if (debuggingEnabled) then
                        print("Did not find injector, index "..tostring(attemptCount)..".")
                    end
                end
            end
        end
    end
    if injectEverythingActive == true then
        injectEverythingFrameCount = injectEverythingFrameCount + 1
        if injectEverythingFrameCount >= 5 then
            injectEverythingFrameCount = 0
            local allObjects = getAllObjects()
            for _, obj in ipairs(allObjects) do
                if obj ~= self and obj ~= nil then
                    objClassName = obj.getVar("className")
                    if objClassName ~= "MeasurementToken" and
                       objClassName ~= "MeasurementToken_Move" and
                       objClassName ~= "DNDMiniInjector_Mini" and
                       objClassName ~= "DNDMiniInjector_Mini_Move" and
                       objClassName ~= "MeasurementTool" then
                        print("[00ff00]Injecting[-] mini " .. obj.getName() .. ".")
                        injectToken(obj)
                        return
                    end
                end
            end
            injectEverythingActive = false
            print("[00ff00]Inject EVERYTHING complete.[-]")
        end
    end

    if updateEverythingActive == true then
        updateEverythingFrameCount = updateEverythingFrameCount + 1
        if updateEverythingFrameCount >= 5 then
            updateEverythingFrameCount = 0
            local allObjects = getAllObjects()
            for _, obj in ipairs(allObjects) do
                if obj ~= self and obj ~= nil then
                    objClassName = obj.getVar("className")
                    if objClassName == "MeasurementToken" or objClassName == "DNDMiniInjector_Mini" then
                        tokenVersion = obj.getVar("versionNumber")
                        if versionNumber ~= tokenVersion then
                            -- Wait for the mini to fully load before killing it
                            if obj.getVar("finishedLoading") ~= true then
                                return
                            end
                            print("[00ff00]Updating[-] mini " .. updateEverythingIndex .. ".")
                            updateEverythingIndex = updateEverythingIndex + 1
                            injectToken(obj)
                            return
                        end
                    end
                end
            end
            updateEverythingActive = false
            updateEverythingIndex = 1
            print("[00ff00]All minis updated.[-]")
            if options.initActive == true then
                Wait.frames(rollInitiative, 60)
            end
        end
    end
end

function onLoad(save_state)
    if save_state ~= "" then
        saved_data = JSON.decode(save_state)
        if saved_data ~= nil then
            if saved_data.options ~= nil then
                for opt,_ in pairs(saved_data.options) do
                    if saved_data.options[opt] ~= nil then
                        options[opt] = saved_data.options[opt]
                    end
                end
            end
            if saved_data.debugging_enabled ~= nil then
                debuggingEnabled = saved_data.debugging_enabled
            end
            if saved_data.ping_init_minis ~= nil then
                pingInitMinis = saved_data.ping_init_minis
            end
            if saved_data.autostart_oneworld ~= nil then
                autostartOneWorld = saved_data.autostart_oneworld
            end
            if saved_data.init_table_only ~= nil then
                initTableOnly = saved_data.init_table_only
            end
            if saved_data.auto_calibrate_enabled ~= nil then
                autoCalibrateEnabled = saved_data.auto_calibrate_enabled
            end
        end
    end

    rebuildContextMenu()
    finishedLoading = true
    self.setName("DND Mini Injector " .. versionNumber)

    addHotkey("Initiative Forward", forwardInitiative, false)
    addHotkey("Initiative Backward", backwardInitiative, false)
    addHotkey("Initiative Refresh", refreshInitiative, false)
    addHotkey("Initiative Roll", rollInitiative, false)

    Wait.frames(updateSettingUI, 10)

    Wait.frames(initOneWorld, 60)

    Wait.frames(updateEverything, 120)

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

function updateSettingUI()
    self.UI.setAttribute("hp", "text", options.hp)
    self.UI.setAttribute("mana", "text", options.mana)
    self.UI.setAttribute("extra", "text", options.extra)

    for opt,_ in pairs(options) do
        if opt == "measureMove" or opt == "alternateDiag" or opt == "playerChar" or opt == "hideBar" or opt == "hideText" or opt == "editText" then
            if options[opt] then
                self.UI.setAttribute(opt, "value", "true")
                self.UI.setAttribute(opt, "text", "✘")
            else
                self.UI.setAttribute(opt, "value", "false")
                self.UI.setAttribute(opt, "text", "")
            end
            self.UI.setAttribute(opt, "textColor", "#FFFFFF")
        end
    end

    toggleOnOff(true)
end

function initOneWorld()
    if autostartOneWorld then
        local owHub = getOneWorldHub()
        if owHub ~= nil and owHub.getVar("iu") ~= nil then
            owHub.call("chkIUnit")
        end
    end
end

function rebuildContextMenu()
    self.clearContextMenu()
    if (pingInitMinis) then
        self.addContextMenuItem("[X] Ping Init Minis", togglePingInitMinis)
    else
        self.addContextMenuItem("[ ] Ping Init Minis", togglePingInitMinis)
    end
    if (initTableOnly) then
        self.addContextMenuItem("[X] Init Table Only", toggleInitTableOnly)
    else
        self.addContextMenuItem("[ ] Init Table Only", toggleInitTableOnly)
    end
    if (autoCalibrateEnabled) then
        self.addContextMenuItem("[X] Auto-Calibrate", toggleAutoCalibrate)
    else
        self.addContextMenuItem("[ ] Auto-Calibrate", toggleAutoCalibrate)
    end
    if (autostartOneWorld) then
        self.addContextMenuItem("[X] Auto-OneWorld", toggleAutostartOneWorld)
    else
        self.addContextMenuItem("[ ] Auto-OneWorld", toggleAutostartOneWorld)
    end
    if (options.metricMode) then
        self.addContextMenuItem("[X] Metric Mode", toggleMetricMode)
    else
        self.addContextMenuItem("[ ] Metric Mode", toggleMetricMode)
    end
    self.addContextMenuItem("Inject EVERYTHING", injectEverything)
    if (debuggingEnabled) then
        self.addContextMenuItem("[X] Debugging", toggleDebug)
    else
        self.addContextMenuItem("[ ] Debugging", toggleDebug)
    end
    if (options.showAll) then
        self.addContextMenuItem("[X] Show Mini UI", toggleOnOff)
    else
        self.addContextMenuItem("[ ] Show Mini UI", toggleOnOff)
    end
end

function toggleDebug()
    debuggingEnabled = not debuggingEnabled
    rebuildContextMenu()
end

function toggleAutostartOneWorld()
    autostartOneWorld = not autostartOneWorld
    rebuildContextMenu()
end

function toggleMetricMode()
    options.metricMode = not options.metricMode
    for k, v in pairs(getAllObjects()) do
        if v.getVar("className") == "MeasurementToken" or v.getVar("className") == "DNDMiniInjector_Mini" then
            v.call("toggleMetricMode")
        end
    end
    rebuildContextMenu()
end

function togglePingInitMinis()
    pingInitMinis = not pingInitMinis
    rebuildContextMenu()
end

function toggleInitTableOnly()
    initTableOnly = not initTableOnly
    rebuildContextMenu()
end

function updateEverything()
    updateEverythingActive = true
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

function injectEverything()
    if injectEverythingAllowed == false then
        print("INJECT EVERYTHING. This will inject movement tokens into literally every object in this save. Only use this in an empty save with only miniatures and measurement tools. Click it again to confirm.")
        injectEverythingAllowed = true
        return
    end
    injectEverythingActive = true
end

function allOff()
    for i,j in pairs(getAllObjects()) do
        if j ~= self then
            if j.getVar("className") == "InjectTokenMini" then
                j.UI.setAttribute("panel", "active", "false")
            end
        end
    end
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
    for i,j in pairs(getAllObjects()) do
        if j ~= self then
            if j.getVar("className") == "InjectTokenMini" then
                if id == "alternateDiag" then
                    j.call('toggleAlternateDiag')
                end
                if j.getVar("player") then
                    if id == "hideBar" then
                        j.UI.setAttribute("progressBar", "visibility", "")
                        j.UI.setAttribute("progressBarS", "visibility", "")
                        j.UI.setAttribute("extraProgress", "visibility", "")
                    elseif id == "hideText" then
                        j.UI.setAttribute("hpText", "visibility", "")
                        j.UI.setAttribute("manaText", "visibility", "")
                        j.UI.setAttribute("extraText", "visibility", "")
                    elseif id == "editText" then
                        j.UI.setAttribute("addSub", "visibility", "")
                        j.UI.setAttribute("addSubS", "visibility", "")
                        j.UI.setAttribute("addSubE", "visibility", "")
                        j.UI.setAttribute("editPanel", "visibility", "")
                    end
                else
                    if id == "hideBar" then
                        j.UI.setAttribute("progressBar", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("progressBarS", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("extraProgress", "visibility", options[id] == true and "Black" or "")
                    elseif id == "hideText" then
                        j.UI.setAttribute("hpText", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("manaText", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("extraText", "visibility", options[id] == true and "Black" or "")
                    elseif id == "editText" then
                        j.UI.setAttribute("addSub", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("addSubS", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("addSubE", "visibility", options[id] == true and "Black" or "")
                        j.UI.setAttribute("editPanel", "visibility", options[id] == true and "Black" or "")
                    end
                end
            end
        end
    end
end

function toggleHideBars(player, value, id)
    options.hideAll = not options.hideAll
    for i,j in pairs(getAllObjects()) do
        if j ~= self and not j.getName():find("DND Mini Panel") then
            if j.getVar("className") == "DNDMiniInjector_Mini" then
                if options.hideAll then
                    j.UI.setAttribute("resourceBar", "active", "false")
                    j.UI.setAttribute("resourceBarS", "active", "false")
                    j.UI.setAttribute("extraBar", "active", "false")
                else
                    j.UI.setAttribute("resourceBar", "active", "true")
                    local objTable = j.getTable("options")
                    if not objTable.hideMana then
                        j.UI.setAttribute("resourceBarS", "active", "true")
                    end
                    if not objTable.hideExtra then
                        j.UI.setAttribute("extraBar", "active", "true")
                    end
                end
            end
        end
    end
end


function toggleOnOff(skipToggle)
    if skipToggle ~= true then
        options.showAll = not options.showAll
        rebuildContextMenu()
    end
    for i,j in pairs(getAllObjects()) do
        if j ~= self and j.getVar("className") == "DNDMiniInjector_Mini" then
            j.UI.setAttribute("panel", "active", options.showAll == true and "true" or "false")
        end
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

local function setMiniVariable(object, stats)
    object.setVar("statNames", stats)
    object.setVar("health", {value = options.hp, max = options.hp})
    object.setVar("mana", {value = options.mana, max = options.mana})
    object.setVar("extra", {value = options.extra, max = options.extra})
    object.setVar("options", {
        HP2Desc = options.HP2Desc,
        belowZero = false,
        aboveMax = false,
        heightModifier = 110,
        showBaseButtons = false,
        showBarButtons = false,
        hideHp = options.hp == 0,
        hideMana = options.mana == 0,
        hideExtra = options.extra == 0,
        incrementBy = 1,
        rotation = 90,
        initSettingsIncluded = true,
        initSettingsRolling = true,
        initSettingsMod = 0,
        initSettingsValue = 100,
        initRealActive = false,
        initRealValue = 0,
        initMockActive = false,
        initMockValue = 0
    })
    object.setVar("player", options.playerChar)
    object.setVar("measureMove", options.measureMove)
    object.setVar("alternateDiag", options.alternateDiag)
    object.setVar("metricMode", options.metricMode)
end

function injectToken(object)
    local assets = self.UI.getCustomAssets()
    local xml = injectMiniXML
    local stats = "statNames = {"
    local xmlStats = ""
    for j,i in pairs(assets) do
        stats = stats .. i.name .. " = false, "
        xmlStats = xmlStats .. '<Button id="' .. i.name .. '" color="#FFFFFF00" active="false"><Image image="' .. i.name .. '" preserveAspect="true"></Image></Button>\n'
    end
    xml = xml:gsub("STATSIMAGE", xmlStats)
    xml = xml:gsub('<VerticalLayout id="bars" height="200">', '<VerticalLayout id="bars" height="' .. 200 + (options.mana == 0 and -100 or 0) + (options.extra ~= 0 and 100 or 0) .. '">')
    if options.playerChar == false then
        if options.hideText == true then
            xml = xml:gsub('id="hpText" visibility=""', 'id="hpText" visibility="Black"')
            xml = xml:gsub('id="manaText" visibility=""', 'id="manaText" visibility="Black"')
            xml = xml:gsub('id="extraText" visibility=""', 'id="extraText" visibility="Black"')
        end
        if options.hideBar == true then
            xml = xml:gsub('id="progressBar" visibility=""', 'id="progressBar" visibility="Black"')
            xml = xml:gsub('id="progressBarS" visibility=""', 'id="progressBarS" visibility="Black"')
            xml = xml:gsub('id="extraProgress" visibility=""', 'id="extraProgress" visibility="Black"')
        end
        if options.editText == true then
            xml = xml:gsub('id="addSub" visibility=""', 'id="addSub" visibility="Black"')
            xml = xml:gsub('id="addSubS" visibility=""', 'id="addSubS" visibility="Black"')
            xml = xml:gsub('id="addSubE" visibility=""', 'id="addSubE" visibility="Black"')
            xml = xml:gsub('id="editPanel" visibility=""', 'id="editPanel" visibility="Black"')
        end
    end
    xml = xml:gsub('<Panel id="panel" position="0 0 -220"', '<Panel id="panel" position="0 0 ' .. object.getBounds().size.y / object.getScale().y * 110 .. '"')

    if not options.hideText and options.HP2Desc then
        object.setDescription(options.hp .. "/" .. options.hp)
    end

    object.setLuaScript(injectMiniLua)
    object.UI.setXml(xml)
    object.reload()
    Wait.time(|| setMiniVariable(object, stats), 0.5)
end

function getOneWorldHub()
    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self and obj ~= nil and obj.getName() == "OW_Hub" then
            return obj
        end
    end
    return nil
end

function getOneWorldMap()
    for _, obj in ipairs(getAllObjects()) do
        if obj ~= self and obj ~= nil and obj.getName() == "_OW_vBase" then
            return obj
        end
    end
    return nil
end

function getMapBounds(debug)
    local defaultBounds = {x = 88.07, y = 1, z = 52.02}
    local oneWorldMap = getOneWorldMap()
    if oneWorldMap ~= nil then
        local oneWorldBounds = oneWorldMap.getBounds();
        if oneWorldBounds.size.x > 10 then
            if debuggingEnabled then
                print("Using OneWorld map bounds.")
            end
            return oneWorldBounds.size
        end
        if debug or debuggingEnabled then
            print("A OneWorld map is not deployed! Using default bounds.")
        end
        return defaultBounds
    end
    if debug or debuggingEnabled then
        print("OneWorld is not available! Using default bounds.")
    end
    return defaultBounds
end

function getInitiativeFigures()
    figures = {}
        if initTableOnly then
        -- Only gather minis from the center of the table.
        local checkBounds = getMapBounds(false)
        checkBounds.y = 40
        local hitList = Physics.cast({
            origin       = {0, 15, 0},
            direction    = {0, -1, 0},
            max_distance = 0,
            type         = 3,
            size         = checkBounds,
            debug        = false,
        })
        for _, hitTable in ipairs(hitList) do
            if hitTable ~= nil
               and hitTable.hit_object ~= nil
               and (hitTable.hit_object.getVar("className") == "MeasurementToken"
                    or hitTable.hit_object.getVar("className") == "DNDMiniInjector_Mini") then
                handleInitMiniature(hitTable.hit_object)
            end
        end
    else
        for k, v in pairs(getAllObjects()) do
            if v.getVar("className") == "MeasurementToken" or v.getVar("className") == "DNDMiniInjector_Mini" then
                handleInitMiniature(v)
            end
        end
    end
    local figureSorter = function(figA, figB)
        -- Sort by initiative value
        if figA.initValue ~= figB.initValue then
            return figA.initValue > figB.initValue
        end
        -- Then by initiative mod
        if figA.initMod ~= figB.initMod then
            return figA.initMod > figB.initMod
        end
        -- Then by name
        return figA.name < figB.name
    end
    table.sort(figures, figureSorter)
    initFigures = figures
    return figures
end

function handleInitMiniature(miniature)
    -- Grab miniature options
    local objTable = miniature.getTable("options")
    -- Only add minis that are initiative included
    if objTable.initSettingsIncluded == true then
        local player = miniature.getVar("player")
        local colorTint = miniature.getColorTint()
        if player == true then
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
        table.insert(figures, figure)
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
    if options.initActive == true then
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
    if changedInitFigure == true and pingInitMinis and player ~= nil then
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
        elseif foundInitFigure == true then
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
    if changedInitFigure == true and pingInitMinis and player ~= nil then
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
    if changedInitFigure == true and pingInitMinis and player ~= nil then
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

function setInitiativeNotes()
    --Format each result into a string that goes into notes
    local noteString = "[CFCFCF]-------- INITIATIVE --------\n-------- ROUND " .. options.initCurrentRound .. " ---------\n-----------------------------\n[-]"
    for i, figure in ipairs(initFigures) do
        noteString = noteString .. getInitiativeString(figure)
    end
    noteString = noteString .. "[CFCFCF]-----------------------------[-]"
    --Put that string into notes
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
        if (figure.player == true or figure.initRolling == false) and figure.initValue == 100 then
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
    xmlUI[2].children = {}

    local allObjects = getAllObjects()
    local minilist = {
        tag='VerticalLayout',
        attributes={id='scroll', minHeight='100', width='600', inertia=false, scrollSensitivity=4, color='#00000000', visibility='Black', rectAlignment='UpperCenter'},
        children = {
            {tag='VerticalLayout', attributes={childForceExpandHeight=false, contentSizeFitter='vertical', spacing='5', padding='5 5 5 5', visibility='Black', rectAlignment='UpperCenter'}, children={}}
        }
    }

    local creatureCount = 0
    for i, figure in ipairs(initFigures) do
        creatureCount = creatureCount + 1
        local c = figure.colorTint
        local color = '#'..string.format('%02x', math.ceil(c.r * 255))..string.format('%02x', math.ceil(c.g * 255))..string.format('%02x', math.ceil(c.b * 255))

        local colorVar = '#202020'
        if options.initCurrentGUID == figure.guidValue then
            colorVar = '#505050'
        elseif figure.player == true then
            colorVar = '#401010'
        end

        local extraText = ''
        local currentHealth = figure.health.value
        local maxHealth = figure.health.max
        local perc = (maxHealth == 0) and 0 or (currentHealth * 1.0) / (maxHealth * 1.0)
        if (perc <= 0) then
            extraText = ' (Dead)'
        elseif (perc <= 0.05) then
            extraText = ' (Deaths Door)'
        elseif (perc <= 0.25) then
            extraText = ' (Spicy)'
        elseif (perc <= 0.5) then
            extraText = ' (Bloody)'
        elseif (perc <= 0.75) then
            extraText = ' (Feeling it now Mr. Krabs?)'
        elseif (perc < 1.0) then
            extraText = ' (Healthy)'
        else
            extraText = ' (Untouched)'
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
                        preferredHeight = 60,
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
                                preferredHeight=60,
                                fontSize='32',
                                resizeTextForBestFit=true,
                                minWidth='113',
                                text=figure.initText
                            }
                        },
                        {
                            tag='panel',
                            attributes={
                                color=color,
                                preferredWidth = 10,
                                flexibleWidth = 0,
                                preferredHeight=60,
                                minWidth='10'
                            }
                        },
                        {
                            tag='text',
                            attributes={
                                id=figure.guidValue ..'_header_title',
                                alignment='MiddleLeft',
                                preferredHeight=60,
                                fontSize='32',
                                resizeTextForBestFit=true,
                                preferredWidth=10000,
                                text=extraText
                            }
                        },
                    }
                },
                {
                    tag='horizontallayout',
                    attributes={
                        preferredHeight=60,
                        childForceExpandHeight=false,
                        childForceExpandWidth=false,
                        spacing=5
                    },
                    children={
                        {
                            tag='InputField',
                            attributes={
                                id=figure.guidValue ..'_input_change',
                                preferredHeight='60',
                                preferredWidth='130',
                                flexibleWidth=0,
                                fontSize='38',
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
                                preferredHeight='60',
                                preferredWidth='130',
                                flexibleWidth=0,
                                fontSize='38',
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
                                preferredWidth='30',
                                preferredHeight='60',
                                flexibleWidth=0,
                                image='ui_arrow_l2',
                                onClick='barReduce'
                            }
                        },
                        {
                            tag='panel',
                            attributes={
                                preferredHeight='60',
                                preferredWidth='300'
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
                                preferredWidth='30',
                                preferredHeight='60',
                                image='ui_arrow_r2',
                                flexibleWidth=0,
                                onClick='barIncrease'
                            }
                        },
                        {
                            tag='InputField',
                            attributes={
                                id=figure.guidValue ..'_input_maximum',
                                preferredHeight='60',
                                preferredWidth='130',
                                fontSize='38',
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

    local calcHeight = 93 * creatureCount
    minilist.attributes.height = calcHeight..''
    minilist.attributes.minHeight = calcHeight..''
    table.insert(xmlUI[2].children, {
        tag='Defaults', children={
            {tag='Text', attributes={color='#cccccc', fontSize='15', alignment='MiddleLeft', visibility='Black'}},
            {tag='InputField', attributes={fontSize='15', preferredHeight='60', visibility='Black'}},
            {tag='ToggleButton', attributes={fontSize='15', preferredHeight='60', colors='#ffcc33|#ffffff|#808080|#606060', selectedBackgroundColor='#dddddd', deselectedBackgroundColor='#999999', visibility='Black'}},
            {tag='Button', attributes={fontSize='15', preferredHeight='60', colors='#dddddd|#ffffff|#808080|#606060', visibility='Black'}},
            {tag='Toggle', attributes={textColor='#cccccc', visibility='Black'}},
        }
    })
    table.insert(xmlUI[2].children, {tag='Panel', attributes={ height=calcHeight..'', width='790', rectAlignment='UpperCenter'},
        children={
            {tag='VerticalLayout', attributes={childForceExpandHeight=false, minHeight='0', spacing=10, rectAlignment='UpperCenter'}, children={
                {tag='HorizontalLayout', attributes={preferredHeight=80, childForceExpandWidth=false, flexibleHeight=0, spacing=20, padding='10 10 10 10'}, children={}},
                minilist
            }}
        }
    })
    self.UI.setXmlTable(xmlUI)
end

function updateFromGuid(guid)
    local token = getObjectFromGUID(guid)
    if (token ~= nil) then
        local extraText = ''
        local healthTable = token.getTable("health")
        local currentHealth = healthTable.value
        local maxHealth = healthTable.max
        local perc = (maxHealth == 0) and 0 or (currentHealth * 1.0) / (maxHealth * 1.0)
        if (perc <= 0) then
            extraText = ' (Dead)'
            local player = token.getVar("player")
            if player == false and options.initActive then
                Wait.frames(rollInitiative, 5)
            end
        elseif (perc <= 0.05) then
            extraText = ' (Deaths Door)'
        elseif (perc <= 0.25) then
            extraText = ' (Spicy)'
        elseif (perc <= 0.5) then
            extraText = ' (Bloody)'
        elseif (perc <= 0.75) then
            extraText = ' (Feeling it now Mr. Krabs?)'
        elseif (perc < 1.0) then
            extraText = ' (Healthy)'
        else
            extraText = ' (Untouched)'
        end
        local percMax = tonumber(perc * 100.0)
        self.UI.setAttribute(guid..'_header_title', 'text', striptags(token.getName())..extraText)
        self.UI.setAttribute(guid..'_input_current', 'text', currentHealth)
        self.UI.setAttribute(guid..'_bar', 'percentage', percMax)
        self.UI.setAttribute(guid..'_input_maximum', 'text', maxHealth)
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
    local token = getObjectFromGUID(guid)
    if token ~= nil then
        if value == "-1" then
            token.call('reduceHP')
        else
            token.call('adjustHP', -10)
        end
    end
end

function barIncrease(player, value, id)
    local guid = id:sub(1, -13)
    local token = getObjectFromGUID(guid)
    if token ~= nil then
        if value == "-1" then
            token.call('increaseHP')
        else
            token.call('adjustHP', 10)
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