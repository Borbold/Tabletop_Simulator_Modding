function UpdateSave()
  local dataToSave = {
    ["tableItems"] = tableItems,
    ["infoGUID"] = infoGUID,
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    enumSkills = {
      сила = 1,
      восприятие = 2,
      выносливость = 3,
      харизма = 4,
      интелект = 5,
      ловкость = 6,
      удача = 7,
    }
    Wait.time(|| Confer(savedData), 0.4)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  tableItems = loadedData.tableItems or {}
  infoGUID = loadedData.infoGUID
  ChangeUI()
end

function onCollisionEnter(info)
  if info.collision_object.getPosition().y < self.getPosition().y then return end

  local newObject = info.collision_object
  destroyObject(info.collision_object)
  
  local cusAss = self.UI.getCustomAssets()
  table.insert(cusAss, {name = 'testICON', url = newObject.getCustomObject().image})
  self.UI.setCustomAssets(cusAss)

  Wait.time(function()
    self.UI.setAttribute("testID", "icon", "testICON")
    self.UI.setAttribute("testID", "iconColor", "#ffffffff")
  end, 0.01)
  
  local newName = newObject.getName()
  local newDescription = newObject.getDescription()
  local newUrlImage = newObject.getCustomObject().image
  
  tableItems["testID"] = {newName, newDescription, newUrlImage}
  local findText = newDescription:find("Эффекты")
  if findText then
    ChangeDependentVariables(newDescription:sub(findText))
  end
  UpdateSave()
end
function RemoveItem(player, _, id)
  if not id or not self.UI.getAttribute(id, "icon") or self.UI.getAttribute(id, "icon") == '' then return end

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
  local currentDescription = {}
  for word in description:gmatch("%S+") do
    table.insert(currentDescription, word)
  end
  
  local value, skills
  for i,v in ipairs(currentDescription) do
    if enumSkills[v] then
      skills = v
      value = tonumber(currentDescription[i - 1])
    end
  end

  if value then
    local args = {}
    if value > 0 then
      args = {
        value = not remove and value or -value, id = "baff" .. enumSkills[skills], playerColor = "Black"
      }
    else
      args = {
        value = not remove and math.abs(value) or -math.abs(value), id = "debaff" .. enumSkills[skills], playerColor = "Black"
      }
    end
    getObjectFromGUID(infoGUID).call("ChangeSkills", args)
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
