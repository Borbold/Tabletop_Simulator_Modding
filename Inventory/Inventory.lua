function UpdateSave()
  local dataToSave = {
    ["tableItems"] = tableItems,
    ["infoGUID"] = infoGUID, ["statusGUID"] = statusGUID, ["skillsGUID"] = skillsGUID,
    ["saveXML"] = self.UI.getXmlTable(), ["saveCustomAsset"] = self.UI.getCustomAssets(),
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    enumSpecial = {
      сила = 1, восприятие = 2, выносливость = 3,
      харизма = 4, интелект = 5, ловкость = 6,
      удача = 7,
    }
    enumStatus = {
      реакция = 1, ["класс брони"] = 2, ["предел урона"] = 3,
      ["сопротивление урону"] = 4, ["сопротивление энергетическому урону"] = 5, ["сопротивление радиации"] = 6,
      ["сопротивление ядам"] = 7, ["шанс на крит"] = 8,
    }
    enumSkills = {
      ["легкое оружие"] = 1, ["тяжелое оружие"] = 2, ["энергетическое оружие"] = 3, ["без оружие"] = 4,
      ["холодное оружие"] = 5, метание = 6, ["первая помощь"] = 7,
      доктор = 8, натуралист = 9, пилот = 10,
      скрытность = 11, взлом = 12, кража = 13,
      ловушки = 14, наука = 15, ремонт = 16,
      красноречие = 17, бартер = 18, ["азартные игры"] = 19,
    }
    enumSlots = {
      фракция_0 = 0, очки_1 = 1, маска_2 = 2,
      спец_предмето_3 = 3, шлем_4 = 4, разгрузка_5 = 5,
      бронежилет_6 = 6, подсумок_7 = 7, одежда_8 = 8,
      рюкзак_9 = 9, быстрый_слот_10 = 10,
    }
    Wait.time(|| Confer(savedData), 0.4)
    local params = {
      function_owner = self, click_function = "RemoveItem",
      label = "testID",
      position = {5.05, 0.2, 15.3}, rotation = {0, 180, 0},
      width = 400, height = 400,
      font_size = 120, font_color = {1, 1, 1},
      color = {0.5, 0.5, 0.5},
      tooltip = "[33ff33]This[ffffff] text appears on mouseover.",
    }
    self.createButton(params)
    params = {
      function_owner = self, click_function = "RemoveItem",
      label = "testID",
      position = {3.8, 0.2, 15.3}, rotation = {0, 180, 0},
      width = 400, height = 400,
      font_size = 120, font_color = {1, 1, 1},
      color = {0.5, 0.5, 0.5},
      tooltip = "[33ff33]This[ffffff] text appears on mouseover.",
    }
    self.createButton(params)
  end, 0.5)
end

function Confer(savedData)
  local loadedData = JSON.decode(savedData or "")
  RebuildAssets(--[[loadedData.saveCustomAsset or]] {})
  tableItems = loadedData.tableItems or {}
  infoGUID = loadedData.infoGUID
  statusGUID = loadedData.statusGUID
  skillsGUID = loadedData.skillsGUID
  if loadedData.saveXML then
    --Wait.time(|| self.UI.setXmlTable(loadedData.saveXML), 1)
  end
end

function onCollisionEnter(info)
  if info.collision_object.getPosition().y < self.getPosition().y then return end
  local newObject = info.collision_object
  local currentDescription = {}
  local newGMNotes = newObject.getGMNotes()
  for word in newGMNotes:gmatch("%S+") do
    table.insert(currentDescription, word)
  end
  destroyObject(info.collision_object)
  
  local cusAss = self.UI.getCustomAssets()
  table.insert(cusAss, {name = currentDescription[2], url = newObject.getCustomObject().image})
  self.UI.setCustomAssets(cusAss)
  
  local newName = newObject.getName()
  local newDescription = newObject.getDescription()
  Wait.time(function()
    self.UI.setAttribute(currentDescription[2], "icon", "testICON")
    self.UI.setAttribute(currentDescription[2], "iconColor", "#ffffffff")
    local indexButton = tonumber(currentDescription[2]:sub(currentDescription[2]:find("_") + 1))
    self.editButton({index = indexButton, tooltip = newName .. "\n" .. newDescription})
    --Wait.time(|| print(self.UI.getXmlTable()[2].children[1].children[2].children[1].children[1].children[1].attributes["icon"]), 0.2)
  end, 0.01)
  local newUrlImage = newObject.getCustomObject().image
  
  tableItems[currentDescription[2]] = {newName, newDescription, newUrlImage, newGMNotes}
  local findText = newDescription:find("Эффекты")
  if findText then
    ChangeDependentVariables(newDescription:sub(findText))
  end
  Wait.time(|| UpdateSave(), 0.2)
end
function RemoveItem(obj, color, alt_click)
  --if not id or not self.UI.getAttribute(id, "icon") or self.UI.getAttribute(id, "icon") == '' then return end
  
  local selfPosition = self.getPosition()
  local spawnParametrs = {
    type = "Custom_Tile",
    position = {x = selfPosition.x, y = selfPosition.y + 0.1, z = selfPosition.z - 4},
    rotation = {x = 0, y = 180, z = 0},
    scale = {x = 1, y = 1, z = 1},
    sound = false, snap_to_grid = true,
  }
  local newObject = spawnObject(spawnParametrs)

  local indexItem, indexButton
  for i,v in pairs(tableItems) do
    if enumSlots[i] ~= nil then
      indexItem = i
      indexButton = enumSlots[i]
    end
  end

  if indexItem and indexButton then
    newObject.setName(tableItems[indexItem][1])
    newObject.setDescription(tableItems[indexItem][2])
    newObject.setCustomObject({image = tableItems[indexItem][3]})
    newObject.setGMNotes(tableItems[indexItem][4])

    local findText = tableItems[indexItem][2]:find("Эффекты")
    if findText then
      ChangeDependentVariables(tableItems[indexItem][2]:sub(findText), true)
    end
    tableItems[indexItem] = nil

    Wait.time(function()
      self.UI.setAttribute(indexItem, "icon", "")
      self.UI.setAttribute(indexItem, "iconColor", "#ffffff00")
      self.editButton({index = indexButton, tooltip = ""})
    end, 0.01)
    UpdateSave()
  else
    broadcastToAll("Чето пошло не так")
  end
end
function ChangeDependentVariables(description, remove)
  local infoGUID = infoGUID or SearchDie("Info")
  local statusGUID = statusGUID or SearchDie("Status")
  local skillsGUID = skillsGUID or SearchDie("Skills")
  local currentDescription = {}
  for word in description:gmatch("%S+") do
    if word:find("%[") then
      local longWord = description:match("%[(.+)%]")
      table.insert(currentDescription, longWord)
    else
      table.insert(currentDescription, word)
    end
  end
  
  for i,v in ipairs(currentDescription) do
    local value, skills, locGUID = nil, "", ""
    if enumSpecial[v] then
      skills = v
      value = tonumber(currentDescription[i - 1])
      locGUID = infoGUID
    elseif enumStatus[v] then
      skills = v
      local textValue = currentDescription[i - 1]
      value = tonumber(textValue:sub(0, #textValue - 1))
      locGUID = statusGUID
    elseif enumSkills[v] then
      skills = v
      local textValue = currentDescription[i - 1]
      value = tonumber(textValue:sub(0, #textValue - 1))
      locGUID = skillsGUID
    end
    
    if value then
      local args = {}
      if value > 0 then
        args = {
          value = not remove and value or -value,
          id = "baff" .. (enumSpecial[skills] or enumStatus[skills] or enumSkills[skills]),
          playerColor = "Black"
        }
      else
        args = {
          value = not remove and math.abs(value) or -math.abs(value),
          id = "debaff" .. (enumSpecial[skills] or enumStatus[skills] or enumSkills[skills]),
          playerColor = "Black"
        }
      end
      getObjectFromGUID(locGUID).call("ChangeSkills", args)
    end
  end
end

function CheckPlayer(playerColor, onlyGM)
  levelGUID = levelGUID or SearchDie("Level")
  local args = {playerColor = playerColor, onlyGM = onlyGM}
  if getObjectFromGUID(levelGUID).call("CheckPlayer", args) then return true end
end
function SearchDie(name)
  for _,obj in pairs(getObjects()) do
    if obj.getName() == name and obj.getColorTint() == self.getColorTint() then
      return obj.getGUID()
    end
  end
end

function RebuildAssets(assets)
  local backG = 'https://i.imgur.com/WQiHEAd.png'
  local example1 = 'https://cdn.discordapp.com/attachments/800324103848198174/838979483075608596/moto_glasses.png'
  local example2 = 'https://cdn.discordapp.com/attachments/800324103848198174/838979481347031070/red_mask.png'
  table.insert(assets, {name = 'uiBackGroundW', url = backG})
  table.insert(assets, {name = 'example1', url = example1})
  table.insert(assets, {name = 'example2', url = example2})
  self.UI.setCustomAssets(assets)
end
