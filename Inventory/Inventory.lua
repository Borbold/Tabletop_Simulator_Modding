function UpdateSave()
  local dataToSave = {
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    Wait.time(|| Confer(savedData), 0.4)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  ChangeUI()
end

function onCollisionEnter(info)
  if info.collision_object.getPosition().y < self.getPosition().y then return end

  local newObject = info.collision_object
  destroyObject(info.collision_object)
  
  local cusAss = self.UI.getCustomAssets()
  table.insert(cusAss, {name = 'testICON', url = newObject.getCustomObject().image})
  self.UI.setCustomAssets(cusAss)
  Wait.time(|| self.UI.setAttribute("testID", "icon", "testICON"), 0.01)
  
  local newName = newObject.getName()
  
  local newDescription = newObject.getDescription()
  if newDescription:find("Эффекты") then
    
  end
end

function RemoveItem(player, _, id)
  if not id or not self.UI.getAttribute(id, "icon") then return end

  local nameIcon = self.UI.getAttribute("testID", "icon")
  local cusAss = self.UI.getCustomAssets()
  local urlIcon
  for i,v in ipairs(cusAss) do
    if v.name == nameIcon then
      urlIcon =  v.url
      break
    end
  end
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
  newObject.setCustomObject({image = urlIcon})

  Wait.time(|| self.UI.setAttribute("testID", "icon", ""), 0.01)
end

function ChangeUI()
  UpdateSave()
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
