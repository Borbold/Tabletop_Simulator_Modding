function UpdateSave()
  local dataToSave = {
    ["tableItems"] = tableItems,
    ["infoGUID"] = infoGUID, ["statusGUID"] = statusGUID, ["skillsGUID"] = skillsGUID,
    ["saveXML"] = self.UI.getXmlTable(), ["saveCustomAsset"] = self.UI.getCustomAssets(),
  }
  --[[Wait.time( function() -- Пример одетой одежды
    for i,v in pairs(self.UI.getXmlTable()) do
      if i == 2 then
        for i1,v1 in pairs(v["children"]) do
          for i2,v2 in pairs(v1["children"]) do
            if i2 == 5 then
              for a,t in pairs(v2["children"][1]["children"][1]["children"][1]["attributes"]) do
                print(a, ": ", t)
              end
            end
          end
        end
      end
    end
  end, 0.25)]]
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  enumSpecial = {
    Сила = 1, Восприятие = 2, Выносливость = 3,
    Харизма = 4, Интелект = 5, Ловкость = 6,
    Удача = 7,
  }
  enumStatus = {
    реакция = 1, ["класс брони"] = 2, ["предел урона"] = 3,
    ["сопротивление урону"] = 4, ["сопротивление энергетическому урону"] = 5, ["сопротивление радиации"] = 6,
    ["сопротивление ядам"] = 7, ["шанс на крит"] = 8,
  }
  enumSkills = {
    ["легкое оружие"] = 1, ["тяжелое оружие"] = 2, ["энергетическое оружие"] = 3, ["без оружие"] = 4,
    ["Холодное Оружие"] = 5, метание = 6, ["первая помощь"] = 7,
    доктор = 8, натуралист = 9, пилот = 10,
    скрытность = 11, взлом = 12, кража = 13,
    ловушки = 14, наука = 15, ремонт = 16,
    красноречие = 17, бартер = 18, ["азартные игры"] = 19,
  }
  enumLimb = {
    голова = 1, глаза = 2, ["прав.рука"] = 3,
    ["прав.нога"] = 4, торс = 5, пах = 6,
    ["лев.рука"] = 7, ["лев.нога"] = 8
  }
  Wait.time(|| Confer(savedData), 1)
end

function Confer(savedData)
  local loadedData = JSON.decode(savedData or "")
  RebuildAssets(loadedData and loadedData.saveCustomAsset or {})
  tableItems = loadedData and loadedData.tableItems or {}
  infoGUID = loadedData and loadedData.infoGUID
  statusGUID = loadedData and loadedData.statusGUID
  skillsGUID = loadedData and loadedData.skillsGUID
  if loadedData and loadedData.saveXML then
    Wait.time(|| self.UI.setXmlTable(loadedData.saveXML), 1)
  end
  FindDependentVariables()
end

function onCollisionEnter(info)
  if info.collision_object.getPosition().y < self.getPosition().y or
     #info.collision_object.getTags() <= 0 then return end
  local newObject = info.collision_object
  local objTag = ""
  if newObject.getRotation()[3] < 90 then
    for _,v in ipairs(newObject.getTags()) do
      if v != "Item" then objTag = v break end
    end
  else
    objTag = "Item"
  end

  local newName = newObject.getName()
  local cusAss = self.UI.getCustomAssets()
  table.insert(cusAss, {name = newName, url = newObject.getCustomObject().image})
  self.UI.setCustomAssets(cusAss)
  
  local newDescription = newObject.getDescription()
  Wait.time(function()
    if objTag != "Item" then
      self.UI.setAttribute(objTag, "icon", newName)
      self.UI.setAttribute(objTag, "iconColor", "#ffffffff")
      self.UI.setAttribute(objTag, "tooltip", newName .. "\n" .. newDescription)
      self.UI.setAttribute(objTag, "ObjName", newName)
      self.UI.setAttribute(objTag, "ObjDesc", newDescription)
      self.UI.setAttribute(objTag, "UrlImage", newObject.getCustomObject().image)
      self.UI.setAttribute(objTag, "UrlBottomImage", newObject.getCustomObject().image_bottom)
      table.insert(tableItems, {id = objTag, description = newDescription})
    else
      for i = 1, 22 do
        if #self.UI.getAttribute(objTag .. i, "tooltip") == 0 then
          self.UI.setAttribute(objTag .. i, "icon", newName)
          self.UI.setAttribute(objTag .. i, "iconColor", "#ffffffff")
          self.UI.setAttribute(objTag .. i, "tooltip", newName .. "\n" .. newDescription)
          self.UI.setAttribute(objTag .. i, "ObjName", newName)
          self.UI.setAttribute(objTag .. i, "ObjDesc", newDescription)
          self.UI.setAttribute(objTag .. i, "UrlImage", newObject.getCustomObject().image)
          self.UI.setAttribute(objTag .. i, "UrlBottomImage", newObject.getCustomObject().image_bottom)
          table.insert(tableItems, {id = objTag .. i, description = newDescription})
          break
        end
      end
    end
    destroyObject(info.collision_object)
  end, 0.01)
  
  local findText = newDescription:find("Эффекты")
  if findText and objTag != "Item" then
    ChangeDependentVariables(newDescription:sub(findText))
  end
  
  Wait.time(|| UpdateSave(), 0.3)
end
function RemoveItem(pl, t_click, id)
  local selfPosition = self.getPosition()
  local spawnParametrs = {
    type = "Custom_Tile",
    position = {x = selfPosition.x, y = selfPosition.y + 0.1, z = selfPosition.z - 4},
    rotation = {x = 0, y = 180, z = 0},
    scale = {x = 0.47, y = 1, z = 0.47},
    sound = false, snap_to_grid = true,
  }

  if id and #self.UI.getAttribute(id, "tooltip") > 0 then
    local newObject = spawnObject(spawnParametrs)
    newObject.setName(self.UI.getAttribute(id, "ObjName"))
    newObject.setDescription(self.UI.getAttribute(id, "ObjDesc"))
    newObject.setCustomObject({
      image = self.UI.getAttribute(id, "UrlImage"),
      image_bottom = self.UI.getAttribute(id, "UrlBottomImage")
    })
    newObject.setTags({id})

    local index
    for i,table in pairs(tableItems) do
      if table.id == id then
        local findText = table.description:find("Эффекты")
        if findText then
          ChangeDependentVariables(table.description:sub(findText), true)
        end
        index = i
        break
      end
    end
    table.remove(tableItems, index)

    Wait.time(function()
      self.UI.setAttribute(id, "icon", "")
      self.UI.setAttribute(id, "iconColor", "#ffffff00")
      self.UI.setAttribute(id, "tooltip", "")
    end, 0.2)
    Wait.time(|| UpdateSave(), 0.3)
  else
    broadcastToAll("Слот и так пуст")
  end
end
function ChangeDependentVariables(description, remove)
  local cutWordDesc, findWord, findNum = {}, "", 0
  local tI = 1
  for prediction in description:gmatch("[^\n]+") do
    tI = tI + 1
    if prediction:find("%+") or prediction:find("%-") then
      for word in prediction:gmatch("%S+") do
        if findNum == 1 then
          table.insert(cutWordDesc, prediction:sub(#findWord + 2))
          findWord = ""
          findNum = 0
        end
    -------------------------------------------------------
        if word:find("%((.+)%)") then
          table.insert(cutWordDesc, word:sub(2, #word - 1))
          findWord = word
          findNum = 1
        end
      end
    end
  end
  
  for i,v in ipairs(cutWordDesc) do
    local value, skills, locGUID = nil, "", ""
    if enumSpecial[v] then
      skills = v
      value = tonumber(cutWordDesc[i - 1])
      infoGUID = infoGUID or SearchDie("Info")
      locGUID = infoGUID
    elseif enumStatus[v] then
      skills = v
      local textValue = cutWordDesc[i - 1]
      value = tonumber(textValue:sub(0, #textValue - 1))
      statusGUID = statusGUID or SearchDie("Status")
      locGUID = statusGUID
    elseif enumSkills[v] then
      skills = v
      local textValue = cutWordDesc[i - 1]
      value = tonumber(textValue:sub(0, #textValue - 1))
      skillsGUID = skillsGUID or SearchDie("Skills")
      locGUID = skillsGUID
    elseif enumLimb[v] then
      skills = v
      value = tonumber(cutWordDesc[i - 1])
      statusGUID = statusGUID or SearchDie("Status")
      locGUID = statusGUID
    end
    
    local condition, SS = nil, ""
    if v:find("HP") then
      SS = "HP"
      condition = v
    end
    
    if value then
      local args = {}
      if true --[[condition and SS == "HP" and getObjectFromGUID(SearchDie("Life").call("CheckCurrentHP", {condition = condition}))]] then
        args = {
          value = not remove and value or 0,
          id = "outfit" .. (enumSpecial[skills] or enumStatus[skills] or enumSkills[skills] or enumLimb[skills]),
          playerColor = "Black"
        }
        if enumLimb[skills] then
          getObjectFromGUID(locGUID).call("ChangeSkillsDT", args)
        else
          getObjectFromGUID(locGUID).call("ChangeSkills", args)
        end
      else
        print("Условие не прошло")
      end
    end
  end
end
function FindDependentVariables()
  local findText = ""
  for i = 1, #tableItems do
    findText = tableItems[i].description:find("Эффекты")
    if findText then
      ChangeDependentVariables(tableItems[i].description:sub(findText))
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
  if #assets == 0 then
    local backG = 'https://i.imgur.com/WQiHEAd.png'
    table.insert(assets, {name = 'uiBackGroundW', url = backG})
  end
  self.UI.setCustomAssets(assets)
end
