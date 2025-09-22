-- Функция для сохранения данных персонажа
function onSave()
    -- Генерация случайного числа для определения, нужно ли сохранять данные
    local rndSave = math.random(1, 3)

    -- Проверка условия для сохранения данных
    if rndSave == 1 or self:getDescription() == "save" then
        -- Создание таблицы для сохранения данных
        local data_to_save = {}
        data_to_save.charSave_table = self:getTable("charSave_table")
        data_to_save.Selected = Selected

        -- Кодирование данных в JSON формат
        local saved_data = JSON.encode(data_to_save)
        return saved_data
    end
end

-- Функция для загрузки данных персонажа
function onLoad(saved_data)
    THIS_IS_A_SCRIPTED_DND_4E_CHARACTER_TOKEN = true

    -- Проверка наличия данных для загрузки
    if saved_data and saved_data ~= "" then
        -- Декодирование данных из JSON формата
        local loaded_data = JSON.decode(saved_data)
        self:setTable("charSave_table", loaded_data.charSave_table)
        Selected = loaded_data.Selected
    else
        -- Установка начальных значений, если данные отсутствуют
        Selected = 0 -- Индекс выбора, 0 - idle
        resetChar()
    end

    -- Настройка цветов и интерфейса
    local plColorsHexTable = {"#3f3f3f","#ffffff","#703a16","#da1917","#f3631c","#e6e42b","#30b22a","#20b09a","#1e87ff","#9f1fef","#f46fcd"}
    local plColors_Table = {"Black","White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
    self.UI:setXml(charXml())
    hideThisChar()
end

-- Функция для скрытия персонажа
function hideThisChar()
    if charSave_table.charHidden then
        local hideFromTbl = {"Grey"}
        for i = 2, 11 do
            if not charSave_table.aColors[i] then
                table.insert(hideFromTbl, plColors_Table[i])
            end
        end
        self:setInvisibleTo(hideFromTbl)
    else
        self:setInvisibleTo({})
    end

    -- Обновление интерфейса через 3 кадра
    Wait.frames(function()
        UI_update()
    end, 3)
end

-- Функция для обновления интерфейса
function UI_update()
    -- Обновление позиции, ротации и масштаба интерфейса
    UI_xmlElementUpdate("tokenUIbase", "position", (charSave_table.tokenGUI_settings[3] * 10)..","..(charSave_table.tokenGUI_settings[1] * 10)..","..(charSave_table.tokenGUI_settings[2] * (-10)))
    UI_xmlElementUpdate("tokenUIbase", "rotation", "0,0,"..charSave_table.tokenGUI_settings[4] * 15 + 90)
    UI_xmlElementUpdate("tokenUIbase", "scale", (1.1 ^ (charSave_table.tokenGUI_settings[5] - 6))..","..(1.1 ^ (charSave_table.tokenGUI_settings[5] - 6))..","..(1.1 ^ (charSave_table.tokenGUI_settings[5] - 6)))

    -- Обновление состояния здоровья
    local HP_i = math.floor(charSave_table.hp / charSave_table.hpMax * 20)

    -- Формирование строки видимости
    local showToStr = "Black"
    for i = 2, 11 do
        if charSave_table.aColors[i] then
            showToStr = showToStr.."|"..plColors_Table[i]
        end
    end

    -- Обновление видимости элементов интерфейса
    if charSave_table.charHidden then
        UI_xmlElementUpdate("conditionsPanel", "visibility", showToStr)
        UI_xmlElementUpdate("selectedMarker", "visibility", showToStr)
        UI_xmlElementUpdate("hpBar", "visibility", showToStr)
        UI_xmlElementUpdate("hiddenMarker", "active", "True")
        UI_xmlElementUpdate("hiddenMarker", "visibility", showToStr)
    else
        UI_xmlElementUpdate("conditionsPanel", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
        UI_xmlElementUpdate("selectedMarker", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
        if charSave_table.hpVisibleToPlayers then
            UI_xmlElementUpdate("hpBar", "visibility", "Black|White|Brown|Red|Orange|Yellow|Green|Teal|Blue|Purple|Pink|Grey")
        else
            UI_xmlElementUpdate("hpBar", "visibility", showToStr)
        end
        UI_xmlElementUpdate("hiddenMarker", "active", "False")
    end

    -- Обновление цвета элементов здоровья
    for i = 1, 20 do
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

    -- Обновление выделения
    if Selected ~= 0 then
        UI_xmlElementUpdate("selectedMarker", "active", "True")
        for i = 1, 4 do
            UI_xmlElementUpdate("selectedMarker_"..strFromNum(i), "outline", plColorsHexTable[Selected].."ff")
        end
        UI_xmlElementUpdate("selectedMarker_00", "color", plColorsHexTable[Selected].."ff")
        UI_xmlElementUpdate("selectedMarker_10", "color", plColorsHexTable[Selected].."ff")
    else
        UI_xmlElementUpdate("selectedMarker", "active", "False")
    end

    -- Обновление состояний
    for i = 1, 20 do
        if charSave_table.conditions.table[i] then
            UI_xmlElementUpdate("conditionPanel_"..strFromNum(i), "active", "True")
        else
            UI_xmlElementUpdate("conditionPanel_"..strFromNum(i), "active", "False")
        end
    end

    if charSave_table.conditions.table[18] then
        for i = 1, 5 do
            if i == charSave_table.conditions.exhaustion then
                UI_xmlElementUpdate("exhaustion_"..strFromNum(i), "active", "True")
            else
                UI_xmlElementUpdate("exhaustion_"..strFromNum(i), "active", "False")
            end
        end
    end

    -- Обновление портрета
    UI_xmlElementUpdate("bigPortrait", "image", charSave_table.portraitUrl)
end

-- Функция для создания эффекта дрожания при выделении
function selectWobble()
    for i = 1, 5 do
        Wait.frames(function()
            self.UI.setAttribute("selectedMarker", "scale", (1+(i*0.2))..","..(1+(i*0.2))..","..(1+(i*0.2)))
        end, i*2+5)
        Wait.frames(function()
            self.UI.setAttribute("selectedMarker", "scale", (2-(i*0.2))..","..(2-(i*0.2))..","..(2-(i*0.2)))
        end, i*2+15)
    end
end

-- Функция для создания эффекта вращения при выделении
function selectSpin()
    for i = 1, 3 do
        Wait.frames(function()
            self.UI.setAttribute("selectedMarkerStar", "rotation", "0,0,"..(i*7))
        end, i*20)
    end
end

-- Функция для случайного изменения состояния персонажа
function onRandomize(player_color)
    self:setVelocity({0,0,0})
    if self.UI.getAttribute("bigPortrait", "active") == "True" then
        self.UI.setAttribute("bigPortrait", "active", "False")
    else
        self.UI.setAttribute("bigPortrait", "active", "True")
    end
    UI_update()
end

-- Функция для сброса состояния персонажа
function resetChar()
    charSave_table = {}
    charSave_table.aColors = {true,false,false,false,false,false,false,false,false,false,false}
    charSave_table.portraitUrl = "https://steamusercontent-a.akamaihd.net/ugc/2497882400488031468/9585602862E83BBAAB9F8D513692B207D21F7874/"
    charSave_table.charName = self:getName()
    charSave_table.hp = 1
    charSave_table.hpMax = 1
    charSave_table.hpTemp = 0
    charSave_table.deathSaves = {1,1,1,1,1}
    charSave_table.charLvl = 1
    charSave_table.charProfBonus = 2
    charSave_table.AC = 10
    charSave_table.speed = 30
    charSave_table.initMod = 0
    charSave_table.pPerceptionMod = 0
    charSave_table.attributes = {}
    charSave_table.saves = {false,false,false,false,false,false}
    charSave_table.savesMod = {Fortitude = 0, Reflex = 0, Will = 0}
    for ii = 1, 6 do
        charSave_table.attributes[ii] = 10
        charSave_table.saves[ii] = false
    end
    charSave_table.skills = {}
    for ii = 1, 18 do
        charSave_table.skills[ii] = {}
        charSave_table.skills[ii].proficient = false
        charSave_table.skills[ii].expertize = false
        charSave_table.skills[ii].mod = 0
    end
    charSave_table.attacks = {}
    for ii = 1, 10 do
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
    for ii = 1, 10 do
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

-- Функция для обновления XML элемента интерфейса
function UI_xmlElementUpdate(xml_ID, xml_attribute, input_string)
    if self.UI.getAttribute(xml_ID, xml_attribute) ~= input_string then
        self.UI.setAttribute(xml_ID, xml_attribute, input_string)
    end
end

-- Функция для преобразования строки в число
function numFromStr(inpStr)
    if string.sub(inpStr, 1, 1) == "0" then
        return tonumber(string.sub(inpStr, 2, 2))
    else
        return tonumber(string.sub(inpStr, 1, 2))
    end
end

-- Функция для преобразования строки в число (конец строки)
function numFromStrEnd(inpStr)
    if string.sub(inpStr, #inpStr-1, #inpStr-1) == "0" then
        return tonumber(string.sub(inpStr, #inpStr, #inpStr))
    else
        return tonumber(string.sub(inpStr, #inpStr-1, #inpStr))
    end
end

-- Функция для преобразования числа в строку
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