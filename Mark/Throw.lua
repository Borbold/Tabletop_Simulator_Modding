function onSave()
    local data_to_save = memory
    saved_data = JSON.encode(data_to_save)
    return saved_data
end

function onload(saved_data)
    if saved_data ~= nil and saved_data ~= "" then
        memory = JSON.decode(saved_data)
    else
        memory = {
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"},
            {mod=nil, dice=nil, name="---"}, {mod=nil, dice=nil, name="---"}
        }
    end
    printMode = "to ALL"
    resetMode = "Reset after\nroll: OFF"
    -- to check button Indexes, see function buttonList()
    indexFirstModBtn = 3
    indexPrintSwitch = 19
    indexMemClr = 22
    indexFirstMemoryBtn = 23
    indexResetSwitch = 54
    indexMemoryNameInput = 9
    spawnCoreButtons()
    spawnMemoryButtons()
    spawnExtraButtons()
    -- spawnDevButtons()
    resetCounts()

    --Set a new seed based on the smallest part of OS time
    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
end

--Blank function to disable buttons when clicked
function none()
end

--The + and - buttons changing the modifer
function modPlus(thisOne)
    modCount = modCount + 1
    updateModDisplay(thisOne)
end
function modMinus(thisOne)
    modCount = modCount - 1
    updateModDisplay(thisOne)
end
function overrideModDisplay(obj, player, input, selected)
    -- print(obj.GUID)
    if input == '' or input == '-' then
        modCount[1] = 0
    else
        modCount[0] = tonumber(input)
    end
    updateModDisplay(1)
    if not selected then
        return ''
    end
end

--The + and - buttons changing the modifer
function modPlus1()
    modCount[1] = modCount[1] + 1
    updateModDisplay(1)
end
function modMinus1()
    modCount[1] = modCount[1] - 1
    updateModDisplay(1)
end
--Override value of the Mod count to input in field
function overrideModDisplay1(obj, player, input, selected)
    -- print(obj.GUID)
    if input == '' or input == '-' then
        modCount[1] = 0
    else
        modCount[1] = tonumber(input)
    end
    updateModDisplay(1)
    if not selected then
        return ''
    end
end

--The + and - buttons changing the modifer
function modPlus2()
    modCount[2] = modCount[2] + 1
    updateModDisplay(2)
end
function modMinus2()
    modCount[2] = modCount[2] - 1
    updateModDisplay(2)
end
--Override value of the Mod count to input in field
function overrideModDisplay2(obj, player, input, selected)
    -- print(obj.GUID)
    if input == '' or input == '-' then
        modCount[2] = 0
    else
        modCount[2] = tonumber(input)
    end
    updateModDisplay(2)
    if not selected then
        return ''
    end
end

--The + and - buttons changing the modifer
function modPlus3()
    modCount[3] = modCount[3] + 1
    updateModDisplay(3)
end
function modMinus3()
    modCount[3] = modCount[3] - 1
    updateModDisplay(3)
end
--Override value of the Mod count to input in field
function overrideModDisplay3(obj, player, input, selected)
    -- print(obj.GUID)
    if input == '' or input == '-' then
        modCount[3] = 0
    else
        modCount[3] = tonumber(input)
    end
    updateModDisplay(3)
    if not selected then
        return ''
    end
end

--The + and - buttons changing the modifer
function modPlus4()
    modCount[4] = modCount[4] + 1
    updateModDisplay(4)
end
function modMinus4()
    modCount[4] = modCount[4] - 1
    updateModDisplay(4)
end
--Override value of the Mod count to input in field
function overrideModDisplay4(obj, player, input, selected)
    -- print(obj.GUID)
    if input == '' or input == '-' then
        modCount[4] = 0
    else
        modCount[4] = tonumber(input)
    end
    updateModDisplay(4)
    if not selected then
        return ''
    end
end

--The + and - buttons changing the modifer
function modPlus5()
    modCount[5] = modCount[5] + 1
    updateModDisplay(5)
    -- updateModTextDisplay(5)
end
function modMinus5()
    modCount[5] = modCount[5] - 1
    updateModDisplay(5)
    -- updateModTextDisplay(5)
end
--Override value of the Mod count to input in field
function overrideModDisplay5(obj, player, input, selected)
    -- print(obj.GUID)
    if input == '' or input == '-' then
        modCount[5] = 0
    else
        modCount[5] = tonumber(input)
    end
    updateModDisplay(5)
    if not selected then
        return ''
    end
end

--Click functions, passing a parameter to updateCount. Because buttons do not
--currently let you pass parameters as part of the button. Sloppy fix.
function d4(obj, player, alt) updateCount(1,alt) end
function d6(obj, player, alt) updateCount(2,alt) end
function d20(obj, player, alt) updateCount(3,alt) end
function d100(obj, player, alt) updateCount(4,alt) end

function setd4(obj, player, n, selected) setCount(1,n) end
function setd6(obj, player, n, selected) setCount(2,n) end
function setd20(obj, player, n, selected) setCount(3,n) end
function setd100(obj, player, n, selected) setCount(4,n) end

--Triggered by any of the d# buttons, adding to their count.
function updateCount(whichOne, alt)
    if not alt then
        diceCount[whichOne] = diceCount[whichOne] + 1
    elseif diceCount[whichOne] > 0 then
        diceCount[whichOne] = diceCount[whichOne] - 1
    end
    updateDiceDisplay(whichOne-1, diceCount[whichOne], diceSide[whichOne])
    setActiveDice(whichOne-1,diceCount[whichOne])
end

function setCount(whichOne, n)
    if n == '' then return end
    diceCount[whichOne] = tonumber(n)
    updateDiceDisplay(whichOne-1, diceCount[whichOne], diceSide[whichOne])
end

--Updates d# displays with the count of how many of each die is selected.
function updateDiceDisplay(ind, dieCount, dieType)
    self.editButton({index=ind, label=dieCount.."d"..dieType})
end

--Updating of the Mod display screen to show changing values
function updateModDisplay(thisMod)
    self.editButton({index=indexFirstModBtn+thisMod, label="Mod:\n" .. modCount[thisMod]})
    setActiveMod(thisMod,modCount[thisMod])
end

--Wrapper roll function
function roll(o,c,alt)
    if alt then parallel_roll(o,c) else direct_roll(o,c) end
end
 
--Direct Roll function. Displays roller, then does the random rolls
function direct_roll(o,c,memoryName)
    if printMode == "to GM only" then
        if not memoryName  then
        printThis("– Secret Roll by " .. Player[c].steam_name.." –", c)
        else
        printThis("– Secret Roll by " .. Player[c].steam_name.." → " .. memoryName, c)
        end
    else
        if not memoryName then
        printThis("– Roll by " .. Player[c].steam_name.." –", c)
        else
        printThis("– Roll by " .. Player[c].steam_name.." → " .. memoryName, c)
        end
    end
    local modTotal = 0
    local totalScore = 0
    local recount = ""
    for i, v in pairs(diceCount) do
        if v > 0 then
            local dicePrintString = "("..v.."d"..diceSide[i]..")  "
            for repeats=1, v do
                local randomRoll = math.random(1, diceSide[i])
                totalScore = totalScore + randomRoll
                if repeats > 1 then dicePrintString = dicePrintString .. "," end
                dicePrintString = dicePrintString .. " " .. randomRoll
            end
            printThis(dicePrintString, "White")
            totalString = dicePrintString
            recount = recount .. " " .. v .. "d" .. diceSide[i] .. " +"
        end
    end
    for i=1, 5 do
        if totalString and modCount[i] ~= 0 then -- totalString is checked to see whether to display mod count at all
            printThis("(MOD" .. i ..")  "..modCount[i], "White")
            recount = recount .. " " .. modCount[i] .. " +"
        end
        modTotal = modTotal + modCount[i]
    end
    -- checking to see if user selected a die to roll
    if not totalString and modTotal ~= 0 then 
        printToColor("You have only selected a modifier, please select at least one die to roll.",c)
    elseif not totalString then 
        printToColor("Please select at least one die to roll.", c)
    else
    printThis("(TOTAL)  " .. tostring(totalScore + modTotal), "White")
    recount = string.sub(recount, 1, string.len(recount) - 2)
    if printMode ~= "to ALL" then printToColor("You rolled in secret:" .. recount, c, stringColorToRGB(c)) end
    totalString = nil
    resetCounts()
end
end

--Dist function. Displays roller, then does the random rolls in parallel
function parallel_roll(o,c)
    if printMode == "to GM only" then
        if not memoryName  then
        printThis("– Secret Parallel Roll by " .. Player[c].steam_name.." –", c)
        else
        printThis("– Secret Parallel Roll by " .. Player[c].steam_name.." → " .. memoryName, c)
        end
    else
        if not memoryName then
        printThis("– Parallel Roll by " .. Player[c].steam_name.." –", c)
        else
        printThis("– Parallel Roll by " .. Player[c].steam_name.." → " .. memoryName, c)
        end
    end
    local modTotal = 0
    local totalScores = {}
    local recount = ""
    local nMOD = 0
    local nDice = 0
    for i, v in pairs(diceCount) do
        if v > 0 then
            local dicePrintString = "(d"..diceSide[i]..")  "
            for repeats=1, v do
                local randomRoll = math.random(1, diceSide[i])
                table.insert(totalScores, randomRoll)
                nDice = nDice + 1
                if repeats > 1 then dicePrintString = dicePrintString .. "," end
                dicePrintString = dicePrintString .. " " .. randomRoll
            end
            printThis(dicePrintString, "White")
            recount = recount .. " " .. v .. "d" .. diceSide[i] .. " +"
            totalString = dicePrintString
        end
    end

    for i=1, 5 do
        if modCount[i] ~= 0 then
            nMOD = nMOD + 1
            modTotal = modTotal + modCount[i]
        end
    end

    local modString = ""
    for i=1, nDice do
        if nMOD >= 2 and nMOD <= nDice then
            totalScores[i] = totalScores[i] + (modCount[i] or 0)
            if i > 1 then modString = modString .. ", " end
            modString = modString .. (modCount[i] or 0)
            recount = recount .. " " .. (modCount[i] or 0) .. " +"
        else
            totalScores[i] = totalScores[i] + modTotal
            modString = modTotal
            recount = recount .. " " .. (modCount[i] or 0) .. " +"
        end
    end
    -- checking to see if user selected a die to roll
    if not totalString and nMOD ~= 0 then 
    printToColor("You have only selected a modifier, please select at least one die to roll.",c)
    elseif not totalString then 
    printToColor("Please select at least one die to roll.", c)
    else
    if nMOD ~= 0 then printThis("(MODS)  " .. modString, "White") end
    printThis("(TOTALS)  " .. table.concat(totalScores, ', '), "White")
    recount = string.sub(recount, 1, string.len(recount) - 2)
    if printMode ~= "to ALL" then printToColor("You parallel rolled in secret:" .. recount, c, stringColorToRGB(c)) end
    totalString = nil
    resetCounts()
end
end

--Function which does the printing, called on by roll()
function printThis(stringForPrint, colorForPrint)
    if printMode == "to ALL" then
        printToAll(stringForPrint, stringColorToRGB(colorForPrint))
    else
        printToColor(stringForPrint, "Black", stringColorToRGB(colorForPrint))
    end
end

--Resets counts and initializes diceSide/modCount/diceCount
function resetCounts()
    modCount = {0, 0, 0, 0, 0}
    diceCount = {0, 0, 0, 0}
    diceSide = {4,6,20,100} 
    for i=1, 4 do
        updateDiceDisplay(i-1, diceCount[i], diceSide[i])
        setActiveDice(i-1, diceCount[i])
    end
    for i=1, 5 do
      updateModDisplay(i)
    end
    -- updateModTextDisplay()
end

--Switches printMode and update the button associated (just changing variable)
function printSwitch()
    if printMode == "to GM only" then
        printMode = "to ALL"
        self.editButton({index=indexPrintSwitch, label=printMode,color=base_btn_bg_color,font_color=base_btn_font_color})
    elseif Player["Black"].seated == false then
        printToAll("Cannot change to GM only because there is no GM in this game. A player must seated on Black.", {1, 0.2, 0.2})
    else
        printMode = "to GM only"
        self.editButton({index=indexPrintSwitch, label=printMode,color=alert_btn_bg_color,font_color=alert_btn_font_color})
    end
end

--[[BEGIN MEMORY LOGIC BELOW]]--
function mem(o,c,i) remember(o,c,i) end
function mem1(o,c,alt) remember(o,c,1,alt) end
function mem2(o,c,alt) remember(o,c,2,alt) end
function mem3(o,c,alt) remember(o,c,3,alt) end
function mem4(o,c,alt) remember(o,c,4,alt) end
function mem5(o,c,alt) remember(o,c,5,alt) end
function mem6(o,c,alt) remember(o,c,6,alt) end
function mem7(o,c,alt) remember(o,c,7,alt) end
function mem8(o,c,alt) remember(o,c,8,alt) end
function mem9(o,c,alt) remember(o,c,9,alt) end
function mem10(o,c,alt) remember(o,c,10,alt) end
function mem11(o,c,alt) remember(o,c,11,alt) end
function mem12(o,c,alt) remember(o,c,12,alt) end
function mem13(o,c,alt) remember(o,c,13,alt) end
function mem14(o,c,alt) remember(o,c,14,alt) end
function mem15(o,c,alt) remember(o,c,15,alt) end
function mem16(o,c,alt) remember(o,c,16,alt) end
function mem17(o,c,alt) remember(o,c,17,alt) end
function mem18(o,c,alt) remember(o,c,18,alt) end
function mem19(o,c,alt) remember(o,c,19,alt) end
function mem20(o,c,alt) remember(o,c,20,alt) end
function mem21(o,c,alt) remember(o,c,21,alt) end
function mem22(o,c,alt) remember(o,c,22,alt) end
function mem23(o,c,alt) remember(o,c,23,alt) end
function mem24(o,c,alt) remember(o,c,24,alt) end
function mem25(o,c,alt) remember(o,c,25,alt) end
function mem26(o,c,alt) remember(o,c,26,alt) end
function mem27(o,c,alt) remember(o,c,27,alt) end
function mem28(o,c,alt) remember(o,c,28,alt) end
function mem29(o,c,alt) remember(o,c,29,alt) end
function mem30(o,c,alt) remember(o,c,30,alt) end

function remember(o,c,whichSlot,alt)
    if clearSlot == true then
        memory[whichSlot].mod = nil
        memory[whichSlot].dice = nil
        memory[whichSlot].name = "---"
        self.editButton({index=whichSlot+indexFirstMemoryBtn-1, label="---", font_size=base_font_size})
        clearSlot = false
        self.editButton({index=indexMemClr, label="Erase\nsaved roll"})
    elseif memory[whichSlot].mod == nil then
        local itemName = self.getInputs()[indexMemoryNameInput+1].value
        self.editInput({index=indexMemoryNameInput, value=""})
        if itemName ~= "" then
            memory[whichSlot].mod = modCount
            memory[whichSlot].dice = diceCount
            memory[whichSlot].name = itemName
            self.editButton({index=whichSlot+indexFirstMemoryBtn-1, label=memory[whichSlot].name, font_size=getLength(whichSlot)})
            resetCounts()
        else
            printThis("Error! Memory slot must be named.", "Red")
            printThis("Input a name in the 'New Name' field.", "White")
            printThis("Then click a memory button to save the currently selected dice/modifier", "White")
        end
    else
        resetCounts()
        for i, c in pairs(modCount) do
            modCount[i] = memory[whichSlot].mod[i] + c
        end
        for i, d in pairs(diceCount) do
            diceCount[i] = memory[whichSlot].dice[i] + d
        end
        memoryName = memory[whichSlot].name
        if alt then parallel_roll(o,c,memoryName) else direct_roll(o,c,memoryName) end
        memoryName = nil
    end
end

function memClear()

    if clearSlot == true then
        clearSlot = false
        self.editButton({index=indexMemClr, label="Erase\nsaved roll"})
    else
        clearSlot = true
        self.editButton({index=indexMemClr, label="Cancel"})
    end
end

--Colors active dice
function setActiveDice(ind, dieCount)
    if dieCount == 0
        then self.editButton ({index=ind, color=base_btn_bg_color, font_color=base_btn_font_color})
        else self.editButton ({index=ind, color=active_btn_bg_color, font_color=active_btn_font_color})
    end
    end

--Colors active mod
function setActiveMod(thisMod, modCount)
    if modCount == 0
        then self.editButton ({index=indexFirstModBtn+thisMod, color=base_btn_bg_color, font_color=base_btn_font_color})
        else self.editButton ({index=indexFirstModBtn+thisMod, color=active_btn_bg_color, font_color=active_btn_font_color})
    end
end

--Creates all buttons
function spawnCoreButtons()

--***********************************************************
-- BASE GRID: SETTING BUTTON POSITIONING
-- (mod buttons have position overrides - look for them in their own section)
--***********************************************************

    --X positions
    x_origin_position = -1.65;
    x_grid_step = 0.55;

    col_1 = x_origin_position;
    col_2 = col_1+x_grid_step;
    col_3 = col_2+x_grid_step;
    col_4 = col_3+x_grid_step;
    col_5 = col_4+x_grid_step;
    col_6 = col_5+x_grid_step;
    col_7 = col_6+x_grid_step;

    --Y positions
    y_pos = 0.15;

    --Z positions
    z_origin_position = -1.5;
    z_grid_step = 0.3;

    row_1 = z_origin_position; -- dice-row 1
    row_2 = row_1+z_grid_step; -- dice-row 2
    row_3 = row_2+z_grid_step+0.2;
    row_4 = row_3+z_grid_step;
    row_5 = row_4+z_grid_step;
    row_6 = row_5+z_grid_step;
    row_7 = row_6+z_grid_step;
    row_8 = row_7+z_grid_step+0.15; -- Memory controls, Reset
    row_9 = row_8+z_grid_step+0.2; -- printSwitch and Roll Buttons

--***********************************************************
-- BUTTON STYLING
--***********************************************************

    base_font_size = 40;

    base_btn_bg_color = {0.15,0.15,0.15};
    base_btn_font_color={1,1,1};

    memory_btn_bg_color = {0.22,0.2,0.21};
    memory_btn_font_color = {1,1,1};

    memory_btn_active_bg_color ={0.18,0.16,0.16};
    memory_btn_active_font_color={1,1,1};

    alert_btn_bg_color = {0.8,0.2,0.2};
    alert_btn_font_color = {1,1,1};

    active_btn_bg_color = {0.5, 0.20, 0.25};
    active_btn_font_color = {1,1,1};

    --Button sizes
    btn_main_height = 160;
    btn_main_width = 280;

--***********************************************************
-- DICE BUTTONS
--***********************************************************

    btn_dice_font_size = base_font_size;

    btn_dice_input_font_size = base_font_size;
    btn_dice_input_color = {1,1,1,0.15};
    btn_dice_input_width = 80;
    btn_dice_input_height = 60;
    btn_dice_input_adjustment_1_char= -0.08;
    btn_dice_input_adjustment_2_char= -0.10;

--d4
    self.createButton({
        label='0d4', click_function="d4", function_owner=self,
        position={col_1,y_pos,row_1}, width=btn_main_width, height=btn_main_height, font_size=btn_dice_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="setd4", function_owner=self, validation=2, alignment=3,color=btn_dice_input_color,
        position={col_1+btn_dice_input_adjustment_1_char,y_pos,row_1}, width=btn_dice_input_width, height=btn_dice_input_height, font_size=btn_dice_input_font_size
    })
--d6
    self.createButton({
        label='0d6', click_function="d6", function_owner=self,
        position={col_2,y_pos,row_1}, width=btn_main_width, height=btn_main_height, font_size=btn_dice_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="setd6", function_owner=self, validation=2, alignment=3,color=btn_dice_input_color,
        position={col_2+btn_dice_input_adjustment_1_char,y_pos,row_1}, width=btn_dice_input_width, height=btn_dice_input_height, font_size=btn_dice_input_font_size
    })
--d20
    self.createButton({
        label='0d20', click_function="d20", function_owner=self,
        position={col_3,y_pos,row_1}, width=btn_main_width, height=btn_main_height, font_size=btn_dice_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="setd20", function_owner=self, validation=2, alignment=3,color=btn_dice_input_color,
        position={col_3+btn_dice_input_adjustment_2_char,y_pos,row_1}, width=btn_dice_input_width, height=btn_dice_input_height, font_size=btn_dice_input_font_size
    })
--d100
    self.createButton({
        label='0d100', click_function="d100", function_owner=self,
        position={col_4,y_pos,row_1}, width=btn_main_width, height=btn_main_height, font_size=btn_dice_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="setd100", function_owner=self, validation=2, alignment=3,color=btn_dice_input_color,
        position={col_4+btn_dice_input_adjustment_2_char,y_pos,row_1}, width=btn_dice_input_width-10, height=btn_dice_input_height, font_size=btn_dice_input_font_size
    })

--***********************************************************
-- MODIFIER BUTTONS
--***********************************************************

    btn_mod_input_color = btn_dice_input_color;
    btn_mod_font_size = base_font_size;
    btn_mod_display_font_size = base_font_size;
    btn_mod_display_height = btn_main_height;
    btn_mod_display_width = 220;

    --Spacing Overrides
    mod_z_position_override = -0.03;
    z_minplus_override = 0.23;

    btn_minplus_font_size = base_font_size*2;
    btn_minplus_height = 70;
    btn_minplus_width = btn_minplus_height;

    plus_minus_vert_spacing = 0.14;
    plus_minus_horz_spacing = plus_minus_vert_spacing / 2;

    row_3_plus = row_3 - plus_minus_horz_spacing;
    row_4_plus = row_4 - plus_minus_horz_spacing;
    row_5_plus = row_5 - plus_minus_horz_spacing;
    row_6_plus = row_6 - plus_minus_horz_spacing;
    row_7_plus = row_7 - plus_minus_horz_spacing;
    row_8_plus = row_8 - plus_minus_horz_spacing;

    row_3_minus = row_3_plus + plus_minus_vert_spacing;
    row_4_minus = row_4_plus + plus_minus_vert_spacing;
    row_5_minus = row_5_plus + plus_minus_vert_spacing;
    row_6_minus = row_6_plus + plus_minus_vert_spacing;
    row_7_minus = row_7_plus + plus_minus_vert_spacing;
    row_8_minus = row_8_plus + plus_minus_vert_spacing;


    self.createButton({
        label='Mod:\n0', click_function="none", function_owner=self,
        position={col_7+mod_z_position_override,y_pos,row_3}, width=btn_mod_display_width, height=btn_mod_display_height, font_size=btn_mod_display_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="overrideModDisplay1", function_owner=self, validation=2, alignment=3,color=btn_mod_input_color,
        position={col_7+mod_z_position_override,y_pos,row_3+0.045}, width=btn_mod_display_width-140, height=btn_mod_display_height-100, font_size=btn_mod_font_size
    })
    self.createButton({
        label='Mod:\n0', click_function="none", function_owner=self,
        position={col_7+mod_z_position_override,y_pos,row_4}, width=btn_mod_display_width, height=btn_mod_display_height, font_size=btn_mod_display_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="overrideModDisplay2", function_owner=self, validation=2, alignment=3,color=btn_mod_input_color,
        position={col_7+mod_z_position_override,y_pos,row_4+0.045}, width=btn_mod_display_width-140, height=btn_mod_display_height-100, font_size=btn_mod_font_size
    })
    self.createButton({
        label='Mod:\n0', click_function="none", function_owner=self,
        position={col_7+mod_z_position_override,y_pos,row_5}, width=btn_mod_display_width, height=btn_mod_display_height, font_size=btn_mod_display_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="overrideModDisplay3", function_owner=self, validation=2, alignment=3,color=btn_mod_input_color,
        position={col_7+mod_z_position_override,y_pos,row_5+0.045}, width=btn_mod_display_width-140, height=btn_mod_display_height-100, font_size=btn_mod_font_size
    })
    self.createButton({
        label='Mod:\n0', click_function="none", function_owner=self,
        position={col_7+mod_z_position_override,y_pos,row_6}, width=btn_mod_display_width, height=btn_mod_display_height, font_size=btn_mod_display_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="overrideModDisplay4", function_owner=self, validation=2, alignment=3,color=btn_mod_input_color,
        position={col_7+mod_z_position_override,y_pos,row_6+0.045}, width=btn_mod_display_width-140, height=btn_mod_display_height-100, font_size=btn_mod_font_size
    })
    self.createButton({
        label='Mod:\n0', click_function="none", function_owner=self,
        position={col_7+mod_z_position_override,y_pos,row_7}, width=btn_mod_display_width, height=btn_mod_display_height, font_size=btn_mod_display_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createInput({
        label='', input_function="overrideModDisplay5", function_owner=self, validation=2, alignment=3,color=btn_mod_input_color,
        position={col_7+mod_z_position_override,y_pos,row_7+0.045}, width=btn_mod_display_width-140, height=btn_mod_display_height-100, font_size=btn_mod_font_size
    })

    --Mod 1 +/-
    self.createButton({
        label='+', click_function="modPlus1", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_3_plus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label='-', click_function="modMinus1", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_3_minus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })

    --Mod 2 +/-
    self.createButton({
        label='+', click_function="modPlus2", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_4_plus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label='-', click_function="modMinus2", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_4_minus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })

    --Mod 3 +/-
    self.createButton({
        label='+', click_function="modPlus3", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_5_plus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label='-', click_function="modMinus3", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_5_minus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })

    --Mod 4 +/-
    self.createButton({
        label='+', click_function="modPlus4", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_6_plus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label='-', click_function="modMinus4", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_6_minus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })

    --Mod 5 +/-
    self.createButton({
        label='+', click_function="modPlus5", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_7_plus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label='-', click_function="modMinus5", function_owner=self,
        position={col_7+z_minplus_override,y_pos,row_7_minus}, width=btn_minplus_width, height=btn_minplus_height, font_size=btn_minplus_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })

--***********************************************************
-- MAIN BUTTONS
--***********************************************************

    self.createButton({
        label='to ALL', click_function="printSwitch", function_owner=self,
        position={col_2-0.25,y_pos,row_9}, width=560, height=btn_main_height, font_size=base_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label='Reset\nroll', click_function="resetCounts", function_owner=self,
        position={col_7+0.01,y_pos,row_8}, width=btn_main_width-20, height=btn_main_height, font_size=base_font_size, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
    self.createButton({
        label=string.char(8635)..' Roll '..string.char(8634), click_function="roll", function_owner=self,
        position={col_5+0.06,y_pos,row_9}, width=1280, height=220, font_size=base_font_size*2, color=base_btn_bg_color,font_color=base_btn_font_color,
    })
end

function spawnMemoryButtons()
--***********************************************************
-- MEMORY CONTROL BUTTONS
--***********************************************************

    self.createInput({
        label='New name for saved roll', input_function="none", function_owner=self,
        position={col_3-0.25,y_pos,row_8}, width=480, height=160, font_size=base_font_size, color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label='Erase\nsaved roll', click_function="memClear", function_owner=self,
        position={col_1,y_pos,row_8}, width=btn_main_width, height=btn_main_height, font_size=base_font_size, color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })

--***********************************************************
-- MEMORY RECALL BUTTONS
--***********************************************************

    self.createButton({
        label=memory[1].name, click_function="mem1", function_owner=self,
        position={col_1,y_pos,row_3}, width=btn_main_width, height=btn_main_height, font_size=getLength(1), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[2].name, click_function="mem2", function_owner=self,
        position={col_2,y_pos,row_3}, width=btn_main_width, height=btn_main_height, font_size=getLength(2), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[3].name, click_function="mem3", function_owner=self,
        position={col_3,y_pos,row_3}, width=btn_main_width, height=btn_main_height, font_size=getLength(3), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[4].name, click_function="mem4", function_owner=self,
        position={col_4,y_pos,row_3}, width=btn_main_width, height=btn_main_height, font_size=getLength(4), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[5].name, click_function="mem5", function_owner=self,
        position={col_5,y_pos,row_3}, width=btn_main_width, height=btn_main_height, font_size=getLength(5), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[6].name, click_function="mem6", function_owner=self,
        position={col_6,y_pos,row_3}, width=btn_main_width, height=btn_main_height, font_size=getLength(6), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })

    self.createButton({
        label=memory[7].name, click_function="mem7", function_owner=self,
        position={col_1,y_pos,row_4}, width=btn_main_width, height=btn_main_height, font_size=getLength(7), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[8].name, click_function="mem8", function_owner=self,
        position={col_2,y_pos,row_4}, width=btn_main_width, height=btn_main_height, font_size=getLength(8), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[9].name, click_function="mem9", function_owner=self,
        position={col_3,y_pos,row_4}, width=btn_main_width, height=btn_main_height, font_size=getLength(9), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[10].name, click_function="mem10", function_owner=self,
        position={col_4,y_pos,row_4}, width=btn_main_width, height=btn_main_height, font_size=getLength(10), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[11].name, click_function="mem11", function_owner=self,
        position={col_5,y_pos,row_4}, width=btn_main_width, height=btn_main_height, font_size=getLength(11), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[12].name, click_function="mem12", function_owner=self,
        position={col_6,y_pos,row_4}, width=btn_main_width, height=btn_main_height, font_size=getLength(12), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })

    self.createButton({
        label=memory[13].name, click_function="mem13", function_owner=self,
        position={col_1,y_pos,row_5}, width=btn_main_width, height=btn_main_height, font_size=getLength(13), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[14].name, click_function="mem14", function_owner=self,
        position={col_2,y_pos,row_5}, width=btn_main_width, height=btn_main_height, font_size=getLength(14), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[15].name, click_function="mem15", function_owner=self,
        position={col_3,y_pos,row_5}, width=btn_main_width, height=btn_main_height, font_size=getLength(15), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[16].name, click_function="mem16", function_owner=self,
        position={col_4,y_pos,row_5}, width=btn_main_width, height=btn_main_height, font_size=getLength(16), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[17].name, click_function="mem17", function_owner=self,
        position={col_5,y_pos,row_5}, width=btn_main_width, height=btn_main_height, font_size=getLength(17), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[18].name, click_function="mem18", function_owner=self,
        position={col_6,y_pos,row_5}, width=btn_main_width, height=btn_main_height, font_size=getLength(18), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })

    self.createButton({
        label=memory[19].name, click_function="mem19", function_owner=self,
        position={col_1,y_pos,row_6}, width=btn_main_width, height=btn_main_height, font_size=getLength(19), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[20].name, click_function="mem20", function_owner=self,
        position={col_2,y_pos,row_6}, width=btn_main_width, height=btn_main_height, font_size=getLength(20), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[21].name, click_function="mem21", function_owner=self,
        position={col_3,y_pos,row_6}, width=btn_main_width, height=btn_main_height, font_size=getLength(21), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[22].name, click_function="mem22", function_owner=self,
        position={col_4,y_pos,row_6}, width=btn_main_width, height=btn_main_height, font_size=getLength(22), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[23].name, click_function="mem23", function_owner=self,
        position={col_5,y_pos,row_6}, width=btn_main_width, height=btn_main_height, font_size=getLength(23), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[24].name, click_function="mem24", function_owner=self,
        position={col_6,y_pos,row_6}, width=btn_main_width, height=btn_main_height, font_size=getLength(24), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })

    self.createButton({
        label=memory[25].name, click_function="mem25", function_owner=self,
        position={col_1,y_pos,row_7}, width=btn_main_width, height=btn_main_height, font_size=getLength(25), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[26].name, click_function="mem26", function_owner=self,
        position={col_2,y_pos,row_7}, width=btn_main_width, height=btn_main_height, font_size=getLength(26), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[27].name, click_function="mem27", function_owner=self,
        position={col_3,y_pos,row_7}, width=btn_main_width, height=btn_main_height, font_size=getLength(27), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[28].name, click_function="mem28", function_owner=self,
        position={col_4,y_pos,row_7}, width=btn_main_width, height=btn_main_height, font_size=getLength(28), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[29].name, click_function="mem29", function_owner=self,
        position={col_5,y_pos,row_7}, width=btn_main_width, height=btn_main_height, font_size=getLength(29), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
    self.createButton({
        label=memory[30].name, click_function="mem30", function_owner=self,
        position={col_6,y_pos,row_7}, width=btn_main_width, height=btn_main_height, font_size=getLength(30), color=memory_btn_bg_color,font_color=memory_btn_font_color,
    })
end
function spawnExtraButtons()

-- Title "button", because there is no text tool in TTS --
    self.createButton({
        label="Right click for parallel rolls", click_function="no-function-this-is-only-for-display", function_owner=self,
        position={col_5+0.06,y_pos,row_9+0.25}, height=0, width=0, font_size=20, color={0,0,0},font_color=base_btn_font_color,
    })

end

--Dynamically sets font size based on length of name (for memory buttons)
function getLength(i)
    local length = string.len(memory[i].name)
    if length > 35 then return 30 
    elseif length > 30 then return 35 
    elseif length > 19 then return 41 
    else return 50 
    end
end

function ChangeMemory(arg)
    local bChar = 0
    for _,m in ipairs(memory) do
        if bChar == 0 then bChar = m.name == arg.tChar and m.mod[1] or 0 end

        if arg.tTag then
            if m.name == arg.tTag then
                m.mod[1] = bChar
                if arg.bonus ~= -1 then
                    m.mod[2] = arg.bonus
                end
                return
            end
        elseif arg.state then
            if m.name == arg.tChar then
                m.mod[2] = arg.bonus
                return
            end
        elseif m.name == arg.tChar then
            m.mod[1] = arg.bonus
            return
        end
    end
end

function Overshoot(arg)
    for i,m in ipairs(memory) do
        if m.name == arg.tTag then
            broadcastToAll(arg.playerColor.." перебросил "..arg.tTag, arg.playerColor)
            mem(self, arg.playerColor, i)
        end
    end
end