local ATTRIBUTE_LIST = {"STR", "DEX", "CON", "INT", "WIS", "CHA"}
local SAVE_TYPES = {Fortitude = "CON", Reflex = "DEX", Will = "WIS"}
local LANGUAGES = {[1] = "EN", [2] = "RU"}
local PROFICIENCY_LEVELS = {"Untraning", "Traning", "Expert", "Master", "Legend"}
local PROFICIENCY_COLORS = {"#ffffff", "#575757ff", "#6a36bdff", "#af2d2dff", "#d0ff00ff"}
local SKILL_ATTRIBUTES = {"DEX", "INT", "STR", "INT", "CHA", "CHA", "CHA", "INT", "INT", "WIS", "WIS", "INT", "CHA", "WIS", "INT", "DEX", "WIS", "DEX", "WIS"}

local ATTACK_ICONS_URL = {
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
    "https://steamusercontent-a.akamaihd.net/ugc/2494507870664536258/A8339EB6A81C34A545C8DD6DF5E4421E0888E943/", -- scythe
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
    "https://steamusercontent-a.akamaihd.net/ugc/2494507870664699074/BB8C3A5AF35C898F562AECC120A1FE74D25D81DF/" -- book
}

-- Built-in functionality --
local function buildVisibilityString(conditionArray)
    local result = {}
    for i = 1, #main_Table do
        if conditionArray[i] then
            table.insert(result, plColors[i])
        end
    end
    return #result > 0 and table.concat(result, "|") or "noone"
end
local function UI_xmlElementUpdate(xml_ID, xml_attribute, input_string)
    if self.UI.getAttribute(xml_ID, xml_attribute) ~= input_string then
        self.UI.setAttribute(xml_ID, xml_attribute, input_string)
    end
end
local function updateMultipleElementsVisibility(elementIds, visibilityArray)
    local visibilityStr = buildVisibilityString(visibilityArray)
    for _, elementId in ipairs(elementIds) do
        UI_xmlElementUpdate(elementId, "visibility", visibilityStr)
    end
end
local function defineAtkIcons()
    for i=1,50 do
        if i <= #ATTACK_ICONS_URL then
            UI_xmlElementUpdate("atkEditIconsGrid_"..strFromNum(i), "image", ATTACK_ICONS_URL[i])
        else
            UI_xmlElementUpdate("atkEditIconsGrid_"..strFromNum(i), "color", "#00000000")
        end
    end
end
local function catchNameParameter(str)
    return str:match("^[^_]+_[^_]+_([^_]+)")
end
local function nFromPlClr(clr)
    for i = 1, #main_Table do
        if clr == plColors[i] then
            return i
        end
    end
end
local function checkGUIDtable()
    for i = 1, #main_Table do
        if getObjectFromGUID(lastPickedCharGUID_table[i]) == nil then
            lastPickedCharGUID_table[i] = ""
        end
    end
end
local function singleColor_UI_update_optimized(n)
    local playerData = main_Table[n]
    local flags = playerData.ui_update_flags
    local prefix = strFromNum(n)

    local anyChange = false

    if flags.basic_stats then
        UI_xmlElementUpdate(prefix.."_charPortrait", "image", playerData.portraitUrl)
        UI_xmlElementUpdate(prefix.."_charName", "text", playerData.charName)
        UI_xmlElementUpdate(prefix.."_charLvl", "text", lang_table[LANGUAGES[lang_set]][2]..playerData.charLvl)
        UI_xmlElementUpdate(prefix.."_charAC", "text", playerData.AC)
        local initModStr = ""
        if playerData.initMod ~= 0 then initModStr = " ("..PoM(playerData.initMod)..playerData.initMod..")" end
        local locInitMod = modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.initMod + playerData.charProfBonus*(playerData.skills[19].proficient - 1)
        UI_xmlElementUpdate("charInitAddButton_"..prefix, "text", lang_table[LANGUAGES[lang_set]][6]..PoM(locInitMod) .. locInitMod .. initModStr)
        local pPerseptionBase = 10 + modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.charProfBonus*(playerData.skills[19].proficient - 1)
        if playerData.pPerceptionMod ~= 0 then ppModStr = " ("..PoM(playerData.pPerceptionMod)..playerData.pPerceptionMod..")" else ppModStr = "" end
        if playerData.pPerceptionMod ~= 0 then ppModStr = " ("..PoM(playerData.pPerceptionMod)..playerData.pPerceptionMod..")" else ppModStr = "" end
        UI_xmlElementUpdate(prefix.."_charPassivePerception", "text", lang_table[LANGUAGES[lang_set]][7]..(playerData.pPerceptionMod + pPerseptionBase)..ppModStr)
        UI_xmlElementUpdate(prefix.."_charSpeed", "text", playerData.speed)
        UI_xmlElementUpdate(prefix.."_charHPbar", "percentage", (playerData.hp * 100 / playerData.hpMax))
        UI_xmlElementUpdate(prefix.."_charHPtext", "text", playerData.hp.." / "..playerData.hpMax)
        if playerData.hpTemp > 0 then
            UI_xmlElementUpdate(prefix.."_charTempHPtext", "text", "+"..playerData.hpTemp)
        else
            UI_xmlElementUpdate(prefix.."_charTempHPtext", "text", "")
        end
        anyChange = true
        flags.basic_stats = false
    end

    if flags.attributes then
        for _, name in ipairs(ATTRIBUTE_LIST) do
            UI_xmlElementUpdate(prefix.."_charAttrValue_" .. name, "text", playerData.attributes[name])
            UI_xmlElementUpdate(prefix.."_charAttrMod_" .. name, "text", PoM(modFromAttr(playerData.attributes[name]))..modFromAttr(playerData.attributes[name]))
        end
        anyChange = true
        flags.attributes = false
    end

    if flags.saves then
        local typeST = 1
        for smN, smV in pairs(playerData.savesMod) do
            local index = playerData.saves[smN]
            local colorStr = PROFICIENCY_COLORS[index]
            local tooltipText = lang_table[LANGUAGES[lang_set]][61 + typeST] .. " " .. lang_table[LANGUAGES[lang_set]][77 + index]; typeST = typeST + 1
            UI_xmlElementUpdate(prefix.."_charSaveButton_"..smN, "tooltip", tooltipText)
            if smV ~= 0 then saveModStr = "\n"..PoM(smV)..smV else saveModStr = "" end
            UI_xmlElementUpdate(prefix.."_charSaveButton_"..smN, "text", lang_table[LANGUAGES[lang_set]][14]..saveModStr)
            UI_xmlElementUpdate(prefix.."_charSaveButton_"..smN, "color", colorStr)
        end
        anyChange = true
        flags.saves = false
    end

    if flags.skills then
        for ii = 1, #playerData.skills do
            local sklModStr, index = "", playerData.skills[ii].proficient
            local colorStr = PROFICIENCY_COLORS[index]
            if playerData.skills[ii].mod ~= 0 then sklModStr = " "..PoM(playerData.skills[ii].mod)..playerData.skills[ii].mod end
            UI_xmlElementUpdate(prefix.."_charSkillButton_"..strFromNum(ii), "text", lang_table[LANGUAGES[lang_set]][14 + ii]..sklModStr)
            UI_xmlElementUpdate(prefix.."_charSkillButton_"..strFromNum(ii), "color", colorStr)

            local proficientSkill = playerData.charProfBonus*(index - 1)
            local thisSkillMod = modFromAttr(playerData.attributes[SKILL_ATTRIBUTES[ii]]) + playerData.skills[ii].mod + proficientSkill
            UI_xmlElementUpdate(prefix.."_charSkillButton_"..strFromNum(ii), "tooltip", "d20"..PoM(thisSkillMod) .. thisSkillMod .. " " .. lang_table[LANGUAGES[lang_set]][77 + index])
        end
        anyChange = true
        flags.skills = false
    end

    if flags.attacks then
        for ii = 1, 10 do
            UI_xmlElementUpdate(prefix.."_atkButtonImg_"..strFromNum(ii),"image",ATTACK_ICONS_URL[playerData.attacks[ii].icon])
            UI_xmlElementUpdate(prefix.."_atkButton_"..strFromNum(ii),"tooltip",playerData.attacks[ii].atkName)
        end
        anyChange = true
        flags.attacks = false
    end
    
    if flags.spell_slots then
        for ii = 1, 9 do
            local spellButtonStr = ""
            for iii=1, playerData.splSlotsMax[ii] do
                spellButtonStr = spellButtonStr..(iii <= playerData.splSlots[ii] and "●" or "○")
            end
            UI_xmlElementUpdate(prefix.."_spellSlotButton_"..strFromNum(ii),"text", " "..ii..". "..spellButtonStr)
        end
        anyChange = true
        flags.spell_slots = false
    end
    
    if flags.resources then
        for ii=1,10 do
            UI_xmlElementUpdate(prefix.."_resTextName_"..strFromNum(ii),"text", " "..ii..". "..playerData.resourses[ii].resName)
            if playerData.resourses[ii].resMax > 0 then
                UI_xmlElementUpdate(prefix.."_resTextNum_"..strFromNum(ii),"text", playerData.resourses[ii].resValue.." / "..playerData.resourses[ii].resMax)
            else
                UI_xmlElementUpdate(prefix.."_resTextNum_"..strFromNum(ii),"text", playerData.resourses[ii].resValue)
            end
        end
        anyChange = true
        flags.resources = false
    end

    if flags.conditions then
        for ii=1,20 do
            if playerData.conditions.table[ii] then condButtColor = "#ffffff02" else condButtColor = "#ffffff88" end
            UI_xmlElementUpdate(prefix.."_conditionButton_"..strFromNum(ii),"color", condButtColor)
        end
        
        for ii=1,5 do
            local conditionTable = {}
            for iii=1,11 do
                conditionTable[iii] = (main_Table[iii].conditions.exhaustion == ii)
            end
            local editModeVisibilityStr = buildVisibilityString(conditionTable)
            UI_xmlElementUpdate("exhaustionIcon_"..strFromNum(ii),"visibility",editModeVisibilityStr)
        end
        anyChange = true
        flags.conditions = false
    end

    if flags.notes then
        UI_xmlElementUpdate(prefix.."_notesText_B","text", playerData.notes_B)
        UI_xmlElementUpdate(prefix.."_notesInput_B","text", playerData.notes_B)
        anyChange = true
        flags.notes = false
    end

    if flags.team_bar then
        teamBar_UI_update()
        anyChange = true
        flags.team_bar = false
    end
    
    if anyChange and lastPickedCharGUID_table[n] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[n]) ~= nil and not firstLoad then
        SetStatsIntoToken(n)
    end
end
local function getNestedValue(obj, path)
    local keys = {}
    for key in path:gmatch("[^%.]+") do
        table.insert(keys, key)
    end
    
    local value = obj
    for _, key in ipairs(keys) do
        value = value[key:match("^%d+$") and tonumber(key) or key]
        if not value then return nil end
    end
    return value
end
local function setNestedValue(obj, path, newValue)
    local keys = {}
    for key in path:gmatch("[^%.]+") do
        table.insert(keys, key)
    end
    
    local current = obj
    for i = 1, #keys - 1 do
        local key = keys[i]
        current = current[key:match("^%d+$") and tonumber(key) or key]
        if not current then return end
    end
    current[keys[#keys]] = newValue
end
local function modifyNumericValue(pl, value, changeType, fieldPath, minVal, maxVal, updateFlag)
    local playerIndex = nFromPlClr(pl.color)
    local changeAmount = (changeType == "small") and 1 or 5
    local currentValue = getNestedValue(main_Table[playerIndex], fieldPath)
    
    if value == "-1" then
        currentValue = currentValue + changeAmount
    else
        currentValue = currentValue - changeAmount
    end
    
    currentValue = math.max(minVal, math.min(maxVal, currentValue))
    
    setNestedValue(main_Table[playerIndex], fieldPath, currentValue)
    main_Table[playerIndex].ui_update_flags[updateFlag] = true
    singleColor_UI_update_optimized(playerIndex)
end
local function noCharSelectedPanelCheck()
    local conditionTable = {}
    for i = 1, #main_Table do
        conditionTable[i] = (getObjectFromGUID(lastPickedCharGUID_table[i]) == nil or lastPickedCharGUID_table[i] == "")
    end
    local visibilityStr = buildVisibilityString(conditionTable)
    UI_xmlElementUpdate("noCharSelectedBlockPanel", "visibility", visibilityStr)
end
local function catchFieldType(elementId)
    if elementId:find("Attr") then return "attr" end
    if elementId:find("Save") then return "saveMod" end
    if elementId:find("Skill") then return "skillMod" end
    if elementId:find("Lvl") then return "lvl" end
    if elementId:find("AC") then return "AC" end
    if elementId:find("Speed") then return "speed" end
    if elementId:find("Init") then return "initMod" end
    if elementId:find("PassPerc") then return "pPerceptionMod" end
    return nil
end
local function getRollTypeFromID(elementId)
    if elementId:lower():find("attr") then return "attribute" end
    if elementId:lower():find("save") then return "save" end
    if elementId:lower():find("skill") then return "skill" end
    return nil
end
local function getPanelTypeFromID(elementId)
    return elementId:match("Show(%a+)$") or elementId:match("Toggle(%a+)$")
end
-- Built-in functionality --

function onSave()
    if resetGlobalLuaSave then
        lastPickedCharGUID_table = {"","","","","","","","","","",""}
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
    data_to_save.init_table = {}
    for s=1,#init_table do
        data_to_save.init_table[s] = {
            charName    = init_table[s].charName,
            rollRez     = init_table[s].rollRez,
            initMod     = init_table[s].initMod,
            tokenGUID   = init_table[s].tokenGUID,
            aColor      = init_table[s].aColor,
            portraitUrl = init_table[s].portraitUrl
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
    addHotkey("Hide/Show char sheet", function(playerColor) colorToggleShowMain(Player[playerColor]) end)
    if saved_data ~= nil and saved_data ~= "" then
        loaded_data = JSON.decode(saved_data)
        lang_set = loaded_data.lang_set
        if loaded_data.saveLastPick ~= nil then
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

    init_table[0] = {
        charName = "",
        rollRez = 0,
        initMod = 0,
        tokenGUID = "",
        aColor = 1
    }

    initEditPos = 0
    initEditPanelVisible = false

    plColors = {"Black","White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
    plColorsHexTable={"#3f3f3f","#ffffff","#703a16","#da1917","#f3631c","#e6e42b","#30b22a","#20b09a","#1e87ff","#9f1fef","#f46fcd"}
    editModeVisibility = {false,false,false,false,false,false,false,false,false,false,false}
    screenRollerVisibility = {false,false,false,false,false,false,false,false,false,false,false}
    screenRollerStringsToRoll = {"","","","","","","","","","",""}
    healTempDmg_table = {0,0,0,0,0,0,0,0,0,0,0}
    dSavesStr_table = {"","☻","x"}
    dSavesStrTeamBar_table = {" ","o","x"}
    editModeSelectedAttack = {1,1,1,1,1,1,1,1,1,1,1}

    allowedSymbols = "[ %d+-dк]"
    critRolled = false
    lastRollTotal = 0
    atkClicked = 0
    doubleRoll = 0
    defineAtkIcons()

    panelVisibility_attacks = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_spellSlots = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_resourses = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_notes = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_conditions = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_UIset = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_miniMap = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_main = {true,true,true,true,true,true,true,true,true,true,true}
    panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_bigPortrait = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_atkIconsMenu = {false,false,false,false,false,false,false,false,false,false,false}
    panelVisibility_init = {true,true,true,true,true,true,true,true,true,true,true}
    panelVisibilityMap = {
        attacks = panelVisibility_attacks,
        spellSlots = panelVisibility_spellSlots,
        resourses = panelVisibility_resourses,
        notes = panelVisibility_notes,
        conditions = panelVisibility_conditions,
        UIset = panelVisibility_UIset,
        miniMap = panelVisibility_miniMap,
        main = panelVisibility_main
    }

    rollOutputHex = "[cccccc]"

    main_Table = {}
    for i = 1, 11 do
        main_Table[i] = {}
        main_Table[i].aColors = {true,false,false,false,false,false,false,false,false,false,false}
        main_Table[i].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
        main_Table[i].charName = ""
        main_Table[i].hp = 92
        main_Table[i].hpMax = 113
        main_Table[i].hpTemp = 5
        main_Table[i].deathSaves = {1,1,1,1,1}
        main_Table[i].charLvl = 1
        main_Table[i].charProfBonus = 2
        main_Table[i].AC = 10
        main_Table[i].speed = 30
        main_Table[i].initMod = 0
        main_Table[i].pPerceptionMod = 0
        -- Initialize attributes with default values (modifier: (attr -10) /2)
        main_Table[i].attributes = {STR = 10, DEX = 10, CON = 10, INT = 10, WIS = 10, CHA = 10}
        main_Table[i].saves = {Fortitude = 1, Reflex = 1, Will = 1}
        main_Table[i].savesMod = {Fortitude = 0, Reflex = 0, Will = 0}
        -- Initialize skills with default values
        main_Table[i].skills = {}
        for ii = 1, 19 do
            main_Table[i].skills[ii] = {
                proficient = 1,
                mod = 0
            }
        end
        -- Initialize attacks with default values
        main_Table[i].attacks = {}
        for ii = 1, 10 do
            main_Table[i].attacks[ii] = {
                atkName = "unarmed",
                atkRolled = true,
                atkAttr = 1,
                proficient = 1,
                minCrit = 20,
                atkMod = 0,
                dmgRolled = true,
                dmgAttr = 1,
                dmgStr = "1",
                dmgStrCrit = "0",
                resUsed = 0,
                icon = 1
            }
        end
        main_Table[i].splSlots = {0,0,0,0,0,0,0,0,0}
        main_Table[i].splSlotsMax = {0,0,0,0,0,0,0,0,0}
        main_Table[i].resourses = {}
        for ii=1,10 do
            main_Table[i].resourses[ii] = {
                resName = "",
                resValue = 0,
                resMax = 0
            }
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

        main_Table[i].ui_update_flags = {
            basic_stats = false, -- hp, name, lvl, ac, speed
            attributes = false,
            saves = false,
            skills = false,
            attacks = false,
            spell_slots = false,
            resources = false,
            conditions = false,
            team_bar = false,
            notes = false
        }
    end
    checkGUIDtable()

    firstLoad = true
    addCharMode = false
    copyCharMode = false

    Wait.time(function()
        defineMiniMapUnit("◒")
        miniMap_UI_update()
    end, 0.2)

    charLua = ""
    WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Pathfinder2e/Character.lua",
        function(request) charLua = request.text end)
    lang_table = {}
    WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Pathfinder2e/DefineLangTable.json",
        function(request) lang_table = JSON.decode(request.text) end)
    Wait.time(function()
        language_UI_update()
        mainSheet_UI_update()
        initiative_UI_update()
    end, 3)
    Wait.time(function()
        noCharSelectedPanelCheck()
    end, 4)

    resetCounter = 0
end

-----------------------------   sheet <-> figurine interactions

function onObjectPickUp(plCl, pObj)
    if pObj.getVar("SCRIPTED_PF2E_CHARACTER") ~= nil and not copyCharMode then
        if pObj.getTable("charSave_table").aColors[nFromPlClr(plCl)] then
            previousTokenGUID = lastPickedCharGUID_table[nFromPlClr(plCl)]
            lastPickedCharGUID_table[nFromPlClr(plCl)] = pObj.getGUID()
            GetStatsFromToken(nFromPlClr(plCl),pObj)
            pObj.setVar("Selected", nFromPlClr(plCl))
            Wait.time(function()
                pObj.call("UI_update")
            end, 0.1)
            if previousTokenGUID ~= "" and getObjectFromGUID(previousTokenGUID) ~= nil and previousTokenGUID ~= lastPickedCharGUID_table[nFromPlClr(plCl)] then
                getObjectFromGUID(previousTokenGUID).setVar("Selected", tokenSelectionCheck(previousTokenGUID))
                Wait.time(function()
                    getObjectFromGUID(previousTokenGUID).call("UI_update")
                end, 0.1)
            end
            noCharSelectedPanelCheck()
        end
    elseif pObj.getVar("SCRIPTED_PF2E_CHARACTER") ~= nil and copyCharMode then
        pObj.setTable("charSave_table", main_Table[nFromPlClr(plCl)])
        pObj.call("UI_update")
        copyCharMode = false
        UI.setAttribute("copyCharModePanel", "active", "False")
        GM_settingsPanel_UI_update()
    else
        if plCl == "Black" and addCharMode then
            pObj.setLuaScript(charLua)
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
    for i = #main_Table, 1, -1 do
        if lastPickedCharGUID_table[i] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[i]) ~= nil then
            if lastPickedCharGUID_table[i] == previousTokenGUID then
                selectedUpdate = i
            end
        end
    end
    return selectedUpdate
end

function GetStatsFromToken(pl_N, obj)
    main_Table[pl_N] = obj.getTable("charSave_table")
    if main_Table[pl_N].charHidden == nil then
        main_Table[pl_N].charHidden = false
    end
    UI_upd(pl_N)
    atkEdit_UI_update(pl_N,editModeSelectedAttack[pl_N])
end

function SetStatsIntoToken(pl_N)
    if getObjectFromGUID(lastPickedCharGUID_table[pl_N]) ~= nil then
        getObjectFromGUID(lastPickedCharGUID_table[pl_N]).setTable("charSave_table", main_Table[pl_N])
        getObjectFromGUID(lastPickedCharGUID_table[pl_N]).call("UI_update")
    else
        lastPickedCharGUID_table[pl_N] = ""
    end
end

-----------------------------   sheet edits

function setCharPortrait(pl,vl,thisID)
    if vl ~= "" then
        main_Table[nFromPlClr(pl.color)].portraitUrl = vl
    else
        main_Table[nFromPlClr(pl.color)].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
    end
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(playerIndex)
end

function setCharName(pl,vl,thisID)
    if vl ~= nil then
        main_Table[nFromPlClr(pl.color)].charName = vl
        if getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]) ~= nil then
            getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]).setName(vl)
        end
        local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
        main_Table[playerIndex].ui_update_flags.basic_stats = true
        singleColor_UI_update_optimized(playerIndex)
    end
end

function setCharHP(pl,vl,thisID)
    if tonumber(vl) ~= nil then
        if numFromStrEnd(thisID) == 1 then
            main_Table[nFromPlClr(pl.color)].hp = tonumber(vl)
        else
            main_Table[nFromPlClr(pl.color)].hpMax = tonumber(vl)
        end
        if main_Table[nFromPlClr(pl.color)].hp < 0 then main_Table[nFromPlClr(pl.color)].hp = 0 end
        if main_Table[nFromPlClr(pl.color)].hpMax < 0 then main_Table[nFromPlClr(pl.color)].hpMax = 0 end
        if main_Table[nFromPlClr(pl.color)].hp > main_Table[nFromPlClr(pl.color)].hpMax then main_Table[nFromPlClr(pl.color)].hp = main_Table[nFromPlClr(pl.color)].hpMax end

        local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
        main_Table[playerIndex].ui_update_flags.basic_stats = true
        main_Table[playerIndex].ui_update_flags.team_bar = true
        singleColor_UI_update_optimized(playerIndex)
    end
end

function setCharHPvisibility(pl,vl,thisID)
    main_Table[nFromPlClr(pl.color)].hpVisibleToPlayers = not main_Table[nFromPlClr(pl.color)].hpVisibleToPlayers
    singleColor_UI_update(nFromPlClr(pl.color))
end

function setNumericField(pl, value, thisID)
    local configs = {
        attr = {field = "attributes.%s", min = 0, max = 50, flag = "attributes", changeType = "small"},
        saveMod = {field = "savesMod.%s", min = -15, max = 15, flag = "saves", changeType = "small"},
        skillMod = {field = "skills.%d.mod", min = -50, max = 50, flag = "skills", changeType = "small"},
        lvl = {field = "charLvl", min = 1, max = 20, flag = "basic_stats", changeType = "small"},
        AC = {field = "AC", min = 0, max = 50, flag = "basic_stats", changeType = "small"},
        speed = {field = "speed", min = 0, max = 1000, flag = "basic_stats", changeType = "large"},
        initMod = {field = "initMod", min = -15, max = 15, flag = "basic_stats", changeType = "small"},
        pPerceptionMod = {field = "pPerceptionMod", min = -15, max = 15, flag = "basic_stats", changeType = "small"}
    }
    
    local fieldType = catchFieldType(thisID)
    local config = configs[fieldType]
    if not config then return end
    
    local fieldName = string.format(config.field, catchNameParameter(thisID) or numFromStrEnd(thisID))
    modifyNumericValue(pl, value, config.changeType, fieldName, config.min, config.max, config.flag)
end

-------------------------   sheet buttons and more edits

local function rollAttribute(pl, vl, idName, MTId, textName, plColHex)
    local modifier = modFromAttr(main_Table[MTId].attributes[idName])
    local modStr = "1d20" .. PoM(modifier) .. modifier
    if vl == "-1" then
        stringRoller(modStr,pl, plColHex..main_Table[MTId].charName.."[-]: "..textName..":",1,false)
    elseif vl == "-2" then
        doubleRoll = 2
        stringRoller(modStr,pl, plColHex..main_Table[MTId].charName.."[-]: "..textName..":",2,false)
        stringRoller(modStr,pl, rollOutputHex..main_Table[MTId].charName.."[-]: "..textName..":",4,false)
    end
end

local function charSaveButton(pl, vl, idName, MTId, textName, plColHex)
    if editModeVisibility[MTId] then
        main_Table[MTId].saves[idName] = main_Table[MTId].saves[idName] + 1
        if main_Table[MTId].saves[idName] > #PROFICIENCY_LEVELS then main_Table[MTId].saves[idName] = 1 end
        main_Table[MTId].ui_update_flags.saves = true
        singleColor_UI_update_optimized(MTId)
    else
        local modifier = modFromAttr(main_Table[MTId].attributes[SAVE_TYPES[idName]]) + main_Table[MTId].savesMod[idName]
        local profBonus = main_Table[MTId].charProfBonus*(main_Table[MTId].saves[idName] - 1)
        local modStr = "1d20" .. PoM(modifier + profBonus) .. modifier + profBonus
        if vl == "-1" then
            stringRoller(modStr,pl, plColHex..main_Table[MTId].charName.."[-]: "..textName..":",1,false)
        elseif vl == "-2" then
            doubleRoll = 2
            stringRoller(modStr,pl, plColHex..main_Table[MTId].charName.."[-]: "..textName..":",2,false)
            stringRoller(modStr,pl, rollOutputHex..main_Table[MTId].charName.."[-]: "..textName..":",4,false)
        end
    end
end

local function skillButtonMain(pl, vl, id, textName, plColHex)
    local playerIndex, ending = numFromStr(id), numFromStrEnd(id)
    if editModeVisibility[playerIndex] then
        main_Table[playerIndex].skills[ending].proficient = main_Table[playerIndex].skills[ending].proficient + 1
        if main_Table[playerIndex].skills[ending].proficient > #PROFICIENCY_LEVELS then main_Table[playerIndex].skills[ending].proficient = 1 end
        main_Table[playerIndex].ui_update_flags.skills = true
        main_Table[playerIndex].ui_update_flags.basic_stats = true
        singleColor_UI_update_optimized(playerIndex)
    else
        local modifier = modFromAttr(main_Table[playerIndex].attributes[SKILL_ATTRIBUTES[ending]]) + main_Table[playerIndex].skills[ending].mod
        local profBonus = main_Table[playerIndex].charProfBonus*(main_Table[playerIndex].skills[ending].proficient - 1)
        local modStr = "1d20" .. PoM(modifier + profBonus) .. modifier + profBonus
        if vl == "-1" then
            stringRoller(modStr,pl, plColHex..main_Table[playerIndex].charName.."[-]: "..textName..":",1,false)
        elseif vl == "-2" then
            doubleRoll = 2
            stringRoller(modStr,pl, plColHex..main_Table[playerIndex].charName.."[-]: "..textName..":",2,false)
            stringRoller(modStr,pl, rollOutputHex..main_Table[playerIndex].charName.."[-]: "..textName..":",4,false)
        end
    end
end

function rollAndEditValue(pl, vl, id)
    local idName, MTId, textName = catchNameParameter(id), numFromStr(id), ""
    local plColHex = "["..Color[pl.color]:toHex(false).."]"
    if id:lower():find("attr") then
        textName = self.UI.getAttribute("attrName_" .. idName, "text")
        rollAttribute(pl, vl, idName, MTId, textName, plColHex)
    elseif id:lower():find("save") then
        textName = self.UI.getAttribute(id, "tooltip"):match("^([^ ]+ [^ ]+)")
        charSaveButton(pl, vl, idName, MTId, textName, plColHex)
    elseif id:lower():find("skill") then
        textName = lang_table[LANGUAGES[lang_set]][numFromStrEnd(id) + 14]:match("^([^ ]+)")
        skillButtonMain(pl, vl, id, textName, plColHex)
    end
end

-------------------------   HP

function setCharHealDmgVal(pl,vl,thisID)
    if tonumber(vl) ~= nil and vl ~= "" then
        healTempDmg_table[nFromPlClr(pl.color)] = math.abs(tonumber(vl))
    end
end

function takeDmg(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if healTempDmg_table[playerIndex] >= main_Table[playerIndex].hp + main_Table[playerIndex].hpTemp + main_Table[playerIndex].hpMax then
        for d=1,3 do
            main_Table[playerIndex].deathSaves[d] = 3
            main_Table[playerIndex].conditions.table[20] = true
        end
    end
    dmgLeftAfterTemp = math.max(0, healTempDmg_table[playerIndex] - main_Table[playerIndex].hpTemp)
    main_Table[playerIndex].hpTemp = math.max(0, main_Table[playerIndex].hpTemp - healTempDmg_table[playerIndex])
    main_Table[playerIndex].hp     = math.max(0, main_Table[playerIndex].hp - dmgLeftAfterTemp)
    healTempDmg_table[playerIndex] = 0
    self.UI.setAttribute(strFromNum(playerIndex).."_charHealDmgValueInput", "text", "")
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
    miniMap_UI_update()
end

function healHP(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].hp = math.min(main_Table[playerIndex].hpMax, main_Table[playerIndex].hp + healTempDmg_table[playerIndex])
    healTempDmg_table[playerIndex] = 0
    self.UI.setAttribute(strFromNum(playerIndex).."_charHealDmgValueInput", "text", "")
    for i=1,#main_Table[playerIndex].deathSaves do
        main_Table[playerIndex].deathSaves[i] = 1
    end
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
    miniMap_UI_update()
end

function setTempHP(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if healTempDmg_table[playerIndex] ~= 0 and vl == "-1" then
        main_Table[playerIndex].hpTemp = healTempDmg_table[playerIndex]
    elseif vl == "-2" then
        main_Table[playerIndex].hpTemp = 0
    end
    healTempDmg_table[playerIndex] = 0
    self.UI.setAttribute(strFromNum(playerIndex).."_charHealDmgValueInput", "text", "")
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(playerIndex)
end

function deathSaveButton(pl,vl,thisID)
    local playerIndex = numFromStr(thisID)
    main_Table[playerIndex].deathSaves[numFromStrEnd(thisID)] = main_Table[playerIndex].deathSaves[numFromStrEnd(thisID)] + 1
    if main_Table[playerIndex].deathSaves[numFromStrEnd(thisID)] > 3 then main_Table[playerIndex].deathSaves[numFromStrEnd(thisID)] = 1 end
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------   attacks

function atkButton(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    local plColHex = "["..Color[pl.color]:toHex(false).."]"
    if editModeVisibility[playerIndex] then
        editModeSelectedAttack[playerIndex] = numStrEnd
        for i=1,10 do
            if editModeSelectedAttack[playerIndex] == i or not editModeVisibility[playerIndex] then atkButtonImg_color = "#ffffffff" else atkButtonImg_color = "#ffffff88" end
            UI_xmlElementUpdate(strFromNum(playerIndex).."_atkButtonImg_"..strFromNum(i),"color",atkButtonImg_color)
        end
        atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
    else
        if main_Table[playerIndex].attacks[numStrEnd].resUsed == 0 or (main_Table[playerIndex].attacks[numStrEnd].resUsed ~= 0 and main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resValue > 0) then
            if main_Table[playerIndex].attacks[numStrEnd].resUsed ~= 0 then
                if main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resMax ~= 0 then
                    resLeftStr = " / "..main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resMax
                else
                    resLeftStr = ""
                end
                resLeftStr = " [aaaaff]("..main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resValue..resLeftStr..")[-]"
                main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resValue = main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resValue -1
                singleColor_UI_update(playerIndex)
            else
                resLeftStr = ""
            end

            local atkRollMod = main_Table[playerIndex].attacks[numStrEnd].atkMod
            if main_Table[playerIndex].attacks[numStrEnd].atkAttr ~= 0 then atkRollMod = atkRollMod + modFromAttr(main_Table[playerIndex].attributes[ATTRIBUTE_LIST[main_Table[playerIndex].attacks[numStrEnd].atkAttr]]) end
            if main_Table[playerIndex].attacks[numStrEnd].proficient > 1 then atkRollMod = atkRollMod + main_Table[playerIndex].charProfBonus*(main_Table[playerIndex].attacks[numStrEnd].proficient - 1) end
            atkClicked = numStrEnd
            critRolled = false

            if main_Table[playerIndex].attacks[numStrEnd].atkRolled then
                dmgRollType = 4
                if vl == "-1" then
                    if main_Table[playerIndex].attacks[numStrEnd].dmgRolled then rTypeA = 2 else rTypeA = 1 end
                    stringRoller("1d20"..PoM_add(atkRollMod),pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..main_Table[playerIndex].attacks[numStrEnd].atkName..resLeftStr..":",rTypeA,false)
                elseif vl == "-2" then
                    rTypeA = 2
                    if main_Table[playerIndex].attacks[numStrEnd].dmgRolled then rTypeB = 3 else rTypeB = 4 end
                    doubleRoll = 2
                    stringRoller("1d20"..PoM_add(atkRollMod),pl, plColHex..main_Table[numFromStr(thisID)].charName.."[-]: "..main_Table[playerIndex].attacks[numStrEnd].atkName..resLeftStr..":",rTypeA,false)
                    stringRoller("1d20"..PoM_add(atkRollMod),pl, rollOutputHex..main_Table[numFromStr(thisID)].charName.."[-]: "..main_Table[playerIndex].attacks[numStrEnd].atkName..":",rTypeB,false)
                end
            else
                dmgRollType = 1
                if diceRollsSneakyGM and pl.color == "Black" then
                    printToColor("[b] ͡° ● "..main_Table[numFromStr(thisID)].charName.."[/b][-]: [cccccc]"..main_Table[playerIndex].attacks[numStrEnd].atkName..":[-]", pl.color, pl.color)
                else
                    printToAll("[b]● "..main_Table[numFromStr(thisID)].charName.."[/b][-]: [cccccc]"..main_Table[playerIndex].attacks[numStrEnd].atkName..":[-]", pl.color)
                end
                
            end

            if main_Table[playerIndex].attacks[numStrEnd].dmgRolled then
                if main_Table[playerIndex].attacks[numStrEnd].dmgAttr ~= 0 then
                    dmgAttrStr = PoM_add(modFromAttr(main_Table[playerIndex].attributes[ATTRIBUTE_LIST[main_Table[playerIndex].attacks[numStrEnd].dmgAttr]]))
                    dmgAttrStrText = " + ".. lang_table[LANGUAGES[lang_set]][main_Table[playerIndex].attacks[numStrEnd].dmgAttr + 7]
                else
                    dmgAttrStr = ""
                    dmgAttrStrText = ""
                end

                if critRolled then
                    stringRoller(main_Table[playerIndex].attacks[numStrEnd].dmgStr..dmgAttrStr,pl, lang_table[LANGUAGES[lang_set]][45]..main_Table[playerIndex].attacks[numStrEnd].dmgStr..dmgAttrStrText.." :",3,false)
                    stringRoller(main_Table[playerIndex].attacks[numStrEnd].dmgStrCrit,pl, lang_table[LANGUAGES[lang_set]][46]..main_Table[playerIndex].attacks[numStrEnd].dmgStrCrit.." :",4,true)
                else
                    stringRoller(main_Table[playerIndex].attacks[numStrEnd].dmgStr..dmgAttrStr,pl, lang_table[LANGUAGES[lang_set]][45]..main_Table[playerIndex].attacks[numStrEnd].dmgStr.. dmgAttrStrText.." :",dmgRollType,false)
                end

            end
            atkClicked = 0

            if not main_Table[playerIndex].attacks[numStrEnd].atkRolled and not main_Table[playerIndex].attacks[numStrEnd].dmgRolled then
                if diceRollsSneakyGM and pl.color == "Black" then
                    printToColor(" ͡° ● "..main_Table[playerIndex].charName..": "..rollOutputHex..main_Table[playerIndex].attacks[numStrEnd].atkName..resLeftStr.."[-]", pl.color, pl.color)
                else
                    printToAll("● "..main_Table[playerIndex].charName..": "..rollOutputHex..main_Table[playerIndex].attacks[numStrEnd].atkName..resLeftStr.."[-]", pl.color)
                end
            end
        elseif main_Table[playerIndex].attacks[numStrEnd].resUsed ~= 0 and main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resValue == 0 then
            printToAll("► [cccccc]".. main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resName..": [ff8888]"..main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resValue.." / "..main_Table[playerIndex].resourses[main_Table[playerIndex].attacks[numStrEnd].resUsed].resMax .."[-]", pl.color)
        end
    end
end

function atkSetIcon(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if vl == "-1" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon + 1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon > #ATTACK_ICONS_URL then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon = 1 end
    elseif vl == "-2" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon -1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon <1 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon = #ATTACK_ICONS_URL end
    end
    main_Table[playerIndex].ui_update_flags.attacks = true
    atkEdit_UI_update(playerIndex, editModeSelectedAttack[playerIndex])
    singleColor_UI_update_optimized(playerIndex)
end

function atkSetName(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkName = vl
    main_Table[playerIndex].ui_update_flags.attacks = true
    atkEdit_UI_update(playerIndex, editModeSelectedAttack[playerIndex])
end

function atkToggleRollAtk(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkRolled = not main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkRolled
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetAtkAttr(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if vl == "-1" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr + 1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr > 6 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr = 0 end
    elseif vl == "-2" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr - 1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr < 0 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkAttr = 6 end
    end
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkToggleProf(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    local locProf = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].proficient
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].proficient = locProf < 5 and locProf + 1 or 1
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetMinCrit(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if tonumber(vl) ~= nil then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit = tonumber(vl)
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit > 20 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit = 20 end
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit < 1 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit = 1 end
        atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
    end
end

function atkSetAtkMod(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if tonumber(vl) ~= nil then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod = tonumber(vl)
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod >  20 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod =  20 end
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod < -20 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod = -20 end
        atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
    end
end

function atkToggleRollDmg(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgRolled = not main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgRolled
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetDmgAttr(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if vl == "-1" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr + 1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr >6 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr = 0 end
    elseif vl == "-2" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr -1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr <0 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgAttr = 6 end
    end
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetResUsed(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if vl == "-1" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed + 1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed >10 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed = 0 end
    elseif vl == "-2" then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed -1
        if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed <0 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].resUsed = 10 end
    end
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetStr(pl, vl, id)
    local playerIndex = nFromPlClr(pl.color)
    if vl:match("[^" .. allowedSymbols .. "]+") ~= nil then printToAll("► [ff9999]Dice input error![-]", plr.color) return end
    if tonumber(string.sub(vl, 1, 1)) == nil then
        printToAll("► [ff9999]Dice input error![-]", pl.color)
    else
        if id == "dmg" then
            main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgStr = vl
        elseif id == "crit" then
            main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgStrCrit = vl
        end
        atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
    end
end

-------------------------   spell slots

function spellSlotButtonMain(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    if editModeVisibility[playerIndex] then
        local locSSM = main_Table[playerIndex].splSlotsMax[numStrEnd]
        locSSM = locSSM + (vl == "-2" and 1 or -1)
        locSSM = (locSSM < 0 and 0) or (locSSM > 15 and 15) or locSSM
        main_Table[playerIndex].splSlotsMax[numStrEnd] = locSSM
    else
        if vl == "-2" then
            main_Table[playerIndex].splSlots[numStrEnd] = main_Table[playerIndex].splSlots[numStrEnd] + 1
            if main_Table[playerIndex].splSlots[numStrEnd] > main_Table[playerIndex].splSlotsMax[numStrEnd] then
                main_Table[playerIndex].splSlots[numStrEnd] = main_Table[playerIndex].splSlotsMax[numStrEnd]
            end
        elseif vl == "-1" then
            main_Table[playerIndex].splSlots[numStrEnd] = main_Table[playerIndex].splSlots[numStrEnd] - 1
            if main_Table[playerIndex].splSlots[numStrEnd] < 0 then
                main_Table[playerIndex].splSlots[numStrEnd] = 0
            end
        end
    end
    main_Table[playerIndex].ui_update_flags.spell_slots = true
    singleColor_UI_update_optimized(playerIndex)
end

function spellSlotButtonMax(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    if vl == "-2" then
        main_Table[playerIndex].splSlotsMax[numStrEnd] = main_Table[playerIndex].splSlotsMax[numStrEnd] + 1
        if main_Table[playerIndex].splSlotsMax[numStrEnd] > 10 then
            main_Table[playerIndex].splSlotsMax[numStrEnd] = 10
        end
    elseif vl == "-1" then
        main_Table[playerIndex].splSlotsMax[numStrEnd] = main_Table[playerIndex].splSlotsMax[numStrEnd] - 1
        if main_Table[playerIndex].splSlotsMax[numStrEnd] < 0 then
            main_Table[playerIndex].splSlotsMax[numStrEnd] = 0
        end
    end
    if main_Table[playerIndex].splSlots[numStrEnd] > main_Table[playerIndex].splSlotsMax[numStrEnd] then
        main_Table[playerIndex].splSlots[numStrEnd] = main_Table[playerIndex].splSlotsMax[numStrEnd]
    end
    main_Table[playerIndex].ui_update_flags.spell_slots = true
    singleColor_UI_update_optimized(playerIndex)
end

function spellSlotButtonMaxAll(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    for i=1,9 do
        main_Table[playerIndex].splSlots[i] = main_Table[playerIndex].splSlotsMax[i]
    end
    main_Table[playerIndex].ui_update_flags.spell_slots = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------   ressourses

function resSetName(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    main_Table[playerIndex].resourses[numStrEnd].resName = vl
    main_Table[playerIndex].ui_update_flags.resources = true
    singleColor_UI_update_optimized(playerIndex)
end

function resSetValue(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    if tonumber(vl) ~= nil then
        main_Table[playerIndex].resourses[numStrEnd].resValue = tonumber(vl)
        if main_Table[playerIndex].resourses[numStrEnd].resMax > 0 then
            if main_Table[playerIndex].resourses[numStrEnd].resValue > main_Table[playerIndex].resourses[numStrEnd].resMax then
                main_Table[playerIndex].resourses[numStrEnd].resValue = main_Table[playerIndex].resourses[numStrEnd].resMax
            end
        end
    end
    main_Table[playerIndex].ui_update_flags.resources = true
    singleColor_UI_update_optimized(playerIndex)
end

function resSetMax(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    if tonumber(vl) ~= nil then
        main_Table[playerIndex].resourses[numStrEnd].resMax = tonumber(vl)
        if main_Table[playerIndex].resourses[numStrEnd].resMax >0 then
            if main_Table[playerIndex].resourses[numStrEnd].resValue > main_Table[playerIndex].resourses[numStrEnd].resMax then
                main_Table[playerIndex].resourses[numStrEnd].resValue = main_Table[playerIndex].resourses[numStrEnd].resMax
            end
        end
        main_Table[playerIndex].ui_update_flags.resources = true
        singleColor_UI_update_optimized(playerIndex)
    end
end

function resSingleAdd(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    if numFromStr(thisID) == 1 then n_to_mult = -1 else n_to_mult = 1 end
    if vl == "-1" then n_to_add = 1 elseif vl == "-2" then n_to_add = 5 end
    main_Table[playerIndex].resourses[numStrEnd].resValue = main_Table[playerIndex].resourses[numStrEnd].resValue + (n_to_add * n_to_mult)
    if main_Table[playerIndex].resourses[numStrEnd].resMax >0 then
        if main_Table[playerIndex].resourses[numStrEnd].resValue > main_Table[playerIndex].resourses[numStrEnd].resMax then
            main_Table[playerIndex].resourses[numStrEnd].resValue = main_Table[playerIndex].resourses[numStrEnd].resMax
        end
        if main_Table[playerIndex].resourses[numStrEnd].resValue < 0 then
            main_Table[playerIndex].resourses[numStrEnd].resValue = 0
        end
    end
    main_Table[playerIndex].ui_update_flags.resources = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------

function setNotes(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    if string.sub(thisID,#thisID,#thisID) == "A" then
        main_Table[playerIndex].notes_A = vl
    else
        main_Table[playerIndex].notes_B = vl
    end
    main_Table[playerIndex].ui_update_flags.notes = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------

function setAssignedPlayer(pl,vl,thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    main_Table[playerIndex].aColors[numStrEnd] = not main_Table[playerIndex].aColors[numStrEnd]
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
    getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]).call("hideThisChar")
end

function toggleInvisible(pl,vl,thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].charHidden = not main_Table[playerIndex].charHidden
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
    getObjectFromGUID(lastPickedCharGUID_table[playerIndex]).call("hideThisChar")
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
            if numFromStrEnd(thisID) > #init_table then initTurnPos = 1 end
            initEditPos = 0
            UI_xmlElementUpdate("initSetupPanel", "active", "False")
            initiative_UI_update()
        end
    elseif initEditPos ~= numFromStrEnd(thisID) and numFromStrEnd(thisID) <= #init_table then
        UI_xmlElementUpdate("initSetupButton_"..strFromNum(initEditPos), "tooltip", "setup")
        initEditPos = numFromStrEnd(thisID)
        UI_xmlElementUpdate("initSetupPanel", "active", "True")
        UI_xmlElementUpdate("initSetupPanel", "offsetXY", "0 "..tostring(216 - 27 * initEditPos))
        UI_xmlElementUpdate("initSetupButton_"..strFromNum(numFromStrEnd(thisID)), "tooltip", "Right click:\nremove from initiative!")

        UI_xmlElementUpdate("initSetupRezInput", "text", init_table[numFromStrEnd(thisID)].rollRez)
        UI_xmlElementUpdate("initSetupNameInput", "text", init_table[numFromStrEnd(thisID)].charName)
        UI_xmlElementUpdate("initSetupModInput", "text", init_table[numFromStrEnd(thisID)].initMod)
        UI_xmlElementUpdate("initSetupColButton", "tooltip", plColors[init_table[numFromStrEnd(thisID)].aColor])
        
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
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    if #init_table < 15 then
        alreadyInInitiative = false
        for i=1,#init_table do
            if lastPickedCharGUID_table[playerIndex] == init_table[i].tokenGUID then
                alreadyInInitiative = true
            end
        end
        if not alreadyInInitiative then
            local locInitMod = modFromAttr(main_Table[playerIndex].attributes["WIS"]) +
                main_Table[playerIndex].skills[19].mod + main_Table[playerIndex].initMod +
                main_Table[playerIndex].charProfBonus*(main_Table[playerIndex].skills[19].proficient - 1)
            table.insert(init_table, #init_table + 1, {
                charName = main_Table[playerIndex].charName,
                rollRez = 0,
                initMod = locInitMod,
                tokenGUID = lastPickedCharGUID_table[playerIndex],
                aColor = playerIndex
            })
            initiative_UI_update()
        end
    end
end

function initiative_UI_update()   -------------
    UI_xmlElementUpdate("initTitleText", "text", lang_table[LANGUAGES[lang_set]][47])
    UI_xmlElementUpdate("initRoundCounter", "text", lang_table[LANGUAGES[lang_set]][48]..initRound)
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
        Wait.time(function()
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(#init_table + 1), "color", "#aaaaaa")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(#init_table + 1), "text", "+")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(#init_table + 1), "tooltip", "add char")
        end, 0.1)
    end
    if #init_table > 0 then
        UI_xmlElementUpdate("initCol_01", "tooltip", init_table[initTurnPos].charName.."\n"..init_table[initTurnPos].rollRez.." ("..PoM_add(init_table[initTurnPos].initMod)..")")
        UI_xmlElementUpdate("initCol_01", "color", plColorsHexTable[init_table[initTurnPos].aColor])
        UI_xmlElementUpdate("initImage_01", "color", "#ffffff")
        if getObjectFromGUID(init_table[initTurnPos].tokenGUID) ~= nil then
            UI_xmlElementUpdate("initImage_01", "image", getObjectFromGUID(init_table[initTurnPos].tokenGUID).getTable("charSave_table").portraitUrl)
        elseif init_table[initTurnPos].portraitUrl then
            UI_xmlElementUpdate("initImage_01", "image", init_table[initTurnPos].portraitUrl)
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
            if getObjectFromGUID(init_table[initImgUpdatePos].tokenGUID) ~= nil then
                UI_xmlElementUpdate("initImage_"..strFromNum(i), "image", getObjectFromGUID(init_table[initImgUpdatePos].tokenGUID).getTable("charSave_table").portraitUrl)
            elseif init_table[initImgUpdatePos].portraitUrl then
                UI_xmlElementUpdate("initImage_"..strFromNum(i), "image", init_table[initImgUpdatePos].portraitUrl)
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
            UI_xmlElementUpdate("initPassButton", "visibility", "Black|"..plColors[init_table[initTurnPos].aColor])
        end
    else
        UI_xmlElementUpdate("initPassButton", "visibility", "Black")
    end
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
    if tonumber(vl) ~= nil then
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
        if init_table[initEditPos].aColor > #main_Table then init_table[initEditPos].aColor = 1 end
    elseif vl == "-2" then
        init_table[initEditPos].aColor = init_table[initEditPos].aColor - 1
        if init_table[initEditPos].aColor < 1 then init_table[initEditPos].aColor = #main_Table end
    end
    UI_xmlElementUpdate("initSetupColButton", "tooltip", plColors[init_table[initEditPos].aColor])
    initiative_UI_update()
end

function initSetupModInp(pl,vl,thisID)
    if tonumber(vl) ~= nil then
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

function setInitCharPortrait(pl,vl)
    if vl ~= "" then
        init_table[initEditPos].portraitUrl = vl
    else
        init_table[initEditPos].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
    end
    initiative_UI_update()
end

function initRollSingle()
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
    if numFromStrEnd(thisID) ~= 18 then
        main_Table[nFromPlClr(pl.color)].conditions.table[numFromStrEnd(thisID)] = not main_Table[nFromPlClr(pl.color)].conditions.table[numFromStrEnd(thisID)]
    else
        if vl == "-1" then
            main_Table[nFromPlClr(pl.color)].conditions.exhaustion = main_Table[nFromPlClr(pl.color)].conditions.exhaustion + 1
            if main_Table[nFromPlClr(pl.color)].conditions.exhaustion > 5 then main_Table[nFromPlClr(pl.color)].conditions.exhaustion = 0 end
        elseif vl == "-2" then
            main_Table[nFromPlClr(pl.color)].conditions.exhaustion = main_Table[nFromPlClr(pl.color)].conditions.exhaustion - 1
            if main_Table[nFromPlClr(pl.color)].conditions.exhaustion < 0 then main_Table[nFromPlClr(pl.color)].conditions.exhaustion = 5 end
        end
        if main_Table[nFromPlClr(pl.color)].conditions.exhaustion ~= 0 then
            main_Table[nFromPlClr(pl.color)].conditions.table[numFromStrEnd(thisID)] = true
        else
            main_Table[nFromPlClr(pl.color)].conditions.table[numFromStrEnd(thisID)] = false
        end
    end
    local playerIndex, numStrEnd = nFromPlClr(pl.color), numFromStrEnd(thisID)
    main_Table[playerIndex].ui_update_flags.conditions = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------   char 3d UI settings

function tokenGUI_slider(pl,vl,thisID)
    main_Table[numFromStr(thisID)].tokenGUI_settings[numFromStrEnd(thisID)] = tonumber(vl)
    singleColor_UI_update(nFromPlClr(pl.color))
end

function tokenGUI_reset(pl,vl,thisID)
    main_Table[nFromPlClr(pl.color)].tokenGUI_settings = {0,0,0,0,5}
    singleColor_UI_update(nFromPlClr(pl.color))
end

-------------------------   UI updates

function colorToggleEditMode(pl,vl,thisID)
    if vl == "-1" then
        editModeVisibility[nFromPlClr(pl.color)] = not editModeVisibility[nFromPlClr(pl.color)]
        
        local elementsToUpdate = {
            "charPortraitNameInputsPanel", "charLvlEdit", "charACedit", "charSpeedEdit",
            "charProfBonusEdit", "assignedPlayersPanel", "charInitEdit", "charPassPercEdit",
            "charHPinputs", "atkEditPanel", "spellSlotsEditMaxButtons", "spellSlotMaxAllButton",
            "resoursesEditInputsPanel", "savesModsButtons"
        }
        updateMultipleElementsVisibility(elementsToUpdate, editModeVisibility)
        if editModeVisibility[1] then
            UI_xmlElementUpdate("charProfBonusEdit", "visibility", "Black")
            UI_xmlElementUpdate("assignedPlayersPanel", "visibility", "Black")
        end
        
        local editModeVisibilityStr = buildVisibilityString(editModeVisibility)
        for i=1, 6 do
            UI_xmlElementUpdate("charAttrEdit_"..i,"visibility",editModeVisibilityStr)
        end
        for i = 1, #main_Table[nFromPlClr(pl.color)].skills do
            UI_xmlElementUpdate("charSkillEditButtons_"..strFromNum(i),"visibility",editModeVisibilityStr)
        end

        UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)).."_charPortraitUrlInput", "text", main_Table[nFromPlClr(pl.color)].portraitUrl)

        for i=1,10 do
            if editModeSelectedAttack[nFromPlClr(pl.color)] == i or not editModeVisibility[nFromPlClr(pl.color)] then
                atkButtonImg_color = "#ffffffff"
            else
                atkButtonImg_color = "#ffffff88"
            end
            UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)).."_atkButtonImg_"..strFromNum(i),"color",atkButtonImg_color)
        end
        if editModeVisibility[nFromPlClr(pl.color)] then
            atkEdit_UI_update(nFromPlClr(pl.color), editModeSelectedAttack[nFromPlClr(pl.color)])
        end

        local flagVis = editModeVisibilityStr:find(pl.color) and "true" or "false"
        UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)) .. "_notesInput_A", "interactable", flagVis)
        UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)) .. "_notesInput_B", "interactable", flagVis)
    elseif vl == "-2" and editModeVisibility[nFromPlClr(pl.color)] and getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]) ~= nil then
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
            getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]).call("resetChar")
            GetStatsFromToken(nFromPlClr(pl.color), getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]))
            UI_xmlElementUpdate("charSheetUtilButton_08","color","#ffffff")
            resetCounter = 0
        end
    end
end

-- Helper function to update all elements of a specific type for all colors
function updateAllColorElements(baseId, attribute, value)
    for i = 1, #main_Table do
        local colorNum = string.format("%02d", i)
        local id = colorNum .. "_" .. baseId
        UI_xmlElementUpdate(id, attribute, value)
    end
end

-- Consolidated panel toggle function - reduces code duplication
local function togglePanelVisibility(pl, panel, extraAction)
    local visibilityArray = panelVisibilityMap[panel]
    if visibilityArray then
        local playerIndex = nFromPlClr(pl.color)
        visibilityArray[playerIndex] = not visibilityArray[playerIndex]
        UI_xmlElementUpdate("panel_"..panel, "visibility", buildVisibilityString(visibilityArray))
        if extraAction then extraAction() end
    end
end

-- Simplified toggle functions using the consolidated function
function colorToggleShowAttacks(pl,_,thisID)
    togglePanelVisibility(pl, "attacks")
end

function colorToggleShowSpellSlots(pl,_,thisID)
    togglePanelVisibility(pl, "spellSlots")
end

function colorToggleShowResourses(pl,_,thisID)
    togglePanelVisibility(pl, "resourses")
end

function colorToggleShowNotes(pl,_,thisID)
    togglePanelVisibility(pl, "notes")
end

function colorToggleConditions(pl,_,thisID)
    togglePanelVisibility(pl, "conditions")
end

function colorToggleUIsetup(pl,_,thisID)
    togglePanelVisibility(pl, "UIset")
end

function colorToggleShowMain(pl,vl,thisID)
    togglePanelVisibility(pl, "main", function()
        if not panelVisibility_main[nFromPlClr(pl.color)] and vl == "-2" then
            -- Show all panels when main is hidden
            panelVisibility_attacks[nFromPlClr(pl.color)] = true
            colorToggleShowAttacks(pl,_,_)
            panelVisibility_spellSlots[nFromPlClr(pl.color)] = true
            colorToggleShowSpellSlots(pl,_,_)
            panelVisibility_resourses[nFromPlClr(pl.color)] = true
            colorToggleShowResourses(pl,_,_)
            panelVisibility_notes[nFromPlClr(pl.color)] = true
            colorToggleShowNotes(pl,_,_)
            panelVisibility_conditions[nFromPlClr(pl.color)] = true
            colorToggleConditions(pl,_,_)
            panelVisibility_UIset[nFromPlClr(pl.color)] = true
            colorToggleUIsetup(pl,_,_)
        end
    end)
end

function colorToggleShowMiniMap(pl,vl,thisID)
    togglePanelVisibility(pl, "miniMap", "miniMap", function()
        miniMap_UI_update()
    end)
end

function colorToggleShowInitiative(pl,vl,thisID)
    panelVisibility_init[nFromPlClr(pl.color)] = not panelVisibility_init[nFromPlClr(pl.color)]
    local editModeVisibilityStr = buildVisibilityString(panelVisibility_init)
    UI_xmlElementUpdate("init_panel", "visibility", editModeVisibilityStr)
end

function colorToggleProjector(pl,vl,thisID)
    if nFromPlClr(pl.color) == 1 and vl == "-2" then
        panelVisibility_projector[nFromPlClr(pl.color)] = not panelVisibility_projector[nFromPlClr(pl.color)]
        if panelVisibility_projector[1] then
            panelVisibility_projector = {true,true,true,true,true,true,true,true,true,true,true}
            UI_xmlElementUpdate("projectorImage", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink")
        else
            panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
            UI_xmlElementUpdate("projectorImage", "visibility", "noone")
        end
    else
        panelVisibility_projector[nFromPlClr(pl.color)] = not panelVisibility_projector[nFromPlClr(pl.color)]
        local editModeVisibilityStr = buildVisibilityString(panelVisibility_projector)
        UI_xmlElementUpdate("projectorImage", "visibility", editModeVisibilityStr)
    end
end

function colorToggleBigPortrait(pl,vl,thisID)
    if thisID == "bigPortraitBigClose" then
        panelVisibility_bigPortrait[nFromPlClr(pl.color)] = false
    elseif thisID == "bigPortraitSelf" or (string.sub(thisID, 1, 15) == "bigPortraitInit" and #init_table > 0) or string.sub(thisID, 4, #thisID) == "bigPortraitTeam" then
        panelVisibility_bigPortrait[nFromPlClr(pl.color)] = true
        if thisID == "bigPortraitSelf" then
            UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)).."_bigPortraitImage","image",main_Table[nFromPlClr(pl.color)].portraitUrl)
        elseif string.sub(thisID, 1, 15) == "bigPortraitInit" and #init_table > 0 then
            local bigPortraitInitPos = initTurnPos
            for i=1,numFromStrEnd(thisID)-1 do
                bigPortraitInitPos = bigPortraitInitPos + 1
                if bigPortraitInitPos > #init_table then bigPortraitInitPos = 1 end
            end
            if vl == "-1" then
                if thisID:find("Init") then
                    UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)).."_bigPortraitImage","image",self.UI.getAttribute("initImage_"..thisID:match("^[^_]+_([^_]+)"), "image"))
                else
                    UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)).."_bigPortraitImage","image",getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID).getTable("charSave_table").portraitUrl)
                end
            elseif vl == "-2" then
                panelVisibility_bigPortrait[nFromPlClr(pl.color)] = false
                if getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID) ~= nil then
                    Player[plColors[nFromPlClr(pl.color)]].pingTable( getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID).getPosition() )
                end
            end
        elseif string.sub(thisID, 4, #thisID) == "bigPortraitTeam" then
            UI_xmlElementUpdate(strFromNum(nFromPlClr(pl.color)).."_bigPortraitImage","image",main_Table[numFromStr(thisID)].portraitUrl)
        end
    end
    local editModeVisibilityStr = buildVisibilityString(panelVisibility_bigPortrait)
    UI_xmlElementUpdate("bigPortraitPanel", "visibility", editModeVisibilityStr)
end

function onObjectRandomize(object, player_color)
    if panelVisibility_projector[1] then
        if player_color == "Black" and object.getCustomObject().image ~= nil then
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
    if main_Table[pl_N].attacks[atk_N].atkAttr ~= 0 then
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditAtkAttrButton","text",lang_table[LANGUAGES[lang_set]][main_Table[pl_N].attacks[atk_N].atkAttr + 7])
    else
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditAtkAttrButton","text","")
    end
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditProfButton","textOutline",PROFICIENCY_COLORS[main_Table[pl_N].attacks[atk_N].proficient])
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditMinCritText","text",lang_table[LANGUAGES[lang_set]][41]..main_Table[pl_N].attacks[atk_N].minCrit)
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditAtkModText","text",lang_table[LANGUAGES[lang_set]][42]..PoM_add(main_Table[pl_N].attacks[atk_N].atkMod))
    if main_Table[pl_N].attacks[atk_N].dmgRolled then tempColorStr = "#8888ffff" else tempColorStr = "#ffffff00" end
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditRollDmgButton","textOutline",tempColorStr)
    if main_Table[pl_N].attacks[atk_N].dmgAttr ~= 0 then
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditDmgAttrButton","text",lang_table[LANGUAGES[lang_set]][main_Table[pl_N].attacks[atk_N].dmgAttr + 7])
    else
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditDmgAttrButton","text","")
    end

    if main_Table[pl_N].attacks[atk_N].resUsed ~= 0 then
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditResUsedButton","text", main_Table[pl_N].attacks[atk_N].resUsed..". "..main_Table[pl_N].resourses[main_Table[pl_N].attacks[atk_N].resUsed].resName)
    else
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditResUsedButton","text","")
    end

    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditDmgStrText","text",lang_table[LANGUAGES[lang_set]][43]..main_Table[pl_N].attacks[atk_N].dmgStr)
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditCritDmgStrText","text",lang_table[LANGUAGES[lang_set]][44]..main_Table[pl_N].attacks[atk_N].dmgStrCrit)
    
    UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditIconImg","image",ATTACK_ICONS_URL[main_Table[pl_N].attacks[atk_N].icon])

    for ii=1,10 do
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkButtonImg_"..strFromNum(ii),"image",ATTACK_ICONS_URL[main_Table[pl_N].attacks[ii].icon])
        UI_xmlElementUpdate(strFromNum(pl_N).."_atkButton_"..strFromNum(ii),"tooltip",main_Table[pl_N].attacks[ii].atkName)
    end

    for ii=1,50 do
        if main_Table[pl_N].attacks[editModeSelectedAttack[pl_N]].icon == ii then
            UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditIconsGridButton_"..strFromNum(ii),"color","#ffffff02")
        else
            UI_xmlElementUpdate(strFromNum(pl_N).."_atkEditIconsGridButton_"..strFromNum(ii),"color","#ffffff44")
        end
    end

    if lastPickedCharGUID_table[pl_N] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[pl_N]) ~= nil and not firstLoad then
        SetStatsIntoToken(pl_N)
    end
end

function colorToggleAtkIconsMenu(pl,_,thisID)
    panelVisibility_atkIconsMenu[nFromPlClr(pl.color)] = not panelVisibility_atkIconsMenu[nFromPlClr(pl.color)]
    local editModeVisibilityStr = buildVisibilityString(panelVisibility_atkIconsMenu)
    UI_xmlElementUpdate("atkIconsMenu", "visibility", editModeVisibilityStr)
end

function atkIconsMenuButton(pl,vl,thisID)
    if numFromStrEnd(thisID) <= #ATTACK_ICONS_URL then
        main_Table[nFromPlClr(pl.color)].attacks[editModeSelectedAttack[nFromPlClr(pl.color)]].icon = numFromStrEnd(thisID)
        colorToggleAtkIconsMenu(pl,_,thisID)
        atkEdit_UI_update(nFromPlClr(pl.color),editModeSelectedAttack[nFromPlClr(pl.color)])
    end
end

function colorToggleScreenRoller(pl,_,thisID)
    for i = 1, #main_Table do
        if pl.color == plColors[i] then
            screenRollerVisibility[i] = not screenRollerVisibility[i]
        end
    end
    local screenRollerVisibilityStr = buildVisibilityString(screenRollerVisibility)
    UI_xmlElementUpdate("screenRollerBigPanel", "visibility", screenRollerVisibilityStr)
end

function mainSheet_UI_update()
    for i, name in ipairs(ATTRIBUTE_LIST) do
        UI_xmlElementUpdate("attrName_" .. name, "text", lang_table[LANGUAGES[lang_set]][7 + i])
    end
    for i = 1, 11 do
        singleColor_UI_update(i)
    end
    firstLoad = false
end

function singleColor_UI_update(n)
    UI_upd(n)
    if lastPickedCharGUID_table[n] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[n]) ~= nil and not firstLoad then
        SetStatsIntoToken(n)
    end
    for i = 1, #main_Table do
        if lastPickedCharGUID_table[i] ~= "" and i ~= n and lastPickedCharGUID_table[i] == lastPickedCharGUID_table[n] then
            if getObjectFromGUID(lastPickedCharGUID_table[i]) ~= nil then
                GetStatsFromToken(i, getObjectFromGUID(lastPickedCharGUID_table[i]))
            end
        end
    end
end

function UI_upd(i)
    local prefix, char = strFromNum(i), main_Table[i]
    UI_xmlElementUpdate(prefix.."_charPortrait", "image", char.portraitUrl)
    UI_xmlElementUpdate(prefix.."_charPortraitUrlInput", "text", char.portraitUrl)

    UI_xmlElementUpdate(prefix.."_charName", "text", char.charName)
    UI_xmlElementUpdate(prefix.."_charLvl", "text", lang_table[LANGUAGES[lang_set]][2]..char.charLvl)
    UI_xmlElementUpdate(prefix.."_charAC", "text", char.AC)
    UI_xmlElementUpdate(prefix.."_charSpeed", "text", char.speed)

    local initModStr = ""
    if char.initMod ~= 0 then initModStr = " ("..PoM(char.initMod)..char.initMod..")" end
    local locInitMod = modFromAttr(char.attributes["WIS"]) + char.skills[19].mod + char.initMod + char.charProfBonus*(char.skills[19].proficient - 1)
    UI_xmlElementUpdate("charInitAddButton_"..prefix, "text", lang_table[LANGUAGES[lang_set]][6]..PoM(locInitMod) .. locInitMod .. initModStr)

    local pPerseptionBase = 10 + modFromAttr(char.attributes["WIS"]) + char.skills[19].mod + char.charProfBonus*(char.skills[19].proficient - 1)
    if char.pPerceptionMod ~= 0 then ppModStr = " ("..PoM(char.pPerceptionMod)..char.pPerceptionMod..")" else ppModStr = "" end
    if char.pPerceptionMod ~= 0 then ppModStr = " ("..PoM(char.pPerceptionMod)..char.pPerceptionMod..")" else ppModStr = "" end
    UI_xmlElementUpdate(prefix.."_charPassivePerception", "text", lang_table[LANGUAGES[lang_set]][7]..(char.pPerceptionMod + pPerseptionBase)..ppModStr)

    UI_xmlElementUpdate(prefix.."_charHPbar", "percentage", (char.hp * 100 / char.hpMax))

    UI_xmlElementUpdate(prefix.."_charHPtext", "text", char.hp.." / "..char.hpMax)
    if char.hpTemp > 0 then
        UI_xmlElementUpdate(prefix.."_charTempHPtext", "text", "+"..char.hpTemp)
    else
        UI_xmlElementUpdate(prefix.."_charTempHPtext", "text", "")
    end
    
    if i == 1 and char.hpVisibleToPlayers then
        UI_xmlElementUpdate("charHPsetVisibilityButton", "text", "<O>") --●◘ ◯
    elseif i == 1 and not char.hpVisibleToPlayers then
        UI_xmlElementUpdate("charHPsetVisibilityButton", "text", "GM")
    end

    if char.hp < 1 then
        dSavesActive = "True"
    else
        dSavesActive = "False"
    end
    for ii = 1, 5 do
        UI_xmlElementUpdate(prefix.."_charDeathSaveButton_"..strFromNum(ii), "active", dSavesActive)
        UI_xmlElementUpdate(prefix.."_charDeathSaveButton_"..strFromNum(ii), "text", dSavesStr_table[char.deathSaves[ii]])
    end

    for _, name in ipairs(ATTRIBUTE_LIST) do
        UI_xmlElementUpdate(prefix.."_charAttrValue_" .. name, "text", char.attributes[name])
        UI_xmlElementUpdate(prefix.."_charAttrMod_" .. name, "text", PoM(modFromAttr(char.attributes[name]))..modFromAttr(char.attributes[name]))
    end

    local typeST = 1
    for smN, smV in pairs(char.savesMod) do
        local index = char.saves[smN]
        local colorStr = PROFICIENCY_COLORS[index]
        local tooltipText = lang_table[LANGUAGES[lang_set]][61 + typeST] .. " " .. lang_table[LANGUAGES[lang_set]][77 + index]; typeST = typeST + 1
        UI_xmlElementUpdate(prefix.."_charSaveButton_"..smN, "tooltip", tooltipText)
        if smV ~= 0 then saveModStr = "\n"..PoM(smV)..smV else saveModStr = "" end
        UI_xmlElementUpdate(prefix.."_charSaveButton_"..smN, "text", lang_table[LANGUAGES[lang_set]][14]..saveModStr)
        UI_xmlElementUpdate(prefix.."_charSaveButton_"..smN, "color", colorStr)
    end

    for ii = 1, #char.skills do
        local sklModStr, index = "", char.skills[ii].proficient
        local colorStr = PROFICIENCY_COLORS[index]
        if char.skills[ii].mod ~= 0 then sklModStr = " "..PoM(char.skills[ii].mod)..char.skills[ii].mod end
        UI_xmlElementUpdate(prefix.."_charSkillButton_"..strFromNum(ii), "text", lang_table[LANGUAGES[lang_set]][14 + ii]..sklModStr)
        UI_xmlElementUpdate(prefix.."_charSkillButton_"..strFromNum(ii), "color", colorStr)

        local proficientSkill = char.charProfBonus*(index - 1)
        local thisSkillMod = modFromAttr(char.attributes[SKILL_ATTRIBUTES[ii]]) + char.skills[ii].mod + proficientSkill
        UI_xmlElementUpdate(prefix.."_charSkillButton_"..strFromNum(ii), "tooltip", "d20"..PoM(thisSkillMod) .. thisSkillMod .. " " .. lang_table[LANGUAGES[lang_set]][77 + index])
    end

    for ii = 1, 10 do
        UI_xmlElementUpdate(prefix.."_atkButtonImg_"..strFromNum(ii),"image",ATTACK_ICONS_URL[char.attacks[ii].icon])
        UI_xmlElementUpdate(prefix.."_atkButton_"..strFromNum(ii),"tooltip",char.attacks[ii].atkName)
    end

    for ii = 1, 9 do
        spellButtonStr = ""
        for iii=1,char.splSlotsMax[ii] do
            if iii <= char.splSlots[ii] then
                spellButtonStr = spellButtonStr.."●"
            else
                spellButtonStr = spellButtonStr.."○"
            end
        end
        UI_xmlElementUpdate(prefix.."_spellSlotButton_"..strFromNum(ii),"text", " "..ii..". "..spellButtonStr)
    end

    for ii=1,10 do
        UI_xmlElementUpdate(prefix.."_resTextName_"..strFromNum(ii),"text", " "..ii..". "..char.resourses[ii].resName)
        if char.resourses[ii].resMax > 0 then
            UI_xmlElementUpdate(prefix.."_resTextNum_"..strFromNum(ii),"text", char.resourses[ii].resValue.." / "..char.resourses[ii].resMax)
        else
            UI_xmlElementUpdate(prefix.."_resTextNum_"..strFromNum(ii),"text", char.resourses[ii].resValue)
        end
    end

    UI_xmlElementUpdate(prefix.."_notesText_B","text", char.notes_B)
    UI_xmlElementUpdate(prefix.."_notesInput_B","text", char.notes_B)

    if i == 1 then
        for ii=2,11 do
            if char.aColors[ii] then
                UI_xmlElementUpdate("assighedPlayerButton_"..strFromNum(ii),"text", "●")
            else
                UI_xmlElementUpdate("assighedPlayerButton_"..strFromNum(ii),"text", "")
            end
        end
    end

    for ii=1,20 do
        if char.conditions.table[ii] then condButtColor = "#ffffff02" else condButtColor = "#ffffff88" end
        UI_xmlElementUpdate(prefix.."_conditionButton_"..strFromNum(ii),"color", condButtColor)
    end

    for ii=1,5 do
        local conditionTable = {}
        for iii=1,11 do
            conditionTable[iii] = (main_Table[iii].conditions.exhaustion == ii)
        end
        local editModeVisibilityStr = buildVisibilityString(conditionTable)
        UI_xmlElementUpdate("exhaustionIcon_"..strFromNum(ii), "visibility", editModeVisibilityStr)
    end

    UI_xmlElementUpdate(prefix.."_UIsetSlider_"..strFromNum(1),"value",char.tokenGUI_settings[1])
    UI_xmlElementUpdate(prefix.."_UIsetSlider_"..strFromNum(2),"value",char.tokenGUI_settings[2])
    UI_xmlElementUpdate(prefix.."_UIsetSlider_"..strFromNum(3),"value",char.tokenGUI_settings[3])
    UI_xmlElementUpdate(prefix.."_UIsetSlider_"..strFromNum(4),"value",char.tokenGUI_settings[4])
    UI_xmlElementUpdate(prefix.."_UIsetSlider_"..strFromNum(5),"value",char.tokenGUI_settings[5])
    
    if char.charHidden then
        UI_xmlElementUpdate("setInvisButton","color","#000022")
    else
        UI_xmlElementUpdate("setInvisButton","color","#cccccc")
    end

    teamBar_UI_update()
end

function onPlayerChangeColor(player_color)
    Wait.time(function()
        teamBar_UI_update()
    end, 0.2)
end

function teamBar_UI_update()
    nPlayers = 0
    for i=2,11 do
        if Player[plColors[i]].seated and lastPickedCharGUID_table[i] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[i]) ~= nil and not getObjectFromGUID(lastPickedCharGUID_table[i]).getTable("charSave_table").charHidden then
            nPlayers = nPlayers + 1
            UI_xmlElementUpdate(strFromNum(i).."_teamBarSegment", "active", "True")
            UI_xmlElementUpdate(strFromNum(i).."_teamBarColor", "color", plColorsHexTable[i])
            if lastPickedCharGUID_table[i] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[i]) ~= nil then
                UI_xmlElementUpdate(strFromNum(i).."_teamBarImage", "image", main_Table[i].portraitUrl)
            else
                UI_xmlElementUpdate(strFromNum(i).."_teamBarImage", "image", "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/")
            end
            local pPerseptionBase = 10 + modFromAttr(main_Table[i].attributes["WIS"]) + main_Table[i].skills[19].mod + main_Table[i].charProfBonus*(main_Table[i].skills[19].proficient - 1)
            if main_Table[i].pPerceptionMod ~= 0 then ppModStr = " ("..PoM(main_Table[i].pPerceptionMod)..main_Table[i].pPerceptionMod..")" else ppModStr = "" end
            
            UI_xmlElementUpdate(strFromNum(i).."_bigPortraitTeam", "tooltip", main_Table[i].charName.."\n"..
            lang_table[LANGUAGES[lang_set]][2]..main_Table[i].charLvl.."  "..lang_table[LANGUAGES[lang_set]][3]..main_Table[i].AC.."  "..lang_table[LANGUAGES[lang_set]][4]..main_Table[i].speed.."\n"..
            lang_table[LANGUAGES[lang_set]][7]..(main_Table[i].pPerceptionMod + pPerseptionBase)..ppModStr.."\n"..
            lang_table[LANGUAGES[lang_set]][8].." ".. main_Table[i].attributes["STR"].."("..PoM_add(modFromAttr(main_Table[i].attributes["STR"]))..")   "..
            lang_table[LANGUAGES[lang_set]][9].." ".. main_Table[i].attributes["DEX"].."("..PoM_add(modFromAttr(main_Table[i].attributes["DEX"]))..")   \n"..
            lang_table[LANGUAGES[lang_set]][10].." "..main_Table[i].attributes["CON"].."("..PoM_add(modFromAttr(main_Table[i].attributes["CON"]))..")   "..
            lang_table[LANGUAGES[lang_set]][11].." "..main_Table[i].attributes["INT"].."("..PoM_add(modFromAttr(main_Table[i].attributes["INT"]))..")   \n"..
            lang_table[LANGUAGES[lang_set]][12].." "..main_Table[i].attributes["WIS"].."("..PoM_add(modFromAttr(main_Table[i].attributes["WIS"]))..")   "..
            lang_table[LANGUAGES[lang_set]][13].." "..main_Table[i].attributes["CHA"].."("..PoM_add(modFromAttr(main_Table[i].attributes["CHA"]))..")   "
            )
            UI_xmlElementUpdate(strFromNum(i).."_teamBarHP", "percentage", math.floor(main_Table[i].hp / main_Table[i].hpMax * 100))
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
    if lastPickedCharGUID_table[nFromPlClr(pl.color)] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]) ~= nil then
        pl.lookAt({position = getObjectFromGUID(lastPickedCharGUID_table[nFromPlClr(pl.color)]).getPosition(), pitch = 65, yaw = 0, distance = 25})
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
    local countLang = 0
    for _,_ in pairs(lang_table) do countLang = countLang + 1 end
    if vl == "-1" then
        lang_set = lang_set + 1
        if lang_set > countLang then lang_set = 1 end
    elseif vl == "-2" then
        lang_set = lang_set - 1
        if lang_set < 1 then lang_set = countLang end
    end
    mainSheet_UI_update()
    initiative_UI_update()
    language_UI_update()
end

function language_UI_update()
    UI_xmlElementUpdate("noCharSelectedBlockText", "text", lang_table[LANGUAGES[lang_set]][1])
    for i = 1, #main_Table do
        UI_xmlElementUpdate(strFromNum(i).."_charPortraitUrlInput", "tooltip", lang_table[LANGUAGES[lang_set]][49])
    end
    UI_xmlElementUpdate("charNameInput", "tooltip", lang_table[LANGUAGES[lang_set]][50])
    UI_xmlElementUpdate("charHPsetInput_01", "tooltip", lang_table[LANGUAGES[lang_set]][51])
    UI_xmlElementUpdate("charHPsetInput_02", "tooltip", lang_table[LANGUAGES[lang_set]][52])
    UI_xmlElementUpdate("charHPsetVisibilityButton", "tooltip", lang_table[LANGUAGES[lang_set]][53])
    
    UI_xmlElementUpdate("charHP_dmgButton", "text", lang_table[LANGUAGES[lang_set]][54])
    UI_xmlElementUpdate("charHP_dmgButton", "tooltip", lang_table[LANGUAGES[lang_set]][55])
    for i = 1, #main_Table do
        UI_xmlElementUpdate(strFromNum(i).."_charHealDmgValueInput", "tooltip", lang_table[LANGUAGES[lang_set]][56])
    end
    UI_xmlElementUpdate("charHP_healButton", "text", lang_table[LANGUAGES[lang_set]][57])
    UI_xmlElementUpdate("charHP_healButton", "tooltip", lang_table[LANGUAGES[lang_set]][58])
    UI_xmlElementUpdate("charHP_tempButton", "text", lang_table[LANGUAGES[lang_set]][59])
    UI_xmlElementUpdate("charHP_tempButton", "tooltip", lang_table[LANGUAGES[lang_set]][60])

    for i=1, 11 do
        for ii=1, 5 do
            UI_xmlElementUpdate(strFromNum(i).."_charDeathSaveButton_"..strFromNum(ii), "tooltip", lang_table[LANGUAGES[lang_set]][61])
        end
    end
    for i=1, 11 do
        for ii=1, 6 do
            UI_xmlElementUpdate(strFromNum(i).."_charAttrMod_"..strFromNum(ii), "tooltip", lang_table[LANGUAGES[lang_set]][33 + ii])
        end
    end
    for i=1, 18 do
        UI_xmlElementUpdate("charSkillButtonE_"..strFromNum(i), "tooltip", lang_table[LANGUAGES[lang_set]][65])
        UI_xmlElementUpdate("charSkillButtonE_"..strFromNum(i), "text", lang_table[LANGUAGES[lang_set]][33])
        UI_xmlElementUpdate("charSkillButtonM_"..strFromNum(i), "tooltip", lang_table[LANGUAGES[lang_set]][79])
        UI_xmlElementUpdate("charSkillButtonM_"..strFromNum(i), "text", lang_table[LANGUAGES[lang_set]][78])
        UI_xmlElementUpdate("charSkillButtonL_"..strFromNum(i), "tooltip", lang_table[LANGUAGES[lang_set]][81])
        UI_xmlElementUpdate("charSkillButtonL_"..strFromNum(i), "text", lang_table[LANGUAGES[lang_set]][80])
    end
    for i=1, 8 do
        UI_xmlElementUpdate("charSheetUtilButton_"..strFromNum(i), "text", lang_table[LANGUAGES[lang_set]][65+i])
    end
    UI_xmlElementUpdate("charSheetUtilButton_06", "tooltip", lang_table[LANGUAGES[lang_set]][74])
    UI_xmlElementUpdate("charSheetUtilButton_07", "tooltip", lang_table[LANGUAGES[lang_set]][75])
    UI_xmlElementUpdate("charSheetUtilButton_08", "tooltip", lang_table[LANGUAGES[lang_set]][76])
    UI_xmlElementUpdate("charSheetUtilButton_09", "tooltip", lang_table[LANGUAGES[lang_set]][77])

    for i=2,11 do
        UI_xmlElementUpdate("assighedPlayerButton_"..strFromNum(i), "tooltip", lang_table[LANGUAGES[lang_set]][85])
    end

    for i = 1, #main_Table do
        UI_xmlElementUpdate("charInitAddButton_"..strFromNum(i), "tooltip", lang_table[LANGUAGES[lang_set]][86])
    end

    UI_xmlElementUpdate("initPassButton", "text", lang_table[LANGUAGES[lang_set]][84])

    UI_xmlElementUpdate("atkEditIconSetButton", "tooltip", lang_table[LANGUAGES[lang_set]][87])
    for i = 1, #main_Table do
        UI_xmlElementUpdate(strFromNum(i).."_atkEditRollAtkButton", "tooltip", lang_table[LANGUAGES[lang_set]][88])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditAtkAttrButton", "tooltip", lang_table[LANGUAGES[lang_set]][89])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditProfButton", "tooltip", lang_table[LANGUAGES[lang_set]][90])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditRollDmgButton", "tooltip", lang_table[LANGUAGES[lang_set]][91])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditDmgAttrButton", "tooltip", lang_table[LANGUAGES[lang_set]][92])
        UI_xmlElementUpdate(strFromNum(i).."_atkEditResUsedButton", "tooltip", lang_table[LANGUAGES[lang_set]][93])
    end
    for i = 1, #main_Table do
        for ii=1,9 do
            UI_xmlElementUpdate(strFromNum(i).."_spellSlotButton_"..strFromNum(ii), "tooltip", lang_table[LANGUAGES[lang_set]][94])
        end
        UI_xmlElementUpdate("spellSlotButtonMax_"..strFromNum(i), "tooltip", lang_table[LANGUAGES[lang_set]][94])
    end
    UI_xmlElementUpdate("notesPanelTitle", "text", lang_table[LANGUAGES[lang_set]][95])
    
    for i = 1, #main_Table do
        for ii=1,20 do
            UI_xmlElementUpdate(strFromNum(i).."_conditionButton_"..strFromNum(ii), "tooltip", lang_table[LANGUAGES[lang_set]][96+ii])
        end
    end

    UI_xmlElementUpdate("UIset_text_01", "text", lang_table[LANGUAGES[lang_set]][117])
    UI_xmlElementUpdate("UIset_text_02", "text", lang_table[LANGUAGES[lang_set]][118])

    UI_xmlElementUpdate("addCharModeText", "text", lang_table[LANGUAGES[lang_set]][120])
    
    UI_xmlElementUpdate("GM_toolsButton_01", "tooltip", lang_table[LANGUAGES[lang_set]][120])
    UI_xmlElementUpdate("GM_toolsButton_03", "tooltip", lang_table[LANGUAGES[lang_set]][122])
    UI_xmlElementUpdate("GM_toolsButton_05", "tooltip", lang_table[LANGUAGES[lang_set]][124])
    UI_xmlElementUpdate("GM_toolsButton_06", "tooltip", lang_table[LANGUAGES[lang_set]][125])
    UI_xmlElementUpdate("GM_toolsButton_07", "tooltip", lang_table[LANGUAGES[lang_set]][126])

    UI_xmlElementUpdate("projectorToggleButton", "tooltip", lang_table[LANGUAGES[lang_set]][127])

    UI_xmlElementUpdate("screenRollerMinimizer", "tooltip", lang_table[LANGUAGES[lang_set]][128])
    
    UI_xmlElementUpdate("setInvisButton", "text", lang_table[LANGUAGES[lang_set]][129])
    UI_xmlElementUpdate("setInvisButton", "tooltip", lang_table[LANGUAGES[lang_set]][130])

    UI_xmlElementUpdate("copyCharModeText", "text", lang_table[LANGUAGES[lang_set]][131])
    UI_xmlElementUpdate("GM_toolsButton_08", "tooltip", lang_table[LANGUAGES[lang_set]][132])
    UI_xmlElementUpdate("GM_toolsButton_09", "tooltip", lang_table[LANGUAGES[lang_set]][133])
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
    if getObjectFromGUID(lastPickedCharGUID_table[1]) ~= nil then
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
        if getAllObjects()[i].getVar("SCRIPTED_PF2E_CHARACTER") ~= nil then
            table.insert(objectsToUpdate, #objectsToUpdate + 1, getAllObjects()[i])
        end
    end
    for i=1,#objectsToUpdate do
        objectsToUpdate[i].setLuaScript(charLua)
        objectsToUpdate[i].reload()
        Wait.time(function()
            objectsToUpdate[i].call("UI_update")
        end, 0.1)
    end
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
    if autoPromote and player_color ~= "Grey" then
        Wait.time(function()
            if not Player[player_color].promoted and not Player[player_color].host then
                Player[player_color].promote()
            end
        end, 0.15)
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
local map_zone = nil
function miniMap_UI_update()
    miniMap_is_open = false
    for i = 1, #main_Table do
        if panelVisibility_miniMap[i] then
            miniMap_is_open = true
        end
    end

    if miniMap_is_open then
        local all_chars = {}
        if not map_zone then
            local allObj = getAllObjects()
            for i,v in ipairs(allObj) do
                if v.getName() == "_OW_tZone" then
                    map_zone = v
                    all_chars = v.getObjects()
                    break
                end
            end
        else
            all_chars = map_zone.getObjects()
        end
        if not map_zone then printToAll("Init OW map", {r = 0.7, g = 0.2, b = 0}) return end
        local w = 1
        while #all_chars >= w do
            if not all_chars[w].getVar("SCRIPTED_PF2E_CHARACTER") then
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
                        addColStr = plColors[ii]
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
    if dropped_object.getVar("SCRIPTED_PF2E_CHARACTER") ~= nil then
        miniMap_UI_update()
    end
end

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
end

function miniMap_pingBorder(pl,vl,thisID)
    Player[pl.color].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] - 70 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2]})
    Player[pl.color].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] + 70 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] - 140 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] - 70 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] + 70 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] + 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] + 70 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2]})
    Player[pl.color].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] - 70 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] + 140 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] + 70 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] ,0,miniMap_offset[2] - 140 / miniMap_zoom})
    Player[pl.color].pingTable({miniMap_offset[1] - 70 / miniMap_zoom ,0,miniMap_offset[2] - 140 / miniMap_zoom})

    Player[pl.color].pingTable({miniMap_offset[1] ,0,miniMap_offset[2]})
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
    for i = 1, #main_Table do
        if pl.color == plColors[i] then
            pl_N = i
        end
    end
    screenRollerStringsToRoll[pl_N] = vl
end

function screenStringRoller(pl,_,thisID)
    pl_N = nFromPlClr(pl.color)
    stringRoller(screenRollerStringsToRoll[pl_N],pl,"",1,false)
end

function stringRoller(inpStr, plr, commStr, rollType, rollCritDmg)
    -- Проверка на недопустимые символы
    if inpStr:match("[^" .. allowedSymbols .. "]+") then
        printToAll("► [ff9999]Dice input error![-]", plr.color)
        return
    end
    
    -- Проверка, что строка начинается с числа
    if not tonumber(string.sub(inpStr, 1, 1)) then
        printToAll("► [ff9999]Dice input error![-]", plr.color)
        return
    end
    
    -- Замена кириллической "к" на латинскую "d"
    inpStr = inpStr:gsub("к", "d")
    
    -- Инициализация генератора случайных чисел
    math.randomseed(os.clock() * 10000 + lastRollTotal)
    
    -- Разбор строки на сегменты и операторы
    local segments, operators = parseInputString(inpStr)
    
    -- Расчет результатов
    local totalResult, resultString, d20Color = calculateRollResults(segments, operators, plr)
    
    -- Формирование вывода
    local boxStart, boxEnd = getBoxFormatting(rollType, diceRollsShowEveryDie)
    
    -- Вывод результатов
    outputRollResults(plr, commStr, inpStr, totalResult, resultString, d20Color, 
                     boxStart, boxEnd, rollCritDmg, diceRollsShowEveryDie, diceRollsSneakyGM)
    
    lastRollTotal = totalResult
end

-- Вспомогательная функция для разбора входной строки
function parseInputString(inpStr)
    local segments = {}
    local operators = {}
    local segmentStart = 1
    
    for i = 1, #inpStr do
        local char = string.sub(inpStr, i, i)
        if char == "+" or char == "-" then
            operators[#operators + 1] = char
            local segmentEnd = i - 1
            segments[#segments + 1] = string.sub(inpStr, segmentStart, segmentEnd)
            segmentStart = i + 1
        end
    end
    
    -- Добавляем последний сегмент
    segments[#segments + 1] = string.sub(inpStr, segmentStart, #inpStr)
    
    return segments, operators
end

-- Вспомогательная функция для расчета результатов бросков
function calculateRollResults(segments, operators, plr)
    local totalResult = 0
    local resultString = ""
    local d20Color = ""
    
    -- Обработка двойных бросков
    local doubleRollPrefix, doubleRollSuffix = "", ""
    if doubleRoll > 0 then
        doubleRollPrefix = "[b]<"
        doubleRollSuffix = ">[/b]"
        doubleRoll = doubleRoll - 1
    end
    
    for i, segment in ipairs(segments) do
        if i > 1 then
            resultString = resultString .. operators[i-1]
        end
        
        local dPos = segment:find("d")
        if dPos then
            -- Обработка броска кубика
            local timesToRoll = tonumber(segment:sub(1, dPos-1)) or 0
            timesToRoll = math.min(timesToRoll, 5000) -- Ограничение количества бросков
            local sidesToRoll = tonumber(segment:sub(dPos+1)) or 0
            
            resultString = resultString .. "("
            
            for j = 1, timesToRoll do
                local rollResult = math.random(1, sidesToRoll)
                
                -- Проверка критов для d20
                if sidesToRoll == 20 and timesToRoll == 1 then
                    d20Color = getD20Color(rollResult)
                    
                    -- Дополнительная проверка для атак
                    if atkClicked ~= 0 then
                        local playerData = main_Table[nFromPlClr(plr)]
                        local minCrit = playerData and playerData.attacks[atkClicked].minCrit or 20
                        if rollResult >= minCrit then
                            critRolled = true
                            d20Color = "[ffff00]"
                        end
                    end
                end
                
                -- Цветовое форматирование результата
                local rollColor = getRollColor(rollResult, sidesToRoll)
                resultString = resultString .. rollColor .. rollResult .. "[-]"
                
                if j < timesToRoll then
                    resultString = resultString .. ","
                end
                
                -- Суммирование результата
                if i == 1 or operators[i-1] == "+" then
                    totalResult = totalResult + rollResult
                else
                    totalResult = totalResult - rollResult
                end
            end
            
            resultString = resultString .. ") "
        else
            -- Обработка статического модификатора
            local modifier = tonumber(segment) or 0
            resultString = resultString .. "(" .. modifier .. ") "
            
            if i == 1 or operators[i-1] == "+" then
                totalResult = totalResult + modifier
            else
                totalResult = totalResult - modifier
            end
        end
    end
    
    return totalResult, resultString, d20Color
end

-- Вспомогательная функция для определения цвета d20
function getD20Color(rollResult)
    if rollResult == 20 then
        return "[ffff00]"
    elseif rollResult == 1 then
        return "[ff8888]"
    else
        return "[ccccee]"
    end
end

-- Вспомогательная функция для определения цвета результата броска
function getRollColor(rollResult, sidesToRoll)
    if rollResult == 1 then
        return "[ff8888]"
    elseif rollResult == sidesToRoll then
        return "[ffff00]"
    else
        return "[ccccee]"
    end
end

-- Вспомогательная функция для форматирования рамок
function getBoxFormatting(rollType, showEveryDie)
    local boxStart, boxEnd
    
    if showEveryDie then
        if rollType == 1 then
            boxStart, boxEnd = "[b]╔[/b]", "[b]╚[/b]"
        elseif rollType == 2 then
            boxStart, boxEnd = "[b]╔[/b]", "[b]║[/b]"
        elseif rollType == 3 then
            boxStart, boxEnd = "[b]║[/b]", "[b]║[/b]"
        elseif rollType == 4 then
            boxStart, boxEnd = "[b]║[/b]", "[b]╚[/b]"
        end
    else
        if rollType == 1 then
            boxStart = "[b]●[/b]"
        elseif rollType == 2 then
            boxStart = "[b]╔[/b]"
        elseif rollType == 3 then
            boxStart = "[b]║[/b]"
        elseif rollType == 4 then
            boxStart = "[b]╚[/b]"
        end
    end
    
    return boxStart, boxEnd
end

-- Вспомогательная функция для вывода результатов
function outputRollResults(plr, commStr, inpStr, totalResult, resultString, d20Color, 
                          boxStart, boxEnd, rollCritDmg, showEveryDie, sneakyGM)
    local isSneaky = sneakyGM and plr.color == "Black"
    local printFunction = isSneaky and printToColor or printToAll
    local printTarget = isSneaky and plr.color or nil
    
    if rollCritDmg then
        local critMessage = string.format(" ͡° %s [ffffaa]%s %s = %s  ► %s ◄ [-]", 
                                         boxStart, commStr, inpStr, totalResult, totalResult + lastRollTotal)
        printFunction(critMessage, plr.color, printTarget)
        
        if showEveryDie then
            local detailsMessage = string.format(" ͡° %s [ffffaa]%s[-]", boxEnd, resultString)
            printFunction(detailsMessage, plr.color, printTarget)
        end
    else
        local rollMessage = string.format(" ͡° %s %s%s %s = %s%s%s[-]", 
                                         boxStart, rollOutputHex, commStr, inpStr, d20Color, 
                                         doubleRollPrefix or "", totalResult, doubleRollSuffix or "")
        printFunction(rollMessage, plr.color, printTarget)
        
        if showEveryDie then
            local detailsMessage = string.format(" ͡° %s %s%s[-]", boxEnd, rollOutputHex, resultString)
            printFunction(detailsMessage, plr.color, printTarget)
        end
    end
end