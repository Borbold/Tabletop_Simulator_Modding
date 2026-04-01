local ATTRIBUTE_LIST = {"STR", "DEX", "CON", "INT", "WIS", "CHA"}
local SAVE_TYPES = {Fortitude = "CON", Reflex = "DEX", Will = "WIS"}
local LANGUAGES = {[1] = "EN", [2] = "RU"}
local PROFICIENCY_LEVELS = {"Untraning", "Traning", "Expert", "Master", "Legend"}
local PROFICIENCY_COLORS = {"#ffffff", "#575757ff", "#6a36bdff", "#af2d2dff", "#d0ff00ff"}
local SKILL_ATTRIBUTES = {"DEX", "INT", "STR", "INT", "CHA", "CHA", "CHA", "INT", "INT", "WIS", "WIS", "INT", "CHA", "WIS", "INT", "DEX", "WIS", "DEX", "WIS"}
local PLAYER_COLOR = {"Black","White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
local PLAYER_COLOR_CODES = {"#3f3f3f","#ffffff","#703a16","#da1917","#f3631c","#e6e42b","#30b22a","#20b09a","#1e87ff","#9f1fef","#f46fcd"}
local DEATH_SAVE_SYMBOLS = {"","☻","x"}
local DEATH_SAVE_SYMBOLS_TEAM_BAR = {" ","o","x"}

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
local guidToIndex = {}
local function tokenSelectionCheck(previousTokenGUID)
    return guidToIndex[guid] or 0
end
local function updateGuidCache()
    for i, guid in ipairs(lastPickedCharGUID_table) do
        guidToIndex[guid] = i
    end
end
local function updateAttackIcons(n, updates)
    local prefix = strFromNum(n)
    for i = 1, 10 do
        updates[prefix.."_atkButtonImg_"..strFromNum(i)] = { image = ATTACK_ICONS_URL[main_Table[n].attacks[i].icon] }
        updates[prefix.."_atkButton_"..strFromNum(i)] = { tooltip = main_Table[n].attacks[i].atkName }
    end
end
local function PoM(mod)
    return (mod >= 0 and "+" or "")
end
local function formatModifier(mod)
    return PoM(mod) .. mod
end
local function buildVisibilityString(conditionArray)
    local result = {}
    for i = 1, #main_Table do
        if conditionArray[i] then
            table.insert(result, PLAYER_COLOR[i])
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
        if clr == PLAYER_COLOR[i] then
            return i
        end
    end
end
local function checkGUIDtable()
    for i = 1, #main_Table do
        if getObjectFromGUID(lastPickedCharGUID_table[i]) == nil then
            lastPickedCharGUID_table[i] = ""
            updateGuidCache()
        end
    end
end
-- Вспомогательная функция для пакетного обновления UI
-- Собирает все изменения в одну таблицу и применяет их за один проход
local function batchUIUpdate(updateTable)
    if not updateTable or not next(updateTable) then return end
    
    for id, attributes in pairs(updateTable) do
        for attr, value in pairs(attributes) do
            self.UI.setAttribute(id, attr, value)
        end
    end
end
local function singleColor_UI_update_optimized(n)
    local playerData = main_Table[n]
    local flags = playerData.ui_update_flags
    local prefix = strFromNum(n)

    -- Создаем одну большую таблицу для всех обновлений
    local allUpdates = {}

    if flags.basic_stats then
        allUpdates[prefix.."_charPortrait"] = {image = playerData.portraitUrl}
        allUpdates[prefix.."_charName"] = {text = playerData.charName}
        allUpdates[prefix.."_charLvl"] = {text = currentLang[2]..playerData.charLvl}
        allUpdates[prefix.."_charAC"] = {text = playerData.AC}
        
        local initModStr = ""
        if playerData.initMod ~= 0 then initModStr = " ("..PoM(playerData.initMod)..playerData.initMod..")" end
        local locInitMod = modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.initMod + playerData.charProfBonus*(playerData.skills[19].proficient - 1)
        allUpdates["charInitAddButton_"..prefix] = {text = currentLang[6]..PoM(locInitMod) .. locInitMod .. initModStr}
        
        local pPerseptionBase = 10 + modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.charProfBonus*(playerData.skills[19].proficient - 1)
        local ppModStr = ""
        if playerData.pPerceptionMod ~= 0 then ppModStr = " ("..PoM(playerData.pPerceptionMod)..playerData.pPerceptionMod..")" end
        allUpdates[prefix.."_charPassivePerception"] = {text = currentLang[7]..(playerData.pPerceptionMod + pPerseptionBase)..ppModStr}
        
        allUpdates[prefix.."_charSpeed"] = {text = playerData.speed}
        allUpdates[prefix.."_charHPbar"] = {percentage = (playerData.hp * 100 / playerData.hpMax)}
        allUpdates[prefix.."_charHPtext"] = {text = playerData.hp.." / "..playerData.hpMax}
        
        if playerData.hpTemp > 0 then
            allUpdates[prefix.."_charTempHPtext"] = {text = "+"..playerData.hpTemp}
        else
            allUpdates[prefix.."_charTempHPtext"] = {text = ""}
        end
        
        flags.basic_stats = false
    end

    if flags.attributes then
        for _, name in ipairs(ATTRIBUTE_LIST) do
            allUpdates[prefix.."_charAttrValue_" .. name] = {text = playerData.attributes[name]}
            allUpdates[prefix.."_charAttrMod_" .. name] = {text = PoM(modFromAttr(playerData.attributes[name]))..modFromAttr(playerData.attributes[name])}
        end
        flags.attributes = false
    end

    if flags.saves then
        local typeST = 1
        for smN, smV in pairs(playerData.savesMod) do
            local index = playerData.saves[smN]
            local colorStr = PROFICIENCY_COLORS[index]
            local tooltipText = currentLang[61 + typeST] .. " " .. currentLang[77 + index]
            typeST = typeST + 1
            
            local saveModStr = ""
            if smV ~= 0 then saveModStr = "\n"..PoM(smV)..smV end
            
            allUpdates[prefix.."_charSaveButton_"..smN] = {
                tooltip = tooltipText,
                text = currentLang[14]..saveModStr,
                color = colorStr
            }
        end
        flags.saves = false
    end

    if flags.skills then
        for ii = 1, #playerData.skills do
            local sklModStr = ""
            if playerData.skills[ii].mod ~= 0 then sklModStr = " "..PoM(playerData.skills[ii].mod)..playerData.skills[ii].mod end
            local index = playerData.skills[ii].proficient
            local colorStr = PROFICIENCY_COLORS[index]
            
            allUpdates[prefix.."_charSkillButton_"..strFromNum(ii)] = {
                text = currentLang[14 + ii]..sklModStr,
                color = colorStr
            }

            local proficientSkill = playerData.charProfBonus*(index - 1)
            local thisSkillMod = modFromAttr(playerData.attributes[SKILL_ATTRIBUTES[ii]]) + playerData.skills[ii].mod + proficientSkill
            allUpdates[prefix.."_charSkillButton_"..strFromNum(ii)].tooltip = "d20"..PoM(thisSkillMod) .. thisSkillMod .. " " .. currentLang[77 + index]
        end
        flags.skills = false
    end

    if flags.attacks then
        updateAttackIcons(n, allUpdates)
        flags.attacks = false
    end
    
    if flags.spell_slots then
        for ii = 1, 9 do
            local spellButtonStr = ""
            for iii=1, playerData.splSlotsMax[ii] do
                spellButtonStr = spellButtonStr..(iii <= playerData.splSlots[ii] and "●" or "○")
            end
            allUpdates[prefix.."_spellSlotButton_"..strFromNum(ii)] = {text = " "..ii..". "..spellButtonStr}
        end
        flags.spell_slots = false
    end
    
    if flags.resources then
        for ii=1,10 do
            allUpdates[prefix.."_resTextName_"..strFromNum(ii)] = {text = " "..ii..". "..playerData.resourses[ii].resName}
            if playerData.resourses[ii].resMax > 0 then
                allUpdates[prefix.."_resTextNum_"..strFromNum(ii)] = {text = playerData.resourses[ii].resValue.." / "..playerData.resourses[ii].resMax}
            else
                allUpdates[prefix.."_resTextNum_"..strFromNum(ii)] = {text = playerData.resourses[ii].resValue}
            end
        end
        flags.resources = false
    end

    if flags.conditions then
        for ii=1,20 do
            local condButtColor = playerData.conditions.table[ii] and "#ffffff02" or "#ffffff88"
            allUpdates[prefix.."_conditionButton_"..strFromNum(ii)] = {color = condButtColor}
        end
        
        for ii=1,5 do
            local conditionTable = {}
            for iii=1,11 do
                conditionTable[iii] = (main_Table[iii].conditions.exhaustion == ii)
            end
            local editModeVisibilityStr = buildVisibilityString(conditionTable)
            allUpdates["exhaustionIcon_"..strFromNum(ii)] = {visibility = editModeVisibilityStr}
        end
        flags.conditions = false
    end

    if flags.notes then
        allUpdates[prefix.."_notesText_B"] = {text = playerData.notes_B}
        allUpdates[prefix.."_notesInput_B"] = {text = playerData.notes_B}
        flags.notes = false
    end

    if flags.team_bar then
        -- Вызываем старую функцию, так как ее логика сложна и затрагивает всех игроков
        teamBar_UI_update()
        flags.team_bar = false
        singleColor_UI_update(n)
    end
    
    -- ОДИН-ЕДИНСТВЕННЫЙ ВЫЗОВ ДЛЯ ОБНОВЛЕНИЯ UI
    batchUIUpdate(allUpdates)
    
    if lastPickedCharGUID_table[n] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[n]) ~= nil and not firstLoad then
        SetStatsIntoToken(n)
    end
end
local function clamp(value, minVal, maxVal)
    if maxVal == nil then maxVal = math.huge end
    return math.max(minVal, math.min(maxVal, value))
end
local function modifyResource(playerIndex, resourceIndex, delta, newValue, newMax)
    local res = main_Table[playerIndex].resourses[resourceIndex]
    if newValue ~= nil then
        res.resValue = clamp(newValue, 0, res.resMax > 0 and res.resMax or math.huge)
    elseif newMax ~= nil then
        res.resMax = math.max(0, newMax)
        if res.resValue > res.resMax then res.resValue = res.resMax end
    elseif delta ~= nil then
        res.resValue = clamp(res.resValue + delta, 0, res.resMax > 0 and res.resMax or math.huge)
    end
    main_Table[playerIndex].ui_update_flags.resources = true
    singleColor_UI_update_optimized(playerIndex)
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
-- Built-in functionality --

function onSave()
    if resetGlobalLuaSave then
        lastPickedCharGUID_table = {"","","","","","","","","","",""}
        resetGlobalLuaSave = false
        print("Global Lua lastPickedCharGUID_table reset")
    end
    local data_to_save = {
        lang_set = lang_set,
        saveLastPick = saveLastPick,
        lastPickedCharGUID_table = Global.getTable("lastPickedCharGUID_table"),
        initTurnPos = initTurnPos,
        initRound = initRound,
        init_table = {},
        charBaseSpin = charBaseSpin,
        charAutosaveDelay = charAutosaveDelay,
        diceRollsShowEveryDie = diceRollsShowEveryDie,
        diceRollsSneakyGM = diceRollsSneakyGM,
        autoPromote = autoPromote,
        miniMap_offset = { miniMap_offset[1], miniMap_offset[2] },
        miniMap_zoom = miniMap_zoom
    }
    for s = 1, #init_table do
        data_to_save.init_table[s] = {
            charName    = init_table[s].charName,
            rollRez     = init_table[s].rollRez,
            initMod     = init_table[s].initMod,
            tokenGUID   = init_table[s].tokenGUID,
            aColor      = init_table[s].aColor,
            portraitUrl = init_table[s].portraitUrl
        }
    end
    return JSON.encode(data_to_save)
end

-- Функция-конструктор для данных одного персонажа
function createNewCharacterData()
    local char = {
        -- Базовые данные
        aColors = {true,false,false,false,false,false,false,false,false,false,false},
        portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/",
        charName = "",
        hp = 92,
        hpMax = 113,
        hpTemp = 5,
        deathSaves = {1,1,1,1,1},
        charLvl = 1,
        charProfBonus = 2,
        AC = 10,
        speed = 30,
        initMod = 0,
        pPerceptionMod = 0,
        
        -- Инициализация атрибутов с значениями по умолчанию
        attributes = {STR = 10, DEX = 10, CON = 10, INT = 10, WIS = 10, CHA = 10},
        saves = {Fortitude = 1, Reflex = 1, Will = 1},
        savesMod = {Fortitude = 0, Reflex = 0, Will = 0},
        
        -- Инициализация навыков
        skills = {},
        
        -- Инициализация атак
        attacks = {},
        
        -- Инициализация ячеек для заклинаний
        splSlots = {0,0,0,0,0,0,0,0,0},
        splSlotsMax = {0,0,0,0,0,0,0,0,0},
        
        -- Инициализация ресурсов
        resourses = {},
        
        -- Заметки
        notes_A = "",
        notes_B = "",

        -- Настройки UI для фигурки
        figurineUI_scale = 1,
        figurineUI_xyzMods = {0,0,0},
        
        -- Состояния и условия
        conditions = {
            table = {false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false},
            exhaustion = 0
        },

        -- Прочие флаги
        hpVisibleToPlayers = true,
        tokenGUI_settings = {0,0,0,0,0},
        charHidden = false,

        -- Флаги для обновления UI
        ui_update_flags = {
            basic_stats = false,
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
    }

    -- Инициализация вложенных таблиц в циклах
    for ii = 1, 19 do
        char.skills[ii] = {
            proficient = 1,
            mod = 0
        }
    end

    for ii = 1, 10 do
        char.attacks[ii] = {
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

    for ii=1,10 do
        char.resourses[ii] = {
            resName = "",
            resValue = 0,
            resMax = 0
        }
    end
    
    return char
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
        initRound = loaded_data.initRound
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
    updateGuidCache()
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

    editModeVisibility = {false,false,false,false,false,false,false,false,false,false,false}
    screenRollerVisibility = {false,false,false,false,false,false,false,false,false,false,false}
    screenRollerStringsToRoll = {"","","","","","","","","","",""}
    healTempDmg_table = {0,0,0,0,0,0,0,0,0,0,0}
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
        main_Table[i] = createNewCharacterData()
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
    lang_table, currentLang = {}, {}
    WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Pathfinder2e/DefineLangTable.json",
        function(request) lang_table = JSON.decode(request.text) currentLang = lang_table[LANGUAGES[lang_set]] end)
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

local function GM_settingsPanel_UI_update()
    local updates = {}
    -- Button 02 (charBaseSpin)
    if charBaseSpin then
        updates["GM_toolsButton_02"] = { textOutline = "#ff000088", color = "#ffffffff" }
    else
        updates["GM_toolsButton_02"] = { textOutline = "#ff000000", color = "#cccccccc" }
    end
    -- Button 03 (addCharMode)
    if addCharMode then
        updates["GM_toolsButton_03"] = { textOutline = "#0000aa88", color = "#ffffffff" }
    else
        updates["GM_toolsButton_03"] = { textOutline = "#0000aa00", color = "#cccccccc" }
    end
    -- Button 05 (diceRollsShowEveryDie)
    if diceRollsShowEveryDie then
        updates["GM_toolsButton_05"] = {
            textOutline = "#0000aa88",
            text = "●   ●\n●\n●   ●",
            color = "#ffffffff"
        }
    else
        updates["GM_toolsButton_05"] = {
            textOutline = "#0000aa00",
            text = "○   ○\n○\n○   ○",
            color = "#cccccccc"
        }
    end
    -- Button 06 (diceRollsSneakyGM)
    if diceRollsSneakyGM then
        updates["GM_toolsButton_06"] = { textOutline = "#0000aa88", color = "#ffffffff" }
    else
        updates["GM_toolsButton_06"] = { textOutline = "#0000aa00", color = "#cccccccc" }
    end
    -- Button 07 (autoPromote)
    if autoPromote then
        updates["GM_toolsButton_07"] = { textOutline = "#0000aa88", text = "★", color = "#ffffffff" }
    else
        updates["GM_toolsButton_07"] = { textOutline = "#0000aa00", text = "☆", color = "#cccccccc" }
    end
    -- Button 08 (copyCharMode)
    if copyCharMode then
        updates["GM_toolsButton_08"] = { textOutline = "#ffff0088", color = "#ffffffff" }
    else
        updates["GM_toolsButton_08"] = { textOutline = "#ffff0000", color = "#cccccccc" }
    end
    -- Button 09 (saveLastPick)
    if saveLastPick then
        updates["GM_toolsButton_09"] = { fontStyle = "bold", textOutline = "#ff000088", color = "#ffffffff" }
    else
        updates["GM_toolsButton_09"] = { fontStyle = "normal", textOutline = "#ff000000", color = "#cccccccc" }
    end

    batchUIUpdate(updates)
end

local function GetStatsFromToken(pl_N, obj)
    main_Table[pl_N] = obj.getTable("charSave_table")
    for flag, _ in pairs(main_Table[pl_N].ui_update_flags) do
        main_Table[pl_N].ui_update_flags[flag] = true
    end
    singleColor_UI_update_optimized(pl_N)
    atkEdit_UI_update(pl_N, editModeSelectedAttack[pl_N])
end
local itPickedUp = false
function onObjectPickUp(plCl, pObj)
    if not itPickedUp and pObj.getVar("SCRIPTED_PF2E_CHARACTER") ~= nil and not copyCharMode then
        itPickedUp = true
        if pObj.getTable("charSave_table").aColors[nFromPlClr(plCl)] then
            local idx = nFromPlClr(plCl)
            local previousTokenGUID = lastPickedCharGUID_table[idx]
            if lastPickedCharGUID_table[idx] ~= pObj.getGUID() then
                lastPickedCharGUID_table[idx] = pObj.getGUID()
                updateGuidCache()
            end
            GetStatsFromToken(idx, pObj)
            pObj.setVar("Selected", idx)
            -- Отложенное обновление текущего токена (чтобы не блокировать)
            Wait.time(function()
                itPickedUp = false
                pObj.call("UI_update")
            end, 0.1)
            -- Обновление предыдущего токена, если он существует и отличается
            if previousTokenGUID ~= "" and previousTokenGUID ~= lastPickedCharGUID_table[idx] then
                local prevObj = getObjectFromGUID(previousTokenGUID)
                if prevObj then
                    prevObj.setVar("Selected", tokenSelectionCheck(previousTokenGUID))
                    Wait.time(function()
                        prevObj.call("UI_update")
                    end, 0.15)
                end
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

function SetStatsIntoToken(pl_N)
    if getObjectFromGUID(lastPickedCharGUID_table[pl_N]) ~= nil then
        getObjectFromGUID(lastPickedCharGUID_table[pl_N]).setTable("charSave_table", main_Table[pl_N])
        getObjectFromGUID(lastPickedCharGUID_table[pl_N]).call("UI_update")
    else
        lastPickedCharGUID_table[pl_N] = ""
        updateGuidCache()
    end
end

-----------------------------   sheet edits

function setCharPortrait(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if vl ~= "" then
        main_Table[playerIndex].portraitUrl = vl
    else
        main_Table[playerIndex].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
    end
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(playerIndex)
end

function setCharName(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if vl == nil then return end
    
    main_Table[playerIndex].charName = vl
    if getObjectFromGUID(lastPickedCharGUID_table[playerIndex]) ~= nil then
        getObjectFromGUID(lastPickedCharGUID_table[playerIndex]).setName(vl)
    end
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(playerIndex)
end

function setCharHP(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if tonumber(vl) == nil then return end

    local playerIndex, numStrEnd = playerIndex, extractNumberFromString(thisID, "end")
    if numStrEnd == 1 then
        main_Table[playerIndex].hp = tonumber(vl)
    else
        main_Table[playerIndex].hpMax = tonumber(vl)
    end
    if main_Table[playerIndex].hp < 0 then main_Table[playerIndex].hp = 0 end
    if main_Table[playerIndex].hpMax < 0 then main_Table[playerIndex].hpMax = 0 end
    if main_Table[playerIndex].hp > main_Table[playerIndex].hpMax then main_Table[playerIndex].hp = main_Table[playerIndex].hpMax end
    main_Table[playerIndex].ui_update_flags.basic_stats = true
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
end

function setCharHPvisibility(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].hpVisibleToPlayers = not main_Table[playerIndex].hpVisibleToPlayers
    singleColor_UI_update(playerIndex)
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
    
    local fieldName = string.format(config.field, catchNameParameter(thisID) or extractNumberFromString(thisID, "end"))
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
    local playerIndex, numStrEnd = extractNumberFromString(id, "start"), extractNumberFromString(id, "end")
    if editModeVisibility[playerIndex] then
        main_Table[playerIndex].skills[numStrEnd].proficient = main_Table[playerIndex].skills[numStrEnd].proficient + 1
        if main_Table[playerIndex].skills[numStrEnd].proficient > #PROFICIENCY_LEVELS then main_Table[playerIndex].skills[numStrEnd].proficient = 1 end
        main_Table[playerIndex].ui_update_flags.skills = true
        main_Table[playerIndex].ui_update_flags.basic_stats = true
        singleColor_UI_update_optimized(playerIndex)
    else
        local modifier = modFromAttr(main_Table[playerIndex].attributes[SKILL_ATTRIBUTES[numStrEnd]]) + main_Table[playerIndex].skills[numStrEnd].mod
        local profBonus = main_Table[playerIndex].charProfBonus*(main_Table[playerIndex].skills[numStrEnd].proficient - 1)
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
    local idName, MTId, textName = catchNameParameter(id), extractNumberFromString(id, "start"), ""
    local plColHex = "["..Color[pl.color]:toHex(false).."]"
    if id:lower():find("attr") then
        textName = self.UI.getAttribute("attrName_" .. idName, "text")
        rollAttribute(pl, vl, idName, MTId, textName, plColHex)
    elseif id:lower():find("save") then
        textName = self.UI.getAttribute(id, "tooltip"):match("^([^ ]+ [^ ]+)")
        charSaveButton(pl, vl, idName, MTId, textName, plColHex)
    elseif id:lower():find("skill") then
        textName = currentLang[extractNumberFromString(id, "end") + 14]:match("^([^ ]+)")
        skillButtonMain(pl, vl, id, textName, plColHex)
    end
end

-------------------------   HP

function setCharHealDmgVal(pl, vl, thisID)
    local num = tonumber(vl)
    if num ~= nil and vl ~= "" then
        local idx = nFromPlClr(pl.color)
        healTempDmg_table[idx] = math.abs(num)
    end
end

function takeDmg(pl, vl, thisID)
    local idx = nFromPlClr(pl.color)
    local char = main_Table[idx]
    local dmgValue = healTempDmg_table[idx]
    -- Проверка на мгновенную смерть
    if dmgValue >= char.hp + char.hpTemp + char.hpMax then
        for d = 1, 3 do
            char.deathSaves[d] = 3
        end
        char.conditions.table[20] = true
    end
    -- Расчёт урона: сначала временные HP, потом основные
    local dmgAfterTemp = math.max(0, dmgValue - char.hpTemp)
    char.hpTemp = math.max(0, char.hpTemp - dmgValue)
    char.hp = math.max(0, char.hp - dmgAfterTemp)
    -- Сброс значения поля ввода и таблицы временного урона
    healTempDmg_table[idx] = 0
    self.UI.setAttribute(strFromNum(idx) .. "_charHealDmgValueInput", "text", "")
    -- Обновление UI
    char.ui_update_flags.basic_stats = true
    char.ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(idx)
    -- Обновление мини-карты (если открыта)
    miniMap_UI_update()
end

function healHP(pl, vl, thisID)
    local idx = nFromPlClr(pl.color)
    local char = main_Table[idx]
    local healAmount = healTempDmg_table[idx]

    char.hp = clamp(char.hp + healAmount, 0, char.hpMax)
    -- Сброс временных данных
    healTempDmg_table[idx] = 0
    self.UI.setAttribute(strFromNum(idx) .. "_charHealDmgValueInput", "text", "")
    -- Сброс смертельных спасбросков
    for i = 1, #char.deathSaves do
        char.deathSaves[i] = 1
    end

    char.ui_update_flags.basic_stats = true
    char.ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(idx)

    miniMap_UI_update()
end

function setTempHP(pl, vl, thisID)
    local idx = nFromPlClr(pl.color)
    local char = main_Table[idx]
    local tempValue = healTempDmg_table[idx]

    if tempValue ~= 0 and vl == "-1" then
        char.hpTemp = tempValue
    elseif vl == "-2" then
        char.hpTemp = 0
    end
    -- Очистка
    healTempDmg_table[idx] = 0
    self.UI.setAttribute(strFromNum(idx) .. "_charHealDmgValueInput", "text", "")

    char.ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(idx)
end

function deathSaveButton(pl, vl, thisID)
    local idx = extractNumberFromString(thisID, "start")
    local saveNum = extractNumberFromString(thisID, "end")
    local char = main_Table[idx]
    -- Защита от выхода за пределы массива (deathSaves имеет размер 5)
    if saveNum < 1 or saveNum > #char.deathSaves then return end
    -- Циклическое переключение: 1 -> 2 -> 3 -> 1
    char.deathSaves[saveNum] = (char.deathSaves[saveNum] % 3) + 1

    char.ui_update_flags.basic_stats = true
    singleColor_UI_update_optimized(idx)
end

-------------------------   attacks

function atkButton(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    local atkNum = extractNumberFromString(thisID, "end")
    local attack = main_Table[playerIndex].attacks[atkNum]
    local plColHex = "["..Color[pl.color]:toHex(false).."]"
    local prefix = strFromNum(playerIndex)

    if editModeVisibility[playerIndex] then
        -- Режим редактирования
        editModeSelectedAttack[playerIndex] = atkNum
        local updates = {}
        for i = 1, 10 do
            local color = (editModeSelectedAttack[playerIndex] == i or not editModeVisibility[playerIndex])
                          and "#ffffffff" or "#ffffff88"
            updates[prefix.."_atkButtonImg_"..strFromNum(i)] = { color = color }
        end
        batchUIUpdate(updates)
        atkEdit_UI_update(playerIndex, editModeSelectedAttack[playerIndex])
        return
    end

    -- Режим использования атаки
    local resIdx = attack.resUsed
    if resIdx ~= 0 then
        local resource = main_Table[playerIndex].resourses[resIdx]
        if resource.resValue <= 0 then
            printToAll("► [cccccc]".. resource.resName ..": [ff8888]".. resource.resValue .." / ".. resource.resMax .."[-]", pl.color)
            return
        end
    end

    -- Расход ресурса (если используется)
    if resIdx ~= 0 then
        modifyResource(playerIndex, resIdx, -1)
    end

    -- Формирование строки с остатком ресурса для вывода
    local resLeftStr = ""
    if resIdx ~= 0 then
        local resource = main_Table[playerIndex].resourses[resIdx]
        if resource.resMax > 0 then
            resLeftStr = " [aaaaff](" .. resource.resValue .. " / " .. resource.resMax .. ")[-]"
        else
            resLeftStr = " [aaaaff](" .. resource.resValue .. ")[-]"
        end
    end

    -- Расчёт модификатора атаки
    local atkRollMod = attack.atkMod
    if attack.atkAttr ~= 0 then
        atkRollMod = atkRollMod + modFromAttr(main_Table[playerIndex].attributes[ATTRIBUTE_LIST[attack.atkAttr]])
    end
    if attack.proficient > 1 then
        atkRollMod = atkRollMod + main_Table[playerIndex].charProfBonus * (attack.proficient - 1)
    end

    atkClicked = atkNum
    critRolled = false

    -- Бросок атаки
    if attack.atkRolled then
        local dmgRollType = 4
        if vl == "-1" then
            local rType = attack.dmgRolled and 2 or 1
            stringRoller("1d20"..formatModifier(atkRollMod), pl,
                plColHex..main_Table[playerIndex].charName.."[-]: "..attack.atkName..resLeftStr..":",
                rType, false)
        elseif vl == "-2" then
            doubleRoll = 2
            local rTypeA = 2
            local rTypeB = attack.dmgRolled and 3 or 4
            stringRoller("1d20"..formatModifier(atkRollMod), pl,
                plColHex..main_Table[playerIndex].charName.."[-]: "..attack.atkName..resLeftStr..":",
                rTypeA, false)
            stringRoller("1d20"..formatModifier(atkRollMod), pl,
                rollOutputHex..main_Table[playerIndex].charName.."[-]: "..attack.atkName..":",
                rTypeB, false)
        end
    else
        if diceRollsSneakyGM and pl.color == "Black" then
            printToColor("[b] ͡° ● "..main_Table[playerIndex].charName.."[/b][-]: [cccccc]"..attack.atkName..":[-]", pl.color, pl.color)
        else
            printToAll("[b]● "..main_Table[playerIndex].charName.."[/b][-]: [cccccc]"..attack.atkName..":[-]", pl.color)
        end
    end

    -- Бросок урона
    if attack.dmgRolled then
        local dmgAttrStr = ""
        local dmgAttrStrText = ""
        if attack.dmgAttr ~= 0 then
            local dmgAttrMod = modFromAttr(main_Table[playerIndex].attributes[ATTRIBUTE_LIST[attack.dmgAttr]])
            dmgAttrStr = formatModifier(dmgAttrMod)
            dmgAttrStrText = " + " .. currentLang[attack.dmgAttr + 7]
        end

        if critRolled then
            stringRoller(attack.dmgStr..dmgAttrStr, pl,
                currentLang[45]..attack.dmgStr..dmgAttrStrText.." :", 3, false)
            stringRoller(attack.dmgStrCrit, pl,
                currentLang[46]..attack.dmgStrCrit.." :", 4, true)
        else
            local dmgRollType = 1
            stringRoller(attack.dmgStr..dmgAttrStr, pl,
                currentLang[45]..attack.dmgStr..dmgAttrStrText.." :", dmgRollType, false)
        end
    end

    -- Если ни атака, ни урон не бросались, выводим просто имя
    if not attack.atkRolled and not attack.dmgRolled then
        if diceRollsSneakyGM and pl.color == "Black" then
            printToColor(" ͡° ● "..main_Table[playerIndex].charName..": "..rollOutputHex..attack.atkName..resLeftStr.."[-]", pl.color, pl.color)
        else
            printToAll("● "..main_Table[playerIndex].charName..": "..rollOutputHex..attack.atkName..resLeftStr.."[-]", pl.color)
        end
    end

    atkClicked = 0
end

function atkSetIcon(pl, vl, thisID)
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

function atkSetName(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkName = vl
    main_Table[playerIndex].ui_update_flags.attacks = true
    atkEdit_UI_update(playerIndex, editModeSelectedAttack[playerIndex])
end

function atkToggleRollAtk(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkRolled = not main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkRolled
    atkEdit_UI_update(playerIndex, editModeSelectedAttack[playerIndex])
end

function atkSetAtkAttr(pl, vl, thisID)
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

function atkToggleProf(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    local locProf = main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].proficient
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].proficient = locProf < 5 and locProf + 1 or 1
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetMinCrit(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if tonumber(vl) == nil then return end

    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit = tonumber(vl)
    if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit > 20 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit = 20 end
    if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit < 1 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].minCrit = 1 end
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetAtkMod(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if tonumber(vl) == nil then return end
    
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod = tonumber(vl)
    if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod >  20 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod =  20 end
    if main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod < -20 then main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].atkMod = -20 end
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkToggleRollDmg(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgRolled = not main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].dmgRolled
    atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
end

function atkSetDmgAttr(pl, vl, thisID)
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

function atkSetResUsed(pl, vl, thisID)
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

function spellSlotButtonMain(pl, vl, thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), extractNumberFromString(thisID, "end")
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

function spellSlotButtonMax(pl, vl, thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), extractNumberFromString(thisID, "end")
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

function spellSlotButtonMaxAll(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    for i = 1, 9 do
        main_Table[playerIndex].splSlots[i] = main_Table[playerIndex].splSlotsMax[i]
    end
    main_Table[playerIndex].ui_update_flags.spell_slots = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------   ressourses

function resSetName(pl, vl, thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), extractNumberFromString(thisID, "end")
    main_Table[playerIndex].resourses[numStrEnd].resName = vl
    main_Table[playerIndex].ui_update_flags.resources = true
    singleColor_UI_update_optimized(playerIndex)
end

function resSetValue(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    local resourceIndex = extractNumberFromString(thisID, "end")
    local newValue = tonumber(vl)
    if newValue then
        modifyResource(playerIndex, resourceIndex, nil, newValue)
    end
end

function resSetMax(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    local resourceIndex = extractNumberFromString(thisID, "end")
    local newMax = tonumber(vl)
    if newMax == nil then return end
    modifyResource(playerIndex, resourceIndex, nil, nil, newMax)
end

function resSingleAdd(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    local resourceIndex = extractNumberFromString(thisID, "end")
    -- Определяем направление: start == 1 -> левая кнопка (минус), иначе правая (плюс)
    local direction = (extractNumberFromString(thisID, "start") == 1) and -1 or 1
    local amount = (vl == "-1") and 1 or 5  -- маленькое или большое изменение
    local delta = direction * amount
    modifyResource(playerIndex, resourceIndex, delta)
end

-------------------------

function setNotes(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if string.sub(thisID, #thisID, #thisID) == "A" then
        main_Table[playerIndex].notes_A = vl
    else
        main_Table[playerIndex].notes_B = vl
    end
    main_Table[playerIndex].ui_update_flags.notes = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------

function setAssignedPlayer(pl, vl, thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), extractNumberFromString(thisID, "end")
    main_Table[playerIndex].aColors[numStrEnd] = not main_Table[playerIndex].aColors[numStrEnd]
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
    getObjectFromGUID(lastPickedCharGUID_table[playerIndex]).call("hideThisChar")
end

function toggleInvisible(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].charHidden = not main_Table[playerIndex].charHidden
    main_Table[playerIndex].ui_update_flags.team_bar = true
    singleColor_UI_update_optimized(playerIndex)
    getObjectFromGUID(lastPickedCharGUID_table[playerIndex]).call("hideThisChar")
end

-------------------------   initiative

function toggleInitEdit(pl, vl, thisID)
    if pl.color == "Black" then
        initEditPanelVisible = not initEditPanelVisible
        if initEditPanelVisible then
            UI_xmlElementUpdate("initEditPanel", "active", "True")
        else
            UI_xmlElementUpdate("initEditPanel", "active", "False")
        end
    end
end

function initSetupButt(pl, vl, thisID)
    local idInStr = extractNumberFromString(thisID, "end")
    if initEditPos == idInStr then
        if vl == "-1" then
            initEditPos = 0
            UI_xmlElementUpdate("initSetupPanel", "active", "False")
            UI_xmlElementUpdate("initSetupButton_"..strFromNum(idInStr), "tooltip", "setup")
        elseif vl == "-2" then
            table.remove(init_table, idInStr)
            if initTurnPos > idInStr then initTurnPos = initTurnPos - 1 end
            if idInStr > #init_table then initTurnPos = 1 end
            initEditPos = 0
            UI_xmlElementUpdate("initSetupPanel", "active", "False")
            initiative_UI_update()
        end
    elseif initEditPos ~= idInStr and idInStr <= #init_table then
        UI_xmlElementUpdate("initSetupButton_"..strFromNum(initEditPos), "tooltip", "setup")
        initEditPos = idInStr
        UI_xmlElementUpdate("initSetupPanel", "active", "True")
        UI_xmlElementUpdate("initSetupPanel", "offsetXY", "0 "..tostring(216 - 27 * initEditPos))
        UI_xmlElementUpdate("initSetupButton_"..strFromNum(idInStr), "tooltip", "Right click:\nremove from initiative!")

        UI_xmlElementUpdate("initSetupRezInput", "text", init_table[idInStr].rollRez)
        UI_xmlElementUpdate("initSetupNameInput", "text", init_table[idInStr].charName)
        UI_xmlElementUpdate("initSetupModInput", "text", init_table[idInStr].initMod)
        UI_xmlElementUpdate("initSetupColButton", "tooltip", PLAYER_COLOR[init_table[idInStr].aColor])
        
    elseif #init_table < 15 and idInStr == #init_table + 1 then
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

function addCharToInitiative(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if #init_table < 15 then
        alreadyInInitiative = false
        for i = 1, #init_table do
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

function initiative_UI_update()
    local updates = {}
    updates["initTitleText"] = { text = currentLang[47] }
    updates["initRoundCounter"] = { text = currentLang[48] .. initRound }
    for i = 1, 15 do
        if i <= #init_table then
            local entry = init_table[i]
            local prefix = strFromNum(i)
            local isCurrent = (i == initTurnPos)
            updates["initText_A_"..prefix] = {
                color = isCurrent and "#ffff00" or "#000000",
                outline = isCurrent and "#888800" or "#00000000",
                text = entry.rollRez
            }
            updates["initText_B_"..prefix] = { text = entry.charName }
            updates["initText_C_"..prefix] = { text = formatModifier(entry.initMod) }
            updates["initSetupButton_"..prefix] = {
                color = "#ffffff",
                text = "*",
                tooltip = "setup"
            }
            updates["initColor_"..prefix] = {
                color = PLAYER_COLOR_CODES[entry.aColor],
                outline = PLAYER_COLOR_CODES[entry.aColor]
            }
        else
            updates["initText_A_"..strFromNum(i)] = { text = "" }
            updates["initText_B_"..strFromNum(i)] = { text = "" }
            updates["initText_C_"..strFromNum(i)] = { text = "" }
            updates["initSetupButton_"..strFromNum(i)] = { color = "#ffffff00", text = "", tooltip = "" }
            updates["initColor_"..strFromNum(i)] = { color = "#00000000", outline = "#00000000" }
        end
    end
    if #init_table < 15 then
        local nextIndex = #init_table + 1
        updates["initSetupButton_"..strFromNum(nextIndex)] = {
            color = "#aaaaaa",
            text = "+",
            tooltip = "add char"
        }
    end
    if #init_table > 0 then
        local cur = init_table[initTurnPos]
        updates["initCol_01"] = {
            tooltip = cur.charName.."\n"..cur.rollRez.." ("..formatModifier(cur.initMod)..")",
            color = PLAYER_COLOR_CODES[cur.aColor]
        }
        updates["initImage_01"] = { color = "#ffffff" }
        local token = getObjectFromGUID(cur.tokenGUID)
        updates["initImage_01"].image = token and token.getTable("charSave_table").portraitUrl
            or (cur.portraitUrl and cur.portraitUrl)
            or "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
        local imgPos = initTurnPos
        for i = 2, 6 do
            imgPos = imgPos + 1
            if imgPos > #init_table then imgPos = 1 end
            local other = init_table[imgPos]
            updates["initCol_"..strFromNum(i)] = {
                tooltip = other.charName.."\n"..other.rollRez.." ("..formatModifier(other.initMod)..")",
                color = PLAYER_COLOR_CODES[other.aColor]
            }
            updates["initImage_"..strFromNum(i)] = { color = "#ffffff" }
            local tok = getObjectFromGUID(other.tokenGUID)
            updates["initImage_"..strFromNum(i)].image = tok and tok.getTable("charSave_table").portraitUrl
                or (other.portraitUrl and other.portraitUrl)
                or "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
        end
    else
        for i = 1, 6 do
            updates["initCol_"..strFromNum(i)] = { tooltip = "", color = "#aaaaaa" }
            updates["initImage_"..strFromNum(i)] = { color = "#aaaaaa00" }
        end
    end
    local passVis = (#init_table > 0) and (init_table[initTurnPos].aColor == 1 and "Black" or "Black|"..PLAYER_COLOR[init_table[initTurnPos].aColor]) or "Black"
    updates["initPassButton"] = { visibility = passVis }
    batchUIUpdate(updates)
end

function initMoveActive(pl, vl, thisID)
    if vl == "-2" then
        initTurnPos = initTurnPos + 1
        if initTurnPos > #init_table then initTurnPos = 1 initRound = initRound + 1 end
    elseif vl == "-1" then
        initTurnPos = initTurnPos - 1
        if initTurnPos < 1 then initTurnPos = #init_table initRound = initRound - 1 end
    end
    initiative_UI_update()
end

function initPass(pl, vl, thisID)
    initMoveActive(pl, "-2", thisID)
end

function initSetupRezInp(pl, vl, thisID)
    if tonumber(vl) ~= nil then
        init_table[initEditPos].rollRez = tonumber(vl)
        initiative_UI_update()
    end
end

function initSetupNameInp(pl, vl, thisID)
    init_table[initEditPos].charName = vl
    initiative_UI_update()
end

function initToggleColor(pl, vl, thisID)
    if vl == "-1" then
        init_table[initEditPos].aColor = init_table[initEditPos].aColor + 1
        if init_table[initEditPos].aColor > #main_Table then init_table[initEditPos].aColor = 1 end
    elseif vl == "-2" then
        init_table[initEditPos].aColor = init_table[initEditPos].aColor - 1
        if init_table[initEditPos].aColor < 1 then init_table[initEditPos].aColor = #main_Table end
    end
    UI_xmlElementUpdate("initSetupColButton", "tooltip", PLAYER_COLOR[init_table[initEditPos].aColor])
    initiative_UI_update()
end

function initSetupModInp(pl, vl, thisID)
    if tonumber(vl) ~= nil then
        init_table[initEditPos].initMod = tonumber(vl)
        initiative_UI_update()
    end
end

function initRollAll(pl, vl, thisID)
    math.randomseed(os.clock()*10000)
    for i = 1, #init_table do
        init_table[i].rollRez = math.random(1, 20) + init_table[i].initMod
    end
    initiative_UI_update()
end

function setInitCharPortrait(pl, vl)
    if vl ~= "" then
        init_table[initEditPos].portraitUrl = vl
    else
        init_table[initEditPos].portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
    end
    initiative_UI_update()
end

function initRollSingle()
    math.randomseed(os.clock()*10000)
    init_table[initEditPos].rollRez = math.random(1, 20) + init_table[initEditPos].initMod
    UI_xmlElementUpdate("initSetupRezInput", "text", init_table[initEditPos].rollRez)
    initiative_UI_update()
end

function initSortAll(pl, vl, thisID)
    if #init_table > 1 then
        table.sort(init_table, function (k1, k2)
            return k1.rollRez > k2.rollRez
        end)
        initiative_UI_update()
    end
end

function initRoundsReset(pl, vl, thisID)
    initRound = 1
    initiative_UI_update()
end
-------------------------   conditions

function contitionButt(pl, vl, thisID)
    local playerIndex, numStrEnd = nFromPlClr(pl.color), extractNumberFromString(thisID, "end")
    if numStrEnd ~= 18 then
        main_Table[playerIndex].conditions.table[numStrEnd] = not main_Table[playerIndex].conditions.table[numStrEnd]
    else
        if vl == "-1" then
            main_Table[playerIndex].conditions.exhaustion = main_Table[playerIndex].conditions.exhaustion + 1
            if main_Table[playerIndex].conditions.exhaustion > 5 then main_Table[playerIndex].conditions.exhaustion = 0 end
        elseif vl == "-2" then
            main_Table[playerIndex].conditions.exhaustion = main_Table[playerIndex].conditions.exhaustion - 1
            if main_Table[playerIndex].conditions.exhaustion < 0 then main_Table[playerIndex].conditions.exhaustion = 5 end
        end
        if main_Table[playerIndex].conditions.exhaustion ~= 0 then
            main_Table[playerIndex].conditions.table[numStrEnd] = true
        else
            main_Table[playerIndex].conditions.table[numStrEnd] = false
        end
    end
    main_Table[playerIndex].ui_update_flags.conditions = true
    singleColor_UI_update_optimized(playerIndex)
end

-------------------------   char 3d UI settings

function tokenGUI_slider(pl, vl, thisID)
    main_Table[extractNumberFromString(thisID, "start")].tokenGUI_settings[extractNumberFromString(thisID, "end")] = tonumber(vl)
    singleColor_UI_update(nFromPlClr(pl.color))
end

function tokenGUI_reset(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    main_Table[playerIndex].tokenGUI_settings = {0,0,0,0,5}
    singleColor_UI_update(playerIndex)
end

-------------------------   UI updates

function colorToggleEditMode(pl, vl, thisID)
    local idx = nFromPlClr(pl.color)
    local prefix = strFromNum(idx)

    if vl == "-1" then
        -- Переключение режима редактирования
        editModeVisibility[idx] = not editModeVisibility[idx]
        local visibilityStr = buildVisibilityString(editModeVisibility)
        local updates = {}

        -- Панели, которые показываются/скрываются при редактировании
        local elementsToUpdate = {
            "charPortraitNameInputsPanel", "charLvlEdit", "charACedit", "charSpeedEdit",
            "charProfBonusEdit", "assignedPlayersPanel", "charInitEdit", "charPassPercEdit",
            "charHPinputs", "atkEditPanel", "spellSlotsEditMaxButtons", "spellSlotMaxAllButton",
            "resoursesEditInputsPanel", "savesModsButtons"
        }
        for _, elem in ipairs(elementsToUpdate) do
            updates[elem] = { visibility = visibilityStr }
        end

        -- Специальные панели, видимые только для GM (Black)
        if editModeVisibility[1] then
            updates["charProfBonusEdit"] = { visibility = "Black" }
            updates["assignedPlayersPanel"] = { visibility = "Black" }
        end

        -- Кнопки редактирования атрибутов
        for i = 1, 6 do
            updates["charAttrEdit_" .. i] = { visibility = visibilityStr }
        end

        -- Кнопки редактирования навыков
        for i = 1, #main_Table[idx].skills do
            updates["charSkillEditButtons_" .. strFromNum(i)] = { visibility = visibilityStr }
        end

        -- Текст портрета
        updates[prefix .. "_charPortraitUrlInput"] = { text = main_Table[idx].portraitUrl }

        -- Подсветка кнопок атак в зависимости от выбранной атаки
        for i = 1, 10 do
            local color = (editModeSelectedAttack[idx] == i or not editModeVisibility[idx])
                        and "#ffffffff" or "#ffffff88"
            updates[prefix .. "_atkButtonImg_" .. strFromNum(i)] = { color = color }
        end

        -- Интерактивность полей заметок
        local flagVis = visibilityStr:find(pl.color) and "true" or "false"
        updates[prefix .. "_notesInput_A"] = { interactable = flagVis }
        updates[prefix .. "_notesInput_B"] = { interactable = flagVis }

        -- Применяем все обновления
        batchUIUpdate(updates)

        -- Если режим редактирования включён, обновляем панель редактирования атак
        if editModeVisibility[idx] then
            atkEdit_UI_update(idx, editModeSelectedAttack[idx])
        end

    elseif vl == "-2" and editModeVisibility[idx] and getObjectFromGUID(lastPickedCharGUID_table[idx]) then
        -- Обработка сброса персонажа (счётчик нажатий)
        if resetCounter < 4 then
            resetCounter = resetCounter + 1
            UI_xmlElementUpdate("charSheetUtilButton_08", "color", "#ff8888")
            if resetCounter == 1 then
                Wait.time(function()
                    resetCounter = 0
                    UI_xmlElementUpdate("charSheetUtilButton_08", "color", "#ffffff")
                end, 3)
            end
        else
            local token = getObjectFromGUID(lastPickedCharGUID_table[idx])
            if token then
                token.call("resetChar")
                GetStatsFromToken(idx, token)
                UI_xmlElementUpdate("charSheetUtilButton_08", "color", "#ffffff")
                resetGlobalLuaSave = false
                resetCounter = 0
            end
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
    if not visibilityArray then return end

    local playerIndex = nFromPlClr(pl.color)
    visibilityArray[playerIndex] = not visibilityArray[playerIndex]
    UI_xmlElementUpdate("panel_"..panel, "visibility", buildVisibilityString(visibilityArray))
    if extraAction then extraAction() end
end

-- Simplified toggle functions using the consolidated function
local tableShow = {"attacks", "resourses", "spellSlots", "notes", "conditions", "UIset", "lookChar"}
function colorToggleShow(pl, _, thisID)
    local panel, playerIndex = tableShow[extractNumberFromString(thisID, "end")], nFromPlClr(pl.color)
    if panel == "lookChar" then
        if lastPickedCharGUID_table[playerIndex] ~= "" and getObjectFromGUID(lastPickedCharGUID_table[playerIndex]) ~= nil then
            pl.lookAt({position = getObjectFromGUID(lastPickedCharGUID_table[playerIndex]).getPosition(), pitch = 65, yaw = 0, distance = 25})
        end
    else
        togglePanelVisibility(pl, panel)
    end
end

function colorToggleShowMain(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    togglePanelVisibility(pl, "main", function()
        if vl == "-2" then
            -- Show all panels when main is hidden
            panelVisibility_attacks[playerIndex] = not panelVisibility_main[playerIndex]
            panelVisibility_spellSlots[playerIndex] = not panelVisibility_main[playerIndex]
            panelVisibility_resourses[playerIndex] = not panelVisibility_main[playerIndex]
            panelVisibility_notes[playerIndex] = not panelVisibility_main[playerIndex]
            panelVisibility_conditions[playerIndex] = not panelVisibility_main[playerIndex]
            panelVisibility_UIset[playerIndex] = not panelVisibility_main[playerIndex]
            for i = 1, #tableShow - 1 do
                colorToggleShow(pl, nil, "charSheetUtilButton_0"..i)
            end
        end
    end)
end

function colorToggleShowMiniMap(pl, vl, thisID)
    togglePanelVisibility(pl, "miniMap", function()
        miniMap_UI_update()
    end)
end

function colorToggleShowInitiative(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    panelVisibility_init[playerIndex] = not panelVisibility_init[playerIndex]
    local editModeVisibilityStr = buildVisibilityString(panelVisibility_init)
    UI_xmlElementUpdate("init_panel", "visibility", editModeVisibilityStr)
end

function colorToggleProjector(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if playerIndex == 1 and vl == "-2" then
        panelVisibility_projector[playerIndex] = not panelVisibility_projector[playerIndex]
        if panelVisibility_projector[1] then
            panelVisibility_projector = {true,true,true,true,true,true,true,true,true,true,true}
            UI_xmlElementUpdate("projectorImage", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink")
        else
            panelVisibility_projector = {false,false,false,false,false,false,false,false,false,false,false}
            UI_xmlElementUpdate("projectorImage", "visibility", "noone")
        end
    else
        panelVisibility_projector[playerIndex] = not panelVisibility_projector[playerIndex]
        local editModeVisibilityStr = buildVisibilityString(panelVisibility_projector)
        UI_xmlElementUpdate("projectorImage", "visibility", editModeVisibilityStr)
    end
end

function colorToggleBigPortrait(pl, vl, thisID)
    local playerIndex = nFromPlClr(pl.color)
    if thisID == "bigPortraitBigClose" then
        panelVisibility_bigPortrait[playerIndex] = false
    elseif thisID == "bigPortraitSelf" or (string.sub(thisID, 1, 15) == "bigPortraitInit" and #init_table > 0) or string.sub(thisID, 4, #thisID) == "bigPortraitTeam" then
        panelVisibility_bigPortrait[playerIndex] = true
        if thisID == "bigPortraitSelf" then
            UI_xmlElementUpdate(strFromNum(playerIndex).."_bigPortraitImage","image",main_Table[playerIndex].portraitUrl)
        elseif string.sub(thisID, 1, 15) == "bigPortraitInit" and #init_table > 0 then
            local bigPortraitInitPos = initTurnPos
            for i=1,extractNumberFromString(thisID, "end")-1 do
                bigPortraitInitPos = bigPortraitInitPos + 1
                if bigPortraitInitPos > #init_table then bigPortraitInitPos = 1 end
            end
            if vl == "-1" then
                if thisID:find("Init") then
                    UI_xmlElementUpdate(strFromNum(playerIndex).."_bigPortraitImage","image",self.UI.getAttribute("initImage_"..thisID:match("^[^_]+_([^_]+)"), "image"))
                else
                    UI_xmlElementUpdate(strFromNum(playerIndex).."_bigPortraitImage","image",getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID).getTable("charSave_table").portraitUrl)
                end
            elseif vl == "-2" then
                panelVisibility_bigPortrait[playerIndex] = false
                if getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID) ~= nil then
                    Player[PLAYER_COLOR[playerIndex]].pingTable( getObjectFromGUID(init_table[bigPortraitInitPos].tokenGUID).getPosition() )
                end
            end
        elseif string.sub(thisID, 4, #thisID) == "bigPortraitTeam" then
            UI_xmlElementUpdate(strFromNum(playerIndex).."_bigPortraitImage","image",main_Table[extractNumberFromString(thisID, "start")].portraitUrl)
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

function atkEdit_UI_update(pl_N, atk_N)
    local char = main_Table[pl_N]
    local attack = char.attacks[atk_N]
    local prefix = strFromNum(pl_N)
    local lang = currentLang
    local updates = {}

    -- Основная информация
    updates[prefix.."_atkEditNameText"] = { text = " " .. atk_N .. ". " .. attack.atkName }
    updates[prefix.."_atkEditRollAtkButton"] = { textOutline = attack.atkRolled and "#8888ffff" or "#ffffff00" }

    if attack.atkAttr ~= 0 then
        updates[prefix.."_atkEditAtkAttrButton"] = { text = lang[attack.atkAttr + 7] }
    else
        updates[prefix.."_atkEditAtkAttrButton"] = { text = "" }
    end

    updates[prefix.."_atkEditProfButton"] = { textOutline = PROFICIENCY_COLORS[attack.proficient] }
    updates[prefix.."_atkEditMinCritText"] = { text = lang[41] .. attack.minCrit }
    updates[prefix.."_atkEditAtkModText"] = { text = lang[42] .. formatModifier(attack.atkMod) }

    updates[prefix.."_atkEditRollDmgButton"] = { textOutline = attack.dmgRolled and "#8888ffff" or "#ffffff00" }

    if attack.dmgAttr ~= 0 then
        updates[prefix.."_atkEditDmgAttrButton"] = { text = lang[attack.dmgAttr + 7] }
    else
        updates[prefix.."_atkEditDmgAttrButton"] = { text = "" }
    end

    if attack.resUsed ~= 0 then
        updates[prefix.."_atkEditResUsedButton"] = { text = attack.resUsed .. ". " .. char.resourses[attack.resUsed].resName }
    else
        updates[prefix.."_atkEditResUsedButton"] = { text = "" }
    end

    updates[prefix.."_atkEditDmgStrText"] = { text = lang[43] .. attack.dmgStr }
    updates[prefix.."_atkEditCritDmgStrText"] = { text = lang[44] .. attack.dmgStrCrit }
    updates[prefix.."_atkEditIconImg"] = { image = ATTACK_ICONS_URL[attack.icon] }

    -- Обновление кнопок атак (все 10)
    updateAttackIcons(pl_N, updates)

    -- Обновление сетки иконок (50 кнопок)
    local selectedIcon = attack.icon
    for ii = 1, 50 do
        local color = (selectedIcon == ii) and "#ffffff02" or "#ffffff44"
        updates[prefix.."_atkEditIconsGridButton_"..strFromNum(ii)] = { color = color }
    end

    batchUIUpdate(updates)

    -- Обновление токена, если он привязан
    local token = getObjectFromGUID(lastPickedCharGUID_table[pl_N])
    if token and not firstLoad then
        SetStatsIntoToken(pl_N)
    end
end

function colorToggleAtkIconsMenu(pl,_,thisID)
    local playerIndex = nFromPlClr(pl.color)
    panelVisibility_atkIconsMenu[playerIndex] = not panelVisibility_atkIconsMenu[playerIndex]
    local editModeVisibilityStr = buildVisibilityString(panelVisibility_atkIconsMenu)
    UI_xmlElementUpdate("atkIconsMenu", "visibility", editModeVisibilityStr)
end

function atkIconsMenuButton(pl, vl, thisID)
    local playerIndex, strEnd = nFromPlClr(pl.color), extractNumberFromString(thisID, "end")
    if strEnd <= #ATTACK_ICONS_URL then
        main_Table[playerIndex].attacks[editModeSelectedAttack[playerIndex]].icon = strEnd
        colorToggleAtkIconsMenu(pl,_,thisID)
        atkEdit_UI_update(playerIndex,editModeSelectedAttack[playerIndex])
    end
end

function colorToggleScreenRoller(pl,_,thisID)
    for i = 1, #main_Table do
        if pl.color == PLAYER_COLOR[i] then
            screenRollerVisibility[i] = not screenRollerVisibility[i]
        end
    end
    local screenRollerVisibilityStr = buildVisibilityString(screenRollerVisibility)
    UI_xmlElementUpdate("screenRollerBigPanel", "visibility", screenRollerVisibilityStr)
end

function mainSheet_UI_update()
    for i, name in ipairs(ATTRIBUTE_LIST) do
        UI_xmlElementUpdate("attrName_" .. name, "text", currentLang[7 + i])
    end
    for i = 1, 11 do
        singleColor_UI_update(i)
    end
    firstLoad = false
end

function fullUIUpdate(n)
    local playerData = main_Table[n]
    local updates = {}
    local prefix = strFromNum(n)
    local lang = currentLang
    -- 1. Базовые характеристики
    updates[prefix.."_charPortrait"] = { image = playerData.portraitUrl }
    updates[prefix.."_charPortraitUrlInput"] = { text = playerData.portraitUrl }
    updates[prefix.."_charName"] = { text = playerData.charName }
    updates[prefix.."_charLvl"] = { text = lang[2] .. playerData.charLvl }
    updates[prefix.."_charAC"] = { text = playerData.AC }
    updates[prefix.."_charSpeed"] = { text = playerData.speed }

    local initModStr = playerData.initMod ~= 0 and " (" .. PoM(playerData.initMod) .. playerData.initMod .. ")" or ""
    local locInitMod = modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.initMod + playerData.charProfBonus * (playerData.skills[19].proficient - 1)
    updates["charInitAddButton_"..prefix] = { text = lang[6] .. PoM(locInitMod) .. locInitMod .. initModStr }

    local pPerceptionBase = 10 + modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.charProfBonus * (playerData.skills[19].proficient - 1)
    local ppModStr = playerData.pPerceptionMod ~= 0 and " (" .. PoM(playerData.pPerceptionMod) .. playerData.pPerceptionMod .. ")" or ""
    updates[prefix.."_charPassivePerception"] = { text = lang[7] .. (playerData.pPerceptionMod + pPerceptionBase) .. ppModStr }

    updates[prefix.."_charHPbar"] = { percentage = playerData.hp * 100 / playerData.hpMax }
    updates[prefix.."_charHPtext"] = { text = playerData.hp .. " / " .. playerData.hpMax }
    updates[prefix.."_charTempHPtext"] = { text = playerData.hpTemp > 0 and "+" .. playerData.hpTemp or "" }

    if n == 1 then
        updates["charHPsetVisibilityButton"] = { text = playerData.hpVisibleToPlayers and "<O>" or "GM" }
    end
    -- 2. Спасброски и атрибуты
    for _, name in ipairs(ATTRIBUTE_LIST) do
        updates[prefix.."_charAttrValue_"..name] = { text = playerData.attributes[name] }
        updates[prefix.."_charAttrMod_"..name] = { text = PoM(modFromAttr(playerData.attributes[name])) .. modFromAttr(playerData.attributes[name]) }
    end

    local typeST = 1
    for smN, smV in pairs(playerData.savesMod) do
        local index = playerData.saves[smN]
        local color = PROFICIENCY_COLORS[index]
        local tooltip = lang[61 + typeST] .. " " .. lang[77 + index]
        typeST = typeST + 1
        local saveModStr = smV ~= 0 and "\n" .. PoM(smV) .. smV or ""
        updates[prefix.."_charSaveButton_"..smN] = {
            tooltip = tooltip,
            text = lang[14] .. saveModStr,
            color = color
        }
    end
    -- 3. Навыки
    for ii = 1, #playerData.skills do
        local idx = playerData.skills[ii].proficient
        local color = PROFICIENCY_COLORS[idx]
        local modStr = playerData.skills[ii].mod ~= 0 and " " .. PoM(playerData.skills[ii].mod) .. playerData.skills[ii].mod or ""
        updates[prefix.."_charSkillButton_"..strFromNum(ii)] = {
            text = lang[14 + ii] .. modStr,
            color = color
        }
        local profBonus = playerData.charProfBonus * (idx - 1)
        local totalMod = modFromAttr(playerData.attributes[SKILL_ATTRIBUTES[ii]]) + playerData.skills[ii].mod + profBonus
        updates[prefix.."_charSkillButton_"..strFromNum(ii)].tooltip = "d20" .. PoM(totalMod) .. totalMod .. " " .. lang[77 + idx]
    end
    -- 4. Атаки
    updateAttackIcons(n, updates)
    -- 5. Слоты заклинаний
    for ii = 1, 9 do
        local slotsStr = ""
        for iii = 1, playerData.splSlotsMax[ii] do
            slotsStr = slotsStr .. (iii <= playerData.splSlots[ii] and "●" or "○")
        end
        updates[prefix.."_spellSlotButton_"..strFromNum(ii)] = { text = " " .. ii .. ". " .. slotsStr }
    end
    -- 6. Ресурсы
    for ii = 1, 10 do
        updates[prefix.."_resTextName_"..strFromNum(ii)] = { text = " " .. ii .. ". " .. playerData.resourses[ii].resName }
        if playerData.resourses[ii].resMax > 0 then
            updates[prefix.."_resTextNum_"..strFromNum(ii)] = { text = playerData.resourses[ii].resValue .. " / " .. playerData.resourses[ii].resMax }
        else
            updates[prefix.."_resTextNum_"..strFromNum(ii)] = { text = playerData.resourses[ii].resValue }
        end
    end
    -- 7. Заметки
    updates[prefix.."_notesText_B"] = { text = playerData.notes_B }
    updates[prefix.."_notesInput_B"] = { text = playerData.notes_B }
    -- 8. Назначенные игроки (только для GM)
    if n == 1 then
        for ii = 2, 11 do
            updates["assighedPlayerButton_"..strFromNum(ii)] = { text = playerData.aColors[ii] and "●" or "" }
        end
    end
    -- 9. Состояния
    for ii = 1, 20 do
        local color = playerData.conditions.table[ii] and "#ffffff02" or "#ffffff88"
        updates[prefix.."_conditionButton_"..strFromNum(ii)] = { color = color }
    end

    for ii = 1, 5 do
        local conditionTable = {}
        for iii = 1, 11 do
            conditionTable[iii] = (main_Table[iii].conditions.exhaustion == ii)
        end
        updates["exhaustionIcon_"..strFromNum(ii)] = { visibility = buildVisibilityString(conditionTable) }
    end
    -- 10. Настройки UI для токена
    for ii = 1, 5 do
        updates[prefix.."_UIsetSlider_"..strFromNum(ii)] = { value = playerData.tokenGUI_settings[ii] }
    end

    updates["setInvisButton"] = { color = playerData.charHidden and "#000022" or "#cccccc" }
    -- Применяем все обновления одним пакетом
    batchUIUpdate(updates)
    -- Дополнительное обновление team bar (требует отдельной логики, так как влияет на всех)
    teamBar_UI_update()
end

-- Переработанная функция singleColor_UI_update, использующая полное пакетное обновление
function singleColor_UI_update(n)
    local tokenGUID = lastPickedCharGUID_table[n]
    local token = tokenGUID ~= "" and getObjectFromGUID(tokenGUID) or nil
    local needTokenUpdate = (token ~= nil and not firstLoad)

    fullUIUpdate(n)

    -- Обновление токена, если он привязан
    if needTokenUpdate then
        SetStatsIntoToken(n)
    end

    -- Синхронизация с другими персонажами, имеющими тот же GUID
    if tokenGUID and tokenGUID ~= "" then
        for i = 1, #main_Table do
            if i ~= n and lastPickedCharGUID_table[i] == tokenGUID then
                local otherToken = getObjectFromGUID(tokenGUID)
                if otherToken then
                    GetStatsFromToken(i, otherToken)
                end
            end
        end
    end
end

function onPlayerChangeColor(player_color)
    Wait.time(function()
        teamBar_UI_update()
    end, 0.2)
end

function teamBar_UI_update()
    local updates = {}
    local activeCount = 0
    for i = 2, 11 do
        local playerData = main_Table[i]
        local token = getObjectFromGUID(lastPickedCharGUID_table[i])
        local isActive = Player[PLAYER_COLOR[i]].seated and token and not playerData.charHidden
        if isActive then
            activeCount = activeCount + 1
            updates[strFromNum(i).."_teamBarSegment"] = { active = "True" }
            updates[strFromNum(i).."_teamBarColor"] = { color = PLAYER_COLOR_CODES[i] }
            updates[strFromNum(i).."_teamBarImage"] = { image = playerData.portraitUrl }
            -- tooltip строится один раз
            local pPerceptionBase = 10 + modFromAttr(playerData.attributes["WIS"]) + playerData.skills[19].mod + playerData.charProfBonus*(playerData.skills[19].proficient - 1)
            local ppModStr = playerData.pPerceptionMod ~= 0 and " ("..PoM(playerData.pPerceptionMod)..playerData.pPerceptionMod..")" or ""
            local attrMod = {
                STR = modFromAttr(playerData.attributes["STR"]),
                DEX = modFromAttr(playerData.attributes["DEX"]),
                CON = modFromAttr(playerData.attributes["CON"]),
                INT = modFromAttr(playerData.attributes["INT"]),
                WIS = modFromAttr(playerData.attributes["WIS"]),
                CHA = modFromAttr(playerData.attributes["CHA"])
            }
            local tooltip = string.format("%s\n%s%d  %s%d  %s%d\n%s%d%s\n%s %s(%s)   %s %s(%s)   \n%s %s(%s)   %s %s(%s)   \n%s %s(%s)   %s %s(%s)   ",
                playerData.charName,
                currentLang[2], playerData.charLvl, currentLang[3], playerData.AC, currentLang[4], playerData.speed,
                currentLang[7], playerData.pPerceptionMod + pPerceptionBase, ppModStr,
                currentLang[8], playerData.attributes["STR"], formatModifier(attrMod.STR),
                currentLang[9], playerData.attributes["DEX"], formatModifier(attrMod.DEX),
                currentLang[10], playerData.attributes["CON"], formatModifier(attrMod.CON),
                currentLang[11], playerData.attributes["INT"], formatModifier(attrMod.INT),
                currentLang[12], playerData.attributes["WIS"], formatModifier(attrMod.WIS),
                currentLang[13], playerData.attributes["CHA"], formatModifier(attrMod.CHA)
            )
            updates[strFromNum(i).."_bigPortraitTeam"] = { tooltip = tooltip }

            local hpPercent = math.floor(playerData.hp / playerData.hpMax * 100)
            updates[strFromNum(i).."_teamBarHP"] = { percentage = hpPercent }

            if playerData.hp > 0 then
                updates[strFromNum(i).."_teamBarHPsaves"] = { text = playerData.hp.." / "..playerData.hpMax }
            else
                local savesStr = ""
                for s = 1, 5 do savesStr = savesStr .. DEATH_SAVE_SYMBOLS_TEAM_BAR[playerData.deathSaves[s]] end
                updates[strFromNum(i).."_teamBarHPsaves"] = { text = savesStr }
            end
        else
            updates[strFromNum(i).."_teamBarSegment"] = { active = "False" }
        end
    end
    batchUIUpdate(updates)
    UI_xmlElementUpdate("teamBarPanel", "active", activeCount > 0 and "True" or "False")
    UI_xmlElementUpdate("teamBarPanel", "width", 60 * activeCount)
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

function set_UI_Language(pl, vl, thisID)
    local countLang = 0
    for _,_ in pairs(lang_table) do countLang = countLang + 1 end
    if vl == "-1" then
        lang_set = lang_set + 1
        if lang_set > countLang then lang_set = 1 end
    elseif vl == "-2" then
        lang_set = lang_set - 1
        if lang_set < 1 then lang_set = countLang end
    end
    currentLang = lang_table[LANGUAGES[lang_set]]
    mainSheet_UI_update()
    initiative_UI_update()
    language_UI_update()
end

function language_UI_update()
    local updates = {}
    local lang = currentLang

    updates["noCharSelectedBlockText"] = { text = lang[1] }
    for i = 1, #main_Table do
        updates[strFromNum(i) .. "_charPortraitUrlInput"] = { tooltip = lang[49] }
    end

    updates["charNameInput"] = { tooltip = lang[50] }
    updates["charHPsetInput_01"] = { tooltip = lang[51] }
    updates["charHPsetInput_02"] = { tooltip = lang[52] }
    updates["charHPsetVisibilityButton"] = { tooltip = lang[53] }

    updates["charHP_dmgButton"] = { text = lang[54], tooltip = lang[55] }
    for i = 1, #main_Table do
        updates[strFromNum(i) .. "_charHealDmgValueInput"] = { tooltip = lang[56] }
    end
    updates["charHP_healButton"] = { text = lang[57], tooltip = lang[58] }
    updates["charHP_tempButton"] = { text = lang[59], tooltip = lang[60] }
    -- Death saves
    for i = 1, 11 do
        for ii = 1, 5 do
            updates[strFromNum(i) .. "_charDeathSaveButton_" .. strFromNum(ii)] = { tooltip = lang[61] }
        end
    end
    -- Attribute modifiers tooltips
    for i = 1, 11 do
        for ii = 1, 6 do
            updates[strFromNum(i) .. "_charAttrMod_" .. strFromNum(ii)] = { tooltip = lang[33 + ii] }
        end
    end
    -- Skill edit buttons (E, M, L)
    for i = 1, 18 do
        updates["charSkillButtonE_" .. strFromNum(i)] = { tooltip = lang[65], text = lang[33] }
        updates["charSkillButtonM_" .. strFromNum(i)] = { tooltip = lang[79], text = lang[78] }
        updates["charSkillButtonL_" .. strFromNum(i)] = { tooltip = lang[81], text = lang[80] }
    end
    -- Utility buttons
    for i = 1, 8 do
        updates["charSheetUtilButton_" .. strFromNum(i)] = { text = lang[65 + i] }
    end
    updates["charSheetUtilButton_06"] = { tooltip = lang[74] }
    updates["charSheetUtilButton_07"] = { tooltip = lang[75] }
    updates["charSheetUtilButton_08"] = { tooltip = lang[76] }
    updates["charSheetUtilButton_09"] = { tooltip = lang[77] }
    -- Assigned players
    for i = 2, 11 do
        updates["assighedPlayerButton_" .. strFromNum(i)] = { tooltip = lang[85] }
    end
    -- Initiative add buttons
    for i = 1, #main_Table do
        updates["charInitAddButton_" .. strFromNum(i)] = { tooltip = lang[86] }
    end

    updates["initPassButton"] = { text = lang[84] }
    -- Attack edit panel tooltips
    updates["atkEditIconSetButton"] = { tooltip = lang[87] }
    for i = 1, #main_Table do
        updates[strFromNum(i) .. "_atkEditRollAtkButton"] = { tooltip = lang[88] }
        updates[strFromNum(i) .. "_atkEditAtkAttrButton"] = { tooltip = lang[89] }
        updates[strFromNum(i) .. "_atkEditProfButton"] = { tooltip = lang[90] }
        updates[strFromNum(i) .. "_atkEditRollDmgButton"] = { tooltip = lang[91] }
        updates[strFromNum(i) .. "_atkEditDmgAttrButton"] = { tooltip = lang[92] }
        updates[strFromNum(i) .. "_atkEditResUsedButton"] = { tooltip = lang[93] }
    end

    -- Spell slots
    for i = 1, #main_Table do
        for ii = 1, 9 do
            updates[strFromNum(i) .. "_spellSlotButton_" .. strFromNum(ii)] = { tooltip = lang[94] }
        end
        updates["spellSlotButtonMax_" .. strFromNum(i)] = { tooltip = lang[94] }
    end
    updates["notesPanelTitle"] = { text = lang[95] }

    -- Conditions
    for i = 1, #main_Table do
        for ii = 1, 20 do
            updates[strFromNum(i) .. "_conditionButton_" .. strFromNum(ii)] = { tooltip = lang[96 + ii] }
        end
    end

    -- UI settings
    updates["UIset_text_01"] = { text = lang[117] }
    updates["UIset_text_02"] = { text = lang[118] }

    -- Mode panels
    updates["addCharModeText"] = { text = lang[120] }

    -- GM tools
    updates["GM_toolsButton_01"] = { tooltip = lang[120] }
    updates["GM_toolsButton_03"] = { tooltip = lang[122] }
    updates["GM_toolsButton_05"] = { tooltip = lang[124] }
    updates["GM_toolsButton_06"] = { tooltip = lang[125] }
    updates["GM_toolsButton_07"] = { tooltip = lang[126] }

    updates["projectorToggleButton"] = { tooltip = lang[127] }
    updates["screenRollerMinimizer"] = { tooltip = lang[128] }

    updates["setInvisButton"] = { text = lang[129], tooltip = lang[130] }
    updates["copyCharModeText"] = { text = lang[131] }
    updates["GM_toolsButton_08"] = { tooltip = lang[132] }
    updates["GM_toolsButton_09"] = { tooltip = lang[133] }

    batchUIUpdate(updates)
end

function toggleCharBaseSpin()
    charBaseSpin = not charBaseSpin
    GM_settingsPanel_UI_update()
end

function toggleAddCharMode(pl, vl, thisID)
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

function toggleCopyCharMode(pl, vl, thisID)
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

function makeMeGM(pl, vl, thisID)
    if vl == "-2" then
        pl.changeColor("Black")
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

                unitColor = PLAYER_COLOR_CODES[1]
                for ii=2,11 do
                    if all_chars[i].getTable("charSave_table").aColors[ii] then
                        unitColor = PLAYER_COLOR_CODES[ii]
                    end
                end
                UI_xmlElementUpdate("miniMap_text_"..strFromNum(i), "color", unitColor)

                UI_xmlElementUpdate("miniMap_unit_"..strFromNum(i), "tooltip", all_chars[i].getName())

                showToStr = "Black"
                for ii=2,11 do
                    if all_chars[i].getTable("charSave_table").aColors[ii] then
                        addColStr = PLAYER_COLOR[ii]
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

function set_miniMap_unit(pl, vl, thisID)
    defineMiniMapUnit(vl)
end

function defineMiniMapUnit(inpStr)
    for i=1,99 do
        UI_xmlElementUpdate("miniMap_text_"..strFromNum(i), "text", inpStr) -- ▲ ♠
    end
end

local tableMiniMapChanger = {
    {["-2"] = 1, ["-1"] = 2},
    {["-2"] = 1, ["-1"] = 5},
    {["-2"] = -1, ["-1"] = -2},
    {["-2"] = -1, ["-1"] = -5},
    {["-2"] = -1, ["-1"] = -5},
    {["-2"] = 1, ["-1"] = 5}
}
function minimapControl(pl, vl, thisID)
    local numStrEnd = extractNumberFromString(thisID, "end")
    if numStrEnd == 1 or numStrEnd == 3 then
        miniMap_zoom = miniMap_zoom + tableMiniMapChanger[numStrEnd][vl]
    elseif numStrEnd == 2 or numStrEnd == 5 then
        miniMap_offset[2] = miniMap_offset[2] + tableMiniMapChanger[numStrEnd][vl]
    elseif numStrEnd == 4 or numStrEnd == 6 then
        miniMap_offset[1] = miniMap_offset[1] + tableMiniMapChanger[numStrEnd][vl]
    end
    miniMap_UI_update()
end

function miniMap_pingBorder(pl, vl, thisID)
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

function extractNumberFromString(inpStr, position)
    if not inpStr or #inpStr < 2 then return 0 end
    if position == "start" then
        return tonumber(string.match(inpStr, "^%d%d?")) or 0
    elseif position == "end" then
        return tonumber(string.match(inpStr, "%d%d?$")) or 0
    end
    return 0
end

function strFromNum(inpNum)
    if inpNum < 10 then
        return "0"..tostring(inpNum)
    else
        return tostring(inpNum)
    end
end

function screenRoller(pl, vl, thisID)
    if vl == "-1" then
        stringRoller(string.sub(thisID,6,#thisID),pl,"",1,false)
    elseif vl == "-2" then
        doubleRoll = 2
        stringRoller(string.sub(thisID,6,#thisID),pl,"",2,false)
        stringRoller(string.sub(thisID,6,#thisID),pl,"",4,false)
    end
end

function setScreenRollerStrings(pl, vl, thisID)
    for i = 1, #main_Table do
        if pl.color == PLAYER_COLOR[i] then
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