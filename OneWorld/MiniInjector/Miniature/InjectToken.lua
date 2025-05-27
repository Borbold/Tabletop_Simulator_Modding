versionNumber = "4.7.9"
scaleMultiplierX = 1.0
scaleMultiplierY = 1.0
scaleMultiplierZ = 1.0
finishedLoading = false
calibratedOnce = false
debuggingEnabled = false
onUpdateTriggerCount = 0
onSaveFrameCount = 0
onUpdateScale = 1.0
onUpdateGridSize = 1.0
loadTime = 1.0
saveVersion = 1
a = {}
triggerNames = {}
showing = false
savedAttachScales = {}

health = {value = 10, max = 10}
mana = {value = 0, max = 0}
extra = {value = 0, max = 0}

statNames = {}
options = {
    HP2Desc = false,
    belowZero = false,
    aboveMax = false,
    heightModifier = 110,
    showBaseButtons = false,
    showBarButtons = false,
    hideHp = false,
    hideMana = true,
    hideExtra = true,
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
}

firstEdit = true

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

function resetInitiative()
    options.initSettingsValue = 100
    options.initRealActive = false
    options.initRealValue = 0
    options.initMockActive = false
    options.initMockValue = 0
    self.UI.setAttribute("InitValueInput", "text", options.initSettingsValue)
    updateSave()
end

function getInitiative(inputActive)
    if options.initRealActive == true then
        if debuggingEnabled then
            print(self.getName() .. ' init real cache ' .. options.initRealValue)
        end
        return options.initRealValue
    end
    if inputActive == true then
        options.initRealActive = true
        if options.initMockActive == true then
            options.initRealValue = options.initMockValue
        else
            options.initRealValue = calculateInitiative()
        end
        if debuggingEnabled then
            print(self.getName() .. ' init real calc' .. options.initRealValue)
        end
        updateSave()
        return options.initRealValue
    end
    if options.initMockActive == true then
        if debuggingEnabled then
            print(self.getName() .. ' init mock cache ' .. options.initMockValue)
        end
        return options.initMockValue
    end
    options.initMockActive = true
    options.initMockValue = calculateInitiative()
    if debuggingEnabled then
        print(self.getName() .. ' init mock calc ' .. options.initMockValue)
    end
    updateSave()
    return options.initMockValue
end

function calculateInitiative()
    if options.initSettingsRolling == true then
        return math.random(1,20) + tonumber(options.initSettingsMod)
    else
        return tonumber(options.initSettingsValue)
    end
end

function updateSave()
    if onSaveFrameCount > 0 then
        onSaveFrameCount = 120
        return
    end
    onSaveFrameCount = 120
    startLuaCoroutine(self, "updateSaveActual")
end

function updateSaveActual()
    while onSaveFrameCount > 0 do
        onSaveFrameCount = onSaveFrameCount - 1
        coroutine.yield(0)
    end
    saveVersion = saveVersion + 1
    if debuggingEnabled then
        print(self.getName() .. " saving, version " .. saveVersion .. ".")
    end
    local encodedAttachScales = {}
    if #savedAttachScales > 0 then
        for _, scaleVector in ipairs(savedAttachScales) do
            table.insert(encodedAttachScales, {x=scaleVector.x, y=scaleVector.y, z=scaleVector.z})
        end
    end
    self.script_state = JSON.encode({
        scale_multiplier_x = scaleMultiplierX,
        scale_multiplier_y = scaleMultiplierY,
        scale_multiplier_z = scaleMultiplierZ,
        calibrated_once = calibratedOnce,
        health = health,
        mana = mana,
        extra = extra,
        options = options,
        encodedAttachScales = encodedAttachScales,
        statNames = statNames,
        player = player,
        measureMove = measureMove,
        alternateDiag = alternateDiag,
        metricMode = metricMode,
        stabilizeOnDrop = stabilizeOnDrop,
        miniHighlight = miniHighlight,
        highlightToggle = highlightToggle,
        hideFromPlayers = hideFromPlayers,
        saveVersion = saveVersion,
        xml = xml
    })
    return 1
end

function onLoad_helper(save_state)
    if stabilizeOnDrop == true and self.held_by_color == nil then
        stabilize()
    end
    local saved_data = nil
    local my_saved_data = nil
    local bestVersion = 0
    if save_state ~= "" then
        saved_data = JSON.decode(save_state)
        my_saved_data = saved_data
        if saved_data.saveVersion ~= nil then
            bestVersion = saved_data.saveVersion
        end
    end
    -- ALRIGHTY, let's see which state data we need to use
    states = self.getStates()
    if states ~= nil then
        for _, s in pairs(states) do
            test_data = JSON.decode(s.lua_script_state)
            if test_data ~= nil and test_data.saveVersion ~= nil and test_data.saveVersion > bestVersion then
                saved_data = test_data
                bestVersion = test_data.saveVersion
            end
        end
    end
    if debuggingEnabled then
        print(self.getName() .. " best version: " .. bestVersion)
    end
    if saved_data ~= nil then
        if saved_data.health then
            for heal,_ in pairs(health) do
                health[heal] = saved_data.health[heal]
            end
        end
        if saved_data.mana then
            for res,_ in pairs(mana) do
                mana[res] = saved_data.mana[res]
            end
        end
        if saved_data.extra then
            for res,_ in pairs(extra) do
                extra[res] = saved_data.extra[res]
            end
        end
        if saved_data.options then
            for opt,_ in pairs(options) do
                if saved_data.options[opt] ~= nil then
                    options[opt] = saved_data.options[opt]
                end
            end
        end
        if saved_data.encodedAttachScales then
            for _,encodedScale in pairs(saved_data.encodedAttachScales) do
                if debuggingEnabled then
                    print("loaded vector: " .. encodedScale.x .. ", " .. encodedScale.y .. ", " .. encodedScale.z)
                end
                table.insert(savedAttachScales, vector(encodedScale.x, encodedScale.y, encodedScale.z))
            end
        end
        if saved_data.statNames then
            statNames = deepCopy(saved_data.statNames)
        end
        -- Check if we need to override the scale calibration
        -- This state's calibration takes precedence over other states
        if my_saved_data ~= nil and my_saved_data.calibrated_once == true then
            saved_data.calibrated_once = my_saved_data.calibrated_once
            saved_data.scale_multiplier_x = my_saved_data.scale_multiplier_x
            saved_data.scale_multiplier_y = my_saved_data.scale_multiplier_y
            saved_data.scale_multiplier_z = my_saved_data.scale_multiplier_z
            if my_saved_data.options ~= nil then
                options["heightModifier"] = my_saved_data.options["heightModifier"]
            end
        end
        if saved_data.scale_multiplier_x ~= nil then
            scaleMultiplierX = saved_data.scale_multiplier_x
        end
        if saved_data.scale_multiplier_y ~= nil then
            scaleMultiplierY = saved_data.scale_multiplier_y
        end
        if saved_data.scale_multiplier_z ~= nil then
            scaleMultiplierZ = saved_data.scale_multiplier_z
        end
        if saved_data.calibrated_once ~= nil then
            calibratedOnce = saved_data.calibrated_once
        end
        player = saved_data.player and saved_data.player or false
        measureMove = saved_data.measureMove and saved_data.measureMove or false
        alternateDiag = saved_data.alternateDiag and saved_data.alternateDiag or false
        metricMode = saved_data.metricMode and saved_data.metricMode or false
        stabilizeOnDrop = saved_data.stabilizeOnDrop and saved_data.stabilizeOnDrop or false
        miniHighlight = saved_data.miniHighlight and saved_data.miniHighlight or "highlightNone"
        highlightToggle = saved_data.highlightToggle and saved_data.highlightToggle or true
        hideFromPlayers = (saved_data.hideFromPlayers and player == false) and saved_data.hideFromPlayers or false
        if saved_data.saveVersion ~= nil then
            saveVersion = saved_data.saveVersion
            if debuggingEnabled then
                print(self.getName() .. " loading, version " .. saveVersion .. ".")
            end
        end
        xml = saved_data.xml and saved_data.xml or ""
        self.UI.setXml(saved_data.xml and saved_data.xml or "")
    end
    className = "InjectTokenMini"
    Wait.time(|| loadStageTwo(), 0.5)
    finishedLoading = true
    return 1
end

function loadStageTwo()
    self.UI.setAttribute("panel", "position", "0 0 -" .. self.getBounds().size.y / self.getScale().y * options.heightModifier)
    self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
    self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
    self.UI.setAttribute("progressBarS", "percentage", mana.value / mana.max * 100)
    self.UI.setAttribute("manaText", "text", mana.value .. "/" .. mana.max)
    self.UI.setAttribute("extraProgress", "percentage", extra.value / extra.max * 100)
    self.UI.setAttribute("extraText", "text", extra.value .. "/" .. extra.max)
    self.UI.setAttribute("manaText", "textColor", "#FFFFFF")
    self.UI.setAttribute("increment", "text", options.incrementBy)
    self.UI.setAttribute("InitModInput", "text", options.initSettingsMod)
    self.UI.setAttribute("InitValueInput", "text", options.initSettingsValue)

    for i,j in pairs(statNames) do
        if j == true then
            self.UI.setAttribute(i, "active", true)
        end
    end
    
    self.UI.setAttribute("statePanel", "width", getStatsCount()*300)
    if options.showBarButtons == true then
        self.UI.setAttribute("addSub", "active", true)
        self.UI.setAttribute("addSubS", "active", true)
        self.UI.setAttribute("addSubE", "active", true)
    end

    if health.max == 0 then
        options.hideHp = true
    end
    if mana.max == 0 then
        options.hideMana = true
    end
    if extra.max == 0 then
        options.hideExtra = true
    end

    self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "True" or "False")

    self.UI.setAttribute("resourceBar", "active", options.hideHp == true and "False" or "True")
    self.UI.setAttribute("resourceBarS", "active", options.hideMana == true and "False" or "True")
    self.UI.setAttribute("extraBar", "active", options.hideExtra == true and "False" or "True")

    self.UI.setAttribute("addSub", "active", options.showBarButtons == true and "True" or "False")
    self.UI.setAttribute("addSubS", "active", options.showBarButtons == true and "True" or "False")
    self.UI.setAttribute("addSubE", "active", options.showBarButtons == true and "True" or "False")
    self.UI.setAttribute("panel", "rotation", options.rotation .. " 270 90")

    self.UI.setAttribute("PlayerCharToggle", "textColor", player == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("MeasureMoveToggle", "textColor", measureMove == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("MetricModeToggle", "textColor", metricMode == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("StabilizeToggle", "textColor", stabilizeOnDrop == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("HH", "textColor", options.hideHp == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("HM", "textColor", options.hideMana == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("HE", "textColor", options.hideExtra == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("HB", "textColor", options.showBarButtons == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("BZ", "textColor", options.belowZero == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("AM", "textColor", options.aboveMax == true and "#AA2222" or "#FFFFFF")

    self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#AA2222" or "#FFFFFF")
    self.UI.setAttribute("InitiativeRollingToggle", "textColor", options.initSettingsRolling == true and "#AA2222" or "#FFFFFF")

    -- Look for the mini injector, if available
    local allObjects = getAllObjects()
    for _, obj in ipairs(allObjects) do
        if obj ~= self and obj ~= nil then
            local typeCheck = obj.getVar("className")
            if typeCheck == "MiniInjector" then
                autoCalibrate = obj.getVar("autoCalibrateEnabled")
                if autoCalibrate == true then
                    calibrateScale()
                end
                -- grab ui settings
                local injOptions = obj.getTable("options")
                alternateDiag = injOptions.alternateDiag
                self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag == true and "#AA2222" or "#FFFFFF")
                metricMode = injOptions.metricMode
                self.UI.setAttribute("MetricModeToggle", "textColor", metricMode == true and "#AA2222" or "#FFFFFF")
                if player == true then
                    self.UI.setAttribute("progressBar", "visibility", "")
                    self.UI.setAttribute("progressBarS", "visibility", "")
                    self.UI.setAttribute("extraProgress", "visibility", "")
                    self.UI.setAttribute("hpText", "visibility", "")
                    self.UI.setAttribute("manaText", "visibility", "")
                    self.UI.setAttribute("extraText", "visibility", "")
                    self.UI.setAttribute("addSub", "visibility", "")
                    self.UI.setAttribute("addSubS", "visibility", "")
                    self.UI.setAttribute("addSubE", "visibility", "")
                    self.UI.setAttribute("editPanel", "visibility", "")
                    self.UI.setAttribute("leftSide1", "visibility", "")
                    self.UI.setAttribute("editButton0", "visibility", "")
                    self.UI.setAttribute("editButton1", "visibility", "")
                    self.UI.setAttribute("editButtonS1", "visibility", "")
                    self.UI.setAttribute("leftSide2", "visibility", "")
                    self.UI.setAttribute("editButton2", "visibility", "")
                    self.UI.setAttribute("editButtonS2", "visibility", "")
                    self.UI.setAttribute("leftSide3", "visibility", "")
                    self.UI.setAttribute("editButton3", "visibility", "")
                    self.UI.setAttribute("editButtonS3", "visibility", "")
                else
                    if injOptions.hideBar == true then
                        self.UI.setAttribute("progressBar", "visibility", "Black")
                        self.UI.setAttribute("progressBarS", "visibility", "Black")
                        self.UI.setAttribute("extraProgress", "visibility", "Black")
                    else
                        self.UI.setAttribute("progressBar", "visibility", "")
                        self.UI.setAttribute("progressBarS", "visibility", "")
                        self.UI.setAttribute("extraProgress", "visibility", "")
                    end
                    if injOptions.hideText == true then
                        self.UI.setAttribute("hpText", "visibility", "Black")
                        self.UI.setAttribute("manaText", "visibility", "Black")
                        self.UI.setAttribute("extraText", "visibility", "Black")
                    else
                        self.UI.setAttribute("hpText", "visibility", "")
                        self.UI.setAttribute("manaText", "visibility", "")
                        self.UI.setAttribute("extraText", "visibility", "")
                    end
                    if injOptions.editText == true then
                        self.UI.setAttribute("addSub", "visibility", "Black")
                        self.UI.setAttribute("addSubS", "visibility", "Black")
                        self.UI.setAttribute("addSubE", "visibility", "Black")
                        self.UI.setAttribute("editPanel", "visibility", "Black")
                    else
                        self.UI.setAttribute("addSub", "visibility", "")
                        self.UI.setAttribute("addSubS", "visibility", "")
                        self.UI.setAttribute("addSubE", "visibility", "")
                        self.UI.setAttribute("editPanel", "visibility", "")
                    end
                    self.UI.setAttribute("panel", "active", injOptions.showAll == true and "true" or "false")
                    self.UI.setAttribute("editButton0", "visibility", "Black")
                    self.UI.setAttribute("leftSide1", "visibility", "Black")
                    self.UI.setAttribute("editButton1", "visibility", "Black")
                    self.UI.setAttribute("editButtonS1", "visibility", "Black")
                    self.UI.setAttribute("leftSide2", "visibility", "Black")
                    self.UI.setAttribute("editButton2", "visibility", "Black")
                    self.UI.setAttribute("editButtonS2", "visibility", "Black")
                    self.UI.setAttribute("leftSide3", "visibility", "Black")
                    self.UI.setAttribute("editButton3", "visibility", "Black")
                    self.UI.setAttribute("editButtonS3", "visibility", "Black")
                end
            end
        end
    end

    rebuildContextMenu()

    updateHighlight()

    self.auto_raise = true
    self.interactable = true

    onUpdateScale = 1.0
    onUpdateGridSize = 1.0
    loadTime = os.clock()

    instantiateTriggers()

    if hideFromPlayers then
        aColors = Player.getAvailableColors()
        for k, v in ipairs(aColors) do
            if v == "Black" or v == "Grey" or v == "White" then
                table.remove(aColors, k)
            end
        end
        table.insert(aColors, "Grey")
        table.insert(aColors, "White")
        if debuggingEnabled then
            print(self.getName() .. " gone.")
        end
        self.setInvisibleTo(aColors)
    end

    updateSave()

    autoFogOfWarReveal()

    return 1
end

function onLoad(save_state)
    Wait.time(|| onLoad_helper(save_state), 0.2)
    WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/OneWorld/MiniInjector/Miniature/MoveToken.lua",
        function(request)
            moveMiniLua = request.text
        end
    )
end

function onObjectSpawn(object)
    if object.type == "FogOfWar" then
        Wait.time(function() autoFogOfWarReveal() end, 5)
    end
end

function afowr_helper()
    coroutine.yield(0)
    self.ignore_fog_of_war = true
    self.ignore_fog_of_war = false
    coroutine.yield(0)
    self.ignore_fog_of_war = true
    self.ignore_fog_of_war = false
    return 1
end
function autoFogOfWarReveal()
    if player == true then
        startLuaCoroutine(self, "afowr_helper")
    end
end

function instantiateTriggers()
    for i = 0, 99 do
        triggerNames[i] = nil
        if self.AssetBundle ~= nil and self.AssetBundle.getTriggerEffects() ~= nil and self.AssetBundle.getTriggerEffects()[i] ~= nil then
            a[i] = false
            triggerNames[i] = self.AssetBundle.getTriggerEffects()[i].name
            _G["TriggerFunction" .. i] = function()
                self.AssetBundle.playTriggerEffect(i - 1)
            end
        end
    end
end

function onPlayerConnect(player)
    -- Wait 30 seconds for them to load fully.
    Wait.time(updateHighlight, 30)
end

function changeHighlight(player, value, id)
    miniHighlight = id
    highlightToggle = true
    updateHighlight(miniHighlight)
end

function toggleHighlight(player, value, id)
    highlightToggle = not highlightToggle
    updateHighlight()
end

function updateHighlight()
    if highlightToggle == false then
        self.highlightOff()
    elseif miniHighlight == "highlightNone" then
        self.highlightOff()
    elseif miniHighlight == "highlightWhite" then
        self.highlightOn(Color.White)
    elseif miniHighlight == "highlightBrown" then
        self.highlightOn(Color.Brown)
    elseif miniHighlight == "highlightRed" then
        self.highlightOn(Color.Red)
    elseif miniHighlight == "highlightOrange" then
        self.highlightOn(Color.Orange)
    elseif miniHighlight == "highlightYellow" then
        self.highlightOn(Color.Yellow)
    elseif miniHighlight == "highlightGreen" then
        self.highlightOn(Color.Green)
    elseif miniHighlight == "highlightTeal" then
        self.highlightOn(Color.Teal)
    elseif miniHighlight == "highlightBlue" then
        self.highlightOn(Color.Blue)
    elseif miniHighlight == "highlightPurple" then
        self.highlightOn(Color.Purple)
    elseif miniHighlight == "highlightPink" then
        self.highlightOn(Color.Pink)
    elseif miniHighlight == "highlightBlack" then
        self.highlightOn(Color.Black)
    end
    updateSave()
end

function onUpdate()
    onUpdateTriggerCount = onUpdateTriggerCount + 1
    if onUpdateTriggerCount > 60 then
        onUpdateTriggerCount = 0
        if finishedLoading == true and onUpdateScale ~= self.getScale().y then
            local newScale = dec3(0.3 * (1.0 / self.getScale().y))
            self.UI.setAttribute("panel", "scale", newScale .. " " .. newScale)
            self.UI.setAttribute("panel", "position", "0 0 -" .. (options.heightModifier + 1))
            self.UI.setAttribute("panel", "position", "0 0 -" .. options.heightModifier)
            local vertical = 0
            vertical = vertical + (options.hideHp == true and 0 or 100)
            vertical = vertical + (options.hideMana == true and 0 or 100)
            vertical = vertical + (options.hideExtra == true and 0 or 100)
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "True" or "False")
            self.UI.setAttribute("resourceBar", "active", options.hideHp == true and "False" or "True")
            self.UI.setAttribute("resourceBarS", "active", options.hideMana == true and "False" or "True")
            self.UI.setAttribute("extraBar", "active", options.hideExtra == true and "False" or "True")
            self.UI.setAttribute("bars", "height", vertical)
            onUpdateScale = self.getScale().y
            updateSave()
        end
        if finishedLoading == true and onUpdateGridSize ~= Grid.sizeX then
            resetScale()
        end
    end
end

function dec3(input)
    return math.floor(input * 1000.0) / 1000.0
end

function rebuildContextMenu()
    self.clearContextMenu()
    self.addContextMenuItem("UI Height UP", uiHeightUp, true)
    self.addContextMenuItem("UI Height DOWN", uiHeightDown, true)
    self.addContextMenuItem("UI Rotate 90", uiRotate90, true)
    if hideFromPlayers == true then
        self.addContextMenuItem("[X] Hide from players", toggleHideFromPlayers)
    else
        self.addContextMenuItem("[ ] Hide from players", toggleHideFromPlayers)
    end
    if calibratedOnce == true then
        self.addContextMenuItem("[X] Calibrate Scale", calibrateScale)
    else
        self.addContextMenuItem("[ ] Calibrate Scale", calibrateScale)
    end
    self.addContextMenuItem("Reset Scale", resetScale)
    self.addContextMenuItem("Reload Mini", function() self.reload() end)
    if debuggingEnabled == true then
        self.addContextMenuItem("[X] Debugging", toggleDebug)
    else
        self.addContextMenuItem("[ ] Debugging", toggleDebug)
    end
end

function uiHeightUp()
    options.heightModifier = options.heightModifier + 50
    self.UI.setAttribute("panel", "position", "0 0 -" .. options.heightModifier)
    updateSave()
end

function uiHeightDown()
    options.heightModifier = options.heightModifier - 50
    self.UI.setAttribute("panel", "position", "0 0 -" .. options.heightModifier)
    updateSave()
end

function uiRotate90()
    options.rotation = options.rotation + 90
    self.UI.setAttribute("panel", "rotation", options.rotation .. " 270 90")
    updateSave()
end

function toggleDebug()
    debuggingEnabled = not debuggingEnabled
    rebuildContextMenu()
    updateSave()
end

function toggleHideFromPlayers()
    if player == true and hideFromPlayers == false then
        print(self.getName() .. " is a player character, cannot hide.")
        return
    end
    hideFromPlayers = not hideFromPlayers
    if hideFromPlayers then
        aColors = Player.getAvailableColors()
        for k, v in ipairs(aColors) do
            if v == "Black" or v == "Grey" or v == "White" then
                table.remove(aColors, k)
            end
        end
        table.insert(aColors, "Grey")
        table.insert(aColors, "White")
        if debuggingEnabled then
            print(self.getName() .. " gone.")
        end
        self.setInvisibleTo(aColors)
        -- If the object has attachments, make them invisible too
        myAttach = self.removeAttachments()
        if #myAttach > 0 then
            savedAttachScales = {}
            if debuggingEnabled then
                print(self.getName() .. " has attach.")
            end
            for _, attachObj in ipairs(myAttach) do
                if debuggingEnabled then
                    print(attachObj.getName() .. " gone.")
                end
                --attachObj.setInvisibleTo(aColors)
                table.insert(savedAttachScales, attachObj.getScale())
                attachObj.setScale(vector(0, 0, 0))
                self.addAttachment(attachObj)
            end
        end
    else
        if debuggingEnabled then
            print(self.getName() .. " back.")
        end
        self.setInvisibleTo({})
        -- If the object has attachments, make them visible too
        myAttach = self.removeAttachments()
        if #myAttach > 0 then
            if debuggingEnabled then
                print(self.getName() .. " has attach.")
            end
            for attachIndex, attachObj in ipairs(myAttach) do
                if debuggingEnabled then
                    print(attachObj.getName() .. " back.")
                end
                attachObj.setScale(savedAttachScales[attachIndex])
                self.addAttachment(attachObj)
            end
        end
        savedAttachScales = {}
    end
    rebuildContextMenu()
    updateSave()
end

function togglePlayer()
    player = not player
    autoFogOfWarReveal()
    self.UI.setAttribute("PlayerCharToggle", "textColor", player == true and "#AA2222" or "#FFFFFF")
    if player == true then
        resetInitiative()
    end
    if player == true and hideFromPlayers == true then
        toggleHideFromPlayers()
    end
    Wait.time(loadStageTwo(), 0.2)
    updateSave()
end

function toggleMeasure()
    measureMove = not measureMove
    self.UI.setAttribute("MeasureMoveToggle", "textColor", measureMove == true and "#AA2222" or "#FFFFFF")
    updateSave()
end

function toggleAlternateDiag(thePlayer1)
    local myPlayer = thePlayer1
    local function tad_Helper(thePlayer2)
        -- Look for the mini injector, if available
        local allObjects = getAllObjects()
        for _, obj in ipairs(allObjects) do
            if obj ~= self and obj ~= nil then
                local typeCheck = obj.getVar("className")
                if typeCheck == "MiniInjector" then
                    local injOptions = obj.getTable("options")
                    alternateDiag = injOptions.alternateDiag
                    self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag == true and "#AA2222" or "#FFFFFF")
                    if thePlayer2 ~= nil then
                        broadcastToAll("Injector is present. Use the injector to toggle measurement style.", thePlayer2.color)
                    end
                    updateSave()
                    return
                end
            end
        end
        alternateDiag = not alternateDiag
        self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag == true and "#AA2222" or "#FFFFFF")
        updateSave()
    end
    Wait.frames(function() tad_Helper(myPlayer) end, 30)
end

function toggleMetricMode(thePlayer1)
    local myPlayer = thePlayer1
    local function tmm_Helper(thePlayer2)
        -- Look for the mini injector, if available
        local allObjects = getAllObjects()
        for _, obj in ipairs(allObjects) do
            if obj ~= self and obj ~= nil then
                local typeCheck = obj.getVar("className")
                if typeCheck == "MiniInjector" then
                    local injOptions = obj.getTable("options")
                    metricMode = injOptions.metricMode
                    self.UI.setAttribute("MetricModeToggle", "textColor", metricMode == true and "#AA2222" or "#FFFFFF")
                    if thePlayer2 ~= nil then
                        broadcastToAll("Injector is present. Use the injector to toggle metric mode.", thePlayer2.color)
                    end
                    updateSave()
                    return
                end
            end
        end
        metricMode = not metricMode
        self.UI.setAttribute("MetricModeToggle", "textColor", metricMode == true and "#AA2222" or "#FFFFFF")
        updateSave()
    end
    Wait.frames(function() tmm_Helper(myPlayer) end, 30)
end

function toggleStabilizeOnDrop()
    stabilizeOnDrop = not stabilizeOnDrop
    self.UI.setAttribute("StabilizeToggle", "textColor", stabilizeOnDrop == true and "#AA2222" or "#FFFFFF")
    updateSave()
end

function toggleInitiativeInclude()
    options.initSettingsIncluded = not options.initSettingsIncluded
    if options.initSettingsIncluded == false then
        options.initRealActive = false
        options.initRealValue = 0
        options.initMockActive = false
        options.initMockValue = 0
    end
    self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#AA2222" or "#FFFFFF")
    updateSave()
end

function toggleInitiativeRolling()
    options.initSettingsRolling = not options.initSettingsRolling
    if options.initSettingsRolling == true then
        options.initRealActive = false
        options.initRealValue = 0
        options.initMockActive = false
        options.initMockValue = 0
    end
    self.UI.setAttribute("InitiativeRollingToggle", "textColor", options.initSettingsRolling == true and "#AA2222" or "#FFFFFF")
    updateSave()
end

function calibrateScale()
    currentScale = self.getScale()
    scaleMultiplierX = currentScale.x / Grid.sizeX
    scaleMultiplierY = currentScale.y / Grid.sizeX
    scaleMultiplierZ = currentScale.z / Grid.sizeX
    calibratedOnce = true
    if debuggingEnabled then
        print(self.getName() .. ": Calibrated scale with reference to grid.")
    end
    rebuildContextMenu()
    updateSave()
end

function resetScale()
    if calibratedOnce == false then
        if debuggingEnabled == true then
            print(self.getName() .. ": Mini not calibrated to grid yet.")
        end
        return
    end
    newScaleX = Grid.sizeX * scaleMultiplierX
    newScaleY = Grid.sizeX * scaleMultiplierY
    newScaleZ = Grid.sizeX * scaleMultiplierZ
    if debuggingEnabled == true then
        print(self.getName() .. ": Reset scale with reference to grid.")
    end
    scaleVector = vector(newScaleX, newScaleY, newScaleZ)
    self.setScale(scaleVector)
    onUpdateGridSize = Grid.sizeX
    updateSave()
end

function onRotate(spin, flip, player_color, old_spin, old_flip)
    if flip ~= old_flip then
        destabilize()
        if stabilizeOnDrop == true then
            local object = self
            local timeWaiting = os.clock() + 0.26
            local rotateWatch = function()
                if object == nil or object.resting then
                    return true
                end
                local currentRotation = object.getRotation()
                local rotationTarget = object.getRotationSmooth()
                return os.clock() > timeWaiting and (rotationTarget == nil or currentRotation:angle(rotationTarget) < 0.5)
            end
            local rotateFunc = function()
                if object == nil then
                    return
                end
                if stabilizeOnDrop == true then
                    if debuggingEnabled == true then
                        print(self.getName() .. ": Stabilizing after rotation.")
                    end
                    stabilize()
                end
            end
            Wait.condition(rotateFunc, rotateWatch)
        end
    end
end

function onPickUp(pcolor)
    destabilize()
    if measureMove == true and hideFromPlayers == false and finishedLoading == true then
        createMoveToken(pcolor, self)
    end
end

function onDrop(dcolor)
    if stabilizeOnDrop == true then
        stabilize()
    end
    if measureMove == true then
        destroyMoveToken()
    end
end

function stabilize()
    if debuggingEnabled == true then
        print(self.getName() .. ": stabilizing.")
    end
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", true)
end

function destabilize()
    if debuggingEnabled == true then
        print(self.getName() .. ": de-stabilizing.")
    end
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", false)
end

function destroyMoveToken()
    if string.match(tostring(myMoveToken),"Custom") then
        destroyObject(myMoveToken)
    end
end

function createMoveToken(mcolor, mtoken)
    destroyMoveToken()
    if finishedLoading == false then
        return
    end
    tokenRot = Player[mcolor].getPointerRotation()
    movetokenparams = {
        image = "https://steamusercontent-a.akamaihd.net/ugc/1868444108696929152/648A17F99D67FE9DDEBDED3A83E6E8B72A9ACCDB/",
        thickness = 0.1,
        type = 2
    }
    startloc = mtoken.getPosition()
    local hitList = Physics.cast({
        origin       = mtoken.getBounds().center,
        direction    = {0,-1,0},
        type         = 1,
        max_distance = 10,
        debug        = false,
    })
    for _, hitTable in ipairs(hitList) do
        -- Find the first object directly below the mini
        if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= mtoken then
            startloc = hitTable.point
            break
        else
            if debuggingEnabled == true then
                print("Did not find object below mini.")
            end
        end
    end
    tokenScale = {
        x= Grid.sizeX / 2.2,
        y= 0.1,
        z= Grid.sizeX / 2.2
    }
    spawnparams = {
        type = "Custom_Tile",
        position = startloc,
        rotation = {x = 0, y = tokenRot, z = 0},
        scale = tokenScale,
        sound = false
    }
    local moveToken = spawnObject(spawnparams)
    moveToken.setLock(true)
    moveToken.setCustomObject(movetokenparams)
    mtoken.setVar("myMoveToken", moveToken)
    moveToken.setVar("move_targetObject", mtoken)
    moveToken.setVar("myPlayer", mcolor)
    moveToken.setVar("alternateDiag", alternateDiag)
    moveToken.setVar("metricMode", metricMode)
    moveToken.setVar("className", "DNDMiniInjector_Mini_Move")
    moveToken.ignore_fog_of_war = player
    moveToken.interactable = false
    moveToken.setLuaScript(moveMiniLua)
end

function reduceHP()
    adjustHP(-1)
end

function increaseHP()
    adjustHP(1)
end

function adjustHP(difference)
    local intDiff = tonumber(difference)
    health.value = health.value + intDiff
    if health.value > health.max and not options.aboveMax then health.value = health.max end
    if health.value < 0 and not options.belowZero then health.value = 0 end
    if player == false and health.value <= 0 and options.initSettingsIncluded == true and options.initRealActive == true then
        options.initSettingsIncluded = false
        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#AA2222" or "#FFFFFF")
        miniHighlight = "highlightNone"
        updateHighlight()
    end
    self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
    self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
    updateRollers()
    updateSave()
end

function setHP(newHP)
    local intNewHP = tonumber(newHP)
    health.value = intNewHP
    if health.value > health.max and not options.aboveMax then health.value = health.max end
    if health.value < 0 and not options.belowZero then health.value = 0 end
    if player == false and health.value <= 0 and options.initSettingsIncluded == true and options.initRealActive == true then
        options.initSettingsIncluded = false
        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#AA2222" or "#FFFFFF")
        miniHighlight = "highlightNone"
        updateHighlight()
    end
    self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
    self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
    updateRollers()
    updateSave()
end

function setHPMax(newHPMax)
    local intNewHPMax = tonumber(newHPMax)
    if (intNewHPMax < 0) then
      intNewHPMax = 0
    end
    if (health.value > health.max) then
      health.value = health.max
    end
    health.max = intNewHPMax
    if health.value > health.max and not options.aboveMax then health.value = health.max end
    if health.value < 0 and not options.belowZero then health.value = 0 end
    if player == false and health.value <= 0 and options.initSettingsIncluded == true and options.initRealActive == true then
        options.initSettingsIncluded = false
        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#AA2222" or "#FFFFFF")
    end
    self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
    self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
    updateRollers()
    updateSave()
end

function updateRollers()
    local allObjects = getAllObjects()
    for _, obj in ipairs(allObjects) do
        local className = obj.getVar("className")
        if className == "MiniInjector" then
            obj.call("updateFromGuid", self.guid)
        end
    end
end

function onEndEdit(player, value, id)
    if id == "increment" then
        options.incrementBy = tonumber(value)
        self.UI.setAttribute("increment", "text", options.incrementBy)
    elseif id == "InitModInput" then
        options.initSettingsMod = tonumber(value)
        self.UI.setAttribute("InitModInput", "text", options.initSettingsMod)
    elseif id == "InitValueInput" then
        options.initSettingsValue = tonumber(value)
        options.initRealActive = false
        options.initRealValue = 0
        options.initMockActive = false
        options.initMockValue = 0
        self.UI.setAttribute("InitValueInput", "text", options.initSettingsValue)
        if self.getVar("player") == true then
            broadcastToAll(self.getName() .. " set initiative " .. options.initSettingsValue .. ".", player.color)
        end
    end
    updateSave()
end

function onClickEx(params)
    onClick(params.player, params.value, params.id)
end

function add() onClick(-1, - 1, "add") end
function sub() onClick(-1, - 1, "sub") end

function onClick(player_in, value, id)
    if id == "leftSide1" or id == "leftSide2" or id == "leftSide3" then
        if showing ~= true then
            showAllButtons()
        else
            self.clearButtons()
            showing = false
        end
    elseif id == "editButton0" or id == "editButton1" or id == "editButton2" or id == "editButton3" then
        if firstEdit == true or self.UI.getAttribute("editPanel", "active") == "False" or self.UI.getAttribute("editPanel", "active") == nil then
            self.UI.setAttribute("editPanel", "active", true)
            self.UI.setAttribute("statePanel", "active", false)
            firstEdit = false
        else
            self.UI.setAttribute("editPanel", "active", false)
            self.UI.setAttribute("statePanel", "active", true)
        end
    elseif id == "subHeight" or id == "addHeight" then
        if id == "addHeight" then
            options.heightModifier = options.heightModifier + getIncrement(value)
        else
            options.heightModifier = options.heightModifier - getIncrement(value)
        end
        self.UI.setAttribute("panel", "position", "0 0 -" .. options.heightModifier)
    elseif id == "subRotation" or id == "addRotation" then
        if id == "addRotation" then
            options.rotation = options.rotation + getIncrement(value)
        else
            options.rotation = options.rotation - getIncrement(value)
        end
        self.UI.setAttribute("panel", "rotation", options.rotation .. " 270 90")
    elseif id == "HH" then
        options.hideHp = not options.hideHp
        local vertical = self.UI.getAttribute("bars", "height")
        Wait.frames(function()
            self.UI.setAttribute("HH", "textColor", options.hideHp == true and "#AA2222" or "#FFFFFF")
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "True" or "False")
            self.UI.setAttribute("resourceBar", "active", options.hideHp == true and "False" or "True")
            self.UI.setAttribute("bars", "height", vertical + (options.hideHp == true and -100 or 100))
        end, 1)
    elseif id == "HM" then
        options.hideMana = not options.hideMana
        local vertical = self.UI.getAttribute("bars", "height")
        Wait.frames(function()
            self.UI.setAttribute("HM", "textColor", options.hideMana == true and "#AA2222" or "#FFFFFF")
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "True" or "False")
            self.UI.setAttribute("resourceBarS", "active", options.hideMana == true and "False" or "True")
            self.UI.setAttribute("bars", "height", vertical + (options.hideMana == true and -100 or 100))
        end, 1)
    elseif id == "HE" then
        options.hideExtra = not options.hideExtra
        local vertical = self.UI.getAttribute("bars", "height")
        Wait.frames(function()
            self.UI.setAttribute("HE", "textColor", options.hideExtra == true and "#AA2222" or "#FFFFFF")
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "True" or "False")
            self.UI.setAttribute("extraBar", "active", options.hideExtra == true and "False" or "True")
            self.UI.setAttribute("bars", "height", vertical + (options.hideExtra == true and -100 or 100))
        end, 1)
    elseif id == "HB" or id == "editButtonS1" or id == "editButtonS2" or id == "editButtonS3" then
        if options.showBarButtons then
            self.UI.setAttribute("addSub", "active", false)
            self.UI.setAttribute("addSubS", "active", false)
            self.UI.setAttribute("addSubE", "active", false)
            options.showBarButtons = false
        else
            self.UI.setAttribute("addSub", "active", true)
            self.UI.setAttribute("addSubS", "active", true)
            self.UI.setAttribute("addSubE", "active", true)
            options.showBarButtons = true
        end
        self.UI.setAttribute("HB", "textColor", options.showBarButtons == true and "#AA2222" or "#FFFFFF")
    elseif id == "BZ" then
        options.belowZero = not options.belowZero
        self.UI.setAttribute("BZ", "textColor", options.belowZero == true and "#AA2222" or "#FFFFFF")
        if health.value > health.max and not options.aboveMax then health.value = health.max end
        if health.value < 0 and not options.belowZero then health.value = 0 end
        if mana.value > mana.max and not options.aboveMax then mana.value = mana.max end
        if mana.value < 0 and not options.belowZero then mana.value = 0 end
        if extra.value > extra.max and not options.aboveMax then extra.value = extra.max end
        if extra.value < 0 and not options.belowZero then extra.value = 0 end
        self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
        self.UI.setAttribute("progressBarS", "percentage", mana.value / mana.max * 100)
        self.UI.setAttribute("extraProgress", "percentage", extra.value / extra.max * 100)
        self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
        self.UI.setAttribute("manaText", "text", mana.value .. "/" .. mana.max)
        self.UI.setAttribute("extraText", "text", extra.value .. "/" .. extra.max)
        if options.HP2Desc then
            self.setDescription(health.value .. "/" .. health.max)
        end
        updateRollers()
    elseif id == "AM" then
        options.aboveMax = not options.aboveMax
        self.UI.setAttribute("AM", "textColor", options.aboveMax == true and "#AA2222" or "#FFFFFF")
        if health.value > health.max and not options.aboveMax then health.value = health.max end
        if health.value < 0 and not options.belowZero then health.value = 0 end
        if mana.value > mana.max and not options.aboveMax then mana.value = mana.max end
        if mana.value < 0 and not options.belowZero then mana.value = 0 end
        if extra.value > extra.max and not options.aboveMax then extra.value = extra.max end
        if extra.value < 0 and not options.belowZero then extra.value = 0 end
        self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
        self.UI.setAttribute("progressBarS", "percentage", mana.value / mana.max * 100)
        self.UI.setAttribute("extraProgress", "percentage", extra.value / extra.max * 100)
        self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
        self.UI.setAttribute("manaText", "text", mana.value .. "/" .. mana.max)
        self.UI.setAttribute("extraText", "text", extra.value .. "/" .. extra.max)
        if options.HP2Desc then
            self.setDescription(health.value .. "/" .. health.max)
        end
        updateRollers()
    elseif statNames[id] ~= nil then
        self.UI.setAttribute(id, "active", false)
        self.UI.setAttribute("statePanel", "width", tonumber(self.UI.getAttribute("statePanel", "width")-300))
        statNames[id] = false
    else
        if id == "add" then
            health.value = health.value + getIncrement(value)
        elseif id == "addS" then
            mana.value = mana.value + getIncrement(value)
        elseif id == "addE" then
            extra.value = extra.value + getIncrement(value)
        elseif id == "sub" then
            health.value = health.value - getIncrement(value)
        elseif id == "subS" then
            mana.value = mana.value - getIncrement(value)
        elseif id == "subE" then
            extra.value = extra.value - getIncrement(value)
        elseif id == "addMax" then
            health.value = health.value + getIncrement(value)
            health.max = health.max + getIncrement(value)
        elseif id == "addMaxS" then
            mana.value = mana.value + getIncrement(value)
            mana.max = mana.max + getIncrement(value)
        elseif id == "addMaxE" then
            extra.value = extra.value + getIncrement(value)
            extra.max = extra.max + getIncrement(value)
        elseif id == "subMax" then
            health.value = health.value - getIncrement(value)
            health.max = health.max - getIncrement(value)
        elseif id == "subMaxS" then
            mana.value = mana.value - getIncrement(value)
            mana.max = mana.max - getIncrement(value)
        elseif id == "subMaxE" then
            extra.value = extra.value - getIncrement(value)
            extra.max = extra.max - getIncrement(value)
        end
        if health.value > health.max and not options.aboveMax then health.value = health.max end
        if health.value < 0 and not options.belowZero then health.value = 0 end
        if mana.value > mana.max and not options.aboveMax then mana.value = mana.max end
        if mana.value < 0 and not options.belowZero then mana.value = 0 end
        if extra.value > extra.max and not options.aboveMax then extra.value = extra.max end
        if extra.value < 0 and not options.belowZero then extra.value = 0 end
        self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
        self.UI.setAttribute("progressBarS", "percentage", mana.value / mana.max * 100)
        self.UI.setAttribute("extraProgress", "percentage", extra.value / extra.max * 100)
        self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
        self.UI.setAttribute("manaText", "text", mana.value .. "/" .. mana.max)
        self.UI.setAttribute("extraText", "text", extra.value .. "/" .. extra.max)
        if options.HP2Desc then
            self.setDescription(health.value .. "/" .. health.max)
        end
        if player == false and health.value <= 0 and options.initSettingsIncluded == true and options.initRealActive == true then
            options.initSettingsIncluded = false
            self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#AA2222" or "#FFFFFF")
        end
        updateRollers()
    end
    self.UI.setAttribute("hpText", "textColor", "#FFFFFF")
    self.UI.setAttribute("manaText", "textColor", "#FFFFFF")
    updateSave()
end

function getIncrement(value)
    if value == "-1" then
        return options.incrementBy
    else
        return 10
    end
end

function showAllButtons()
    local foundTriggers = false
    posi = 16
    posiY = 2
    counter = 0
    for k = 0, 99 do
        if triggerNames[k] ~= nil and triggerNames[k] ~= "Reset" then
            foundTriggers = true
            -- typical button params
            local button_parameters1 = {}
            button_parameters1.click_function = "trigger"

            button_parameters1.function_owner = self
            button_parameters1.label = triggerNames[k]
            button_parameters1.position = {posi, 4, posiY}
            button_parameters1.rotation = {0, 90, 0}
            button_parameters1.width = 2000
            button_parameters1.height = 400
            button_parameters1.font_size = 150

            if a[k] == true then
                button_parameters1.color = {74 / 255, 186 / 255, 74 / 255}
                button_parameters1.hover_color = {74 / 255, 186 / 255, 74 / 255}
            end

            counter = counter + 1
            if counter < 16 then
                posi = posi - 1

                if counter == 11 then
                    if posiY == 21.5 then
                        posiY = posiY + 6
                        posi = 16
                        counter = 0
                    end
                end
            else
                posi = 16
                if posiY == 2 then
                    posiY = posiY + 6
                else
                    posiY = posiY + 4.5
                end
                counter = 0
            end

            -- create a new global function
            _G["ClickFunction" .. k] = function(obj, col)
                -- that simply calls our real target function
                RealClickFunction(obj, k)
            end

            button_parameters1.click_function = "ClickFunction" .. k

            self.createButton(button_parameters1)
        end
    end
    if triggerNames == false then
        print("No triggers found.")
        return
    end
    showing = true
end

function RealClickFunction(obj, index)
    if a[index] ~= true then
        a[index] = true
        self.editButton({index = index - 2, color = {74 / 255, 186 / 255, 74 / 255}})
        self.editButton({index = index - 2, hover_color = {120 / 255, 255 / 255, 120 / 255}})
    else
        a[index] = false
        self.editButton({index = index - 2, color = {255 / 255, 255 / 255, 255 / 255}})
        self.editButton({index = index - 2, hover_color = {180 / 255, 180 / 255, 180 / 255}})
    end
    self.AssetBundle.playTriggerEffect(0)
    Wait.frames(updateTriggerAgain, 10)
end

function updateTriggerAgain()
    timer = 1
    for i = 0, 99 do
        if a[i] ~= nil then
            if a[i] == true then
                Wait.frames(_G["TriggerFunction" .. i], timer)
                timer = timer + 10
            end
        end
    end
end

function onCollisionEnter(a) -- if colliding with a status token, destroy it and apply to UI
    local newState = a.collision_object.getName()
    if statNames and statNames[newState] ~= nil then
        statNames[newState] = true
        a.collision_object.destruct()
        self.UI.setAttribute(newState, "active", true)
        Wait.frames(function() self.UI.setAttribute("statePanel", "width", getStatsCount()*300) end, 1)
    end
end

function getStatsCount()
    local count = 0
    for i,j in pairs(statNames) do
        if self.UI.getAttribute(i, "active") == "True" or self.UI.getAttribute(i, "active") == "true" then
            count = count + 1
        end
    end
    return count
end

function setInjectVariables(info)
    health, mana, extra = info.health, info.mana, info.extra
    options, xml = info.options, info.xml
    statNames = info.statNames
    updateSave()
    Wait.time(|| self.reload(), 0.5)
end