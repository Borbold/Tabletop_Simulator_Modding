function UpdateSave()
  local dataToSave = {
    ["allStoresGUID"] = allStoresGUID
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  CreateGlobalVariable()
  if(savedData ~= "") then
    local loadedData = JSON.decode(savedData)
    allStoresGUID = loadedData.allStoresGUID or {}
    currentStoreId = #allStoresGUID ~= 0 and #allStoresGUID or 1
    if(currentStoreId > 0) then
      for _,storeGUID in ipairs(allStoresGUID) do
        local storeName = getObjectFromGUID(storeGUID).getName()
        Wait.time(|| XMLReplacementAdd(storeName), 0.3)
      end
    end
  end
end

function CreateGlobalVariable()
  WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Mark/Shop/Bag.lua", function(request)
    if request.is_error then
      log(request.error)
    else
      readyScriptUnderBag = request.text
    end
  end)
  WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Mark/Shop/Item.lua", function(request)
    if request.is_error then
      log(request.error)
    else
      readyScriptUnderItem = request.text
    end
  end)

  shopName = {
    tag = "Row",
    attributes = {
      preferredHeight = 80
    },
    children = {
      {
        tag = "Cell",
        attributes = {
        },
        children = {
          {
            tag = "InputField",
            attributes = {
              id = "storename",
              placeholder = "storename",
              text = "",
              color = "#1f1f1fda",
              textColor = "#ffffff",
              resizeTextForBestFit = "True",
              resizeTextMaxSize = "60",
              onEndEdit = "UpdateNameStore",
              tooltip = "Название магазина.",
              tooltipFontSize = "35",
              tooltipPosition = "Above",
              tooltipWidth = "400",
              tooltipOffset = "90"
            }
          }
        },
      }
    }
  }
  shopButton = {
    tag = "Row",
    attributes = {
      preferredHeight = 80
    },
    children = {
      {
        tag = "Cell",
        attributes = {
        },
        children = {
          {
            tag = "Button",
            attributes = {
              id = "up",
              text = "↑",
              resizeTextForBestFit = "True",
              resizeTextMaxSize = "60",
              onClick = "ShowcaseMerchandise"
            }
          },
          {
            tag = "Button",
            attributes = {
              id = "down",
              text = "↓",
              resizeTextForBestFit = "True",
              resizeTextMaxSize = "60",
              onClick = "HidecaseMerchandise"
            }
          },
          {
            tag = "Button",
            attributes = {
              id = "add",
              text = "+",
              resizeTextForBestFit = "True",
              resizeTextMaxSize = "60",
              onClick = "TestAddNewList",
              visibility = "Black"
            }
          },
          {
            tag = "Button",
            attributes = {
              id = "percent",
              text = "100%",
              resizeTextForBestFit = "True",
              resizeTextMaxSize = "60",
              onClick = "PercentageSubjects",
              tooltip = "Процентное отношение количества предметов, которое будет выложено в случайном порядке",
              tooltipFontSize = "35",
              tooltipWidth = "400",
              tooltipOffset = "90",
              visibility = "Black"
            }
          },
        },
      }
    }
  }

  showGUIDBag = ""

  allObjectsItemGUID = {}
  watchword = {"sell item", "coin pouch"}
  CoinPouchGUID = ""
  percentageStoreItem = {}
end

-- Хз как реализовать
function TestAddNewList(_, _, _)
  print("Пока в разработке")
end

function PercentageSubjects(_, _, idStoreGUID)
  local percent_t = self.UI.getAttribute(idStoreGUID, "text")
  local percent = tonumber(percent_t:sub(1, #percent_t - 1))
  percent = ((percent - 25) > 0 and (percent - 25)) or 100
  self.UI.setAttribute(idStoreGUID, "text", percent.."%")

  local id = tonumber(idStoreGUID:gsub("%D", ""))
  percentageStoreItem[allStoresGUID[id]] = percent
end

function onCollisionEnter(info)
  if(#watchword ~= 2 or info.collision_object.getPosition().y < self.getPosition().y) then return end

  local obj = info.collision_object
  if(obj.getGMNotes():lower():find(watchword[1])) then
    for _,v in ipairs(allObjectsItemGUID) do if(v == obj.getGUID()) then return end end
    table.insert(allObjectsItemGUID, obj.getGUID())
  elseif(obj.getGMNotes():lower():find(watchword[2])) then
    Wait.time(|| SetNumberCoinsObjects(info), 0.2)
  end
end
function onCollisionExit(info)
  if(info.collision_object.getPosition().y < self.getPosition().y) then return end

  local obj = info.collision_object
  if(allObjectsItemGUID and #allObjectsItemGUID > 0) then
    if(obj.getGMNotes():lower():find(watchword[1])) then
      for i, v in ipairs(allObjectsItemGUID) do
        if(v == obj.getGUID()) then
          table.remove(allObjectsItemGUID, i)
          break
        end
      end
    elseif(obj.getGMNotes():lower():find(watchword[2])) then
      Wait.time(|| SetNumberCoinsObjects(), 0.2)
    end
  end
end
function SetNumberCoinsObjects(info)
  CoinPouchGUID = (info and info.collision_object.getGUID()) or ""
  for _, guid in ipairs(allObjectsItemGUID) do
    Wait.time(|| SetCoinPouchGUIDIn(guid), 0.5)
  end
end
function SetCoinPouchGUIDIn(guidItem)
  getObjectFromGUID(guidItem).call("SetCoinPouchGUID", {guid = CoinPouchGUID})
end

function onObjectDestroy(info)
  DeleteItem(info.getGUID())
  DeleteBag(info.getGUID())
end
function DeleteItem(guid)
  for i, v in ipairs(allObjectsItemGUID) do
    if(v == guid) then
      table.remove(allObjectsItemGUID, i)
    end
  end
end
function DeleteBag(guid)
  local indexStoreId = 1
  for _, g in ipairs(allStoresGUID) do
    if(g == guid) then
      XMLReplacementDelete((indexStoreId - 1)*2 + 1)
      Wait.time(|| WasteRemoval(), 0.2)
      return
    end
    indexStoreId = indexStoreId + 1
  end
end
function WasteRemoval()
  local countBags = 0
  for index, guid in ipairs(allStoresGUID) do
    countBags = 1
    if(not getObjectFromGUID(guid)) then
      table.remove(allStoresGUID, index)
    end
  end
  if(countBags == 0) then currentStoreId = 1 end
  UpdateSave()
end

function CreateBag()
  if(#allObjectsItemGUID > 0) then
    Wait.time(|| CreateScriptInItem(), 0.5)
    Wait.time(|| PutObjectsInBag(), 0.8)
  end
end
function CreateScriptInItem()
  print("Adding scripts from item")
  for _, guid in ipairs(allObjectsItemGUID) do
    getObjectFromGUID(guid).setLuaScript(readyScriptUnderItem)
  end
  UpdateSave()
end
function PutObjectsInBag()
  local selfPosition = self.getPosition()
  local spawnParametrs = {
    type = "Bag",
    position = {x = selfPosition.x, y = selfPosition.y + 2, z = selfPosition.z - 7},
    rotation = {x = 0, y = 0, z = 0},
    scale = {x = 0.5, y = 0.5, z = 0.5},
    sound = false,
    snap_to_grid = true,
  }
  local locBoardObjectsPos, locBoardObjectsRot, locObjGUID = {}, {}, {}
  local spawnBag = spawnObject(spawnParametrs)
  Wait.time(|| CreateScriptInBag(spawnBag), 0.1)
  for _, v in ipairs(allObjectsItemGUID) do
    local locObj = getObjectFromGUID(v)

    spawnBag.putObject(locObj)

    table.insert(locBoardObjectsPos, locObj.getPosition() - self.getPosition())
    table.insert(locBoardObjectsRot, locObj.getRotation())
    Wait.time(|| table.insert(locObjGUID, locObj.getGUID()), 0.2)
  end
  Wait.time(function() table.insert(allStoresGUID, spawnBag.getGUID()) end, 0.3)
  Wait.time(|| SetObjMeta(spawnBag, locObjGUID, locBoardObjectsPos, locBoardObjectsRot), 0.4)
  Wait.time(|| XMLReplacementAdd(), 0.5)
  Wait.time(|| UpdateSave(), 0.6)
end
function CreateScriptInBag(bag)
  print("Adding scripts from bag")
  bag.setLuaScript(readyScriptUnderBag)
end
function SetObjMeta(bag, objGUID, locBoardObjectsPos, locBoardObjectsRot)
  local parametrs = {rotations = locBoardObjectsRot, positions = locBoardObjectsPos, objGUID = objGUID}
  bag.call("SetObjMetaBag", parametrs)
  showGUIDBag = ""
end

function ShowcaseMerchandise(player, _, id)
  local storeGUID = allStoresGUID[tonumber(id:gsub("%D", ""))]
  local store = getObjectFromGUID(storeGUID)
  if(store) then
    showGUIDBag = storeGUID
    GetObjectsBag(storeGUID, store)
  else
    print("Этот магазин был удален")
    local indexStoreId = 1
    for _, g in ipairs(allStoresGUID) do
      if(g == guid) then
        XMLReplacementDelete((indexStoreId - 1)*2 + 1)
        Wait.time(|| UpdateSave(), 0.2)
        break
      end
      indexStoreId = indexStoreId + 1
    end
  end
  UpdateSave()
end
function GetObjectsBag(storeGUID, store)
  local allObjMeta = store.call("GetObjectMetaBag")
  -- Нет ли разложенных вещей
  if(not next(allObjectsItemGUID)) then
    local currentCountItem = 0
    for idItem, meta in ipairs(allObjMeta) do
      local percentItemShow, countItem = 100, #allObjMeta
      if(percentageStoreItem[storeGUID]) then
        percentItemShow = percentageStoreItem[storeGUID]
      end
      if((math.random(1, 100) <= percentItemShow and currentCountItem < (countItem*percentItemShow)/100) or
          countItem - idItem + currentCountItem < (countItem*percentItemShow)/100) then
        local objGUID = meta[1]

        local locText, count = meta[2], 1
        local objPos = {}
        for digital in locText:gmatch("%S+") do
          table.insert(objPos, digital + self.getPosition()[count])
          count = count + 1
        end
        objPos[2] = self.getPosition().y + 0.5
      
        locText, count = meta[3], 1
        local objRot = {}
        for digital in locText:gmatch("%S+") do
          table.insert(objRot, digital)
          count = count + 1
        end

        local takeParametrs = {
          smooth = false,
          guid = objGUID,
          position = {x = objPos[1], y = objPos[2], z = objPos[3]},
          rotation = {x = objRot[1], y = objRot[2], z = 0}
        }
        store.takeObject(takeParametrs)
        currentCountItem = currentCountItem + 1
      end
      -- Пока хз, добавить это или нет
      --local storItem = store.takeObject(takeParametrs)
      --storItem.locked = true
      --print(storItem.locked)
    end
  end
end

function HidecaseMerchandise()
  local store = getObjectFromGUID(showGUIDBag)
  if(store) then
    local allObjMeta = store.call("GetObjectMetaBag")
    for _, objGUID in ipairs(allObjectsItemGUID) do
      for _, objMeta in ipairs(allObjMeta) do
        if(store and objGUID == objMeta[1] and showGUIDBag == objMeta[4]) then
          getObjectFromGUID(objGUID).call("EndTrade")
          store.putObject(getObjectFromGUID(objMeta[1]))
        end
      end
    end
  end
  self.UI.setAttribute("discountField", "text", "")
end

function UpdateNameStore(_, input, id)
  if(input == "") then return end

  self.UI.setAttribute(id, "text", input)
  Wait.time(|| UpdateSave(), 0.2)
  local detachedBag = getObjectFromGUID(allStoresGUID[tonumber(id:gsub("%D", ""))])
  if(detachedBag) then detachedBag.setName(input) end
end

function GiveDiscount(_, input)
  if(input and input == "") then return end

  local numInput = tonumber(input)
  if(numInput > 0) then
    broadcastToColor("The cost of the items has been increased by "..numInput.."%", "Black")
  else
    broadcastToColor("The cost of the items has been decreased by "..math.abs(numInput).."%", "Black")
  end

  for _,guid in pairs(allObjectsItemGUID) do
    local item = getObjectFromGUID(guid)
    if(item) then
      item.call("GiveDiscountItem", {discount = input})
    else
      print("Какие то проблемы с выдачей скидки")
    end
  end
end

function XMLReplacementAdd(storeName)
  local xmlTable, desiredTable = {}, false
  xmlTable = self.UI.getXmlTable()
  for _,xml in pairs(xmlTable) do
	  for _,parent in pairs(xml) do
      if(type(parent) == "table") then
        for _,children in pairs(parent) do
          if(type(children) == "table") then
            for _,child in pairs(children) do
              if(type(child) == "table") then
                for _,ch in pairs(child) do
                  if(type(ch) == "table") then
                    for title,attribute in pairs(ch) do
                      if(attribute["id"] and attribute["id"]:find("tableLayoutShop")) then
                        desiredTable = true
                      end
                      if(desiredTable and title == "children") then
                        local id = shopName.children[1].children[1].attributes.id
                        shopName.children[1].children[1].attributes.id = id..currentStoreId
                        shopName.children[1].children[1].attributes.text = storeName or ""
                        table.insert(attribute, shopName)

                        for i = 1, 4 do
                          local id = shopButton.children[1].children[i].attributes.id
                          shopButton.children[1].children[i].attributes.id = id..currentStoreId
                        end
                        table.insert(attribute, shopButton)
                        self.UI.setXmlTable(xmlTable)
                        desiredTable = false

                        currentStoreId = currentStoreId + 1
                        Wait.time(function() ReturnDefault() EnlargeHeightPanelStat(currentStoreId) UpdateSave() end, 0.2)
                        return
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
function XMLReplacementDelete(storeId)
  local xmlTable, desiredTable = {}, false
  xmlTable = self.UI.getXmlTable()
  for _,xml in pairs(xmlTable) do
	  for _,parent in pairs(xml) do
      if(type(parent) == "table") then
        for _,children in pairs(parent) do
          if(type(children) == "table") then
            for _,child in pairs(children) do
              if(type(child) == "table") then
                for _,ch in pairs(child) do
                  if(type(ch) == "table") then
                    for title,attribute in pairs(ch) do
                      if(attribute["id"] and attribute["id"]:find("tableLayoutShop")) then
                        desiredTable = true
                      end
                      if(desiredTable and title == "children") then
                        table.remove(attribute, storeId)
                        table.remove(attribute, storeId)
                        self.UI.setXmlTable(xmlTable)
                        desiredTable = false

                        currentStoreId = currentStoreId - 1
                        Wait.time(|| UpdateSave(), 0.2)
                        return
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

function EnlargeHeightPanelStat(countStatisticIndex)
  if(countStatisticIndex > 8) then
    local cellSpacing = self.UI.getAttribute("tableLayoutShop", "cellSpacing")
    local preferredHeight = shopName.attributes.preferredHeight + shopButton.attributes.preferredHeight
    local newHeightPanel = countStatisticIndex*preferredHeight + countStatisticIndex*cellSpacing
    Wait.time(|| self.UI.setAttribute("tableLayoutShop", "height", newHeightPanel), 0.2)
  end
end
function ReturnDefault()
  shopName.children[1].children[1].attributes.id = "storename"
  shopButton.children[1].children[1].attributes.id = "up"
  shopButton.children[1].children[2].attributes.id = "down"
  shopButton.children[1].children[3].attributes.id = "add"
  shopButton.children[1].children[4].attributes.id = "percent"
end