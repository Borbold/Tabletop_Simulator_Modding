className = "InjectTokenMini"
onUpdateScale, onUpdateGridSize = 1.0, 1.0
a, triggerNames = {}, {}
health, mana, extra = {value = 10, max = 10}, {value = 0, max = 0}, {value = 0, max = 0}

options = {
    HP2Desc = false, belowZero = false, aboveMax = false, heightModifier = 110, showBaseButtons = false,
    showBarButtons = false, hideHp = false, hideMana = true, hideExtra = true, incrementBy = 1,
    rotation = 90, initSettingsIncluded = true, initSettingsRolling = true, initSettingsMod = 0,
    initSettingsValue = 100, initRealActive = false, initRealValue = 0, initMockActive = false, initMockValue = 0
}

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
    options.initRealActive, options.initRealValue, options.initMockActive, options.initMockValue = false, 0, false, 0
    self.UI.setAttribute("InitValueInput", "text", options.initSettingsValue)
    updateSave()
end

function getInitiative(inputActive)
    if options.initRealActive then
        return options.initRealValue
    end
    if inputActive then
        options.initRealActive = true
        options.initRealValue = options.initMockActive and options.initMockValue or calculateInitiative()
        updateSave()
        return options.initRealValue
    end
    if options.initMockActive then
        return options.initMockValue
    end
    options.initMockActive = true
    options.initMockValue = calculateInitiative()
    updateSave()
    return options.initMockValue
end

function calculateInitiative()
    return options.initSettingsRolling and math.random(1, 20) + tonumber(options.initSettingsMod) or tonumber(options.initSettingsValue)
end

function updateSave()
    local encodedAttachScales = savedAttachScales and #savedAttachScales > 0 and deepCopy(savedAttachScales) or {}
    self.script_state = JSON.encode({
        scale_multiplier = scaleMultiplier, calibrated_once = calibratedOnce, health = health, mana = mana, extra = extra,
        options = options, encodedAttachScales = encodedAttachScales, statNames = statNames, player = player, measureMove = measureMove,
        alternateDiag = alternateDiag, metricMode = metricMode, stabilizeOnDrop = stabilizeOnDrop, miniHighlight = miniHighlight,
        highlightToggle = highlightToggle, hideFromPlayers = hideFromPlayers, xml = xml
    })
end

local function confer()
    local function updateUIAttributes()
        self.UI.setAttribute("panel", "position", "0 0 -" .. options.heightModifier)
        self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
        self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
        self.UI.setAttribute("progressBarS", "percentage", mana.value / mana.max * 100)
        self.UI.setAttribute("manaText", "text", mana.value .. "/" .. mana.max)
        self.UI.setAttribute("extraProgress", "percentage", extra.value / extra.max * 100)
        self.UI.setAttribute("extraText", "text", extra.value .. "/" .. extra.max)
        self.UI.setAttribute("increment", "text", options.incrementBy)
        self.UI.setAttribute("InitModInput", "text", options.initSettingsMod)
        self.UI.setAttribute("InitValueInput", "text", options.initSettingsValue)

        for statName, active in pairs(statNames) do
            if active then
                self.UI.setAttribute(statName, "active", true)
            end
        end

        self.UI.setAttribute("statePanel", "width", getStatsCount() * 300)
        self.UI.setAttribute("addSub", "active", options.showBarButtons)
        self.UI.setAttribute("addSubS", "active", options.showBarButtons)
        self.UI.setAttribute("addSubE", "active", options.showBarButtons)

        self.UI.setAttribute("resourceBar", "active", not options.hideHp)
        self.UI.setAttribute("resourceBarS", "active", not options.hideMana)
        self.UI.setAttribute("extraBar", "active", not options.hideExtra)

        self.UI.setAttribute("hiddenButtonBar", "active", options.hideHp and options.hideMana and options.hideExtra)
        self.UI.setAttribute("panel", "rotation", options.rotation .. " 270 90")

        self.UI.setAttribute("PlayerCharToggle", "textColor", player and "#ffffff" or "#aa2222")
        self.UI.setAttribute("MeasureMoveToggle", "textColor", measureMove and "#ffffff" or "#aa2222")
        self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag and "#ffffff" or "#aa2222")
        self.UI.setAttribute("MetricModeToggle", "textColor", metricMode and "#ffffff" or "#aa2222")
        self.UI.setAttribute("StabilizeToggle", "textColor", stabilizeOnDrop and "#ffffff" or "#aa2222")
        self.UI.setAttribute("HH", "textColor", options.hideHp and "#ffffff" or "#aa2222")
        self.UI.setAttribute("HM", "textColor", options.hideMana and "#ffffff" or "#aa2222")
        self.UI.setAttribute("HE", "textColor", options.hideExtra and "#ffffff" or "#aa2222")
        self.UI.setAttribute("HB", "textColor", options.showBarButtons and "#ffffff" or "#aa2222")
        self.UI.setAttribute("BZ", "textColor", options.belowZero and "#ffffff" or "#aa2222")
        self.UI.setAttribute("AM", "textColor", options.aboveMax and "#ffffff" or "#aa2222")

        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded and "#ffffff" or "#aa2222")
        self.UI.setAttribute("InitiativeRollingToggle", "textColor", options.initSettingsRolling and "#ffffff" or "#aa2222")
    end

    local function handleInjectPanel()
        autoCalibrate = injectPanel.getVar("autoCalibrateEnabled")
        if autoCalibrate then
            calibrateScale()
        end

        local injOptions = injectPanel.getTable("options")
        alternateDiag, metricMode = injOptions.alternateDiag, injOptions.metricMode
        self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag and "#ffffff" or "#aa2222")
        self.UI.setAttribute("MetricModeToggle", "textColor", metricMode and "#ffffff" or "#aa2222")

        if player then
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
            self.UI.setAttribute("editButton0", "visibility", "")
            self.UI.setAttribute("editButton1", "visibility", "")
            self.UI.setAttribute("editButtonS1", "visibility", "")
            self.UI.setAttribute("editButton2", "visibility", "")
            self.UI.setAttribute("editButtonS2", "visibility", "")
            self.UI.setAttribute("editButton3", "visibility", "")
            self.UI.setAttribute("editButtonS3", "visibility", "")
        else
            if injOptions.hideBar then
                self.UI.setAttribute("progressBar", "visibility", "Black")
                self.UI.setAttribute("progressBarS", "visibility", "Black")
                self.UI.setAttribute("extraProgress", "visibility", "Black")
            else
                self.UI.setAttribute("progressBar", "visibility", "")
                self.UI.setAttribute("progressBarS", "visibility", "")
                self.UI.setAttribute("extraProgress", "visibility", "")
            end
            if injOptions.hideText then
                self.UI.setAttribute("hpText", "visibility", "Black")
                self.UI.setAttribute("manaText", "visibility", "Black")
                self.UI.setAttribute("extraText", "visibility", "Black")
            else
                self.UI.setAttribute("hpText", "visibility", "")
                self.UI.setAttribute("manaText", "visibility", "")
                self.UI.setAttribute("extraText", "visibility", "")
            end
            if injOptions.editText then
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
            self.UI.setAttribute("panel", "active", injOptions.showAll and "true" or "false")
            self.UI.setAttribute("editButton0", "visibility", "Black")
            self.UI.setAttribute("editButton1", "visibility", "Black")
            self.UI.setAttribute("editButtonS1", "visibility", "Black")
            self.UI.setAttribute("editButton2", "visibility", "Black")
            self.UI.setAttribute("editButtonS2", "visibility", "Black")
            self.UI.setAttribute("editButton3", "visibility", "Black")
            self.UI.setAttribute("editButtonS3", "visibility", "Black")
        end
    end

    updateUIAttributes()
    handleInjectPanel()
    rebuildContextMenu()
    updateHighlight()
    self.auto_raise, self.interactable = true, true
    onUpdateScale, onUpdateGridSize = 0, 1
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
        self.setInvisibleTo(aColors)
    end
    updateSave()
    autoFogOfWarReveal()
end

local function updateInformation()
    if onUpdateScale ~= self.getScale().y then
        onUpdateScale = self.getScale().y
        local newScale = string.format("%.2f", 0.2 * onUpdateScale)
        self.UI.setAttribute("panel", "scale", newScale .. " " .. newScale)
        self.UI.setAttribute("panel", "position", "0 0 -" .. (options.heightModifier + 1))
        self.UI.setAttribute("panel", "position", "0 0 -" .. options.heightModifier)
        local vertical = 0
        vertical = vertical + (options.hideHp == true and 0 or 100)
        vertical = vertical + (options.hideMana == true and 0 or 100)
        vertical = vertical + (options.hideExtra == true and 0 or 100)
        self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "true" or "false")
        self.UI.setAttribute("resourceBar", "active", options.hideHp == true and "false" or "true")
        self.UI.setAttribute("resourceBarS", "active", options.hideMana == true and "false" or "true")
        self.UI.setAttribute("extraBar", "active", options.hideExtra == true and "false" or "true")
        self.UI.setAttribute("bars", "height", vertical)
        updateSave()
    end
    if onUpdateGridSize ~= Grid.sizeX then
        resetScale()
    end
end

local function onLoad_helper(save_state)
    local function loadSavedData(saved_data)
        if saved_data.health then
            for k, v in pairs(health) do
                health[k] = saved_data.health[k]
            end
        end
        if saved_data.mana then
            for k, v in pairs(mana) do
                mana[k] = saved_data.mana[k]
            end
        end
        if saved_data.extra then
            for k, v in pairs(extra) do
                extra[k] = saved_data.extra[k]
            end
        end
        if saved_data.options then
            for k, v in pairs(options) do
                if saved_data.options[k] ~= nil then
                    options[k] = saved_data.options[k]
                end
            end
        end
        savedAttachScales = saved_data.encodedAttachScales and deepCopy(saved_data.encodedAttachScales) or {}
        statNames = saved_data.statNames and deepCopy(saved_data.statNames) or {}
        scaleMultiplier = saved_data.scale_multiplier and saved_data.scale_multiplier or {1, 1, 1}
        calibratedOnce = saved_data.calibrated_once and saved_data.calibrated_once or false
        player = saved_data.player and saved_data.player or false
        measureMove = saved_data.measureMove and saved_data.measureMove or false
        alternateDiag = saved_data.alternateDiag and saved_data.alternateDiag or false
        metricMode = saved_data.metricMode and saved_data.metricMode or false
        stabilizeOnDrop = saved_data.stabilizeOnDrop and saved_data.stabilizeOnDrop or false
        miniHighlight = saved_data.miniHighlight and saved_data.miniHighlight or "highlightNone"
        highlightToggle = saved_data.highlightToggle and saved_data.highlightToggle or true
        hideFromPlayers = (saved_data.hideFromPlayers and player == false) and saved_data.hideFromPlayers or false
        xml = saved_data.xml and saved_data.xml or ""
        Wait.time(|| self.UI.setXml(saved_data.xml and saved_data.xml or ""), 0.2)
    end

    if save_state ~= "" then
        local saved_data = JSON.decode(save_state)
        loadSavedData(saved_data)
    end

    injectPanel = getObjectFromGUID(self.getGMNotes())
    Wait.time(confer, 0.5)
    Wait.time(updateInformation, 1, -1)
    Wait.time(function() injectPanel.call("addNewWorkingObjects", self) end, 2)
end

function onLoad(save_state)
    Wait.time(|| onLoad_helper(save_state), 1)
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
    Wait.time(updateHighlight, 20)
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
    if not highlightToggle or miniHighlight == "highlightNone" then
        self.highlightOff()
    else
        self.highlightOn(Color[miniHighlight:gsub("highlight", "")])
    end
    updateSave()
end

function rebuildContextMenu()
    self.clearContextMenu()
    self.addContextMenuItem("UI Height UP", uiHeightUp, true)
    self.addContextMenuItem("UI Height DOWN", uiHeightDown, true)
    self.addContextMenuItem("UI Rotate 90", uiRotate90, true)
    self.addContextMenuItem(string.format("%s Hide from players", hideFromPlayers and "[X]" or "[ ]") "[X] Hide from players", toggleHideFromPlayers)
    self.addContextMenuItem(string.format("%s Calibrate Scale", calibratedOnce and "[X]" or "[ ]") "[X] Hide from players", toggleHideFromPlayers)
    self.addContextMenuItem("Reset Scale", resetScale)
    self.addContextMenuItem("Reload Mini", function() self.reload() end)
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
        self.setInvisibleTo(aColors)
        -- If the object has attachments, make them invisible too
        myAttach = self.removeAttachments()
        if #myAttach > 0 then
            savedAttachScales = {}
            for _, attachObj in ipairs(myAttach) do
                table.insert(savedAttachScales, attachObj.getScale())
                attachObj.setScale({0, 0, 0})
                self.addAttachment(attachObj)
            end
        end
    else
        self.setInvisibleTo({})
        -- If the object has attachments, make them visible too
        myAttach = self.removeAttachments()
        if #myAttach > 0 then
            for attachIndex, attachObj in ipairs(myAttach) do
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
    self.UI.setAttribute("PlayerCharToggle", "textColor", player == true and "#ffffff" or "#aa2222")
    if player == true then
        resetInitiative()
    end
    if player == true and hideFromPlayers == true then
        toggleHideFromPlayers()
    end
    Wait.time(|| confer(), 0.2)
    updateSave()
end

function toggleMeasure()
    measureMove = not measureMove
    self.UI.setAttribute("MeasureMoveToggle", "textColor", measureMove == true and "#ffffff" or "#aa2222")
    updateSave()
end

function toggleAlternateDiag(thePlayer1)
    local myPlayer = thePlayer1
    local function tad_Helper(thePlayer2)
        -- Look for the mini injector, if available
        if injectPanel then
            local injOptions = injectPanel.getTable("options")
            alternateDiag = injOptions.alternateDiag
            self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag == true and "#ffffff" or "#aa2222")
            if thePlayer2 ~= nil then
                broadcastToAll("Injector is present. Use the injector to toggle measurement style.", thePlayer2.color)
            end
            updateSave()
            return
        end
        alternateDiag = not alternateDiag
        self.UI.setAttribute("AlternateDiagToggle", "textColor", alternateDiag == true and "#ffffff" or "#aa2222")
        updateSave()
    end
    Wait.frames(function() tad_Helper(myPlayer) end, 30)
end

function toggleMetricMode(thePlayer1)
    local myPlayer = thePlayer1
    local function tmm_Helper(thePlayer2)
        -- Look for the mini injector, if available
        if injectPanel then
            local injOptions = injectPanel.getTable("options")
            metricMode = injOptions.metricMode
            self.UI.setAttribute("MetricModeToggle", "textColor", metricMode == true and "#ffffff" or "#aa2222")
            if thePlayer2 ~= nil then
                broadcastToAll("Injector is present. Use the injector to toggle metric mode.", thePlayer2.color)
            end
            updateSave()
            return
        end
        metricMode = not metricMode
        self.UI.setAttribute("MetricModeToggle", "textColor", metricMode == true and "#ffffff" or "#aa2222")
        updateSave()
    end
    Wait.frames(function() tmm_Helper(myPlayer) end, 30)
end

function toggleStabilizeOnDrop()
    stabilizeOnDrop = not stabilizeOnDrop
    self.UI.setAttribute("StabilizeToggle", "textColor", stabilizeOnDrop == true and "#ffffff" or "#aa2222")
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
    self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#ffffff" or "#aa2222")
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
    self.UI.setAttribute("InitiativeRollingToggle", "textColor", options.initSettingsRolling == true and "#ffffff" or "#aa2222")
    updateSave()
end

function calibrateScale()
    currentScale = self.getScale()
    scaleMultiplier = {currentScale.x/Grid.sizeX, currentScale.y/Grid.sizeX, currentScale.z/Grid.sizeX}
    calibratedOnce = true
    rebuildContextMenu()
    updateSave()
end

function resetScale()
    if calibratedOnce == false then
        return
    end
    newScaleMultiplier = {Grid.sizeX*scaleMultiplierX, Grid.sizeX*scaleMultiplierY, Grid.sizeX*scaleMultiplierZ}
    self.setScale(newScaleMultiplier)
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
                    stabilize()
                end
            end
            Wait.condition(rotateFunc, rotateWatch)
        end
    end
end

function onPickUp(pcolor)
    destabilize()
    if measureMove == true and hideFromPlayers == false and moveMiniLua then
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
    local rb = self.getComponent("Rigidbody")
    rb.set("freezeRotation", true)
end

function destabilize()
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
    if moveMiniLua == nil then return end
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
        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#ffffff" or "#aa2222")
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
        toggleInitiativeInclude()
        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#ffffff" or "#aa2222")
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
        toggleInitiativeInclude()
        self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#ffffff" or "#aa2222")
    end
    self.UI.setAttribute("hpText", "text", health.value .. "/" .. health.max)
    self.UI.setAttribute("progressBar", "percentage", health.value / health.max * 100)
    updateRollers()
    updateSave()
end

function updateRollers()
    injectPanel.call("updateFromGuid", self.getGUID())
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
    if id == "editButton0" or id == "editButton1" or id == "editButton2" or id == "editButton3" then
        self.UI.setAttribute("editPanel", "active", self.UI.getAttribute("editPanel", "active") == "false" and "true" or "false")
        self.UI.setAttribute("statePanel", "active", self.UI.getAttribute("statePanel", "active") == "false" and "true" or "false")
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
            self.UI.setAttribute("HH", "textColor", options.hideHp == true and "#ffffff" or "#aa2222")
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "true" or "false")
            self.UI.setAttribute("resourceBar", "active", options.hideHp == true and "false" or "true")
            self.UI.setAttribute("bars", "height", vertical + (options.hideHp == true and -100 or 100))
        end, 1)
    elseif id == "HM" then
        options.hideMana = not options.hideMana
        local vertical = self.UI.getAttribute("bars", "height")
        Wait.frames(function()
            self.UI.setAttribute("HM", "textColor", options.hideMana == true and "#ffffff" or "#aa2222")
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "true" or "false")
            self.UI.setAttribute("resourceBarS", "active", options.hideMana == true and "false" or "true")
            self.UI.setAttribute("bars", "height", vertical + (options.hideMana == true and -100 or 100))
        end, 1)
    elseif id == "HE" then
        options.hideExtra = not options.hideExtra
        local vertical = self.UI.getAttribute("bars", "height")
        Wait.frames(function()
            self.UI.setAttribute("HE", "textColor", options.hideExtra == true and "#ffffff" or "#aa2222")
            self.UI.setAttribute("hiddenButtonBar", "active", (options.hideHp == true and options.hideMana == true and options.hideExtra == true) and "true" or "false")
            self.UI.setAttribute("extraBar", "active", options.hideExtra == true and "false" or "true")
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
        self.UI.setAttribute("HB", "textColor", options.showBarButtons == true and "#ffffff" or "#aa2222")
    elseif id == "BZ" then
        options.belowZero = not options.belowZero
        self.UI.setAttribute("BZ", "textColor", options.belowZero == true and "#ffffff" or "#aa2222")
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
        self.UI.setAttribute("AM", "textColor", options.aboveMax == true and "#ffffff" or "#aa2222")
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
            toggleInitiativeInclude()
            self.UI.setAttribute("InitiativeIncludeToggle", "textColor", options.initSettingsIncluded == true and "#ffffff" or "#aa2222")
        end
        updateRollers()
    end
    self.UI.setAttribute("hpText", "textColor", "#ffffff")
    self.UI.setAttribute("manaText", "textColor", "#ffffff")
    updateSave()
end

function getIncrement(value)
    if value == "-1" then
        return options.incrementBy
    else
        return 10
    end
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
-- if colliding with a status token, destroy it and apply to UI
function onCollisionEnter(info) 
    local newState = info.collision_object.getName()
    if statNames and statNames[newState] ~= nil then
        statNames[newState] = true
        info.collision_object.destruct()
        self.UI.setAttribute(newState, "active", true)
        Wait.frames(function() self.UI.setAttribute("statePanel", "width", getStatsCount()*300) end, 1)
    end
end

function getStatsCount()
    local count = 0
    for i,j in pairs(statNames) do
        if self.UI.getAttribute(i, "active") == "true" or self.UI.getAttribute(i, "active") == "true" then
            count = count + 1
        end
    end
    return count
end

function setInjectVariables(info)
    health, mana, extra = info.health, info.mana, info.extra
    options, xml = info.options, info.xml
    statNames = info.statNames
    options.heightModifier = self.getBounds().size.y / self.getScale().y * options.heightModifier
    updateSave()
    Wait.time(|| self.reload(), 0.5)
end

function onObjectDestroy()
    Wait.time(|| injectPanel.call("removeOldWorkingObjects", self), 3)
end