local enumSTnC = {Fortitude = 3, Reflex = 2, Will = 5}

function onSave()
    if resetGlobalLuaSave then
        --lang_set = 1
        lastPickedCharGUID_table = {"","","","","","","","","","",""}
        --initTurnPos = 1
        --initRound = 1
        --init_table = {}
        --charBaseSpin = false
        --charAutosaveDelay = 3
        --diceRollsShowEveryDie = true
        --diceRollsSneakyGM = false
        --autoPromote = false
        --miniMap_zoom = 10
        --miniMap_offset = {0,0}
        resetGlobalLuaSave = false
        print("Global Lua lastPickedCharGUID_table reset")
        print("Use XML emergency reset")
    end
    data_to_save = {}
    data_to_save.lang_set = lang_set
    data_to_save.saveLastPick = saveLastPick
    data_to_save.lastPickedCharGUID_table = Global.getTable("lastPickedCharGUID_table")
    data_to_save.initTurnPos = initTurnPos
    data_to_save.initRound = initRound
    --data_to_save.init_table = Global.getTable("init_table")
    data_to_save.init_table = {}
    for s=1,#init_table do
        data_to_save.init_table[s] = {
            charName    = init_table[s].charName,
            rollRez     = init_table[s].rollRez,
            initMod     = init_table[s].initMod,
            tokenGUID   = init_table[s].tokenGUID,
            aColor      = init_table[s].aColor,
        }
    end
    data_to_save.charBaseSpin = charBaseSpin
    data_to_save.charAutosaveDelay = charAutosaveDelay
    data_to_save.diceRollsShowEveryDie = diceRollsShowEveryDie
    data_to_save.diceRollsSneakyGM = diceRollsSneakyGM
    data_to_save.autoPromote = autoPromote
    data_to_save.miniMap_offset = {miniMap_offset[1],miniMap_offset[2]}
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

function onLoad(saved_data)
    ------------------------------------------
    --saved_data = "" -- MUST BE COMMENTED !!!
    ------------------------------------------
    if saved_data != nil and saved_data != "" then
        loaded_data = JSON.decode(saved_data)
        lang_set = loaded_data.lang_set
        if loaded_data.saveLastPick != nil then
            saveLastPick = loaded_data.saveLastPick
        else
            saveLastPick = false
        end
        if saveLastPick then
            self.setTable("lastPickedCharGUID_table", loaded_data.lastPickedCharGUID_table)
        else
            lastPickedCharGUID_table = {"","","","","","","","","","",""}
        end
        initTurnPos = loaded_data.initTurnPos
        initRound =loaded_data.initRound
        self.setTable("init_table", loaded_data.init_table)
        charBaseSpin = loaded_data.charBaseSpin
        charAutosaveDelay = loaded_data.charAutosaveDelay
        diceRollsShowEveryDie = loaded_data.diceRollsShowEveryDie
        diceRollsSneakyGM = loaded_data.diceRollsSneakyGM
        autoPromote = loaded_data.autoPromote
        if loaded_data.miniMap_zoom == nil then
            miniMap_zoom = 10
        else
            miniMap_zoom = loaded_data.miniMap_zoom
        end
        if loaded_data.miniMap_offset == nil then
            miniMap_offset = {0,0}
        else
            self.setTable("miniMap_offset", loaded_data.miniMap_offset)
        end
    else
        lang_set = 1
        saveLastPick = false
        lastPickedCharGUID_table = {"","","","","","","","","","",""}
        initTurnPos = 1
        initRound = 1
        init_table = {}
        charBaseSpin = false
        charAutosaveDelay = 3
        diceRollsShowEveryDie = true
        diceRollsSneakyGM = false
        autoPromote = false
        miniMap_zoom = 10
        miniMap_offset = {0,0}
    end
    resetGlobalLuaSave = false
    ------------------------------------------

    checkGUIDtable()

    init_table[0] = {}
    init_table[0].charName = ""
    init_table[0].rollRez = 0
    init_table[0].initMod = 0
    init_table[0].tokenGUID = ""
    init_table[0].aColor = 1

    initEditPos = 0
    initEditPanelVisible = false

    lang_table = defineLangTable()

    defSkillsAttr_table = {2, 5, 4, 1, 6, 4, 5, 6, 4, 5, 4, 5, 6, 6, 4, 2, 2, 5}

    plColors_Table = {"Black","White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
    plColorsHexTable={"#3f3f3f","#ffffff","#703a16","#da1917","#f3631c","#e6e42b","#30b22a","#20b09a","#1e87ff","#9f1fef","#f46fcd"}
    --plShow2AllStr = "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey"
    editModeVisibility = {false,false,false,false,false,false,false,false,false,false,false}
    screenRollerVisibility = {false,false,false,false,false,false,false,false,false,false,false}
    screenRollerStringsToRoll = {"","","","","","","","","","",""}
    healTempDmg_table = {0,0,0,0,0,0,0,0,0,0,0}
    dSavesStr_table = {"","☻","x"}
    dSavesStrTeamBar_table = {" ","o","x"}
    editModeSelectedAttack = {1,1,1,1,1,1,1,1,1,1,1}

    allowedSymbols = {" ","1","2","3","4","5","6","7","8","9","0","+","-","d","к"}
    critRolled = false
    lastRollTotal = 0
    atkClicked = 0
    doubleRoll = 0
    atkIconsUrl_Table = {}
    defineAtkIcons()

    panelVisibility_main = {true,true,true,true,true,true,true,true,true,true,true}
    panelVisibility_attacks = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_atkIconsMenu = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_spellSlots = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_resourses = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_notes = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_conditions = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_UIset = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_miniMap = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_init = {true,true,true,true,true,true,true,true,true,true,true}
    panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_bigPortrait = {false,false,false,false,false,false,false,false,false,false,false}


    rollOutputHex = "[cccccc]"

    main_Table = {}
    for i=1,11 do
        main_Table[i] = {}

        main_Table[i].aColors = {true,false,false,false,false,false,false,false,false,false,false}

        main_Table[i].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
        main_Table[i].charName = ""

        main_Table[i].hp = 92
        main_Table[i].hpMax = 113
        main_Table[i].hpTemp = 5
        main_Table[i].deathSaves = {1,1,1,1,1}

        main_Table[i].charLvl = 1
        main_Table[i].charProfBonus = 2 -- math.floor((lvl +7)/4)     -- can be set manually for monsters

        main_Table[i].AC = 10
        main_Table[i].speed = 30
        main_Table[i].initMod = 0
        main_Table[i].pPerceptionMod = 0

        main_Table[i].attributes = {}
        main_Table[i].saves = {false,false,false,false,false,false}
        main_Table[i].savesMod = {Fortitude = 0, Reflex = 0, Will = 0}
        for ii=1,6 do
            main_Table[i].attributes[ii] = 10   -- modifier: (attr -10) /2
            main_Table[i].saves[ii] = false
        end
        main_Table[i].skills = {}
        for ii=1,18 do
            main_Table[i].skills[ii] = {}
            main_Table[i].skills[ii].proficient = false
            main_Table[i].skills[ii].expertize = false
            main_Table[i].skills[ii].mod = 0
        end

        main_Table[i].attacks = {}
        for ii=1,10 do
            main_Table[i].attacks[ii] = {}
            main_Table[i].attacks[ii].atkName = "unarmed"
            main_Table[i].attacks[ii].atkRolled = true
            main_Table[i].attacks[ii].atkAttr = 1
            main_Table[i].attacks[ii].proficient = true
            main_Table[i].attacks[ii].minCrit = 20
            main_Table[i].attacks[ii].atkMod = 0
            main_Table[i].attacks[ii].dmgRolled = true
            main_Table[i].attacks[ii].dmgAttr = 1
            main_Table[i].attacks[ii].dmgStr = "1"
            main_Table[i].attacks[ii].dmgStrCrit = "0"
            main_Table[i].attacks[ii].resUsed = 0
            main_Table[i].attacks[ii].icon = 1
        end

        main_Table[i].splSlots = {0,0,0,0,0,0,0,0,0}
        main_Table[i].splSlotsMax = {0,0,0,0,0,0,0,0,0}

        main_Table[i].resourses = {}
        for ii=1,10 do
            main_Table[i].resourses[ii] = {}
            main_Table[i].resourses[ii].resName = ""
            main_Table[i].resourses[ii].resValue = 0
            main_Table[i].resourses[ii].resMax = 0
        end

        main_Table[i].notes_A = ""
        main_Table[i].notes_B = ""

        main_Table[i].figurineUI_scale = 1
        main_Table[i].figurineUI_xyzMods = {0,0,0}
        
        main_Table[i].conditions = {}
        main_Table[i].conditions.table = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
        main_Table[i].conditions.exhaustion = 0

        main_Table[i].hpVisibleToPlayers = true

        main_Table[i].tokenGUI_settings = {0,0,0,0,0}

        main_Table[i].charHidden = false
    end

    firstLoad = true
    addCharMode = false
    copyCharMode = false

    Wait.frames(function()
        loadSelections()
        defineMiniMapUnit("◒")
        miniMap_UI_update()
        applyCharAutosaveDelay()
    end, 3)

    Wait.frames(function()
        language_UI_update()
    end, 2)
    
    Wait.frames(function()
        mainSheet_UI_update()
        initiative_UI_update()
    end, 60)

    Wait.frames(function()
        noCharSelectedPanelCheck()
    end, 120)

    loadTime = os.clock()

    --miniMap_zoom = 10
    --miniMap_offset = {0,0}

    resetCounter = 0
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function onUpdate()
    if charBaseSpin then
        if (os.clock() - loadTime) > 1 then
            loadTime = os.clock()
            for u=1,11 do
                if getObjectFromGUID(lastPickedCharGUID_table[u]) != nil then
                    getObjectFromGUID(lastPickedCharGUID_table[u]).call("selectSpin")
                end
            end
        end    
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-----------------------------   sheet <-> figurine interactions

function onObjectPickUp(plCl, pObj)
    if pObj.getVar("THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN") != nil and not copyCharMode then -- ffs should be 5E, but now it would be too much fuss to fix
        if pObj.getTable("charSave_table").aColors[nFromPlClr(plCl)] then
            previousTokenGUID = lastPickedCharGUID_table[nFromPlClr(plCl)]
            lastPickedCharGUID_table[nFromPlClr(plCl)] = pObj.getGUID()
            GetStatsFromToken(nFromPlClr(plCl),pObj)
            pObj.setVar("Selected", nFromPlClr(plCl))
            Wait.frames(function()
                pObj.call("UI_update")
            end, 1)
            if previousTokenGUID != "" and getObjectFromGUID(previousTokenGUID) != nil and previousTokenGUID != lastPickedCharGUID_table[nFromPlClr(plCl)] then
                getObjectFromGUID(previousTokenGUID).setVar("Selected", tokenSelectionCheck(previousTokenGUID))
                Wait.frames(function()
                    getObjectFromGUID(previousTokenGUID).call("UI_update")
                end, 1)
            end
            noCharSelectedPanelCheck()
        end
    elseif pObj.getVar("THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN") != nil and copyCharMode then
        pObj.setTable("charSave_table", main_Table[nFromPl(plCl)])
        pObj.call("UI_update")
        copyCharMode = false
        UI.setAttribute("copyCharModePanel", "active", "False")
        GM_settingsPanel_UI_update()
    else
        if plCl == "Black" and addCharMode then
            pObj.setLuaScript(defineCharLua())
            pObj.reload()
            addCharMode = false
            self.UI.setAttribute("addCharModePanel", "active", "False")
            GM_settingsPanel_UI_update()
        end
    end
end

function onObjectDestroy(dying_object)
    noCharSelectedPanelCheck()
end

function tokenSelectionCheck(previousTokenGUID)
    selectedUpdate = 0
    for i=11,1,-1 do
        if lastPickedCharGUID_table[i] != "" and getObjectFromGUID(lastPickedCharGUID_table[i]) != nil then
            if lastPickedCharGUID_table[i] == previousTokenGUID then
                selectedUpdate = i
            end
        end
    end
    return selectedUpdate
end

function GetStatsFromToken(pl_N, obj)
    --main_Table[pl_N] = {}
    main_Table[pl_N] = obj.getTable("charSave_table")
    --print(main_Table[pl_N].charHidden)
    if main_Table[pl_N].charHidden == nil then
        main_Table[pl_N].charHidden = false
    end
    UI_upd(pl_N)
    atkEdit_UI_update(pl_N,editModeSelectedAttack[pl_N])
end

function SetStatsIntoToken(pl_N)
    if getObjectFromGUID(lastPickedCharGUID_table[pl_N]) != nil then
        getObjectFromGUID(lastPickedCharGUID_table[pl_N]).setTable("charSave_table", main_Table[pl_N])
        getObjectFromGUID(lastPickedCharGUID_table[pl_N]).call("UI_update")
    else
        lastPickedCharGUID_table[pl_N] = ""
    end
end

-----------------------------

function noCharSelectedPanelCheck()
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if getObjectFromGUID(lastPickedCharGUID_table[i]) == nil or lastPickedCharGUID_table[i] == "" then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("noCharSelectedBlockPanel","visibility",editModeVisibilityStr)
end

-----------------------------   sheet edits

function setCharPortrait(pl,vl,thisID)
    if vl != "" then
        main_Table[nFromPl(pl)].portraitUrl = vl
    else
        main_Table[nFromPl(pl)].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
    end
    singleColor_UI_update(nFromPl(pl))
end

function setCharName(pl,vl,thisID)
    if vl != nil then
        main_Table[nFromPl(pl)].charName = vl
        if getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]) != nil then
            getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]).setName(vl)
        end
        singleColor_UI_update(nFromPl(pl))
    end
end

function setCharLvl(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStrEnd(thisID) == 1 then
        main_Table[nFromPl(pl)].charLvl = main_Table[nFromPl(pl)].charLvl + num_add
    else
        main_Table[nFromPl(pl)].charLvl = main_Table[nFromPl(pl)].charLvl - num_add
    end
    if main_Table[nFromPl(pl)].charLvl < 1  then main_Table[nFromPl(pl)].charLvl = 20 end
    if main_Table[nFromPl(pl)].charLvl > 20 then main_Table[nFromPl(pl)].charLvl = 1  end
    main_Table[nFromPl(pl)].charProfBonus = math.floor((main_Table[nFromPl(pl)].charLvl + 7)/4)
    singleColor_UI_update(nFromPl(pl))
end

function setCharAC(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStrEnd(thisID) == 1 then
        main_Table[nFromPl(pl)].AC = main_Table[nFromPl(pl)].AC + num_add
    else
        main_Table[nFromPl(pl)].AC = main_Table[nFromPl(pl)].AC - num_add
    end
    if main_Table[nFromPl(pl)].AC < 0  then main_Table[nFromPl(pl)].AC = 50 end
    if main_Table[nFromPl(pl)].AC > 50 then main_Table[nFromPl(pl)].AC = 0  end
    singleColor_UI_update(nFromPl(pl))
end

function setCharSpeed(pl,vl,thisID)
    if vl == "-1" then num_add = 5 elseif vl == "-2" then num_add = 50 end
    if numFromStrEnd(thisID) == 1 then
        main_Table[nFromPl(pl)].speed = main_Table[nFromPl(pl)].speed + num_add
    else
        main_Table[nFromPl(pl)].speed = main_Table[nFromPl(pl)].speed - num_add
    end
    if main_Table[nFromPl(pl)].speed < 0    then main_Table[nFromPl(pl)].speed = 1000 end
    if main_Table[nFromPl(pl)].speed > 1000 then main_Table[nFromPl(pl)].speed = 0    end
    singleColor_UI_update(nFromPl(pl))
end

function setCharProfBonus(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStrEnd(thisID) == 1 then
        main_Table[nFromPl(pl)].charProfBonus = main_Table[nFromPl(pl)].charProfBonus + num_add
    else
        main_Table[nFromPl(pl)].charProfBonus = main_Table[nFromPl(pl)].charProfBonus - num_add
    end
    if main_Table[nFromPl(pl)].charProfBonus < 1  then main_Table[nFromPl(pl)].charProfBonus = 30 end
    if main_Table[nFromPl(pl)].charProfBonus > 30 then main_Table[nFromPl(pl)].charProfBonus = 1  end
    singleColor_UI_update(nFromPl(pl))
end

function setCharInitMod(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStrEnd(thisID) == 1 then
        main_Table[nFromPl(pl)].initMod = main_Table[nFromPl(pl)].initMod + num_add
    else
        main_Table[nFromPl(pl)].initMod = main_Table[nFromPl(pl)].initMod - num_add
    end
    if main_Table[nFromPl(pl)].initMod < -15 then main_Table[nFromPl(pl)].initMod = 15  end
    if main_Table[nFromPl(pl)].initMod > 15  then main_Table[nFromPl(pl)].initMod = -15 end
    singleColor_UI_update(nFromPl(pl))
end

function setCharPassPerceptionMod(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStrEnd(thisID) == 1 then
        main_Table[nFromPl(pl)].pPerceptionMod = main_Table[nFromPl(pl)].pPerceptionMod + num_add
    else
        main_Table[nFromPl(pl)].pPerceptionMod = main_Table[nFromPl(pl)].pPerceptionMod - num_add
    end
    if main_Table[nFromPl(pl)].pPerceptionMod < -15 then main_Table[nFromPl(pl)].pPerceptionMod = 15  end
    if main_Table[nFromPl(pl)].pPerceptionMod > 15  then main_Table[nFromPl(pl)].pPerceptionMod = -15 end
    singleColor_UI_update(nFromPl(pl))
end

function setCharHP(pl,vl,thisID)
    if tonumber(vl) != nil then
        if numFromStrEnd(thisID) == 1 then
            main_Table[nFromPl(pl)].hp = tonumber(vl)
        else
            main_Table[nFromPl(pl)].hpMax = tonumber(vl)
        end
        if main_Table[nFromPl(pl)].hp < 0    then main_Table[nFromPl(pl)].hp = 0    end
        if main_Table[nFromPl(pl)].hpMax < 0 then main_Table[nFromPl(pl)].hpMax = 0 end
        if main_Table[nFromPl(pl)].hp > main_Table[nFromPl(pl)].hpMax then main_Table[nFromPl(pl)].hp = main_Table[nFromPl(pl)].hpMax end
        singleColor_UI_update(nFromPl(pl))
    end
end

function setCharHPvisibility(pl,vl,thisID)
    main_Table[nFromPl(pl)].hpVisibleToPlayers = not main_Table[nFromPl(pl)].hpVisibleToPlayers
    singleColor_UI_update(nFromPl(pl))
end

function setCharAttr(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStr(thisID) == 1 then
        main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] + num_add
    else
        main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] - num_add
    end
    if main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] < 0  then main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] = 50 end
    if main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] > 50 then main_Table[nFromPl(pl)].attributes[numFromStrEnd(thisID)] = 0  end
    singleColor_UI_update(nFromPl(pl))
end

function setCharSaveMod(pl,vl,thisID)
    local nameST = string.match(thisID, "^[^_]+_[^_]+_([^_]+)")
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStr(thisID) == 1 then
        main_Table[nFromPl(pl)].savesMod[nameST] = main_Table[nFromPl(pl)].savesMod[nameST] + num_add
    else
        main_Table[nFromPl(pl)].savesMod[nameST] = main_Table[nFromPl(pl)].savesMod[nameST] - num_add
    end
    if main_Table[nFromPl(pl)].savesMod[nameST] < -15 then main_Table[nFromPl(pl)].savesMod[nameST] = 15  end
    if main_Table[nFromPl(pl)].savesMod[nameST] > 15  then main_Table[nFromPl(pl)].savesMod[nameST] = -15 end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------   sheet buttons and more edits

function rollAttribute(pl,vl,thisID)
    plColHex = "["..Color[pl.color]:toHex(false).."]"
    if vl == "-1" then
        stringRoller("1d20"..PoM(modFromAttr(main_Table[numFromStr(thisID)].attributes[numFromStrEnd(thisID)]))..modFromAttr(main_Table[numFromStr(thisID)].attributes[numFromStrEnd(thisID)]),pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][numFromStrEnd(thisID) + 7]..":",1,false)
    elseif vl == "-2" then
        doubleRoll = 2
        stringRoller("1d20"..PoM(modFromAttr(main_Table[numFromStr(thisID)].attributes[numFromStrEnd(thisID)]))..modFromAttr(main_Table[numFromStr(thisID)].attributes[numFromStrEnd(thisID)]),pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][numFromStrEnd(thisID) + 7]..":",2,false)
        stringRoller("1d20"..PoM(modFromAttr(main_Table[numFromStr(thisID)].attributes[numFromStrEnd(thisID)]))..modFromAttr(main_Table[numFromStr(thisID)].attributes[numFromStrEnd(thisID)]),pl, rollOutputHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][numFromStrEnd(thisID) + 7]..":",4,false)
    end
end

function charSaveButton(pl,vl,thisID)
    local nameST = string.match(thisID, "^[^_]+_[^_]+_([^_]+)")
    if editModeVisibility[nFromPl(pl)] then
        main_Table[nFromPl(pl)].saves[enumSTnC[nameST]] = not main_Table[nFromPl(pl)].saves[enumSTnC[nameST]]
    else
        plColHex = "["..Color[pl.color]:toHex(false).."]"
        if main_Table[numFromStr(thisID)].saves[enumSTnC[nameST]] then
            modStr = "1d20"..PoM(modFromAttr(main_Table[numFromStr(thisID)].attributes[enumSTnC[nameST]]) + main_Table[numFromStr(thisID)].savesMod[nameST] + main_Table[numFromStr(thisID)].charProfBonus) .. modFromAttr(main_Table[numFromStr(thisID)].attributes[enumSTnC[nameST]]) + main_Table[numFromStr(thisID)].savesMod[nameST] + main_Table[numFromStr(thisID)].charProfBonus
        else
            modStr = "1d20"..PoM(modFromAttr(main_Table[numFromStr(thisID)].attributes[enumSTnC[nameST]]) + main_Table[numFromStr(thisID)].savesMod[nameST]) .. modFromAttr(main_Table[numFromStr(thisID)].attributes[enumSTnC[nameST]]) + main_Table[numFromStr(thisID)].savesMod[nameST]
        end
        if vl == "-1" then
            stringRoller(modStr,pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][enumSTnC[nameST] + 7].." "..lang_table[lang_set][40]..":",1,false)
        elseif vl == "-2" then
            doubleRoll = 2
            stringRoller(modStr,pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][enumSTnC[nameST] + 7].." "..lang_table[lang_set][40]..":",2,false)
            stringRoller(modStr,pl, rollOutputHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][enumSTnC[nameST] + 7].." "..lang_table[lang_set][40]..":",4,false)
        end
    end
    singleColor_UI_update(nFromPl(pl))
end

function skillButtonMain(pl,vl,thisID)
    if editModeVisibility[nFromPl(pl)] then
        main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].proficient = not main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].proficient
        if not main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].proficient then
            main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].expertize = false
        end
    else
        plColHex = "["..Color[pl.color]:toHex(false).."]"
        thisSkillMod = modFromAttr(main_Table[numFromStr(thisID)].attributes[defSkillsAttr_table[numFromStrEnd(thisID)]]) + main_Table[numFromStr(thisID)].skills[numFromStrEnd(thisID)].mod
        if main_Table[numFromStr(thisID)].skills[numFromStrEnd(thisID)].proficient and main_Table[numFromStr(thisID)].skills[numFromStrEnd(thisID)].expertize then
            thisSkillMod = thisSkillMod + main_Table[numFromStr(thisID)].charProfBonus * 2
        elseif main_Table[numFromStr(thisID)].skills[numFromStrEnd(thisID)].proficient and not main_Table[numFromStr(thisID)].skills[numFromStrEnd(thisID)].expertize then
            thisSkillMod = thisSkillMod + main_Table[numFromStr(thisID)].charProfBonus
        end
        if vl == "-1" then
            stringRoller("1d20"..PoM(thisSkillMod)..thisSkillMod,pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][numFromStrEnd(thisID) + 14]..":",1,false)
        elseif vl == "-2" then
            doubleRoll = 2
            stringRoller("1d20"..PoM(thisSkillMod)..thisSkillMod,pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][numFromStrEnd(thisID) + 14]..":",2,false)
            stringRoller("1d20"..PoM(thisSkillMod)..thisSkillMod,pl, rollOutputHex..main_Table[numFromStr(thisID)].charName.."[-]: "..lang_table[lang_set][numFromStrEnd(thisID) + 14]..":",4,false)
        end
    end
    singleColor_UI_update(nFromPl(pl))
end

function setExpertize(pl,vl,thisID)
    main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].expertize = not main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].expertize
    if not main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].proficient then
        main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].expertize = false
    end
    singleColor_UI_update(nFromPl(pl))
end

function setSkillMod(pl,vl,thisID)
    if vl == "-1" then num_add = 1 elseif vl == "-2" then num_add = 5 end
    if numFromStr(thisID) == 1 then
        main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod = main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod - num_add
    else
        main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod = main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod + num_add
    end
    if main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod < -50 then main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod = 50  end
    if main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod > 50  then main_Table[nFromPl(pl)].skills[numFromStrEnd(thisID)].mod = -50 end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------   HP

function setCharHealDmgVal(pl,vl,thisID)
    if tonumber(vl) != nil and vl != "" then
        healTempDmg_table[nFromPl(pl)] = math.abs(tonumber(vl))
    end
end

function takeDmg(pl,vl,thisID)
    if healTempDmg_table[nFromPl(pl)] >= main_Table[nFromPl(pl)].hp + main_Table[nFromPl(pl)].hpTemp + main_Table[nFromPl(pl)].hpMax then
        for d=1,3 do
            main_Table[nFromPl(pl)].deathSaves[d] = 3
            main_Table[nFromPl(pl)].conditions.table[20] = true
        end
    end
    dmgLeftAfterTemp = math.max(0, healTempDmg_table[nFromPl(pl)] - main_Table[nFromPl(pl)].hpTemp)
    main_Table[nFromPl(pl)].hpTemp = math.max(0, main_Table[nFromPl(pl)].hpTemp - healTempDmg_table[nFromPl(pl)])
    main_Table[nFromPl(pl)].hp     = math.max(0, main_Table[nFromPl(pl)].hp - dmgLeftAfterTemp)
    healTempDmg_table[nFromPl(pl)] = 0
    self.UI.setAttribute(strFromNum(nFromPl(pl)).."_charHealDmgValueInput", "text", "")
    singleColor_UI_update(nFromPl(pl))
    miniMap_UI_update()
end

function healHP(pl,vl,thisID)
    main_Table[nFromPl(pl)].hp = math.min(main_Table[nFromPl(pl)].hpMax, main_Table[nFromPl(pl)].hp + healTempDmg_table[nFromPl(pl)])
    healTempDmg_table[nFromPl(pl)] = 0
    self.UI.setAttribute(strFromNum(nFromPl(pl)).."_charHealDmgValueInput", "text", "")
    for i=1,#main_Table[nFromPl(pl)].deathSaves do
        main_Table[nFromPl(pl)].deathSaves[i] = 1
    end
    singleColor_UI_update(nFromPl(pl))
    miniMap_UI_update()
end

function setTempHP(pl,vl,thisID)
    if healTempDmg_table[nFromPl(pl)] != 0 and vl == "-1" then
        main_Table[nFromPl(pl)].hpTemp = healTempDmg_table[nFromPl(pl)]
    elseif vl == "-2" then
        main_Table[nFromPl(pl)].hpTemp = 0
    end
    healTempDmg_table[nFromPl(pl)] = 0
    self.UI.setAttribute(strFromNum(nFromPl(pl)).."_charHealDmgValueInput", "text", "")
    singleColor_UI_update(nFromPl(pl))
end

function deathSaveButton(pl,vl,thisID)
    main_Table[numFromStr(thisID)].deathSaves[numFromStrEnd(thisID)] = main_Table[numFromStr(thisID)].deathSaves[numFromStrEnd(thisID)] + 1
    if main_Table[numFromStr(thisID)].deathSaves[numFromStrEnd(thisID)] > 3 then main_Table[numFromStr(thisID)].deathSaves[numFromStrEnd(thisID)] = 1 end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------   attacks

function atkButton(pl,vl,thisID)
    plColHex = "["..Color[pl.color]:toHex(false).."]"
    if editModeVisibility[nFromPl(pl)] then
        editModeSelectedAttack[nFromPl(pl)] = numFromStrEnd(thisID)
        for i=1,10 do
            if editModeSelectedAttack[nFromPl(pl)] == i or not editModeVisibility[nFromPl(pl)] then atkButtonImg_color = "#ffffffff" else atkButtonImg_color = "#ffffff88" end
            UI_xmlElementUpdate(strFromNum(nFromPl(pl)).."_atkButtonImg_"..strFromNum(i),"color",atkButtonImg_color)
        end
        atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
        
    else
        if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed == 0 or (main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed != 0 and main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resValue > 0) then
            if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed != 0 then
                if main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resMax != 0 then
                    resLeftStr = " / "..main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resMax
                else
                    resLeftStr = ""
                end
                resLeftStr = " [aaaaff]("..main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resValue..resLeftStr..")[-]"
                main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resValue = main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resValue -1
                singleColor_UI_update(nFromPl(pl))
            else
                resLeftStr = ""
            end

            atkRollMod = main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkMod
            if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkAttr != 0 then atkRollMod = atkRollMod + modFromAttr(main_Table[nFromPl(pl)].attributes[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkAttr]) end
            if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].proficient then   atkRollMod = atkRollMod + math.floor((main_Table[nFromPl(pl)].charLvl + 7)/4) end
            atkClicked = numFromStrEnd(thisID)
            critRolled = false

            if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkRolled then
                dmgRollType = 4
                if vl == "-1" then
                    if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgRolled then rTypeA = 2 else rTypeA = 1 end
                    stringRoller("1d20"..PoM_add(atkRollMod),pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..resLeftStr..":",rTypeA,false)
                elseif vl == "-2" then
                    rTypeA = 2
                    if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgRolled then rTypeB = 3 else rTypeB = 4 end
                    doubleRoll = 2
                    stringRoller("1d20"..PoM_add(atkRollMod),pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..resLeftStr..":",rTypeA,false)
                    stringRoller("1d20"..PoM_add(atkRollMod),pl, rollOutputHex..main_Table[numFromStr(thisID)].charName.."[-]: "..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..":",rTypeB,false)
                end
            else
                dmgRollType = 1
                if diceRollsSneakyGM and pl.color == "Black" then
                    printToColor("[b] ͡° ● "..main_Table[numFromStr(thisID)].charName.."[/b][-]: [cccccc]"..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..":[-]", pl.color, pl.color)
                else
                    printToAll("[b]● "..main_Table[numFromStr(thisID)].charName.."[/b][-]: [cccccc]"..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..":[-]", pl.color)
                end
                
            end

            if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgRolled then
                if main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgAttr != 0 then
                    dmgAttrStr = PoM_add(modFromAttr(main_Table[nFromPl(pl)].attributes[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgAttr]))
                    dmgAttrStrText = " + ".. lang_table[lang_set][main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgAttr + 7]
                else
                    dmgAttrStr = ""
                    dmgAttrStrText = ""
                end

                if critRolled then
                    stringRoller(main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgStr..dmgAttrStr,pl, lang_table[lang_set][45]..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgStr..dmgAttrStrText.." :",3,false)
                    stringRoller(main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgStrCrit,pl, lang_table[lang_set][46]..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgStrCrit.." :",4,true)
                else
                    stringRoller(main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgStr..dmgAttrStr,pl, lang_table[lang_set][45]..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgStr.. dmgAttrStrText.." :",dmgRollType,false)
                end

            end
            atkClicked = 0

            if not main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkRolled and not main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].dmgRolled then
                if diceRollsSneakyGM and pl.color == "Black" then
                    printToColor(" ͡° ● "..main_Table[nFromPl(pl)].charName..": "..rollOutputHex..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..resLeftStr.."[-]", pl.color, pl.color)
                else
                    printToAll("● "..main_Table[nFromPl(pl)].charName..": "..rollOutputHex..main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].atkName..resLeftStr.."[-]", pl.color)
                end
            end
        elseif main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed != 0 and main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resValue == 0 then
            printToAll("► [cccccc]".. main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resName..": [ff8888]"..main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resValue.." / "..main_Table[nFromPl(pl)].resourses[main_Table[nFromPl(pl)].attacks[numFromStrEnd(thisID)].resUsed].resMax .."[-]", pl.color)
        end
    end
end


function atkSetIcon(pl,vl,thisID)
    if vl == "-1" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon + 1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon > #atkIconsUrl_Table then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon = 1 end
    elseif vl == "-2" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon -1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon <1 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].icon = #atkIconsUrl_Table end
    end
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkSetName(pl,vl,thisID)
    main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkName = vl
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkToggleRollAtk(pl,vl,thisID)
    main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkRolled = not main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkRolled
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkSetAtkAttr(pl,vl,thisID)
    if vl == "-1" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr + 1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr >6 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr = 0 end
    elseif vl == "-2" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr -1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr <0 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkAttr = 6 end
    end
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkToggleProf(pl,vl,thisID)
    main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].proficient = not main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].proficient
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkSetMinCrit(pl,vl,thisID)
    if tonumber(vl) != nil then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].minCrit = tonumber(vl)
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].minCrit > 20 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].minCrit = 20 end
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].minCrit < 1 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].minCrit = 1 end
        atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
    end
end

function atkSetAtkMod(pl,vl,thisID)
    if tonumber(vl) != nil then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkMod = tonumber(vl)
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkMod >  20 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkMod =  20 end
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkMod < -20 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].atkMod = -20 end
        atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
    end
end

function atkToggleRollDmg(pl,vl,thisID)
    main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgRolled = not main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgRolled
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkSetDmgAttr(pl,vl,thisID)
    if vl == "-1" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr + 1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr >6 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr = 0 end
    elseif vl == "-2" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr -1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr <0 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgAttr = 6 end
    end
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkSetResUsed(pl,vl,thisID)
    if vl == "-1" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed + 1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed >10 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed = 0 end
    elseif vl == "-2" then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed = main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed -1
        if main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed <0 then main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].resUsed = 10 end
    end
    atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
end

function atkSetDmgStr(pl,vl,thisID)
    inpStrGood = true
    for i=1,#vl do
        thisSymbolBad = true
        for ii=1,#allowedSymbols do
            if string.sub(vl,i,i) == allowedSymbols[ii] then
                thisSymbolBad = false
            end
        end
        if thisSymbolBad then
            inpStrGood = false
        end
    end
    if tonumber(string.sub(vl, 1, 1)) == nil or not inpStrGood then
        printToAll("► [ff9999]Dice input error![-]", pl.color)
    else
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgStr = vl
        atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
    end
end

function atkSetDmgStrCrit(pl,vl,thisID)
    inpStrGood = true
    for i=1,#vl do
        thisSymbolBad = true
        for ii=1,#allowedSymbols do
            if string.sub(vl,i,i) == allowedSymbols[ii] then
                thisSymbolBad = false
            end
        end
        if thisSymbolBad then
            inpStrGood = false
        end
    end
    if tonumber(string.sub(vl, 1, 1)) == nil or not inpStrGood then
        printToAll("► [ff9999]Dice input error![-]", pl.color)
    else
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[nFromPl(pl)]].dmgStrCrit = vl
        atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[nFromPl(pl)])
    end
end

-------------------------   spell slots

function spellSlotButtonMain(pl,vl,thisID)
    if vl == "-2" then
        main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] + 1
        if main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] > main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] then
            main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)]
        end
    elseif vl == "-1" then
        main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] - 1
        if main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] < 0 then
            main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] = 0
        end
    end
    singleColor_UI_update(nFromPl(pl))
end

function spellSlotButtonMax(pl,vl,thisID)
    if vl == "-2" then
        main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] + 1
        if main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] > 10 then
            main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] = 10
        end
    elseif vl == "-1" then
        main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] - 1
        if main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] < 0 then
            main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] = 0
        end
    end
    if main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] > main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)] then
        main_Table[nFromPl(pl)].splSlots[numFromStrEnd(thisID)] = main_Table[nFromPl(pl)].splSlotsMax[numFromStrEnd(thisID)]
    end
    singleColor_UI_update(nFromPl(pl))
end

function spellSlotButtonMaxAll(pl,vl,thisID)
    for i=1,9 do
        main_Table[nFromPl(pl)].splSlots[i] = main_Table[nFromPl(pl)].splSlotsMax[i]
    end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------   ressourses

function resSetName(pl,vl,thisID)
    main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resName = vl
    singleColor_UI_update(nFromPl(pl))
end

function resSetValue(pl,vl,thisID)
    if tonumber(vl) != nil then
        main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue = tonumber(vl)
        if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax >0 then
            if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue > main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax then
                main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue = main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax
            end
        end
        singleColor_UI_update(nFromPl(pl))
    end
end

function resSetMax(pl,vl,thisID)
    if tonumber(vl) != nil then
        main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax = tonumber(vl)
        if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax >0 then
            if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue > main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax then
                main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue = main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax
            end
        end
        singleColor_UI_update(nFromPl(pl))
    end
end

function resSingleAdd(pl,vl,thisID)
    if numFromStr(thisID) == 1 then n_to_mult = -1 else n_to_mult = 1 end
    if vl == "-1" then n_to_add = 1 elseif vl == "-2" then n_to_add = 5 end
    main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue = main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue + (n_to_add * n_to_mult)
    if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax >0 then
        if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue > main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax then
            main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue = main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resMax
        end
        if main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue < 0 then
            main_Table[nFromPl(pl)].resourses[numFromStrEnd(thisID)].resValue = 0
        end
    end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------

function setNotes(pl,vl,thisID)
    if string.sub(thisID,#thisID,#thisID) == "A" then
        main_Table[nFromPl(pl)].notes_A = vl
    else
        main_Table[nFromPl(pl)].notes_B = vl
    end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------

function setAssignedPlayer(pl,vl,thisID)
    main_Table[nFromPl(pl)].aColors[numFromStrEnd(thisID)] = not main_Table[nFromPl(pl)].aColors[numFromStrEnd(thisID)]
    singleColor_UI_update(nFromPl(pl))
    getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]).call("hideThisChar")
end

function toggleInvisible(pl,vl,thisID)
    main_Table[nFromPl(pl)].charHidden = not main_Table[nFromPl(pl)].charHidden
    singleColor_UI_update(nFromPl(pl))
    getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]).call("hideThisChar")
end

-------------------------   initiative

function toggleInitEdit(pl,vl,thisID)
    if pl.color == "Black" then
        initEditPanelVisible = not initEditPanelVisible
        if initEditPanelVisible then
            UI_xmlElementUpdate("initEditPanel", "active", "True")
        else
            UI_xmlElementUpdate("initEditPanel", "active", "False")
        end
    end
end

function initSetupButt(pl,vl,thisID)
    if initEditPos == numFromStrEnd(thisID) then
        if vl == "-1" then
            initEditPos = 0
            UI_xmlElementUpdate("initSetupPanel", "active", "False")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(numFromStrEnd(thisID)), "tooltip", "setup")
        elseif vl == "-2" then
            table.remove(init_table, numFromStrEnd(thisID))
            if initTurnPos > numFromStrEnd(thisID) then initTurnPos = initTurnPos - 1 end
            --if initTurnPos == numFromStrEnd(thisID) and initTurnPos < #init_table then initTurnPos = initTurnPos end
            if numFromStrEnd(thisID) > #init_table then initTurnPos = 1 end
            initEditPos = 0
            UI_xmlElementUpdate("initSetupPanel", "active", "False")
            initiative_UI_update()
        end
        
    elseif initEditPos != numFromStrEnd(thisID) and numFromStrEnd(thisID) <= #init_table then
        UI_xmlElementUpdate("initSetupButton_"..strFromNum(initEditPos), "tooltip", "setup")
        initEditPos = numFromStrEnd(thisID)
        UI_xmlElementUpdate("initSetupPanel", "active", "True")
        UI_xmlElementUpdate("initSetupPanel", "offsetXY", "0 "..tostring(216 - 27 * initEditPos))
        UI_xmlElementUpdate("initSetupButton_"..strFromNum(numFromStrEnd(thisID)), "tooltip", "Right click:\nremove from initiative!")

        UI_xmlElementUpdate("initSetupRezInput", "text", init_table[numFromStrEnd(thisID)].rollRez)
        UI_xmlElementUpdate("initSetupNameInput", "text", init_table[numFromStrEnd(thisID)].charName)
        UI_xmlElementUpdate("initSetupModInput", "text", init_table[numFromStrEnd(thisID)].initMod)
        UI_xmlElementUpdate("initSetupColButton", "tooltip", plColors_Table[init_table[numFromStrEnd(thisID)].aColor])
        
    elseif #init_table < 15 and numFromStrEnd(thisID) == #init_table + 1 then
        table.insert(init_table, #init_table + 1, {
            charName = "",
            rollRez = 0,
            initMod = 0,
            tokenGUID = "",
            aColor = 1
        })
        initiative_UI_update()
    end
end

function addCharToInitiative(pl,vl,thisID)
    if #init_table < 15 then
        alreadyInInitiative = false
        for i=1,#init_table do
            if lastPickedCharGUID_table[nFromPl(pl)] == init_table[i].tokenGUID then
                alreadyInInitiative = true
            end
        end
        if not alreadyInInitiative then
            table.insert(init_table, #init_table + 1, {
                charName = main_Table[nFromPl(pl)].charName,
                rollRez = 0,
                initMod = modFromAttr(main_Table[nFromPl(pl)].attributes[2]) + main_Table[nFromPl(pl)].initMod,
                tokenGUID = lastPickedCharGUID_table[nFromPl(pl)],
                aColor = nFromPl(pl)
            })
            initiative_UI_update()
        end
    end
end

function initiative_UI_update()   -------------
    UI_xmlElementUpdate("initTitleText", "text", lang_table[lang_set][47])
    UI_xmlElementUpdate("initRoundCounter", "text", lang_table[lang_set][48]..initRound)
    for i=1,15 do
        if i <= #init_table then
            if i == initTurnPos then
                UI_xmlElementUpdate("initText_A_"..strFromNum(i), "color", "#ffff00")
                UI_xmlElementUpdate("initText_A_"..strFromNum(i), "outline", "#888800")
            else
                UI_xmlElementUpdate("initText_A_"..strFromNum(i), "color", "#000000")
                UI_xmlElementUpdate("initText_A_"..strFromNum(i), "outline", "#00000000")
            end
            UI_xmlElementUpdate("initText_A_"..strFromNum(i), "text", init_table[i].rollRez)
            UI_xmlElementUpdate("initText_B_"..strFromNum(i), "text", init_table[i].charName)
            UI_xmlElementUpdate("initText_C_"..strFromNum(i), "text", PoM_add(init_table[i].initMod))
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(i), "color", "#ffffff")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(i), "text", "*")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(i), "tooltip", "setup")

            UI_xmlElementUpdate("initColor_"..strFromNum(i), "color", plColorsHexTable[init_table[i].aColor])
            UI_xmlElementUpdate("initColor_"..strFromNum(i), "outline", plColorsHexTable[init_table[i].aColor])
        else
            UI_xmlElementUpdate("initText_A_"..strFromNum(i), "text", "")
            UI_xmlElementUpdate("initText_B_"..strFromNum(i), "text", "")
            UI_xmlElementUpdate("initText_C_"..strFromNum(i), "text", "")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(i), "color", "#ffffff00")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(i), "text", "")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(i), "tooltip", "")

            UI_xmlElementUpdate("initColor_"..strFromNum(i), "color",   "#00000000")
            UI_xmlElementUpdate("initColor_"..strFromNum(i), "outline", "#00000000")
        end
    end
    
    if #init_table < 15 then
        Wait.frames(function()
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(#init_table + 1), "color", "#aaaaaa")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(#init_table + 1), "text", "+")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(#init_table + 1), "tooltip", "add char")
        end, 1)
    end
    if #init_table > 0 then
        UI_xmlElementUpdate("initCol_01", "tooltip", init_table[initTurnPos].charName.."\n"..init_table[initTurnPos].rollRez.." ("..PoM_add(init_table[initTurnPos].initMod)..")")
        UI_xmlElementUpdate("initCol_01", "color", plColorsHexTable[init_table[initTurnPos].aColor])
        UI_xmlElementUpdate("initImage_01", "color", "#ffffff")
        if getObjectFromGUID(init_table[initTurnPos].tokenGUID) != nil then
            UI_xmlElementUpdate("initImage_01", "image", getObjectFromGUID(init_table[initTurnPos].tokenGUID).getTable("charSave_table").portraitUrl)
        else
            UI_xmlElementUpdate("initImage_01", "image", "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/")
        end
        initImgUpdatePos = initTurnPos
        for i=2,6 do
            initImgUpdatePos = initImgUpdatePos + 1
            if initImgUpdatePos > #init_table then initImgUpdatePos = 1 end
            UI_xmlElementUpdate("initCol_"..strFromNum(i), "tooltip", init_table[initImgUpdatePos].charName.."\n"..init_table[initImgUpdatePos].rollRez.." ("..PoM_add(init_table[initImgUpdatePos].initMod)..")")
            UI_xmlElementUpdate("initCol_"..strFromNum(i), "color", plColorsHexTable[init_table[initImgUpdatePos].aColor])
            UI_xmlElementUpdate("initImage_"..strFromNum(i), "color", "#ffffff")
            if getObjectFromGUID(init_table[initImgUpdatePos].tokenGUID) != nil then
                UI_xmlElementUpdate("initImage_"..strFromNum(i), "image", getObjectFromGUID(init_table[initImgUpdatePos].tokenGUID).getTable("charSave_table").portraitUrl)
            else
                UI_xmlElementUpdate("initImage_"..strFromNum(i), "image", "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/")
            end
        end
    else
        for i=1,6 do
            UI_xmlElementUpdate("initCol_"..strFromNum(i), "tooltip", "")
            UI_xmlElementUpdate("initCol_"..strFromNum(i), "color", "#aaaaaa")
            UI_xmlElementUpdate("initImage_"..strFromNum(i), "color", "#aaaaaa00")
        end
    end
    if #init_table > 0 then
        if init_table[initTurnPos].aColor == 1 then
            UI_xmlElementUpdate("initPassButton", "visibility", "Black")
        else
            UI_xmlElementUpdate("initPassButton", "visibility", "Black|"..plColors_Table[init_table[initTurnPos].aColor])
        end
    else
        UI_xmlElementUpdate("initPassButton", "visibility", "Black")
    end
end

function initExchange(a,b)
    init_table[0] = {}
    init_table[0].charName  = init_table[a].charName  
    init_table[0].rollRez   = init_table[a].rollRez   
    init_table[0].initMod   = init_table[a].initMod   
    init_table[0].tokenGUID = init_table[a].tokenGUID 
    init_table[0].aColor    = init_table[a].aColor    

    init_table[a].charName  = init_table[b].charName  
    init_table[a].rollRez   = init_table[b].rollRez   
    init_table[a].initMod   = init_table[b].initMod   
    init_table[a].tokenGUID = init_table[b].tokenGUID 
    init_table[a].aColor    = init_table[b].aColor    

    init_table[a].charName  = init_table[0].charName  
    init_table[a].rollRez   = init_table[0].rollRez   
    init_table[a].initMod   = init_table[0].initMod   
    init_table[a].tokenGUID = init_table[0].tokenGUID 
    init_table[a].aColor    = init_table[0].aColor    
end

function initMoveActive(pl,vl,thisID)
    if vl == "-2" then
        initTurnPos = initTurnPos + 1
        if initTurnPos > #init_table then initTurnPos = 1 initRound = initRound + 1 end
    elseif vl == "-1" then
        initTurnPos = initTurnPos - 1
        if initTurnPos < 1 then initTurnPos = #init_table initRound = initRound - 1 end
    end
    initiative_UI_update()
end

function initPass(pl,vl,thisID)
    initMoveActive(pl,"-2",thisID)
end

function initSetupRezInp(pl,vl,thisID)
    if tonumber(vl) != nil then
        init_table[initEditPos].rollRez = tonumber(vl)
        initiative_UI_update()
    end
end

function initSetupNameInp(pl,vl,thisID)
    init_table[initEditPos].charName = vl
    initiative_UI_update()
end

function initToggleColor(pl,vl,thisID)
    if vl == "-1" then
        init_table[initEditPos].aColor = init_table[initEditPos].aColor + 1
        if init_table[initEditPos].aColor > 11 then init_table[initEditPos].aColor = 1 end
    elseif vl == "-2" then
        init_table[initEditPos].aColor = init_table[initEditPos].aColor - 1
        if init_table[initEditPos].aColor < 1 then init_table[initEditPos].aColor = 11 end
    end
    UI_xmlElementUpdate("initSetupColButton", "tooltip", plColors_Table[init_table[initEditPos].aColor])
    initiative_UI_update()
end

function initSetupModInp(pl,vl,thisID)
    if tonumber(vl) != nil then
        init_table[initEditPos].initMod = tonumber(vl)
        initiative_UI_update()
    end
end

function initRollAll(pl,vl,thisID)
    math.randomseed(os.clock()*10000)
    for i=1,#init_table do
        init_table[i].rollRez = math.random(1,20) + init_table[i].initMod
    end
    initiative_UI_update()
end

function initRollSingle(pl,vl,thisID)
    math.randomseed(os.clock()*10000)
    init_table[initEditPos].rollRez = math.random(1,20) + init_table[initEditPos].initMod
    UI_xmlElementUpdate("initSetupRezInput", "text", init_table[initEditPos].rollRez)
    initiative_UI_update()
end

function initSortAll(pl,vl,thisID)
    if #init_table > 1 then
        table.sort(init_table, function (k1, k2)
            return k1.rollRez > k2.rollRez
        end)
        initiative_UI_update()
    end
end

function initRoundsReset(pl,vl,thisID)
    initRound = 1
    initiative_UI_update()
end
-------------------------   conditions

function contitionButt(pl,vl,thisID)
    if numFromStrEnd(thisID) != 18 then
        main_Table[nFromPl(pl)].conditions.table[numFromStrEnd(thisID)] = not main_Table[nFromPl(pl)].conditions.table[numFromStrEnd(thisID)]
    else
        if vl == "-1" then
            main_Table[nFromPl(pl)].conditions.exhaustion = main_Table[nFromPl(pl)].conditions.exhaustion + 1
            if main_Table[nFromPl(pl)].conditions.exhaustion > 5 then main_Table[nFromPl(pl)].conditions.exhaustion = 0 end
        elseif vl == "-2" then
            main_Table[nFromPl(pl)].conditions.exhaustion = main_Table[nFromPl(pl)].conditions.exhaustion - 1
            if main_Table[nFromPl(pl)].conditions.exhaustion < 0 then main_Table[nFromPl(pl)].conditions.exhaustion = 5 end
        end
        if main_Table[nFromPl(pl)].conditions.exhaustion != 0 then
            main_Table[nFromPl(pl)].conditions.table[numFromStrEnd(thisID)] = true
        else
            main_Table[nFromPl(pl)].conditions.table[numFromStrEnd(thisID)] = false
        end
    end
    singleColor_UI_update(nFromPl(pl))
end

-------------------------   char 3d UI settings

function tokenGUI_slider(pl,vl,thisID)
    main_Table[numFromStr(thisID)].tokenGUI_settings[numFromStrEnd(thisID)] = tonumber(vl)
    singleColor_UI_update(nFromPl(pl))
end

function tokenGUI_reset(pl,vl,thisID)
    main_Table[nFromPl(pl)].tokenGUI_settings = {0,0,0,0,5}
    singleColor_UI_update(nFromPl(pl))
end

-------------------------   UI updates

function colorToggleEditMode(pl,vl,thisID)
    if vl == "-1" then
        editModeVisibility[nFromPl(pl)] = not editModeVisibility[nFromPl(pl)]
        editModeVisibilityStr = "noone"
        isNoOne = true
        for i=1,11 do
            if editModeVisibility[i] then
                isNoOne = false
                editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
            end
        end
        if not isNoOne then
            editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
        end

        UI_xmlElementUpdate("charPortraitNameInputsPanel","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("charLvlEdit","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("charACedit","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("charSpeedEdit","visibility",editModeVisibilityStr)
        if editModeVisibility[1] then
            UI_xmlElementUpdate("charProfBonusEdit","visibility","Black")
            UI_xmlElementUpdate("assignedPlayersPanel","visibility","Black")
        else
            UI_xmlElementUpdate("charProfBonusEdit","visibility","noone")
            UI_xmlElementUpdate("assignedPlayersPanel","visibility","noone")
        end
        UI_xmlElementUpdate("charInitEdit","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("charPassPercEdit","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("charHPinputs","visibility",editModeVisibilityStr)
        for i=1,6 do
            UI_xmlElementUpdate("charAttrEdit_"..i,"visibility",editModeVisibilityStr)
        end
        UI_xmlElementUpdate("savesModsButtons","visibility",editModeVisibilityStr)
        for i=1,18 do
            UI_xmlElementUpdate("charSkillEditButtons_"..strFromNum(i),"visibility",editModeVisibilityStr)
        end

        UI_xmlElementUpdate(strFromNum(nFromPl(pl)).."_charPortraitUrlInput", "text", main_Table[nFromPl(pl)].portraitUrl)

        UI_xmlElementUpdate("atkEditPanel","visibility",editModeVisibilityStr)
        for i=1,10 do
            if editModeSelectedAttack[nFromPl(pl)] == i or not editModeVisibility[nFromPl(pl)] then
                atkButtonImg_color = "#ffffffff"
            else
                atkButtonImg_color = "#ffffff88"
            end
            UI_xmlElementUpdate(strFromNum(nFromPl(pl)).."_atkButtonImg_"..strFromNum(i),"color",atkButtonImg_color)
        end
        if editModeVisibility[nFromPl(pl)] then
            atkEdit_UI_update(nFromPl(pl), editModeSelectedAttack[nFromPl(pl)])
        end
        UI_xmlElementUpdate("spellSlotsEditMaxButtons","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("spellSlotMaxAllButton","visibility",editModeVisibilityStr)
        UI_xmlElementUpdate("resoursesEditInputsPanel","visibility",editModeVisibilityStr)

        UI_xmlElementUpdate("notesInputs","visibility",editModeVisibilityStr)
    elseif vl == "-2" and editModeVisibility[nFromPl(pl)] and getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]) != nil then
        --resetCounter
        if resetCounter < 4 then
            resetCounter = resetCounter + 1
            UI_xmlElementUpdate("charSheetUtilButton_08","color","#ff8888")
            if resetCounter == 1 then
                Wait.time(function()
                    resetCounter = 0
                    UI_xmlElementUpdate("charSheetUtilButton_08","color","#ffffff")
                end, 3)
            end
        else
            getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]).call("resetChar")
            GetStatsFromToken(nFromPl(pl), getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]))
            UI_xmlElementUpdate("charSheetUtilButton_08","color","#ffffff")
            resetCounter = 0
        end
    end
end

function colorToggleShowAttacks(pl,_,thisID)
    panelVisibility_attacks[nFromPl(pl)] = not panelVisibility_attacks[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_attacks[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_attacks","visibility",editModeVisibilityStr)
end

function colorToggleShowSpellSlots(pl,_,thisID)
    panelVisibility_spellSlots[nFromPl(pl)] = not panelVisibility_spellSlots[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_spellSlots[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_spellSlots","visibility",editModeVisibilityStr)
end

function colorToggleShowResourses(pl,_,thisID)
    panelVisibility_resourses[nFromPl(pl)] = not panelVisibility_resourses[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_resourses[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_resourses","visibility",editModeVisibilityStr)
end

function colorToggleShowNotes(pl,_,thisID)
    panelVisibility_notes[nFromPl(pl)] = not panelVisibility_notes[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_notes[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_notes","visibility",editModeVisibilityStr)
end

function colorToggleConditions(pl,_,thisID)
    panelVisibility_conditions[nFromPl(pl)] = not panelVisibility_conditions[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_conditions[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_conditions","visibility",editModeVisibilityStr)
end

function colorToggleUIsetup(pl,_,thisID)
    panelVisibility_UIset[nFromPl(pl)] = not panelVisibility_UIset[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_UIset[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_UIset","visibility",editModeVisibilityStr)
end

function colorToggleShowMain(pl,vl,thisID)
    panelVisibility_main[nFromPl(pl)] = not panelVisibility_main[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_main[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("panel_main","visibility",editModeVisibilityStr)
    if not panelVisibility_main[nFromPl(pl)] and vl == "-2" then
        panelVisibility_attacks[nFromPl(pl)] = true
        colorToggleShowAttacks(pl,_,_)
        panelVisibility_spellSlots[nFromPl(pl)] = true
        colorToggleShowSpellSlots(pl,_,_)
        panelVisibility_resourses[nFromPl(pl)] = true
        colorToggleShowResourses(pl,_,_)
        panelVisibility_notes[nFromPl(pl)] = true
        colorToggleShowNotes(pl,_,_)
        panelVisibility_conditions[nFromPl(pl)] = true
        colorToggleConditions(pl,_,_)
        panelVisibility_UIset[nFromPl(pl)] = true
        colorToggleUIsetup(pl,_,_)
    end
end

function colorToggleShowMiniMap(pl,vl,thisID)
    panelVisibility_miniMap[nFromPl(pl)] = not panelVisibility_miniMap[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_miniMap[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("miniMapPanel","visibility",editModeVisibilityStr)
    miniMap_UI_update()
end

function colorToggleShowInitiative(pl,vl,thisID)
    panelVisibility_init[nFromPl(pl)] = not panelVisibility_init[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_init[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("init_panel","visibility",editModeVisibilityStr)
end

function colorToggleProjector(pl,vl,thisID)
    if nFromPl(pl) == 1 and vl == "-2" then
        panelVisibility_projector[nFromPl(pl)] = not panelVisibility_projector[nFromPl(pl)]
        if panelVisibility_projector[1] then
            panelVisibility_projector = {true,true,true,true,true,true,true,true,true,true,true}
            UI_xmlElementUpdate("projectorImage","visibility","Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink")
        else
            panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
            UI_xmlElementUpdate("projectorImage","visibility","noone")
        end
    else
        panelVisibility_projector[nFromPl(pl)] = not panelVisibility_projector[nFromPl(pl)]
        editModeVisibilityStr = "noone"
        isNoOne = true
        for i=1,11 do
            if panelVisibility_projector[i] then
                isNoOne = false
                editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
            end
        end
        if not isNoOne then
            editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
        end
        UI_xmlElementUpdate("projectorImage","visibility",editModeVisibilityStr)
    end
end

function colorToggleBigPortrait(pl,vl,thisID)
    if thisID == "bigPortraitBigClose" then
        panelVisibility_bigPortrait[nFromPl(pl)] = false
    elseif thisID == "bigPortraitSelf" or (string.sub(thisID, 1, 15) == "bigPortraitInit" and #init_table > 0) or string.sub(thisID, 4, #thisID) == "bigPortraitTeam" then
        panelVisibility_bigPortrait[nFromPl(pl)] = true
        if thisID == "bigPortraitSelf" then
            UI_xmlElementUpdate(strFromNum(nFromPl(pl)).."_bigPortraitImage","image",main_Table[nFromPl(pl)].portraitUrl)
        elseif string.sub(thisID, 1, 15) == "bigPortraitInit" and #init_table > 0 then
            bigPortraitInitPos = initTurnPos
            for i=1,numFromStrEnd(thisID)-1 do
                bigPortraitInitPos = bigPortraitInitPos + 1
                if bigPortraitInitPos > #init_table then bigPortraitInitPos = 1 end
            end
            if vl == "-1" then
                UI_xmlElementUpdate(strFromNum(nFromPl(pl)).."_bigPortraitImage","image",getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID).getTable("charSave_table").portraitUrl)
            elseif vl == "-2" then
                panelVisibility_bigPortrait[nFromPl(pl)] = false
                if getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID) != nil then
                    Player[plColors_Table[nFromPl(pl)]].pingTable( getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID).getPosition() )
                end
            end
        elseif string.sub(thisID, 4, #thisID) == "bigPortraitTeam" then
            UI_xmlElementUpdate(strFromNum(nFromPl(pl)).."_bigPortraitImage","image",main_Table[numFromStr(thisID)].portraitUrl)
        end
    end
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_bigPortrait[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("bigPortraitPanel","visibility",editModeVisibilityStr)
end

function onObjectRandomize(object, player_color)
    if panelVisibility_projector[1] then
        if player_color == "Black" and object.getCustomObject().image != nil then
            object.setVelocity({0,0,0})
            UI_xmlElementUpdate("projectorImage", "image", object.getCustomObject().image)
            UI_xmlElementUpdate("projectorImage", "tooltip", object.getName())
        end
    end
end

function atkEdit_UI_update(pl_N,atk_N)
    
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditNameText","text"," "..atk_N..". "..main_Table[pl_N].attacks[atk_N].atkName)
    if main_Table[pl_N].attacks[atk_N].atkRolled then tempColorStr = "#8888ffff" else tempColorStr = "#ffffff00" end
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditRollAtkButton","textOutline",tempColorStr)
    if main_Table[pl_N].attacks[atk_N].atkAttr != 0 then
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditAtkAttrButton","text",lang_table[lang_set][main_Table[pl_N].attacks[atk_N].atkAttr + 7])
    else
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditAtkAttrButton","text","")
    end
    if main_Table[pl_N].attacks[atk_N].proficient then tempColorStr = "#8888ffff" else tempColorStr = "#ffffff00" end
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditProfButton","textOutline",tempColorStr)
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditMinCritText","text",lang_table[lang_set][41]..main_Table[pl_N].attacks[atk_N].minCrit)
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditAtkModText","text",lang_table[lang_set][42]..PoM_add(main_Table[pl_N].attacks[atk_N].atkMod))
    if main_Table[pl_N].attacks[atk_N].dmgRolled then tempColorStr = "#8888ffff" else tempColorStr = "#ffffff00" end
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditRollDmgButton","textOutline",tempColorStr)
    if main_Table[pl_N].attacks[atk_N].dmgAttr != 0 then
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditDmgAttrButton","text",lang_table[lang_set][main_Table[pl_N].attacks[atk_N].dmgAttr + 7])
    else
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditDmgAttrButton","text","")
    end

    if main_Table[pl_N].attacks[atk_N].resUsed != 0 then
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditResUsedButton","text", main_Table[pl_N].attacks[atk_N].resUsed..". "..main_Table[pl_N].resourses[main_Table[pl_N].attacks[atk_N].resUsed].resName)
    else
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditResUsedButton","text","")
    end

    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditDmgStrText","text",lang_table[lang_set][43]..main_Table[pl_N].attacks[atk_N].dmgStr)
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditCritDmgStrText","text",lang_table[lang_set][44]..main_Table[pl_N].attacks[atk_N].dmgStrCrit)
    
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditIconImg","image",atkIconsUrl_Table[main_Table[pl_N].attacks[atk_N].icon])

    for ii=1,10 do
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkButtonImg_"..strFromNum(ii),"image",atkIconsUrl_Table[main_Table[pl_N].attacks[ii].icon])
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkButton_"..strFromNum(ii),"tooltip",main_Table[pl_N].attacks[ii].atkName)
    end

    for ii=1,50 do
        if main_Table[pl_N].attacks[editModeSelectedAttack[pl_N]].icon == ii then
            UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditIconsGridButton_"..strFromNum(ii),"color","#ffffff02")
        else
            UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditIconsGridButton_"..strFromNum(ii),"color","#ffffff44")
        end
    end

    if lastPickedCharGUID_table[pl_N] != "" and getObjectFromGUID(lastPickedCharGUID_table[pl_N]) != nil and not firstLoad then
        SetStatsIntoToken(pl_N)
    end
end

function colorToggleAtkIconsMenu(pl,_,thisID)
    panelVisibility_atkIconsMenu[nFromPl(pl)] = not panelVisibility_atkIconsMenu[nFromPl(pl)]
    editModeVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if panelVisibility_atkIconsMenu[i] then
            isNoOne = false
            editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
    end
    UI_xmlElementUpdate("atkIconsMenu","visibility",editModeVisibilityStr)
end

function atkIconsMenuButton(pl,vl,thisID)
    if numFromStrEnd(thisID) <= #atkIconsUrl_Table then
        main_Table[nFromPl(pl)].attacks[editModeSelectedAttack[pl_N]].icon = numFromStrEnd(thisID)
        colorToggleAtkIconsMenu(pl,_,thisID)
        atkEdit_UI_update(nFromPl(pl),editModeSelectedAttack[pl_N])
    end
end

function colorToggleScreenRoller(pl,_,thisID)
    for i=1,11 do
        if pl.color == plColors_Table[i] then
            screenRollerVisibility[i] = not screenRollerVisibility[i]
        end
    end
    screenRollerVisibilityStr = "noone"
    isNoOne = true
    for i=1,11 do
        if screenRollerVisibility[i] then
            isNoOne = false
            screenRollerVisibilityStr = screenRollerVisibilityStr.. "|".. plColors_Table[i]
        end
    end
    if not isNoOne then
        screenRollerVisibilityStr = string.sub(screenRollerVisibilityStr, 7, #screenRollerVisibilityStr)
    end
    UI_xmlElementUpdate("screenRollerBigPanel","visibility",screenRollerVisibilityStr)
end

function mainSheet_UI_update()
    for ii=1,6 do
        UI_xmlElementUpdate("attrName_"..strFromNum(ii), "text", lang_table[lang_set][ii + 7])
    end
    for i=1,11 do
        singleColor_UI_update(i)
    end
    firstLoad = false
end

function singleColor_UI_update(n)
    UI_upd(n)
    if lastPickedCharGUID_table[n] != "" and getObjectFromGUID(lastPickedCharGUID_table[n]) != nil and not firstLoad then
        SetStatsIntoToken(n)
    end
    for i=1,11 do
        if lastPickedCharGUID_table[i] != "" and i != n and lastPickedCharGUID_table[i] == lastPickedCharGUID_table[n] then
            if getObjectFromGUID(lastPickedCharGUID_table[i]) != nil then
                GetStatsFromToken(i,getObjectFromGUID(lastPickedCharGUID_table[i]))
            end
        end
    end
end

function UI_upd(i)
    UI_xmlElementUpdate(strFromNum(i).."_charPortrait", "image", main_Table[i].portraitUrl)
    UI_xmlElementUpdate(strFromNum(i).."_charPortraitUrlInput", "text", main_Table[i].portraitUrl)
        
    UI_xmlElementUpdate(strFromNum(i).."_charName", "text", main_Table[i].charName)
    UI_xmlElementUpdate(strFromNum(i).."_charLvl", "text", lang_table[lang_set][2]..main_Table[i].charLvl)
    UI_xmlElementUpdate(strFromNum(i).."_charAC", "text", lang_table[lang_set][3]..main_Table[i].AC)
    UI_xmlElementUpdate(strFromNum(i).."_charSpeed", "text", lang_table[lang_set][4]..main_Table[i].speed)
    UI_xmlElementUpdate(strFromNum(i).."_charProfBonus", "text", lang_table[lang_set][5].."+"..main_Table[i].charProfBonus)

    if main_Table[i].initMod != 0 then initModStr = "  ("..PoM(main_Table[i].initMod)..main_Table[i].initMod..")" else initModStr = "" end
    UI_xmlElementUpdate(strFromNum(i).."_charInitAddButton", "text", lang_table[lang_set][6]..PoM(modFromAttr(main_Table[i].attributes[2]) + main_Table[i].initMod)..(modFromAttr(main_Table[i].attributes[2]) + main_Table[i].initMod)..initModStr)
        
    pPerseptionBase = 10 + modFromAttr(main_Table[i].attributes[5]) + main_Table[i].skills[12].mod
    if main_Table[i].skills[12].proficient then pPerseptionBase = pPerseptionBase + main_Table[i].charProfBonus end
    if main_Table[i].skills[12].expertize  then pPerseptionBase = pPerseptionBase + main_Table[i].charProfBonus end
    if main_Table[i].pPerceptionMod != 0 then ppModStr = " ("..PoM(main_Table[i].pPerceptionMod)..main_Table[i].pPerceptionMod..")" else ppModStr = "" end
    UI_xmlElementUpdate(strFromNum(i).."_charPassivePerception", "text", lang_table[lang_set][7]..(main_Table[i].pPerceptionMod + pPerseptionBase)..ppModStr)

    UI_xmlElementUpdate(strFromNum(i).."_charHPbar", "width", math.floor(main_Table[i].hp / main_Table[i].hpMax * 386))
    UI_xmlElementUpdate(strFromNum(i).."_charHPbar", "offsetXY", "-"..(193 - math.floor(main_Table[i].hp / main_Table[i].hpMax * 193))..",-15")

    UI_xmlElementUpdate(strFromNum(i).."_charHPtext", "text", main_Table[i].hp.." / "..main_Table[i].hpMax)
    if main_Table[i].hpTemp > 0 then
        UI_xmlElementUpdate(strFromNum(i).."_charTempHPtext", "text", "+"..main_Table[i].hpTemp)
    else
        UI_xmlElementUpdate(strFromNum(i).."_charTempHPtext", "text", "")
    end
    
    if i == 1 and main_Table[i].hpVisibleToPlayers then
        UI_xmlElementUpdate("charHPsetVisibilityButton", "text", "<O>") --●◘ ◯
    elseif i == 1 and not main_Table[i].hpVisibleToPlayers then
        UI_xmlElementUpdate("charHPsetVisibilityButton", "text", "GM")
    end

    if main_Table[i].hp < 1 then
        dSavesActive = "True"
    else
        dSavesActive = "False"
    end
    for ii=1,5 do
        UI_xmlElementUpdate(strFromNum(i).."_charDeathSaveButton_"..strFromNum(ii), "active", dSavesActive)
        UI_xmlElementUpdate(strFromNum(i).."_charDeathSaveButton_"..strFromNum(ii), "text", dSavesStr_table[main_Table[i].deathSaves[ii]])
    end
        
    for ii=1,6 do
        UI_xmlElementUpdate(strFromNum(i).."_charAttrValue_"..strFromNum(ii), "text", main_Table[i].attributes[ii])
        UI_xmlElementUpdate(strFromNum(i).."_charAttrMod_"..strFromNum(ii), "text", PoM(modFromAttr(main_Table[i].attributes[ii]))..modFromAttr(main_Table[i].attributes[ii]))
        if main_Table[i].saves[ii] then fontStr = "bold" else fontStr = "italic" end
    end

    for smN,smV in pairs(main_Table[i].savesMod) do
        if smV != 0 then saveModStr = "\n"..PoM(smV)..smV else saveModStr = "" end
        UI_xmlElementUpdate(strFromNum(i).."_charSaveButton_"..smN, "text", lang_table[lang_set][14]..saveModStr)
        UI_xmlElementUpdate(strFromNum(i).."_charSaveButton_"..smN, "fontStyle", fontStr)
    end
        
    for ii=1,18 do
        if main_Table[i].skills[ii].proficient then fontStr = "bold" else fontStr = "italic" end
        if main_Table[i].skills[ii].expertize then exStr = " ("..lang_table[lang_set][33]..")" else exStr = "" end
        if main_Table[i].skills[ii].mod != 0 then sklModStr = " "..PoM(main_Table[i].skills[ii].mod)..main_Table[i].skills[ii].mod else sklModStr = "" end
        --UI_xmlElementUpdate(strFromNum(i).."_charSkillButton_"..strFromNum(ii), "text", lang_table[lang_set][14 + ii].." ("..lang_table[lang_set][7 + defSkillsAttr_table[ii]]..")"..exStr)
        UI_xmlElementUpdate(strFromNum(i).."_charSkillButton_"..strFromNum(ii), "text", lang_table[lang_set][14 + ii].." ("..string.sub(lang_table[lang_set][7 + defSkillsAttr_table[ii]],1,1)..")"..exStr..sklModStr)
        UI_xmlElementUpdate(strFromNum(i).."_charSkillButton_"..strFromNum(ii), "fontStyle", fontStr)

        thisSkillMod = modFromAttr(main_Table[i].attributes[defSkillsAttr_table[ii]]) + main_Table[i].skills[ii].mod
        if main_Table[i].skills[ii].proficient and main_Table[i].skills[ii].expertize then
            thisSkillMod = thisSkillMod + main_Table[i].charProfBonus * 2
        elseif main_Table[i].skills[ii].proficient and not main_Table[i].skills[ii].expertize then
            thisSkillMod = thisSkillMod + main_Table[i].charProfBonus
        end
        UI_xmlElementUpdate(strFromNum(i).."_charSkillButton_"..strFromNum(ii), "tooltip", "d20"..PoM(thisSkillMod)..thisSkillMod)
    end

    for ii=1,10 do
        UI_xmlElementUpdate(strFromNum(i).."_atkButtonImg_"..strFromNum(ii),"image",atkIconsUrl_Table[main_Table[i].attacks[ii].icon])
        UI_xmlElementUpdate(strFromNum(i).."_atkButton_"..strFromNum(ii),"tooltip",main_Table[i].attacks[ii].atkName)
    end

    for ii=1,9 do
        spellButtonStr = ""
        for iii=1,main_Table[i].splSlotsMax[ii] do
            if iii <= main_Table[i].splSlots[ii] then
                spellButtonStr = spellButtonStr.."●"
            else
                spellButtonStr = spellButtonStr.."○"
            end
        end
        UI_xmlElementUpdate(strFromNum(i).."_spellSlotButton_"..strFromNum(ii),"text", " "..ii..". "..spellButtonStr)
    end

    for ii=1,10 do
        UI_xmlElementUpdate(strFromNum(i).."_resTextName_"..strFromNum(ii),"text", " "..ii..". "..main_Table[i].resourses[ii].resName)
        if main_Table[i].resourses[ii].resMax > 0 then
            UI_xmlElementUpdate(strFromNum(i).."_resTextNum_"..strFromNum(ii),"text", main_Table[i].resourses[ii].resValue.." / "..main_Table[i].resourses[ii].resMax)
        else
            UI_xmlElementUpdate(strFromNum(i).."_resTextNum_"..strFromNum(ii),"text", main_Table[i].resourses[ii].resValue)
        end
    end

    UI_xmlElementUpdate(strFromNum(i).."_notesText_A","text", main_Table[i].notes_A)
    UI_xmlElementUpdate(strFromNum(i).."_notesText_B","text", main_Table[i].notes_B)
    UI_xmlElementUpdate(strFromNum(i).."_notesInput_A","text", main_Table[i].notes_A)
    UI_xmlElementUpdate(strFromNum(i).."_notesInput_B","text", main_Table[i].notes_B)

    if i == 1 then
        for ii=2,11 do
            if main_Table[i].aColors[ii] then
                UI_xmlElementUpdate("assighedPlayerButton_"..strFromNum(ii),"text", "●")
            else
                UI_xmlElementUpdate("assighedPlayerButton_"..strFromNum(ii),"text", "")
            end
        end
    end

    for ii=1,20 do
        if main_Table[i].conditions.table[ii] then condButtColor = "#ffffff02" else condButtColor = "#ffffff88" end
        UI_xmlElementUpdate(strFromNum(i).."_conditionButton_"..strFromNum(ii),"color", condButtColor)
    end

    for ii=1,5 do
        editModeVisibilityStr = "noone"
        isNoOne = true
        for iii=1,11 do
            if main_Table[iii].conditions.exhaustion == ii then
                isNoOne = false
                editModeVisibilityStr = editModeVisibilityStr.. "|".. plColors_Table[iii]
            end
        end
        if not isNoOne then
            editModeVisibilityStr = string.sub(editModeVisibilityStr, 7, #editModeVisibilityStr)
        end
        UI_xmlElementUpdate("exhaustionIcon_"..strFromNum(ii),"visibility",editModeVisibilityStr)
    end

    UI_xmlElementUpdate(strFromNum(i).."_UIsetSlider_"..strFromNum(1),"value",main_Table[i].tokenGUI_settings[1])
    UI_xmlElementUpdate(strFromNum(i).."_UIsetSlider_"..strFromNum(2),"value",main_Table[i].tokenGUI_settings[2])
    UI_xmlElementUpdate(strFromNum(i).."_UIsetSlider_"..strFromNum(3),"value",main_Table[i].tokenGUI_settings[3])
    UI_xmlElementUpdate(strFromNum(i).."_UIsetSlider_"..strFromNum(4),"value",main_Table[i].tokenGUI_settings[4])
    UI_xmlElementUpdate(strFromNum(i).."_UIsetSlider_"..strFromNum(5),"value",main_Table[i].tokenGUI_settings[5])
    
    if main_Table[i].charHidden then
        UI_xmlElementUpdate("setInvisButton","color","#000022")
    else
        UI_xmlElementUpdate("setInvisButton","color","#cccccc")
    end

    teamBar_UI_update()
end

function onPlayerChangeColor(player_color)
    Wait.frames(function()
        teamBar_UI_update()
    end, 3)
end

function teamBar_UI_update()
    nPlayers = 0
    for i=2,11 do
        if Player[plColors_Table[i]].seated and lastPickedCharGUID_table[i] != "" and getObjectFromGUID(lastPickedCharGUID_table[i]) != nil and not getObjectFromGUID(lastPickedCharGUID_table[i]).getTable("charSave_table").charHidden then
            nPlayers = nPlayers + 1
            UI_xmlElementUpdate(strFromNum(i).."_teamBarSegment", "active", "True")
            UI_xmlElementUpdate(strFromNum(i).."_teamBarColor", "color", plColorsHexTable[i])
            if lastPickedCharGUID_table[i] != "" and getObjectFromGUID(lastPickedCharGUID_table[i]) != nil then
                UI_xmlElementUpdate(strFromNum(i).."_teamBarImage", "image", main_Table[i].portraitUrl)
            else
                UI_xmlElementUpdate(strFromNum(i).."_teamBarImage", "image", "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/")
            end
            pPerseptionBase = 10 + modFromAttr(main_Table[i].attributes[5]) + main_Table[i].skills[12].mod
            if main_Table[i].skills[12].proficient then pPerseptionBase = pPerseptionBase + main_Table[i].charProfBonus end
            if main_Table[i].skills[12].expertize  then pPerseptionBase = pPerseptionBase + main_Table[i].charProfBonus end
            if main_Table[i].pPerceptionMod != 0 then ppModStr = " ("..PoM(main_Table[i].pPerceptionMod)..main_Table[i].pPerceptionMod..")" else ppModStr = "" end
            
            UI_xmlElementUpdate(strFromNum(i).."_bigPortraitTeam", "tooltip", main_Table[i].charName.."\n"..
            lang_table[lang_set][2]..main_Table[i].charLvl.."  "..lang_table[lang_set][3]..main_Table[i].AC.."  "..lang_table[lang_set][4]..main_Table[i].speed.."\n"..
            lang_table[lang_set][7]..(main_Table[i].pPerceptionMod + pPerseptionBase)..ppModStr.."\n"..
            lang_table[lang_set][8].." ".. main_Table[i].attributes[1].."("..PoM_add(modFromAttr(main_Table[i].attributes[1]))..")   "..
            lang_table[lang_set][9].." ".. main_Table[i].attributes[2].."("..PoM_add(modFromAttr(main_Table[i].attributes[2]))..")   \n"..
            lang_table[lang_set][10].." "..main_Table[i].attributes[3].."("..PoM_add(modFromAttr(main_Table[i].attributes[3]))..")   "..
            lang_table[lang_set][11].." "..main_Table[i].attributes[4].."("..PoM_add(modFromAttr(main_Table[i].attributes[4]))..")   \n"..
            lang_table[lang_set][12].." "..main_Table[i].attributes[5].."("..PoM_add(modFromAttr(main_Table[i].attributes[5]))..")   "..
            lang_table[lang_set][13].." "..main_Table[i].attributes[6].."("..PoM_add(modFromAttr(main_Table[i].attributes[6]))..")   "
            )
            UI_xmlElementUpdate(strFromNum(i).."_teamBarHP", "percentage", math.floor(main_Table[i].hp / main_Table[i].hpMax * 100))
            --UI_xmlElementUpdate(strFromNum(i).."_teamBarHP", "width", math.floor(main_Table[i].hp / main_Table[i].hpMax * 55))
            --UI_xmlElementUpdate(strFromNum(i).."_teamBarHP", "offsetXY", "-"..(23 - math.floor(main_Table[i].hp / main_Table[i].hpMax * 23))..",0")
            if main_Table[i].hp > 0 then
                UI_xmlElementUpdate(strFromNum(i).."_teamBarHPsaves", "text", main_Table[i].hp.." / "..main_Table[i].hpMax)
            else
                teamBarHpStr = ""
                for ii=1,5 do
                    teamBarHpStr = teamBarHpStr.. dSavesStrTeamBar_table[main_Table[i].deathSaves[ii]]
                end
                UI_xmlElementUpdate(strFromNum(i).."_teamBarHPsaves", "text", teamBarHpStr)
            end
            
        else
            UI_xmlElementUpdate(strFromNum(i).."_teamBarSegment", "active", "False")
        end
    end

    if nPlayers > 0 then
        UI_xmlElementUpdate("teamBarPanel", "active", "True")
    else
        UI_xmlElementUpdate("teamBarPanel", "active", "False")
    end
    UI_xmlElementUpdate("teamBarPanel", "width", 60*nPlayers)
    
end

function lookAtChar(pl,_,thisID)
    if lastPickedCharGUID_table[nFromPl(pl)] != "" and getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]) != nil then
        pl.lookAt({position = getObjectFromGUID(lastPickedCharGUID_table[nFromPl(pl)]).getPosition(), pitch = 65, yaw = 0, distance = 25})
    end
end

--------------------------------------------------------    GM settings panel

function toggleGMsettingsPanel()
    if self.UI.getAttribute("GM_tools_panel", "active") == "False" then
        self.UI.setAttribute("GM_tools_panel", "active", "True")
    else
        self.UI.setAttribute("GM_tools_panel", "active", "False")
    end
    GM_settingsPanel_UI_update()
end

function set_UI_Language(pl,vl,thisID)
    if vl == "-1" then
        lang_set = lang_set + 1
        if lang_set > #lang_table then lang_set = 1 end
    elseif vl == "-2" then
        lang_set = lang_set - 1
        if lang_set < 1 then lang_set = #lang_table end
    end
    mainSheet_UI_update()
    initiative_UI_update()
    language_UI_update()
end

function language_UI_update()   --  tooltipBackgroundColor="#000000" tooltipPosition="Above"
    UI_xmlElementUpdate("noCharSelectedBlockText", "text", lang_table[lang_set][1])
    for i=1,11 do
        UI_xmlElementUpdate(strFromNum(i).."_charPortraitUrlInput", "tooltip", lang_table[lang_set][49])
    end
    UI_xmlElementUpdate("charNameInput", "tooltip", lang_table[lang_set][50])
    UI_xmlElementUpdate("charHPsetInput_01", "tooltip", lang_table[lang_set][51])
    UI_xmlElementUpdate("charHPsetInput_02", "tooltip", lang_table[lang_set][52])
    UI_xmlElementUpdate("charHPsetVisibilityButton", "tooltip", lang_table[lang_set][53])
    
    UI_xmlElementUpdate("charHP_dmgButton", "text", lang_table[lang_set][54])
    UI_xmlElementUpdate("charHP_dmgButton", "tooltip", lang_table[lang_set][55])
    for i=1,11 do
        UI_xmlElementUpdate(strFromNum(i).."_charHealDmgValueInput", "tooltip", lang_table[lang_set][56])
    end
    UI_xmlElementUpdate("charHP_healButton", "text", lang_table[lang_set][57])
    UI_xmlElementUpdate("charHP_healButton", "tooltip", lang_table[lang_set][58])
    UI_xmlElementUpdate("charHP_tempButton", "text", lang_table[lang_set][59])
    UI_xmlElementUpdate("charHP_tempButton", "tooltip", lang_table[lang_set][60])

    for i=1,11 do
        for ii=1,5 do
            UI_xmlElementUpdate(strFromNum(i).."_charDeathSaveButton_"..strFromNum(ii), "tooltip", lang_table[lang_set][61])
        end
    end
    for i=1,11 do
        for ii=1,6 do
            UI_xmlElementUpdate(strFromNum(i).."_charAttrMod_"..strFromNum(ii), "tooltip", lang_table[lang_set][33+ii])
        end
        local j = 1
        for smN,_ in pairs(main_Table[i].savesMod) do
            UI_xmlElementUpdate(strFromNum(i).."_charSaveButton_"..smN, "tooltip", lang_table[lang_set][61+j])
            j = j + 1
        end
    end
    for i=1,18 do
        UI_xmlElementUpdate("charSkillButtonE_"..strFromNum(i), "tooltip", lang_table[lang_set][65])
        UI_xmlElementUpdate("charSkillButtonE_"..strFromNum(i), "text", lang_table[lang_set][33])
    end
    for i=1,8 do
        UI_xmlElementUpdate("charSheetUtilButton_"..strFromNum(i), "text", lang_table[lang_set][65+i])
    end
    UI_xmlElementUpdate("charSheetUtilButton_06", "tooltip", lang_table[lang_set][74])
    UI_xmlElementUpdate("charSheetUtilButton_07", "tooltip", lang_table[lang_set][75])
    UI_xmlElementUpdate("charSheetUtilButton_08", "tooltip", lang_table[lang_set][76])
    UI_xmlElementUpdate("charSheetUtilButton_09", "tooltip", lang_table[lang_set][77])

    for i=2,11 do
        UI_xmlElementUpdate("assighedPlayerButton_"..strFromNum(i), "tooltip", lang_table[lang_set][86])
    end

    for i=1,11 do
        UI_xmlElementUpdate(strFromNum(i).."_charInitAddButton", "tooltip", lang_table[lang_set][87])
    end

    UI_xmlElementUpdate("initPassButton", "text", lang_table[lang_set][86])

    UI_xmlElementUpdate("atkEditIconSetButton", "tooltip", lang_table[lang_set][88])
    for i=1,11 do
        UI_xmlElementUpdate(strFromNum(i).."_atkEditRollAtkButton", "tooltip", lang_table[lang_set][89])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditAtkAttrButton", "tooltip", lang_table[lang_set][90])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditProfButton", "tooltip", lang_table[lang_set][91])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditRollDmgButton", "tooltip", lang_table[lang_set][92])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditDmgAttrButton", "tooltip", lang_table[lang_set][93])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditResUsedButton", "tooltip", lang_table[lang_set][94])
    end
    for i=1,11 do
        for ii=1,9 do
            UI_xmlElementUpdate(strFromNum(i).."_spellSlotButton_"..strFromNum(ii), "tooltip", lang_table[lang_set][95])
        end
        UI_xmlElementUpdate("spellSlotButtonMax_"..strFromNum(i), "tooltip", lang_table[lang_set][95])
    end
    UI_xmlElementUpdate("notesPanelTitle", "text", lang_table[lang_set][96])
    
    for i=1,11 do
        for ii=1,20 do
            UI_xmlElementUpdate(strFromNum(i).."_conditionButton_"..strFromNum(ii), "tooltip", lang_table[lang_set][97+ii])
        end
    end

    UI_xmlElementUpdate("UIset_text_01", "text", lang_table[lang_set][118])
    UI_xmlElementUpdate("UIset_text_02", "text", lang_table[lang_set][119])

    UI_xmlElementUpdate("addCharModeText", "text", lang_table[lang_set][120])
    
    UI_xmlElementUpdate("GM_toolsButton_01", "tooltip", lang_table[lang_set][119])
    UI_xmlElementUpdate("GM_toolsButton_02", "tooltip", lang_table[lang_set][120])
    UI_xmlElementUpdate("GM_toolsButton_03", "tooltip", lang_table[lang_set][123])
    UI_xmlElementUpdate("GM_toolsButton_04", "tooltip", lang_table[lang_set][124])
    UI_xmlElementUpdate("GM_toolsButton_05", "tooltip", lang_table[lang_set][125])
    UI_xmlElementUpdate("GM_toolsButton_06", "tooltip", lang_table[lang_set][126])
    UI_xmlElementUpdate("GM_toolsButton_07", "tooltip", lang_table[lang_set][127])

    UI_xmlElementUpdate("projectorToggleButton", "tooltip", lang_table[lang_set][128])

    UI_xmlElementUpdate("screenRollerMinimizer", "tooltip", lang_table[lang_set][129])
    

    UI_xmlElementUpdate("setInvisButton", "text", lang_table[lang_set][130])
    UI_xmlElementUpdate("setInvisButton", "tooltip", lang_table[lang_set][131])


    UI_xmlElementUpdate("copyCharModeText", "text", lang_table[lang_set][132])
    UI_xmlElementUpdate("GM_toolsButton_08", "tooltip", lang_table[lang_set][133])
    UI_xmlElementUpdate("GM_toolsButton_09", "tooltip", lang_table[lang_set][134])
end

function toggleCharBaseSpin()
    charBaseSpin = not charBaseSpin
    GM_settingsPanel_UI_update()
end

function toggleAddCharMode(pl,vl,thisID)
    if vl == "-1" then
        if copyCharMode then
            toggleCopyCharMode(pl,"-1",thisID)
        end
        addCharMode = not addCharMode
        if addCharMode then
            self.UI.setAttribute("addCharModePanel", "active", "True")
        else
            self.UI.setAttribute("addCharModePanel", "active", "False")
        end
    elseif vl == "-2" then
        updateLuaForAllChars()
    end
    GM_settingsPanel_UI_update()
end

function toggleCopyCharMode(pl,vl,thisID)
    if getObjectFromGUID(lastPickedCharGUID_table[1]) != nil then
        if addCharMode then
            toggleAddCharMode(pl,"-1",thisID)
        end
        copyCharMode = not copyCharMode
        if copyCharMode then
            self.UI.setAttribute("copyCharModePanel", "active", "True")
        else
            self.UI.setAttribute("copyCharModePanel", "active", "False")
        end
        GM_settingsPanel_UI_update()
    end
end


function updateLuaForAllChars()
    objectsToUpdate = {}
    for i=1,#getAllObjects() do
        if getAllObjects()[i].getVar("THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN") != nil then
            table.insert(objectsToUpdate, #objectsToUpdate + 1, getAllObjects()[i])
        end
    end
    for i=1,#objectsToUpdate do
        objectsToUpdate[i].setLuaScript(defineCharLua())
        objectsToUpdate[i].reload()
        Wait.frames(function()
            objectsToUpdate[i].call("UI_update")
        end, 10)
    end
end

function setCharAutosaveDelay(pl,vl,thisID)
    if vl == "-1" then
        charAutosaveDelay = charAutosaveDelay + 1
        if charAutosaveDelay > 18 then charAutosaveDelay = 1 end
    elseif vl == "-2" then
        charAutosaveDelay = charAutosaveDelay - 1
        if charAutosaveDelay < 1 then charAutosaveDelay = 18 end
    end
    applyCharAutosaveDelay()
end

function applyCharAutosaveDelay()
    for i=1,#getAllObjects() do
        if getAllObjects()[i].getVar("THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN") != nil then
            getAllObjects()[i].setVar("autosaveDelay", charAutosaveDelay)
        end
    end
    GM_settingsPanel_UI_update()
end

function toggleShowEveryDie()
    diceRollsShowEveryDie = not diceRollsShowEveryDie
    GM_settingsPanel_UI_update()
end

function toggleSneakyGM()
    diceRollsSneakyGM = not diceRollsSneakyGM
    GM_settingsPanel_UI_update()
end

function toggleAutoPromote()
    autoPromote = not autoPromote
    GM_settingsPanel_UI_update()
    if autoPromote then
        for _, player in ipairs(Player.getPlayers()) do
            if not player.promoted and not player.host then
                player.promote()
            end
        end
    end
end

function toggleSaveLastPick()
    saveLastPick = not saveLastPick
    GM_settingsPanel_UI_update()
end

function onPlayerChangeColor(player_color)
    if autoPromote and player_color != "Grey" then
        Wait.frames(function()
            if not Player[player_color].promoted and not Player[player_color].host then
                Player[player_color].promote()
            end
        end, 3)
    end
end

function makeMeGM(pl,vl,thisID)
    if vl == "-2" then
        pl.changeColor("Black")
    end
end

function GM_settingsPanel_UI_update()
    if charBaseSpin then
        UI_xmlElementUpdate("GM_toolsButton_02", "textOutline", "#ff000088")
        UI_xmlElementUpdate("GM_toolsButton_02", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_02", "textOutline", "#ff000000")
        UI_xmlElementUpdate("GM_toolsButton_02", "color", "#cccccccc")
    end
    UI_xmlElementUpdate("GM_toolsButton_04", "text", "auto save "..(charAutosaveDelay * 10).."s")
    if addCharMode then
        UI_xmlElementUpdate("GM_toolsButton_03", "textOutline", "#0000aa88")
        UI_xmlElementUpdate("GM_toolsButton_03", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_03", "textOutline", "#0000aa00")
        UI_xmlElementUpdate("GM_toolsButton_03", "color", "#cccccccc")
    end
    if diceRollsShowEveryDie then
        UI_xmlElementUpdate("GM_toolsButton_05", "textOutline", "#0000aa88")
        UI_xmlElementUpdate("GM_toolsButton_05", "text", "●   ●\n●\n●   ●")
        UI_xmlElementUpdate("GM_toolsButton_05", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_05", "textOutline", "#0000aa00")
        UI_xmlElementUpdate("GM_toolsButton_05", "text", "○   ○\n○\n○   ○")
        UI_xmlElementUpdate("GM_toolsButton_05", "color", "#cccccccc")
    end

    if diceRollsSneakyGM then
        UI_xmlElementUpdate("GM_toolsButton_06", "textOutline", "#0000aa88")
        UI_xmlElementUpdate("GM_toolsButton_06", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_06", "textOutline", "#0000aa00")
        UI_xmlElementUpdate("GM_toolsButton_06", "color", "#cccccccc")
    end

    if autoPromote then
        UI_xmlElementUpdate("GM_toolsButton_07", "textOutline", "#0000aa88")
        UI_xmlElementUpdate("GM_toolsButton_07", "text", "★")
        UI_xmlElementUpdate("GM_toolsButton_07", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_07", "textOutline", "#0000aa00")
        UI_xmlElementUpdate("GM_toolsButton_07", "text", "☆")
        UI_xmlElementUpdate("GM_toolsButton_07", "color", "#cccccccc")
    end

    if copyCharMode then
        UI_xmlElementUpdate("GM_toolsButton_08", "textOutline", "#ffff0088")
        UI_xmlElementUpdate("GM_toolsButton_08", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_08", "textOutline", "#ffff0000")
        UI_xmlElementUpdate("GM_toolsButton_08", "color", "#cccccccc")
    end

    if saveLastPick then
        UI_xmlElementUpdate("GM_toolsButton_09", "fontStyle", "bold")
        UI_xmlElementUpdate("GM_toolsButton_09", "textOutline", "#ff000088")
        UI_xmlElementUpdate("GM_toolsButton_09", "color", "#ffffffff")
    else
        UI_xmlElementUpdate("GM_toolsButton_09", "fontStyle", "normal")
        UI_xmlElementUpdate("GM_toolsButton_09", "textOutline", "#ff000000")
        UI_xmlElementUpdate("GM_toolsButton_09", "color", "#cccccccc")
    end

end

--------------------------------------------------------    minimap

function miniMap_UI_update()
    miniMap_is_open = false
    for i=1,11 do
        if panelVisibility_miniMap[i] then
            miniMap_is_open = true
        end
    end

    if miniMap_is_open then
        all_chars = {}
        all_chars = getAllObjects()
        w = 1
        while #all_chars > w do
            if all_chars[w].getVar("THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN") == nil then
                table.remove(all_chars, w)
            else
                w = w + 1
            end
        end
        for i=1,99 do
            if i <= #all_chars then

                UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "offsetXY", ((all_chars[i].getPosition()[1] - miniMap_offset[1]) * miniMap_zoom).." "..((all_chars[i].getPosition()[3] - miniMap_offset[2]) * miniMap_zoom))
                if math.abs((all_chars[i].getPosition()[1] - miniMap_offset[1]) * miniMap_zoom) > 145 or math.abs((all_chars[i].getPosition()[3] - miniMap_offset[2]) * miniMap_zoom) > 145 then
                    UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "active", "False")
                else
                    UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "active", "True")
                end
                UI_xmlElementUpdate("miniMap_text_"..strFromNum(i), "rotation", "0 0 "..((-1 * all_chars[i].getRotation()[2]) + (all_chars[i].getTable("charSave_table").tokenGUI_settings[4] * 15)))

                unitScale = ((all_chars[i].getBoundsNormalized().size[1] + all_chars[i].getBoundsNormalized().size[1] + all_chars[i].getBoundsNormalized().size[1]) / 3) * 0.15 * miniMap_zoom
                UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "scale", unitScale.." "..unitScale.." 1")

                unitColor = plColorsHexTable[1]
                for ii=2,11 do
                    if all_chars[i].getTable("charSave_table").aColors[ii] then
                        unitColor = plColorsHexTable[ii]
                    end
                end
                UI_xmlElementUpdate("miniMap_text_"..strFromNum(i), "color", unitColor)

                UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "tooltip", all_chars[i].getName())

                showToStr = "Black"
                for ii=2,11 do
                    if all_chars[i].getTable("charSave_table").aColors[ii] then
                        addColStr = plColors_Table[ii]
                        showToStr = showToStr.."|"..addColStr
                    end
                end
                if all_chars[i].getTable("charSave_table").charHidden then
                    UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "visibility", showToStr)
                else
                    UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink")
                end
                if all_chars[i].getTable("charSave_table").hp <= 0 then
                    UI_xmlElementUpdate("miniMap_text_x_"..strFromNum(i), "active", "True")
                else
                    UI_xmlElementUpdate("miniMap_text_x_"..strFromNum(i), "active", "False")
                end

            else
                UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "active", "False")
            end
        end

        UI_xmlElementUpdate("miniMap_head", "text", "Minimap (x:"..(miniMap_offset[1]).." / y:"..(miniMap_offset[2]).." zm: "..(miniMap_zoom)..")")
    end
end

function onObjectDrop(player_color, dropped_object)
    if dropped_object.getVar("THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN") != nil then
        miniMap_UI_update()
    end
end

--function onObjectHover(player_color, hover_object)
    --    Wait.frames(function()
    --        if not hover_object then
    --            miniMap_UI_update()
    --        end
    --    end, 1)
--end

function set_miniMap_unit(pl,vl,thisID)
    defineMiniMapUnit(vl)
end

function defineMiniMapUnit(inpStr)
    for i=1,99 do
        UI_xmlElementUpdate("miniMap_text_"..strFromNum(i), "text", inpStr) -- ▲ ♠
    end
end

function minimapControl(pl,vl,thisID)
    if numFromStrEnd(thisID) == 1 then
        if vl == "-2" then miniMap_zoom = miniMap_zoom + 1 elseif vl == "-1" then miniMap_zoom = miniMap_zoom + 2 end
    elseif numFromStrEnd(thisID) == 2 then
        if vl == "-2" then miniMap_offset[2] = miniMap_offset[2] + 1 elseif vl == "-1" then miniMap_offset[2] = miniMap_offset[2] + 5 end
    elseif numFromStrEnd(thisID) == 3 then
        if vl == "-2" then miniMap_zoom = miniMap_zoom - 1 elseif vl == "-1" then miniMap_zoom = miniMap_zoom - 2 end
    elseif numFromStrEnd(thisID) == 4 then
        if vl == "-2" then miniMap_offset[1] = miniMap_offset[1] - 1 elseif vl == "-1" then miniMap_offset[1] = miniMap_offset[1] - 5 end
    elseif numFromStrEnd(thisID) == 5 then
        if vl == "-2" then miniMap_offset[2] = miniMap_offset[2] - 1 elseif vl == "-1" then miniMap_offset[2] = miniMap_offset[2] - 5 end
    elseif numFromStrEnd(thisID) == 6 then
        if vl == "-2" then miniMap_offset[1] = miniMap_offset[1] + 1 elseif vl == "-1" then miniMap_offset[1] = miniMap_offset[1] + 5 end
    end

    miniMap_UI_update()
    --miniMap_pingBorder(pl,_,_)
end

function miniMap_pingBorder(pl,vl,thisID)
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] - 70 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2]})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] + 70 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 70 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 70 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] + 70 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2]})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] - 70 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] + 70 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] - 70 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})

    Player[plColors_Table[nFromPl(pl)]].pingTable({miniMap_offset[1] ,0,miniMap_offset[2]})
end

--------------------------------------------------------    tech stuff

function modFromAttr(inpAttr)
    return math.floor((inpAttr - 10) / 2)
end

function numFromStr(inpStr)
    if string.sub(inpStr,1,1) == "0" then
        return tonumber(string.sub(inpStr,2,2))
    else
        return tonumber(string.sub(inpStr,1,2))
    end
end
  
function numFromStrEnd(inpStr)
    if string.sub(inpStr,#inpStr-1,#inpStr-1) == "0" then
        return tonumber(string.sub(inpStr,#inpStr,#inpStr))
    else
        return tonumber(string.sub(inpStr,#inpStr-1,#inpStr))
    end
end
  
function strFromNum(inpNum)
    if inpNum < 10 then
        return "0"..tostring(inpNum)
    else
        return tostring(inpNum)
    end
end

function UI_xmlElementUpdate(xml_ID, xml_attribute, input_string)
    if self.UI.getAttribute(xml_ID, xml_attribute) != input_string then
        self.UI.setAttribute(xml_ID, xml_attribute, input_string)
    end
end

function PoM(inpNum)
    if inpNum < 0 then
        return ""
    else
        return "+"
    end
end

function PoM_add(inpNum)
    return PoM(inpNum)..inpNum
end

function screenRoller(pl,vl,thisID)
    if vl == "-1" then
        stringRoller(string.sub(thisID,6,#thisID),pl,"",1,false)
    elseif vl == "-2" then
        doubleRoll = 2
        stringRoller(string.sub(thisID,6,#thisID),pl,"",2,false)
        stringRoller(string.sub(thisID,6,#thisID),pl,"",4,false)
    end
end

function setScreenRollerStrings(pl,vl,thisID)
    for i=1,11 do
        if pl.color == plColors_Table[i] then
            pl_N = i
        end
    end
    screenRollerStringsToRoll[pl_N] = vl
end

function screenStringRoller(pl,_,thisID)
    pl_N = nFromPl(pl)
    stringRoller(screenRollerStringsToRoll[pl_N],pl,"",1,false)
end

function stringRoller(inpStr,plr,commStr,rollType,rollCritDmg)   -- Main roller function. Input example: 5d6 - 5 + 2d10 + 2
    inpStrGood = true
    for i=1,#inpStr do
        thisSymbolBad = true
        for ii=1,#allowedSymbols do
            if string.sub(inpStr,i,i) == allowedSymbols[ii] then
                thisSymbolBad = false
            end
        end
        if thisSymbolBad then
            inpStrGood = false
        end
    end
    if tonumber(string.sub(inpStr, 1, 1)) == nil or not inpStrGood then
        printToAll("► [ff9999]Dice input error![-]", plr.color)
    else
        for i=1,#inpStr do
            if string.sub(inpStr,i,i) == "к" then
                inpStr = string.sub(inpStr,1,i-1).."d"..string.sub(inpStr,i+1,#inpStr)
            end
        end
        math.randomseed(os.clock()*10000 + lastRollTotal)
        segment_strt = 1
        segment_end = 1
        segments_table = {}
        symbol_table   = {}
        for i=1,#inpStr do
            if string.sub(inpStr, i, i) == "+" or string.sub(inpStr, i, i) == "-" then
                symbol_table[#symbol_table + 1] = string.sub(inpStr, i, i)
                segment_end = i - 1
                table.insert(segments_table, #segments_table + 1, string.sub(inpStr, segment_strt, segment_end))
                segment_strt = i + 1
            end
        end
        table.insert(segments_table, #segments_table + 1, string.sub(inpStr, segment_strt, #inpStr))

        totalRollRez = 0
        totalRollStr = ""
        d20_hex = ""

        if doubleRoll > 0 then
            doubleRollStr_A = "[b]<"
            doubleRollStr_B = ">[/b]"
            doubleRoll = doubleRoll - 1
        else
            doubleRollStr_A = ""
            doubleRollStr_B = ""
        end

        for i=1,#segments_table do
            if i > 1 then
                totalRollStr = totalRollStr..symbol_table[i-1]
            end
            d_pos,d_pos_ = string.find(segments_table[i], "d")
            if d_pos != nil then
                timesToRoll = tonumber(string.sub(segments_table[i],1,d_pos-1))
                if timesToRoll > 5000 then timesToRoll = 0 end
                sidesToRoll = tonumber(string.sub(segments_table[i],d_pos+1,#segments_table[i]))
                totalRollStr = totalRollStr.."("
                for ii=1,timesToRoll do
                    thisDieRez = math.random(1,sidesToRoll)
                    if sidesToRoll == 20 and timesToRoll == 1 and thisDieRez == 20 then
                        d20_hex = "[ffff00]"
                    elseif sidesToRoll == 20 and timesToRoll == 1 and thisDieRez == 1 then
                        d20_hex = "[ff8888]"
                    elseif sidesToRoll == 20 and timesToRoll == 1 then
                        d20_hex = "[ccccee]"
                    end
                    if atkClicked != 0 then
                        if sidesToRoll == 20 and timesToRoll == 1 and thisDieRez >= main_Table[nFromPl(plr)].attacks[atkClicked].minCrit then
                            critRolled = true
                            d20_hex = "[ffff00]"
                        end
                    end
                    if thisDieRez == 1 then
                        thisDieRezColStr = "[ff8888]"
                    elseif thisDieRez == sidesToRoll then
                        thisDieRezColStr = "[ffff00]"
                    else
                        thisDieRezColStr = "[ccccee]"
                    end
                    totalRollStr = totalRollStr..thisDieRezColStr..thisDieRez.."[-]"
                    if ii < timesToRoll then
                        totalRollStr = totalRollStr..","
                    end
                    if i == 1 or symbol_table[i-1] == "+" then
                        totalRollRez = totalRollRez + thisDieRez
                    else
                        totalRollRez = totalRollRez - thisDieRez
                    end
                end
                totalRollStr = totalRollStr..") "
            else
                totalRollStr = totalRollStr.."("..tonumber(segments_table[i])..") "
                if i == 1 or symbol_table[i-1] == "+" then
                    totalRollRez = totalRollRez + tonumber(segments_table[i])
                else
                    totalRollRez = totalRollRez - tonumber(segments_table[i])
                end
            end
        end
        -- ╔┐╗ ╚┘╝ ╠ ║   ╓╙  ╒╘  ╭│╰
        if diceRollsShowEveryDie then
            if rollType == 1 then
                boxStr_a = "[b]╔[/b]"
                boxStr_b = "[b]╚[/b]"
            elseif rollType == 2 then
                boxStr_a = "[b]╔[/b]"
                boxStr_b = "[b]║[/b]"
            elseif rollType == 3 then
                boxStr_a = "[b]║[/b]"
                boxStr_b = "[b]║[/b]"
            elseif rollType == 4 then
                boxStr_a = "[b]║[/b]"
                boxStr_b = "[b]╚[/b]"
            end
        else
            if rollType == 1 then
                boxStr_a = "[b]●[/b]"
            elseif rollType == 2 then
                boxStr_a = "[b]╔[/b]"
            elseif rollType == 3 then
                boxStr_a = "[b]║[/b]"
            elseif rollType == 4 then
                boxStr_a = "[b]╚[/b]"
            end
        end

        if diceRollsSneakyGM and plr.color == "Black" then
            if rollCritDmg then
                printToColor(" ͡° "..boxStr_a.." [ffffaa]"..commStr..""..inpStr.."  =  "..totalRollRez.."  ► "..totalRollRez + lastRollTotal.." ◄ [-]", plr.color, plr.color)
                if diceRollsShowEveryDie then
                    printToColor(" ͡° "..boxStr_b.." [ffffaa]"..totalRollStr.."[-]", plr.color, plr.color)
                end
            else
                printToColor(" ͡° "..boxStr_a.." "..rollOutputHex..commStr..""..inpStr.."  =  "..d20_hex..doubleRollStr_A..totalRollRez..doubleRollStr_B.."[-]", plr.color, plr.color)
                if diceRollsShowEveryDie then
                    printToColor(" ͡° "..boxStr_b.." "..rollOutputHex..totalRollStr.."[-]", plr.color, plr.color)
                end
            end
        else
            if rollCritDmg then
                printToAll(boxStr_a.." [ffffaa]"..commStr..""..inpStr.."  =  "..totalRollRez.."  ► "..totalRollRez + lastRollTotal.." ◄ [-]", plr.color)
                if diceRollsShowEveryDie then
                    printToAll(boxStr_b.." [ffffaa]"..totalRollStr.."[-]", plr.color)
                end
            else
                printToAll(boxStr_a.." "..rollOutputHex..commStr..""..inpStr.."  =  "..d20_hex..doubleRollStr_A..totalRollRez..doubleRollStr_B.."[-]", plr.color)
                if diceRollsShowEveryDie then
                    printToAll(boxStr_b.." "..rollOutputHex..totalRollStr.."[-]", plr.color)
                end
            end
        end
        
        
        lastRollTotal = totalRollRez
    end
end

function nFromPl(plr)
    for i=1,11 do
        if plr.color == plColors_Table[i] then
            pl_N = i
        end
    end
    return pl_N
end

function nFromPlClr(clr)
    for i=1,11 do
        if clr == plColors_Table[i] then
            pl_N = i
        end
    end
    return pl_N
end

function loadSelections()
    Wait.time(function()
        for i=1,11 do
            if lastPickedCharGUID_table[i] != "" and getObjectFromGUID(lastPickedCharGUID_table[i]) !=nil then
                GetStatsFromToken(i,getObjectFromGUID(lastPickedCharGUID_table[i]))
                getObjectFromGUID(lastPickedCharGUID_table[i]).setVar("Selected", i)
                getObjectFromGUID(lastPickedCharGUID_table[i]).call("UI_update")
            end
        end
    end, 2)
end

function checkGUIDtable()
    for i=1,11 do
        if getObjectFromGUID(lastPickedCharGUID_table[i]) == nil then
            lastPickedCharGUID_table[i] = ""
        end
    end
end

function defineAtkIcons()
    atkIconsUrl_Table = {
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201659789/F1C41A152ACC69062CF8D82716867367BB3E84FA/", -- fist
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664687978/1022D882F552CA071700F4E2B7AEA22467FB32F4/", -- hand
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664734191/B7E1C1900DA35C34FE2DA89526E168A140004A07/", -- finger
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664733993/B9BDF3019B02E51C696D07E007B0DB27EE82FAB7/", -- boot
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536516/2E5C13E524EFB7D9D6C6F663D9981F27A6904504/", -- claws
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664713207/11F1287E5E4C2877493C1476F2E6E19570491DFF/", -- claws 2
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536187/11A42F7552F9D7130B29AB6299725A06413385AB/", -- bite
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664687049/FAD03CAF515E3E8C607FF8D0078E006F5689039C/", -- improvised
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201677348/3D07306920E3CC2D8D847BFBC727D1612F704E08/", -- knife
        "https://steamusercontent-a.akamaihd.net/ugc/2490003713551670815/CBBE5E7EAB7EBDE686C3505D774506DF63A4B4ED/", -- bloody curved
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201659965/E2F635D52AF5D740216025EB3297C4038D30F1F3/", -- blades
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201659621/737493430B271B1EC8E68E1FFDCFFBD127243DDF/", -- axe
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201676863/CFF3AD38587F5187581E075D34A2396034A9D9D1/", -- big axe
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201677079/22A4FF4A51B85A1EE1EED2C3A27AA6A8983267AB/", -- mace
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201676779/93172E7DDB30B08434E94064BC977CA005B21307/", -- maul
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536258/A8339EB6A81C34A545C8DD6DF5E4421E0888E943/", -- scithe
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201677280/7B5254FD059AE9C596998F19C83122016BE47198/", -- spear
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201677005/F14812F42F251FF70B3A0D3002C3097811C6FE62/", -- bow
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536735/1C8E225F9C94821616ABA085256A3EA9D77D5D1B/", -- target
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201677141/5D410A1D90675EE1DCC0DF1DD94D145033BA317C/", -- shuriken
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201650780/D8420C18D38014C46ECBF728757C4C2F33E8AF61/", -- shards
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201659704/286EADEB759B0D3043991D2FFE066EB8B932C497/", -- fireball
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201660041/80FE0EAAA26D096788CCCF1A38CB124C503110CA/", -- splash
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201676583/F217FC558762351CDB27F0C918824DBA69242CEB/", -- lightning
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664680116/583EB367133E63904EFC55C3CBBE51DA5A51A7C2/", -- big lightning
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664698893/CC7020A3A2727F764BEFAC38CA745210981AF149/", -- snowflake
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201677216/D0254C05EA5ED307251CC7075D35B206241EF7FB/", -- explosion
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201676943/9FEF434387371617461D13006018E15500070D17/", -- ray
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201676683/1F4099421BA83401CDFAB3EF285D63E6DF770A43/", -- nuke
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664713106/3932C313F732FFA33D448590400430D82C8565AB/", -- cannon
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664698683/5F2BB1A959171109DDCBA5C1BD97111111EF96F9/", -- gas
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664698984/D6BDFFAA54A098FB93AC637C179860115284F61E/", -- death
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201676470/CC1F9302322F28E86E888C8FD0ED8EB27F6A68FD/", -- headNails
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664698803/E860929E68F7F29C027C11F1798139C578541B3B/", -- insect
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536346/CCAAE11009E4BB7FC78175C76EFE17F369E0F0AC/", -- razorblade
        "https://steamusercontent-a.akamaihd.net/ugc/2490003713551678526/923E3E5CC88F94C78B56529157DCBBEE5D9168B8/", -- spinner
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536047/55E9F17A4D9B9AC618C38B6E73D1B4A4CFEAA358/", -- spinner 2
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664734304/39DB33D3AAD022AD718D395A8D47E896194291E5/", -- vortex
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664712986/52488CC726C732F7E7E16262F81EF1FC0B000BF8/", -- breath
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664734114/59963D86D483E255986DE46C046058CA1C5C430E/", -- breath 2
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664734382/7747CDD7531F71B100B93AF9C89F32BB621886E1/", -- dragon
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664698440/C4D9EBB5EB18A0C92177449F67DAA02962CCE580/", -- eye
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201660130/CBAB5F0FA3AC511D3F04D0EA13D27A363FF8484B/", -- wand
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536912/2E8EB7C20EFA8AB7567CDF09D3670779ACFB251E/", -- torch
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536833/6FD74FD84387AB755DA5B34C925075CCFF97D6AB/", -- speaker
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201660224/9DE8AE7F674729D7B880640B52D3937FB9233857/", -- tool
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664698572/F894B3BACCBA692269BF5D09F511BEE079702AA9/", -- anvil
        "https://steamusercontent-a.akamaihd.net/ugc/2490003637201659379/876BA1D1864093246D66EF61E25CFCEAB973E6B3/", -- potion
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536639/9C1D35419567A0C30B53D7A43DFB0B6E5DDF472F/", -- apple
        "https://steamusercontent-a.akamaihd.net/ugc/2494507870664699074/BB8C3A5AF35C898F562AECC120A1FE74D25D81DF/", -- book
    }

    for i=1,50 do
        if i <= #atkIconsUrl_Table then
            UI_xmlElementUpdate("atkEditIconsGrid_"..strFromNum(i), "image", atkIconsUrl_Table[i])
        else
            UI_xmlElementUpdate("atkEditIconsGrid_"..strFromNum(i), "color", "#00000000")
        end
    end
end

function defineLangTable() -- lang_table[lang_set]
    return {
        -- EN
        {"NO CHARACTER SELECTED!", "Level: ", "AC: ", "Speed: ", "Proficiency bonus: ", "Initiative: ", "Passive perception: ", -- 7
        "STR", "DEX", "CON", "INT", "WIS", "CHA", -- 13
        "Save", -- 14
        "Acrobatics", "Animal Handling", "Arcana", "Athletics", "Deception", "History", "Insight", "Intimidation", "Investigation", "Medicine", "Nature", "Perception", 
        "Performance", "Persuasion", "Religion", "Sleight of hand", "Stealth", "Survival", -- 32
        "e", -- 33
        "Strength check", "Dexterity check", "Constitution check", "Intelligence check", "Wisdom check", "Charisma check", -- 39
        "save", -- 40
        "minimal crit value: ",
        "attack modifier: ",
        "damage:\n", "add on crit:\n", -- 43  44
        "damage: ", "critical damage: ", -- 45 46
        "INITIATIVE", "Round: ", -- 47 48
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        "Character\nportrait url", "Character name", "Current\nHit Points", "Maximum\nHit Points", "Toggle token HP-bar visibility:\nEveryone / GM-only", -- 49 50 51 52 53
        "Damage", "Take set value\nas damage", "Enter value for\ndamage / heal / temp HP", "Heal", "Heal set value\nof HP", "Temp", "Apply set value\nas temporary HP", -- 54 55 56 57 58 59 60
        "Death save mark\n(click to change)", -- 61
        "Fortitude save-throw", "Reflex save-throw", "Will save-throw", -- 62 63 64
        "Expertize", -- 65
        "attacks", "resourses", "spell slots", "notes", "conditions", "character UI set", "look at char", "edit character", -- 66 67 68 69 70 71 72 73
        "Adjust 3d interface\non the character\nfigurine", "Center camera\non the character", "Edit mode:\n\nincludes most secondary panels\n\n'+' and '-' buttons may be used with\nright click for increased value\n\nsave-throws and skills buttons switch\nproficiency in edit mode\n\nWhile edit mode is on,\nquickly Right click this button 5 times\nto reset the character",
        "Left click:\nhide this panel\n\nRight click:\n hide all panels", -- 77
        "","","","","","","","PASS","Allow this color\nto control the character","Add character to\nthe initiative queue", -- 87
        ---------------------------------------------------------------------------
        "Set icon", "Toggle attack roll", "Right / Left click -\nset attack attribute", "Toggle proficiency", -- 88 89 90 91
        "Toggle damage roll", "Right / Left click -\nset damage attribute", "Right / Left click -\nset resourse, used for attack", -- 92 93 94
        "Left click: -\nRight click: +", -- 95
        "Notes","", -- 96 97
        ---------------------------------------------------------------------------
        "Blinded", "Deafened", "Charmed", "Frightened", "Grappled", "Incapacitated", "Invisible", "Paralyzed", "Petrified", "Poisoned", "Prone", "Restrained", "Stunned", "Unconscious", "Wounded", "On fire", "Buffed", "Exhaustion", "Dodge (full defence)", "Dead",
        ---------------------------------------------------------------------------
        "angle", "scale", -- 118 119
        "PICK THE NEW CHARACTER", "Change language", "Toggle character selection\nmarker animation\n\nExperimental! May cause lag\nof client-side UI update", "Left click:\nAdd character scripts\ninto a new figurine\n\nRight click:\nupdate script for every\ncharacter on the table", "Right / Left click\nset average autosave interval\nfor characters\n\nincrease to lower the\nautosave lag\ndefault: 10s",
        "Toggle every dice\noutput on rolls", "Toggle hidden GM\ndice rolls", "Toggle\nauto-promote", "Image projector\n\nWhen on, any image token that\nGM points at and presses 'R',\nwill be projected here\n\nGM can force on/off for everyone\nwith Right click",
        "Dice roller\n\nWhen used with Right click\nrolls twice\n\nUse text input for custom rolls\nExample: 6d18 + 1d100 + 22 - 1d2",
        "Hide","Toggle character\ninvisible to players",
        "PICK THE CHARACTER\nYOU WANT TO HAVE\nCURRENT STATS\n(can't be undone)", "Copy all stats\nof currently selected\ncharacter into another",
        "Toggle keeping\ncharacter selections\nbetween table loads\n(randomly causes breaking\nbugs on table load;\nuse tools at the back\nof GM seat to fix)",
        },
        -- RU
        {"ПЕРСОНАЖ НЕ ВЫБРАН!", "Уровень: ", "КД: ", "Скорость: ", "Бонус мастерства: ", "Инициатива: ", "Пассивная внимательность: ", -- 7
        "СИЛ", "ЛОВ", "ТЕЛ", "ИНТ", "МДР", "ХАР", -- 13
        "Спас", -- 14
        "Акробатика", "Обращение с животными", "Магия", "Атлетика", "Обман", "История", "Проницательность", "Запугивание", "Анализ", "Медицина", "Природа", "Внимательность", 
        "Выступление", "Убеждение", "Религия", "Ловкость рук", "Скрытность", "Выживание", -- 32
        "к", -- 33
        "проверка силы", "проверка ловкости", "проверка телосложения", "проверка интеллекта", "проверка мудрости", "проверка харизмы", -- 39
        "спас-бросок", -- 40
        "минимальное значение крита: ",
        "модификатор атаки: ",
        "урон:\n", "добавить при крите:\n", -- 43 44
        "урон: ", "критический урон: ", -- 45 46
        "ИНИЦИАТИВА", "Раунд: ", -- 47 48
        ------------------------------------------------------------------------------------------------------------------------------------------------------
        "Портрет персонажа\n(ссылка)", "Имя персонажа", "Текущие\nОчки Здоровья", "Максимальные\nОчки Здоровья", "Переключить видимость\nздоровья персонажа:\nВсе / только ГМ", -- 49 50 51 52 53
        "Урон", "Получить указанное\nколичество урона", "Введите значение для\nурона / лечения / временных ОД", "Лечить", "Вылечить указанное\nколичество Очков Здоровья", "Врм.", "Установить временные\nОчки Здоровья", -- 54 55 56 57 58 59 60
        "Отметка спас-броска от смерти\n(нажать для изменения)", -- 61
        "Спас-бросок\nстойкости", "Спас-бросок\nрефлексов", "Спас-бросок\nволи", -- 62 63 64 (65 66 67)
        "Компетентность", -- 65
        "атаки", "ресурсы", "ячейки магии", "заметки", "состояния", "настройки UI", "найти персонажа", "редактировать", -- 66 67 68 69 70 71 72 73
        "Подогнать 3д интерфейс\nпод фигурку персонажа", "Центрировать камеру\nна персонаже", "Режим редактирования:\n\nзадействует все панели персонажа\n\nкнопки '+' и '-' можно использовать\nправым кликом для большего шага\n\nкнопки спас-бросков и навыков переключают\nвладение в режиме редактирования\n\nпри включйнном редактировании\n5 быстрых Правых кликов по этой кнопке\nполностью сбросят персонажа",
        "Левый клик:\nскрыть эту панель\n\nПравый клик:\nскрыть все панели", -- 77
        "","","","","","","","ХОД","Разрешить этому цвету\nконтролировать персонажа","Добавить персонажа\nв инициативу", -- 87
        ---------------------------------------------------------------------------
        "Настроить иконку", "Вкл / выкл\nбросок атаки", "Левый / Правый клик -\nнастроить характиристику атаки", "Вкл / выкл\nвладение", -- 88 89 90 91
        "Вкл / выкл\nбросок урона", "Левый / Правый клик -\nнастроить характиристику урона", "Левый / Правый клик -\nнастроить ресурс,\nиспользуемый при атаке", -- 92 93 94
        "Левый клик: -\nПравый клик: +", -- 95
        "Заметки","", -- 96 97
        ---------------------------------------------------------------------------
        "Ослепленный", "Оглушенный", "Очарованный", "Испуганный", "Схваченный", "Недееспособный", "Невидимый", "Парализованый", "Окаменевший", "Отравленный", "Лежит ничком", "Опутанный", "Ошеломленный", "Безсознательный", "Раненный", "Горящий", "Усиленный", "Истощение", "Уклонение (полная оборона)", "Мёртвый",
        ---------------------------------------------------------------------------
        "поворот", "размер", -- 118 119
        "КОСНИТЕСЬ НОВОГО ПЕРСОНАЖА", "Сменить язык", "Вкл / выкл анимацию\nмаркера выделения персонажей\n\nМожет вызвать задержку\nобновления интерфейса\nна клиентской стороне", "Левый клик:\nВставить скрипт персонажа\nв новую фигурку\n\nПравый клик:\nобновить скрипт в каждой\nфигурке персонажа на столе",  "Правый / Левый клик\nнастроить интервал\nавтосохранения персонажей\n\nувеличьте для снижения\nлагов при автосохранении\nпо умолчанию: 10s",
        "Вкл / выкл отображение\nрезультата каждой кости\nпри бросках", "Вкл / выкл скрытые\nброски ГМ", "Вкл / выкл автоматическую\nвыдачу повышенных прав", "Проектор изображений\n\nКогда включен, проецирует любой\nтокен с картинкой, на который ГМ\nукажет и нажмёт 'R'\n\nГМ может включит/выключить\nпроектор для всех (Правый клик)",
        "Броски костей\n\nПри использовании Правым кликом,\nпроизводит двойной бросок\n\nИспользуйте текстовый ввод для\nнестандартных или комбинированных бросков\nпример: 6d18 + 1d100 + 22 - 1d2",
        "Скрыть","Переключить видимость\nперсонажа для игроков",
        "КОСНИТЕСЬ ПЕРСОНАЖА\nКОТОРОМУ ХОТИТЕ\nПЕРЕДАТЬ ТЕКУЩИЕ\nПАРАМЕТРЫ\n(нельзя отменить)", "Скопировать параметры\nтекущего персонажа\nв другого",
        "Переключить сохранение\nвыбора персонажей\n(случайно вызывает баги\nпри загрузке стола;\nискользуйте инструменты на \nспинке кресла ГМа\nдля починки)",
        }
    }
end



function defineCharLua()
    charLua = [[
        function onSave()
            rndSave = math.random(1,3)
            if rndSave == 1 or self.getDescription() == "save" then
                data_to_save={}
                data_to_save.charSave_table = self.getTable("charSave_table")
                data_to_save.Selected = Selected
                saved_data = JSON.encode(data_to_save)
                return saved_data
            end
        end
        function onLoad(saved_data)
            THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN = true
            ------------------------------------------
            --saved_data = "" -- MUST BE COMMENTED !!!
            ------------------------------------------
            if saved_data != nil and saved_data != "" then
                loaded_data = JSON.decode(saved_data)
                self.setTable("charSave_table", loaded_data.charSave_table)
                Selected = loaded_data.Selected
            else
                Selected = 0 -- clr index, 0 - idle
                resetChar()
            end
            plColorsHexTable= {"#3f3f3f","#ffffff","#703a16","#da1917","#f3631c","#e6e42b","#30b22a","#20b09a","#1e87ff","#9f1fef","#f46fcd"}
            plColors_Table = {"Black","White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
            self.UI.setXml(charXml())
            hideThisChar()
        end
        function hideThisChar()
            if charSave_table.charHidden then
                hideFromTbl = {"Grey"}
                for i=2,11 do
                    if not charSave_table.aColors[i] then
                        table.insert(hideFromTbl, plColors_Table[i])
                    end
                end
                self.setInvisibleTo(hideFromTbl)
            else
                self.setInvisibleTo({})
            end
            Wait.frames(function()
                UI_update()
            end, 3)
        end
        function UI_update()
            UI_xmlElementUpdate("tokenUIbase", "position", (charSave_table.tokenGUI_settings[3] * 10)..","..(charSave_table.tokenGUI_settings[1] * 10)..","..(charSave_table.tokenGUI_settings[2] * (-10)))
            UI_xmlElementUpdate("tokenUIbase", "rotation", "0,0,"..charSave_table.tokenGUI_settings[4] * 15 + 90)
            UI_xmlElementUpdate("tokenUIbase", "scale", (1.1 ^ (charSave_table.tokenGUI_settings[5] - 6))..","..(1.1 ^ (charSave_table.tokenGUI_settings[5] - 6))..","..(1.1 ^ (charSave_table.tokenGUI_settings[5] - 6)))
            HP_i = math.floor(charSave_table.hp / charSave_table.hpMax * 20)

            showToStr = "Black"
            for i=2,11 do
                if charSave_table.aColors[i] then
                    addColStr = plColors_Table[i]
                    showToStr = showToStr.."|"..addColStr
                end
            end

            
            if charSave_table.charHidden then
                UI_xmlElementUpdate("conditionsPanel", "visibility", showToStr)
                UI_xmlElementUpdate("selectedMarker", "visibility", showToStr)
                UI_xmlElementUpdate("hpBar", "visibility", showToStr)
                UI_xmlElementUpdate("hiddenMarker", "active", "True")
                UI_xmlElementUpdate("hiddenMarker", "visibility", showToStr)
            else
                UI_xmlElementUpdate("conditionsPanel", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
                UI_xmlElementUpdate("selectedMarker", "visibility",  "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
                --UI_xmlElementUpdate("hpBar", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
                UI_xmlElementUpdate("hiddenMarker", "active", "False")
                if charSave_table.hpVisibleToPlayers then
                    UI_xmlElementUpdate("hpBar", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
                else
                    UI_xmlElementUpdate("hpBar", "visibility", showToStr)
                end
            end

            for i=1,20 do
                if i <= HP_i or (i == 1 and charSave_table.hp > 0) then
                    UI_xmlElementUpdate("hpBarText_"..strFromNum(i), "color", "#aa2222")
                else
                    UI_xmlElementUpdate("hpBarText_"..strFromNum(i), "color", "#662222")
                end
                if charSave_table.hpTemp > 0 and i > 1 and i < 20 then
                    UI_xmlElementUpdate("hpBarText_"..strFromNum(i), "outline", "#ffaa0022")
                elseif charSave_table.hpTemp == 0 and i > 1 and i < 20 then
                    UI_xmlElementUpdate("hpBarText_"..strFromNum(i), "outline", "#66004400")
                end
            end
            if Selected != 0 then 
                UI_xmlElementUpdate("selectedMarker", "active", "True")
                for i=1,4 do
                    UI_xmlElementUpdate("selectedMarker_"..strFromNum(i), "outline", plColorsHexTable[Selected].."ff")
                    --UI_xmlElementUpdate("selectedMarker_"..strFromNum(i), "outline", baseOutlnHexTable[Selected].."88")
                end
                UI_xmlElementUpdate("selectedMarker_00", "color", plColorsHexTable[Selected].."ff")
                UI_xmlElementUpdate("selectedMarker_10", "color", plColorsHexTable[Selected].."ff")
            else
                UI_xmlElementUpdate("selectedMarker", "active", "False")
            end
            for i=1,20 do
                if charSave_table.conditions.table[i] then
                    UI_xmlElementUpdate("conditionPanel_"..strFromNum(i), "active", "True")
                else
                    UI_xmlElementUpdate("conditionPanel_"..strFromNum(i), "active", "False")
                end
            end
            if charSave_table.conditions.table[18] then
                for i=1,5 do
                    if i == charSave_table.conditions.exhaustion then
                        UI_xmlElementUpdate("exhaustion_"..strFromNum(i), "active", "True")
                    else
                        UI_xmlElementUpdate("exhaustion_"..strFromNum(i), "active", "False")
                    end
                end
            end
            UI_xmlElementUpdate("bigPortrait", "image", charSave_table.portraitUrl)
        end
        function selectWobble()
            for i=1,5 do
                Wait.frames(function()
                    self.UI.setAttribute("selectedMarker", "scale", (1+(i*0.2))..","..(1+(i*0.2))..","..(1+(i*0.2)))
                end, i*2+5)
                Wait.frames(function()
                    self.UI.setAttribute("selectedMarker", "scale", (2-(i*0.2))..","..(2-(i*0.2))..","..(2-(i*0.2)))
                end, i*2+15)
            end
        end
        function selectSpin()
            for i=1,3 do
                Wait.frames(function()
                    self.UI.setAttribute("selectedMarkerStar", "rotation", "0,0,"..(i*7))
                end, i*20)
            end
        end
        function onRandomize(player_color)
            self.setVelocity({0,0,0})
            if self.UI.getAttribute("bigPortrait", "active") == "True" then
                self.UI.setAttribute("bigPortrait", "active", "False")
            else
                --if collisionImage != "" then
                --    charSave_table.portraitUrl = collisionImage
                --    collisionImage = ""
                --    UI_update()
                --end
                self.UI.setAttribute("bigPortrait", "active", "True")
            end
            UI_update()
        end
        --function onCollisionEnter(collision_info)
        --    if collision_info.collision_object.getCustomObject().image != nil and not collision_info.collision_object.locked and collision_info.collision_object.interactable and collision_info.collision_object.getPosition()[2] < self.getPosition()[2] then
        --        collisionImage = collision_info.collision_object.getCustomObject().image
        --        Wait.time(function()
        --            collisionImage = ""
        --        end, 10)
        --    end
        --end
        function resetChar()
            charSave_table = {}
            charSave_table.aColors = {true,false,false,false,false,false,false,false,false,false,false}
            charSave_table.portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
            charSave_table.charName = self.getName()
            charSave_table.hp = 1
            charSave_table.hpMax = 1
            charSave_table.hpTemp = 0
            charSave_table.deathSaves = {1,1,1,1,1}
            charSave_table.charLvl = 1
            charSave_table.charProfBonus = 2 -- math.floor((lvl +7)/4)     -- can be set manually for monsters
            charSave_table.AC = 10
            charSave_table.speed = 30
            charSave_table.initMod = 0
            charSave_table.pPerceptionMod = 0
            charSave_table.attributes = {}
            charSave_table.saves = {false,false,false,false,false,false}
            charSave_table.savesMod = {Fortitude = 0, Reflex = 0, Will = 0}
            for ii=1,6 do
                charSave_table.attributes[ii] = 10   -- modifier: (attr -10) /2
                charSave_table.saves[ii] = false
            end
            charSave_table.skills = {}
            for ii=1,18 do
                charSave_table.skills[ii] = {}
                charSave_table.skills[ii].proficient = false
                charSave_table.skills[ii].expertize = false
                charSave_table.skills[ii].mod = 0
            end
            charSave_table.attacks = {}
            for ii=1,10 do
                charSave_table.attacks[ii] = {}
                charSave_table.attacks[ii].atkName = "unarmed"
                charSave_table.attacks[ii].atkRolled = true
                charSave_table.attacks[ii].atkAttr = 1
                charSave_table.attacks[ii].proficient = true
                charSave_table.attacks[ii].minCrit = 20
                charSave_table.attacks[ii].atkMod = 0
                charSave_table.attacks[ii].dmgRolled = true
                charSave_table.attacks[ii].dmgAttr = 1
                charSave_table.attacks[ii].dmgStr = "1"
                charSave_table.attacks[ii].dmgStrCrit = "0"
                charSave_table.attacks[ii].resUsed = 0
                charSave_table.attacks[ii].icon = 1
            end
            charSave_table.splSlots = {0,0,0,0,0,0,0,0,0}
            charSave_table.splSlotsMax = {0,0,0,0,0,0,0,0,0}
            charSave_table.resourses = {}
            for ii=1,10 do
                charSave_table.resourses[ii] = {}
                charSave_table.resourses[ii].resName = ""
                charSave_table.resourses[ii].resValue = 0
                charSave_table.resourses[ii].resMax = 0
            end
            charSave_table.notes_A = ""
            charSave_table.notes_B = ""
            charSave_table.figurineUI_scale = 1
            charSave_table.figurineUI_xyzMods = {0,0,0}
             
            charSave_table.conditions = {}
            charSave_table.conditions.table = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false}
            charSave_table.conditions.exhaustion = 0
            charSave_table.hpVisibleToPlayers = true
            charSave_table.tokenGUI_settings = {0,0,0,0,5}

            charSave_table.charHidden = false
        end
        function UI_xmlElementUpdate(xml_ID, xml_attribute, input_string)
            if self.UI.getAttribute(xml_ID, xml_attribute) != input_string then
                self.UI.setAttribute(xml_ID, xml_attribute, input_string)
            end
        end
        function numFromStr(inpStr)
            if string.sub(inpStr,1,1) == "0" then
                return tonumber(string.sub(inpStr,2,2))
            else
                return tonumber(string.sub(inpStr,1,2))
            end
        end
        function numFromStrEnd(inpStr)
            if string.sub(inpStr,#inpStr-1,#inpStr-1) == "0" then
                return tonumber(string.sub(inpStr,#inpStr,#inpStr))
            else
                return tonumber(string.sub(inpStr,#inpStr-1,#inpStr))
            end
        end
        function strFromNum(inpNum)
            if inpNum < 10 then
                return "0"..tostring(inpNum)
            else
                return tostring(inpNum)
            end
        end
        function charXml()
            xmlStr = ''
            xmlStr = xmlStr..'<Defaults>'
            xmlStr = xmlStr..'    <Text  class="HP_text" color="#aa2222" fontSize="60" fontStyle="bold" text="●" /> <!-- ● ◉ -->'
            xmlStr = xmlStr..'    <Text  class="tokenUIbaseText" color="#ffffffee" shadow="#22222288" />'
            xmlStr = xmlStr..'    <Image class="conditionImage" height="15" width="15" position="0,-40,0" />'
            xmlStr = xmlStr..'    <Text  class="hiddenMarkerText" text="%" fontSize="150" color="#00000044" outline="#aaaaff22" outlineSize="2 -2" />'
            xmlStr = xmlStr..'</Defaults>'
            xmlStr = xmlStr..'<Panel id="tokenUIbase">'
            xmlStr = xmlStr..'    <Panel id="selectedMarker" position="0,0,-2" active="false">'
            xmlStr = xmlStr..'        <Text  id="selectedMarker_10" color="#aaaaaa88" fontSize="100" fontStyle="bold" text="►" position="50,0,0" outline="#00000066" outlineSize="2 -2" scale="0.5,1.2,0.5" />'
            xmlStr = xmlStr..'        <Text  id="selectedMarker_00" color="#aaaaaa88" fontSize="255" fontStyle="bold" text="●" position="0,17,0" outline="#00000066" outlineSize="2 -2"  />'
            xmlStr = xmlStr..'        <Panel id="selectedMarkerStar">'
            xmlStr = xmlStr..'            <Panel id="selectedMarker_01" height="75" width="75" rotation="0,0,0"  color="#00000044" />'
            xmlStr = xmlStr..'            <Panel id="selectedMarker_02" height="75" width="75" rotation="0,0,22" color="#00000044" />'
            xmlStr = xmlStr..'            <Panel id="selectedMarker_03" height="75" width="75" rotation="0,0,45" color="#00000044" />'
            xmlStr = xmlStr..'            <Panel id="selectedMarker_04" height="75" width="75" rotation="0,0,67" color="#00000044" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'    </Panel>'

            xmlStr = xmlStr..'    <Panel id="hiddenMarker" position="0,0,-200" active="false" visibility="Black">'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,0"   />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,30"  />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,60"  />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,90"  />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,120" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,150" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,180" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,210" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,240" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,270" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,300" />'
            xmlStr = xmlStr..'        <Text class="hiddenMarkerText" rotation="0,0,330" />'
            xmlStr = xmlStr..'    </Panel>'

            xmlStr = xmlStr..'    <!-- CONDITIONS -->'
            xmlStr = xmlStr..'    <Panel id="conditionsPanel" position="0,0,-200">'
            xmlStr = xmlStr..'        <!-- Full defence -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_19" position="0,0,50" rotation="0,0,0" active="false">'
            xmlStr = xmlStr..'            <Image height="100" width="100" position="0,-50,80" rotation="-90,0,0"  color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />'
            xmlStr = xmlStr..'            <Image height="100" width="100" position="-50,0,80" rotation="0,90,-90" color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />'
            xmlStr = xmlStr..'            <Image height="100" width="100" position="0,50,80"  rotation="90,0,180" color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />'
            xmlStr = xmlStr..'            <Image height="100" width="100" position="50,0,80"  rotation="0,-90,90" color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 1 Blinded -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_01" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576007925/FD162AF9F20B5FC262E93DF6C1693C3126450D47/" color="#aaaaaa" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 2 Deafened -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_02" rotation="0,0,20" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008053/895C077850ABF6BF61FF5F86604754C55B9AB111/" color="#aaaaff" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 3 Charmed -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_03" rotation="0,0,40" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008145/7F0A26F423A2E24F6171A93426C8F5362B181233/" color="#ff6688" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 4 Frightened -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_04" rotation="0,0,60" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008239/38C9B0F582DC7B2B8A506872232342A9702B04FD/" color="#ffaa00" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 5 Grappled -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_05" rotation="0,0,80" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008385/9ED4DBE5351637586D884F027CD2A169D1508D64/" color="#ffeeaa" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 6 Incapacitated -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_06" rotation="0,0,100" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008472/C82A22313B9834A38F0C0DC74BEC55A0E99834C9/" color="#aaaaaa" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 7 Invisible -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_07" rotation="0,0,120" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302577186503/9BE934856BF13B84EC27C9ADE1C88E21124D90B4/" color="#aaaaff" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 8 Paralyzed -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_08" rotation="0,0,140" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302577381345/E9DA460888E39C0E08A6A74EDC0B1883D28CC62C/" color="#ffff22" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 9 Petrified -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_09" rotation="0,0,160" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008757/BD92573701A4B9B10C2832C410475801A76BE07E/" color="#888844" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 10 Poisined -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_10" rotation="0,0,180" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008825/85756ADCD052206C9148CCB9F4CC2FCC407A78E6/" color="#00aa00" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 11 Prone -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_11" rotation="0,0,200" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008908/758FDA5A09A4E6DD7684AFB8D72EAA870BDC6886/" color="#aaaa88" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 12 Restrained -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_12" rotation="0,0,220" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008992/08B81309BD1B76E6B8171AB81C6AA56FF018A79B/" color="#ffffff" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 13 Stunned -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_13" rotation="0,0,240" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009081/A99C7542A7C400CB1623230998200C7D007FE12B/" color="#aaaaaa" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 14 Unconscious -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_14" rotation="0,0,260" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009190/382367D19631C1184EF694A02A085822FDF62D57/" color="#8888ff" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 15 Bleeding -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_15" rotation="0,0,280" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009283/B379F846DD62FFD4150D0BB341E23E58401C49BE/" color="#ff2222" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 16 Burning -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_16" rotation="0,0,300" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009377/7B4E5357B62E8B35C6FCB48ECA598BF8EAD18A2F/" color="#ffeeaa" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 17 Buffed -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_17" rotation="0,0,320" active="false">'
            xmlStr = xmlStr..'            <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009459/B96ECF9A46A96417B131F735940BDBF63034BE5D/" color="#aaaaff" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'        <!-- 18 Exhaustion -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_18" rotation="0,0,340" active="false">'
            xmlStr = xmlStr..'            <Image id="exhaustion_01" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009685/17E9E7B0A16B5A6140630EF6FF9F4DEEA7AAB8FE/" color="#ff00dd" />'
            xmlStr = xmlStr..'            <Image id="exhaustion_02" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009769/28843649E25B7EB7D0E09F5A48EF9A2C8674EF6A/" color="#ff00dd" />'
            xmlStr = xmlStr..'            <Image id="exhaustion_03" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009838/5C0330ECABBE478F9075D7E976E3D80988B713F3/" color="#ff00dd" />'
            xmlStr = xmlStr..'            <Image id="exhaustion_04" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009909/EF31B152FADB9C3285283548AC6F87AC63704D55/" color="#ff00dd" />'
            xmlStr = xmlStr..'            <Image id="exhaustion_05" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576010001/5309A748F4CE884C432CEA11BD3191B1FCB6BF23/" color="#ff00dd" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'    </Panel>'
            xmlStr = xmlStr..'    <!-- HP BAR  color="#662222"-->'
            xmlStr = xmlStr..'    <Panel id="hpBar" position="0,4,-200">'
            xmlStr = xmlStr..'        <Text id="hpBarText_01" class="HP_text" position="0,0,0"  outline="#552222" outlineSize="1 -1" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_02" class="HP_text" position="0,0,-5"   outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_03" class="HP_text" position="0,0,-10"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_04" class="HP_text" position="0,0,-15"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_05" class="HP_text" position="0,0,-20"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_06" class="HP_text" position="0,0,-25"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_07" class="HP_text" position="0,0,-30"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_08" class="HP_text" position="0,0,-35"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_09" class="HP_text" position="0,0,-40"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_10" class="HP_text" position="0,0,-45"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_11" class="HP_text" position="0,0,-50"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_12" class="HP_text" position="0,0,-55"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_13" class="HP_text" position="0,0,-60"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_14" class="HP_text" position="0,0,-65"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_15" class="HP_text" position="0,0,-70"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_16" class="HP_text" position="0,0,-75"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_17" class="HP_text" position="0,0,-80"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_18" class="HP_text" position="0,0,-85"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_19" class="HP_text" position="0,0,-90"  outline="#00000000" outlineSize="3 -3" />'
            xmlStr = xmlStr..'        <Text id="hpBarText_20" class="HP_text" position="0,0,-95"  outline="#552222" outlineSize="1 -1" />'
            xmlStr = xmlStr..'    </Panel>'
            xmlStr = xmlStr..'    <!-- CONDITIONS ON TOP -->'
            xmlStr = xmlStr..'    <Panel>'
            xmlStr = xmlStr..'        <!-- Dead -->'
            xmlStr = xmlStr..'        <Panel id="conditionPanel_20" position="0,0,-303" rotation="0,0,90" active="false">'
            xmlStr = xmlStr..'            <Image height="40" width="40" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009615/C0B0635BFEFF14FA1052ED89AAF2290DEAD8F1C8/" />'
            xmlStr = xmlStr..'        </Panel>'
            xmlStr = xmlStr..'    </Panel>'
            xmlStr = xmlStr..'    <!-- PORTRAIT -->'
            xmlStr = xmlStr..'    <Image active="False" id="bigPortrait" height="200" width="200" preserveAspect="true" position="0,0,-450" rotation="0,-90,90" color="#ffffffdd" image="https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/" />'
            xmlStr = xmlStr..'</Panel>'
            return xmlStr
        end
    ]]
    return charLua
end