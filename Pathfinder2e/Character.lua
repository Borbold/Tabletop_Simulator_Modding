-- =================================================================
-- КОНФИГУРАЦИОННЫЙ МОДУЛЬ
-- =================================================================
local CONFIG = {
    -- Цвета игроков
    PLAYER_COLORS = {
        HEX = {"#3f3f3f", "#ffffff", "#703a16", "#da1917", "#f3631c", "#e6e42b", "#30b22a", "#20b09a", "#1e87ff", "#9f1fef", "#f46fcd"},
        NAMES = {"Black", "White", "Brown", "Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Purple", "Pink"}
    },
    
    -- Настройки по умолчанию для нового персонажа
    DEFAULT_CHARACTER = {
        PORTRAIT_URL = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/",
        HP = 1,
        HP_MAX = 1,
        LVL = 1,
        AC = 10,
        SPEED = 30,
        PROF_BONUS = 2,
        ATTRIBUTES = {STR = 10, DEX = 10, CON = 10, INT = 10, WIS = 10, CHA = 10},
        SKILLS_COUNT = 19,
        ATTACKS_COUNT = 10,
        RESOURCES_COUNT = 10,
        CONDITIONS_COUNT = 20,
        EXHAUSTION_LEVELS = 5,
        DEATH_SAVES_COUNT = 5,
        UI_SETTINGS = {0, 0, 0, 0, 5}
    },

    -- Настройки UI
    UI = {
        HP_BAR_SEGMENTS = 20,
        HP_BAR_COLORS = {
            FILLED = "#aa2222",
            EMPTY = "#662222",
            TEMP_HP_OUTLINE = "#ffaa0022",
            NO_TEMP_HP_OUTLINE = "#66004400"
        }
    }
}

-- =================================================================
-- ОСНОВНЫЕ ФУНКЦИИ ЖИЗНЕННОГО ЦИКЛА
-- =================================================================

-- Сохранение данных персонажа
local function updateSave()
    local data_to_save = {
        charSave_table = self.getTable("charSave_table"),
        Selected = self.getVar("Selected")
    }
    self.script_state = JSON.encode(data_to_save)
end

-- Загрузка данных персонажа
function onLoad(saved_data)
    self.setVar("SCRIPTED_PF2E_CHARACTER", true)
    
    local charData
    if saved_data and saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        charData = loaded_data.charSave_table
        self.setVar("Selected", loaded_data.Selected or 0)
    end
    -- Устанавливаем имя объекта как имя персонажа для новых
    if not charData.charName or charData.charName == "" then
        charData.charName = self.getName()
    end

    self.setTable("charSave_table", charData)
    -- Устанавливаем XML и обновляем состояние
    self.UI.setXml(charXml())
    hideThisChar()
end

-- =================================================================
-- ОСНОВНЫЕ ФУНКЦИИ УПРАВЛЕНИЯ ИНТЕРФЕЙСОМ (UI)
-- =================================================================

-- Пакетное обновление UI для повышения производительности
local function batchUIUpdate(updateTable)
    if not updateTable or not next(updateTable) then return end
    for id, attributes in pairs(updateTable) do
        for attr, value in pairs(attributes) do
            self.UI.setAttribute(id, attr, value)
        end
    end
end

-- Формирует строку видимости для игроков на основе данных персонажа
local function buildVisibilityString(charData)
    local visibleToStr = "Black"
    for i = 2, #CONFIG.PLAYER_COLORS.NAMES do
        if charData.aColors[i] then
            visibleToStr = visibleToStr .. "|" .. CONFIG.PLAYER_COLORS.NAMES[i]
        end
    end
    return visibleToStr
end

-- Главная функция обновления UI
function UI_update()
    local charData = self.getTable("charSave_table")
    if not charData or not charData.tokenGUI_settings then return end
    
    local allUpdates = {}
    local settings = charData.tokenGUI_settings
    local scale = 1.1 ^ (settings[5] - 6)
    -- 1. Обновление базового UI (позиция, масштаб, портрет)
    allUpdates["tokenUIbase"] = {
        position = string.format("%s,%s,%s", settings[3] * 10, settings[1] * 10, settings[2] * -10),
        rotation = "0,0," .. (settings[4] * 15 + 90),
        scale = string.format("%s,%s,%s", scale, scale, scale)
    }
    allUpdates["bigPortrait"] = { image = charData.portraitUrl }
    -- 2. Обновление видимости элементов
    local visibleToStr = buildVisibilityString(charData)
    local allColorsStr = table.concat(CONFIG.PLAYER_COLORS.NAMES, "|") .. "|Grey"

    if charData.charHidden then
        allUpdates["conditionsPanel"] = { visibility = visibleToStr }
        allUpdates["selectedMarker"] = { visibility = visibleToStr }
        allUpdates["hpBar"] = { visibility = visibleToStr }
        allUpdates["hiddenMarker"] = { active = "True", visibility = visibleToStr }
    else
        allUpdates["conditionsPanel"] = { visibility = allColorsStr }
        allUpdates["selectedMarker"] = { visibility = allColorsStr }
        allUpdates["hpBar"] = { visibility = charData.hpVisibleToPlayers and allColorsStr or visibleToStr }
        allUpdates["hiddenMarker"] = { active = "False" }
    end
    -- 3. Обновление полоски здоровья
    local hpSegments = math.floor(charData.hp / charData.hpMax * CONFIG.UI.HP_BAR_SEGMENTS)
    local hpColors = CONFIG.UI.HP_BAR_COLORS
    for i = 1, CONFIG.UI.HP_BAR_SEGMENTS do
        local id = "hpBarText_" .. string.format("%02d", i)
        local isFilled = (i <= hpSegments or (i == 1 and charData.hp > 0))
        
        allUpdates[id] = {
            color = isFilled and hpColors.FILLED or hpColors.EMPTY,
            outline = (charData.hpTemp > 0 and i > 1 and i < CONFIG.UI.HP_BAR_SEGMENTS) and hpColors.TEMP_HP_OUTLINE or hpColors.NO_TEMP_HP_OUTLINE
        }
    end
    -- 4. Обновление маркера выделения
    local selectedPlayerIndex = self.getVar("Selected")
    if selectedPlayerIndex ~= 0 then
        local selectedColorHex = CONFIG.PLAYER_COLORS.HEX[selectedPlayerIndex] .. "ff"
        allUpdates["selectedMarker"]["active"] = "True"
        allUpdates["selectedMarker_00"] = { color = selectedColorHex }
        allUpdates["selectedMarker_10"] = { color = selectedColorHex }
        for i = 1, 4 do
            allUpdates["selectedMarker_" .. string.format("%02d", i)] = { outline = selectedColorHex }
        end
    else
        allUpdates["selectedMarker"]["active"] = "False"
    end
    -- 5. Обновление иконок состояний (conditions)
    for i = 1, CONFIG.DEFAULT_CHARACTER.CONDITIONS_COUNT do
        allUpdates["conditionPanel_" .. string.format("%02d", i)] = {
            active = charData.conditions.table[i] and "True" or "False"
        }
    end
    -- 6. Обновление уровней истощения (Exhaustion)
    if charData.conditions.table[18] then
        for i = 1, CONFIG.DEFAULT_CHARACTER.EXHAUSTION_LEVELS do
            allUpdates["exhaustion_" .. string.format("%02d", i)] = {
                active = (i == charData.conditions.exhaustion) and "True" or "False"
            }
        end
    end
    -- Применяем все обновления одним вызовом
    batchUIUpdate(allUpdates)
    -- Сохраняем изменения
    updateSave()
end

-- Функция для скрытия/отображения персонажа от определенных игроков
function hideThisChar()
    local charData = self.getTable("charSave_table")
    if not charData then return end

    if charData.charHidden then
        local hideFromTable = {"Grey"}
        for i = 2, #CONFIG.PLAYER_COLORS.NAMES do
            if not charData.aColors[i] then
                table.insert(hideFromTable, CONFIG.PLAYER_COLORS.NAMES[i])
            end
        end
        self.setInvisibleTo(hideFromTable)
    else
        self.setInvisibleTo({})
    end
end

-- Сброс персонажа к состоянию по умолчанию
function resetChar()
    local newCharData = Global.call("createNewCharacterData")
    newCharData.charName = self.getName() -- Сохраняем имя объекта
    self.setTable("charSave_table", newCharData)
    UI_update()
end

function charXml()
    return [[<Defaults>
        <Text  class="HP_text" color="#aa2222" fontSize="60" fontStyle="bold" text="●" /> <!-- ● ◉ -->
        <Text  class="tokenUIbaseText" color="#ffffffee" shadow="#22222288" />
        <Image class="conditionImage" height="15" width="15" position="0,-40,0" />
        <Text  class="hiddenMarkerText" text="%" fontSize="150" color="#00000044" outline="#aaaaff22" outlineSize="2 -2" />
    </Defaults>
    <Panel id="tokenUIbase">
        <Panel id="selectedMarker" position="0,0,-2" active="false">
            <Text  id="selectedMarker_10" color="#aaaaaa88" fontSize="100" fontStyle="bold" text="►" position="50,0,0" outline="#00000066" outlineSize="2 -2" scale="0.5,1.2,0.5" />
            <Text  id="selectedMarker_00" color="#aaaaaa88" fontSize="255" fontStyle="bold" text="●" position="0,17,0" outline="#00000066" outlineSize="2 -2"  />
            <Panel id="selectedMarkerStar">
                <Panel id="selectedMarker_01" height="75" width="75" rotation="0,0,0"  color="#00000044" />
                <Panel id="selectedMarker_02" height="75" width="75" rotation="0,0,22" color="#00000044" />
                <Panel id="selectedMarker_03" height="75" width="75" rotation="0,0,45" color="#00000044" />
                <Panel id="selectedMarker_04" height="75" width="75" rotation="0,0,67" color="#00000044" />
            </Panel>
        </Panel>

        <Panel id="hiddenMarker" position="0,0,-200" active="false" visibility="Black">
            <Text class="hiddenMarkerText" rotation="0,0,0"   />
            <Text class="hiddenMarkerText" rotation="0,0,30"  />
            <Text class="hiddenMarkerText" rotation="0,0,60"  />
            <Text class="hiddenMarkerText" rotation="0,0,90"  />
            <Text class="hiddenMarkerText" rotation="0,0,120" />
            <Text class="hiddenMarkerText" rotation="0,0,150" />
            <Text class="hiddenMarkerText" rotation="0,0,180" />
            <Text class="hiddenMarkerText" rotation="0,0,210" />
            <Text class="hiddenMarkerText" rotation="0,0,240" />
            <Text class="hiddenMarkerText" rotation="0,0,270" />
            <Text class="hiddenMarkerText" rotation="0,0,300" />
            <Text class="hiddenMarkerText" rotation="0,0,330" />
        </Panel>

        <!-- CONDITIONS -->
        <Panel id="conditionsPanel" position="0,0,-200">
            <!-- Full defence -->
            <Panel id="conditionPanel_19" position="0,0,50" rotation="0,0,0" active="false">
                <Image height="100" width="100" position="0,-50,80" rotation="-90,0,0"  color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />
                <Image height="100" width="100" position="-50,0,80" rotation="0,90,-90" color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />
                <Image height="100" width="100" position="0,50,80"  rotation="90,0,180" color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />
                <Image height="100" width="100" position="50,0,80"  rotation="0,-90,90" color="#ffffaa11" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008324/82D432C326C7749716C07567767B2A611EF6E0D1/" />
            </Panel>
            <!-- 1 Blinded -->
            <Panel id="conditionPanel_01" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576007925/FD162AF9F20B5FC262E93DF6C1693C3126450D47/" color="#aaaaaa" />
            </Panel>
            <!-- 2 Deafened -->
            <Panel id="conditionPanel_02" rotation="0,0,20" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008053/895C077850ABF6BF61FF5F86604754C55B9AB111/" color="#aaaaff" />
            </Panel>
            <!-- 3 Charmed -->
            <Panel id="conditionPanel_03" rotation="0,0,40" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008145/7F0A26F423A2E24F6171A93426C8F5362B181233/" color="#ff6688" />
            </Panel>
            <!-- 4 Frightened -->
            <Panel id="conditionPanel_04" rotation="0,0,60" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008239/38C9B0F582DC7B2B8A506872232342A9702B04FD/" color="#ffaa00" />
            </Panel>
            <!-- 5 Grappled -->
            <Panel id="conditionPanel_05" rotation="0,0,80" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008385/9ED4DBE5351637586D884F027CD2A169D1508D64/" color="#ffeeaa" />
            </Panel>
            <!-- 6 Incapacitated -->
            <Panel id="conditionPanel_06" rotation="0,0,100" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008472/C82A22313B9834A38F0C0DC74BEC55A0E99834C9/" color="#aaaaaa" />
            </Panel>
            <!-- 7 Invisible -->
            <Panel id="conditionPanel_07" rotation="0,0,120" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302577186503/9BE934856BF13B84EC27C9ADE1C88E21124D90B4/" color="#aaaaff" />
            </Panel>
            <!-- 8 Paralyzed -->
            <Panel id="conditionPanel_08" rotation="0,0,140" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302577381345/E9DA460888E39C0E08A6A74EDC0B1883D28CC62C/" color="#ffff22" />
            </Panel>
            <!-- 9 Petrified -->
            <Panel id="conditionPanel_09" rotation="0,0,160" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008757/BD92573701A4B9B10C2832C410475801A76BE07E/" color="#888844" />
            </Panel>
            <!-- 10 Poisined -->
            <Panel id="conditionPanel_10" rotation="0,0,180" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008825/85756ADCD052206C9148CCB9F4CC2FCC407A78E6/" color="#00aa00" />
            </Panel>
            <!-- 11 Prone -->
            <Panel id="conditionPanel_11" rotation="0,0,200" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008908/758FDA5A09A4E6DD7684AFB8D72EAA870BDC6886/" color="#aaaa88" />
            </Panel>
            <!-- 12 Restrained -->
            <Panel id="conditionPanel_12" rotation="0,0,220" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576008992/08B81309BD1B76E6B8171AB81C6AA56FF018A79B/" color="#ffffff" />
            </Panel>
            <!-- 13 Stunned -->
            <Panel id="conditionPanel_13" rotation="0,0,240" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009081/A99C7542A7C400CB1623230998200C7D007FE12B/" color="#aaaaaa" />
            </Panel>
            <!-- 14 Unconscious -->
            <Panel id="conditionPanel_14" rotation="0,0,260" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009190/382367D19631C1184EF694A02A085822FDF62D57/" color="#8888ff" />
            </Panel>
            <!-- 15 Bleeding -->
            <Panel id="conditionPanel_15" rotation="0,0,280" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009283/B379F846DD62FFD4150D0BB341E23E58401C49BE/" color="#ff2222" />
            </Panel>
            <!-- 16 Burning -->
            <Panel id="conditionPanel_16" rotation="0,0,300" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009377/7B4E5357B62E8B35C6FCB48ECA598BF8EAD18A2F/" color="#ffeeaa" />
            </Panel>
            <!-- 17 Buffed -->
            <Panel id="conditionPanel_17" rotation="0,0,320" active="false">
                <Image class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009459/B96ECF9A46A96417B131F735940BDBF63034BE5D/" color="#aaaaff" />
            </Panel>
            <!-- 18 Exhaustion -->
            <Panel id="conditionPanel_18" rotation="0,0,340" active="false">
                <Image id="exhaustion_01" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009685/17E9E7B0A16B5A6140630EF6FF9F4DEEA7AAB8FE/" color="#ff00dd" />
                <Image id="exhaustion_02" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009769/28843649E25B7EB7D0E09F5A48EF9A2C8674EF6A/" color="#ff00dd" />
                <Image id="exhaustion_03" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009838/5C0330ECABBE478F9075D7E976E3D80988B713F3/" color="#ff00dd" />
                <Image id="exhaustion_04" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009909/EF31B152FADB9C3285283548AC6F87AC63704D55/" color="#ff00dd" />
                <Image id="exhaustion_05" class="conditionImage" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576010001/5309A748F4CE884C432CEA11BD3191B1FCB6BF23/" color="#ff00dd" />
            </Panel>
        </Panel>
        <!-- HP BAR  color="#662222"-->
        <Panel id="hpBar" position="0,4,-200">
            <Text id="hpBarText_01" class="HP_text" position="0,0,0"  outline="#552222" outlineSize="1 -1" />
            <Text id="hpBarText_02" class="HP_text" position="0,0,-5"   outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_03" class="HP_text" position="0,0,-10"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_04" class="HP_text" position="0,0,-15"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_05" class="HP_text" position="0,0,-20"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_06" class="HP_text" position="0,0,-25"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_07" class="HP_text" position="0,0,-30"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_08" class="HP_text" position="0,0,-35"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_09" class="HP_text" position="0,0,-40"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_10" class="HP_text" position="0,0,-45"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_11" class="HP_text" position="0,0,-50"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_12" class="HP_text" position="0,0,-55"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_13" class="HP_text" position="0,0,-60"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_14" class="HP_text" position="0,0,-65"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_15" class="HP_text" position="0,0,-70"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_16" class="HP_text" position="0,0,-75"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_17" class="HP_text" position="0,0,-80"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_18" class="HP_text" position="0,0,-85"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_19" class="HP_text" position="0,0,-90"  outline="#00000000" outlineSize="3 -3" />
            <Text id="hpBarText_20" class="HP_text" position="0,0,-95"  outline="#552222" outlineSize="1 -1" />
        </Panel>
        <!-- CONDITIONS ON TOP -->
        <Panel>
            <!-- Dead -->
            <Panel id="conditionPanel_20" position="0,0,-303" rotation="0,0,90" active="false">
                <Image height="40" width="40" image="https://steamusercontent-a.akamaihd.net/ugc/2497884302576009615/C0B0635BFEFF14FA1052ED89AAF2290DEAD8F1C8/" />
            </Panel>
        </Panel>
        <!-- PORTRAIT -->
        <Image active="False" id="bigPortrait" height="200" width="200" preserveAspect="true" position="0,0,-450" rotation="0,-90,90" color="#ffffffdd" image="https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/" />
    </Panel>]]
end