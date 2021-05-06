function UpdateSave()
  local dataToSave = {
    ["tableItems"] = tableItems,
    ["infoGUID"] = infoGUID, ["statusGUID"] = statusGUID, ["skillsGUID"] = skillsGUID
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    enumSpecial = {
      сила = 1,
      восприятие = 2,
      выносливость = 3,
      харизма = 4,
      интелект = 5,
      ловкость = 6,
      удача = 7,
    }
    enumStatus = {
      реакция = 1,
      к_брони = 2,
      п_урона = 3,
      с_урону = 4,
      с_э_урону = 5,
      с_радиации = 6,
      с_ядам = 7,
      шанс_крита = 8,
    }
    enumSkills = {
      л_оружие = 1,
      т_оружие = 2,
      э_оружие = 3,
      б_оружие = 4,
      х_оружие = 5,
      метание = 6,
      п_помощь = 7,
      доктор = 8,
      натуралист = 9,
      пилот = 10,
      скрытность = 11,
      взлом = 12,
      кража = 13,
      ловушки = 14,
      наука = 15,
      ремонт = 16,
      красноречие = 17,
      бартер = 18,
      а_игры = 19,
    }
    Wait.time(|| Confer(savedData), 0.4)
    params = {
      click_function = "RemoveItem",
      function_owner = self,
      -- Если не сработает, пиши в label
      index = "testID",
      label          = "...",
      position       = {5.05, 0.2, 15.3},
      rotation       = {0, 180, 0},
      width          = 400,
      height         = 400,
      font_size      = 340,
      color          = {0.5, 0.5, 0.5},
      font_color     = {1, 1, 1},
      tooltip        = "[33ff33]This[ffffff] text appears on mouseover.",
    }
    self.createButton(params)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  tableItems = loadedData.tableItems or {}
  infoGUID = loadedData.infoGUID
  statusGUID = loadedData.statusGUID
  skillsGUID = loadedData.skillsGUID
  ChangeUI()
end

function onCollisionEnter(info)
  if info.collision_object.getPosition().y < self.getPosition().y then return end

  local newObject = info.collision_object
  destroyObject(info.collision_object)
  
  local cusAss = self.UI.getCustomAssets()
  table.insert(cusAss, {name = 'testICON', url = newObject.getCustomObject().image})
  self.UI.setCustomAssets(cusAss)
  
  
  local newName = newObject.getName()
  local newDescription = newObject.getDescription()
  Wait.time(function()
    self.UI.setAttribute("testID", "icon", "testICON")
    self.UI.setAttribute("testID", "iconColor", "#ffffffff")
    self.UI.setAttribute("testID", "tooltip", newName .. "\n" .. newDescription)
  end, 0.01)
  local newUrlImage = newObject.getCustomObject().image
  
  tableItems["testID"] = {newName, newDescription, newUrlImage}
  local findText = newDescription:find("Эффекты")
  if findText then
    ChangeDependentVariables(newDescription:sub(findText))
  end
  UpdateSave()
end
function RemoveItem(obj, color, alt_click)
  --if not id or not self.UI.getAttribute(id, "icon") or self.UI.getAttribute(id, "icon") == '' then return end

  print(obj.params.index) print(obj.params.label)
  
  local selfPosition = self.getPosition()
  local spawnParametrs = {
    type = "Custom_Tile",
    position = {x = selfPosition.x, y = selfPosition.y + 0.1, z = selfPosition.z - 4},
    rotation = {x = 0, y = 180, z = 0},
    scale = {x = 1, y = 1, z = 1},
    sound = false,
    snap_to_grid = true,
  }
  local newObject = spawnObject(spawnParametrs)
  newObject.setName(tableItems["testID"][1])
  newObject.setDescription(tableItems["testID"][2])
  newObject.setCustomObject({image = tableItems["testID"][3]})

  local findText = tableItems["testID"][2]:find("Эффекты")
  if findText then
    ChangeDependentVariables(tableItems["testID"][2]:sub(findText), true)
  end
  tableItems["testID"] = nil

  Wait.time(function()
    self.UI.setAttribute("testID", "icon", "")
    self.UI.setAttribute("testID", "iconColor", "#ffffff00")
  end, 0.01)
  UpdateSave()
end
function ChangeDependentVariables(description, remove)
  local infoGUID = infoGUID or SearchDie("Info")
  local statusGUID = statusGUID or SearchDie("Status")
  local skillsGUID = skillsGUID or SearchDie("Skills")

  local currentDescription = {}
  for word in description:gmatch("%S+") do
    table.insert(currentDescription, word)
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

function ChangeUI()
  UpdateSave()
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

function RebuildAssets()
  local backG = 'https://i.imgur.com/WQiHEAd.png'
  local example1 = 'https://cdn.discordapp.com/attachments/800324103848198174/838979483075608596/moto_glasses.png'
  local example2 = 'https://cdn.discordapp.com/attachments/800324103848198174/838979481347031070/red_mask.png'
  local assets = {
    {name = 'uiBackGroundW', url = backG},
    {name = 'example1', url = example1},
    {name = 'example2', url = example2},
  }
  self.UI.setCustomAssets(assets)
end
