local function isAlive(obj)
    return obj ~= nil and tostring(obj) ~= "null"
end

local function findNodeById(node, id)
    if type(node) ~= "table" then return nil end
    if type(node.attributes) == "table" and node.attributes.id == id then return node end
    if type(node.children) == "table" then
        for _, child in ipairs(node.children) do
            local found = findNodeById(child, id)
            if found ~= nil then return found end
        end
    end
    return nil
end

local ROW_HEIGHT, ROW_SPACING = 80, 5

function UpdateSave()
    local dataToSave = {
        ["allStoresGUID"] = allStoresGUID
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

function onLoad(savedData)
    CreateGlobalVariable()
    local loadedData = (savedData ~= nil and savedData ~= "") and JSON.decode(savedData) or nil
    allStoresGUID = (loadedData and loadedData.allStoresGUID) or {}
    Wait.time(function()
        ValidateStores()
        RebuildStoreRows()
    end, 0.3)
    StartHousekeeping()
end

function CreateGlobalVariable()
    allStoresGUID = {}
    readyScriptUnderItem, readyScriptUnderBag = "", ""
    Wait.time(function()
      WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Mark/Shop/Item.lua", function(request)
        if request.is_error then
            log(request.error)
        else
          readyScriptUnderItem = request.text
        end
      end)
      WebRequest.get("https://raw.githubusercontent.com/Borbold/Fallout_System/refs/heads/main/Mark/Shop/Bag.lua", function(request)
        if request.is_error then
            log(request.error)
        else
          readyScriptUnderBag = request.text
        end
      end)
    end, 1)

    --[[local headers = {
        ["Content-Type"] = "application/json",
        Accept = "application/json",
    }
    Wait.time(function()
      WebRequest.custom("https://github.com/Borbold/Fallout_System/blob/main/Mark/Shop/Item.lua", "GET", true, nil, headers, function(requestItem)
          if requestItem.is_error then
              print("Request item failed: " .. requestItem.error)
              return
          end

          local responseData = JSON.decode(requestItem.text)
          for i,v in ipairs(responseData.payload.blob.rawLines) do
            readyScriptUnderItem = readyScriptUnderItem..v.."\n"
          end

          if(requestItem.is_done) then
            WebRequest.custom("https://github.com/Borbold/Fallout_System/blob/main/Mark/Shop/Bag.lua", "GET", true, nil, headers, function(requestBag)
              if requestBag.is_error then
                  print("Request bag failed: " .. requestBag.error)
                  return
              end

              local responseData = JSON.decode(requestBag.text)
              for i,v in ipairs(responseData.payload.blob.rawLines) do
                readyScriptUnderBag = readyScriptUnderBag..v.."\n"
              end
            end)
          end
      end)
    end, 1)]]

    allObjectsItemGUID = {}
    watchTag = {"sell item", "coin pouch"}
    CoinPouchGUID = ""
end

function AddNewItem(_, _, id)
    CreateBag(nil, nil, nil, StringInNumber(id))
end

function PercentageSubjects(_, _, id)
    local percent = StringInNumber(self.UI.getAttribute(id, "text")) or 100
    percent = percent - 25
    if percent <= 0 then percent = 100 end
    self.UI.setAttribute(id, "text", percent.."%")
end

function onCollisionEnter(info)
    local obj = info and info.collision_object
    if obj == nil or tostring(obj) == "null" then return end
    if(obj.getPosition().y < self.getPosition().y) then return end

    if(obj.hasTag(watchTag[1])) then
      AddItemGuid(obj.getGUID())
    elseif(obj.hasTag(watchTag[2])) then
      Wait.time(|| SetNumberCoinsObjects(obj.getGUID()), 0.2)
    end
    obj.addTag("Picked object shop")
end

function onObjectPickUp(_, obj)
    if obj == nil or tostring(obj) == "null" then return end
    -- тег снимаем всегда, иначе он залипает на предмете
    local wasWatched = obj.hasTag("Picked object shop")
    obj.removeTag("Picked object shop")
    if(not wasWatched or obj.getPosition().y < self.getPosition().y) then return end

    if(obj.hasTag(watchTag[1])) then
      DeleteItem(obj.getGUID())
    elseif(obj.hasTag(watchTag[2])) then
      Wait.time(|| SetNumberCoinsObjects(""), 0.2)
    end
end

function SetNumberCoinsObjects(pouchGUID)
    for _, g in ipairs(allObjectsItemGUID) do
      local item = getObjectFromGUID(g)
      if isAlive(item) then
        Wait.time(function()
          if isAlive(item) then
            item.call("SetCoinPouchGUID", {guid = pouchGUID})
          end
        end, 0.5)
      end
    end
end

local function handleDestroyed(guid)
    if guid == nil then return end
    DeleteItem(guid)
    DeleteBag(guid)
end

function onObjectDestroy(info)
    handleDestroyed(info ~= nil and info.getGUID ~= nil and info.getGUID() or self.getGUID())
end

function onDestroy()
    handleDestroyed(self.getGUID())
end

function DeleteItem(guid)
    for i, v in ipairs(allObjectsItemGUID) do
      if(v == guid) then
        table.remove(allObjectsItemGUID, i)
        break
      end
    end
end

function DeleteBag(guid)
    for index, g in ipairs(allStoresGUID) do
      if(g == guid) then
        table.remove(allStoresGUID, index)
        UpdateSave()
        RebuildStoreRows()
        break
      end
    end
end

function CreateBag(_, _, _, id)
  if(id == nil or id == "") then id = nil
  else
    id = StringInNumber(id)
    if not isAlive(getObjectFromGUID(allStoresGUID[id] or "")) then id = nil end
  end

  if(#allObjectsItemGUID == 0) then
    broadcastToColor("На доске нет предметов для упаковки.", "Black")
    return
  end

  Wait.time(|| CreateScriptInItem(), 0.5)
  Wait.time(|| PutObjectsInBag(id), 0.8)
end

function CreateScriptInItem()
  print("Adding scripts from item")
  if(readyScriptUnderItem == "") then print("Item.lua ещё не загружен") return end
  for _, guid in ipairs(allObjectsItemGUID) do
    getObjectFromGUID(guid).setLuaScript(readyScriptUnderItem)
  end
end

function PutObjectsInBag(id)
  local spawnBag = nil
  if(id == nil) then
    local selfPosition = self.getPosition()
    local spawnParametrs = {
      type = "Bag",
      position = {x = selfPosition.x, y = selfPosition.y + 2, z = selfPosition.z - 7},
      rotation = {x = 0, y = 0, z = 0},
      scale = {x = 0.5, y = 0.5, z = 0.5},
      sound = false,
      snap_to_grid = true,
    }
    spawnBag = spawnObject(spawnParametrs)
    Wait.time(|| CreateScriptInBag(spawnBag), 0.2)
    Wait.time(function() table.insert(allStoresGUID, spawnBag.getGUID()) UpdateSave() RebuildStoreRows() end, 0.3)
  else
    spawnBag = getObjectFromGUID(allStoresGUID[id] or "")
    if not isAlive(spawnBag) then
      broadcastToColor("Магазин #"..id.." не найден.", "Black")
      return
    end
  end

  local boardPos = self.getPosition()
  local locBoardObjectsPos, locBoardObjectsRot, locObjGUID = {}, {}, {}
  for _, v in ipairs(allObjectsItemGUID) do
    local locObj = getObjectFromGUID(v)
    if isAlive(locObj) then
      -- координаты снимаем ДО перемещения в мешок
      local locPos = locObj.getPosition() - boardPos
      local locRot = locObj.getRotation()

      table.insert(locObjGUID, v)
      table.insert(locBoardObjectsPos, {x = locPos.x, y = locPos.y, z = locPos.z})
      table.insert(locBoardObjectsRot, {x = locRot.x, y = locRot.y, z = locRot.z})

      spawnBag.putObject(locObj)
    end
  end
  Wait.time(function()
    if not isAlive(spawnBag) then return end
    SetObjMeta(spawnBag, locObjGUID, locBoardObjectsPos, locBoardObjectsRot)
  end, 0.4)

  -- список больше не «залипает» на уже упакованных предметах
  allObjectsItemGUID = {}
end

function CreateScriptInBag(bag)
  print("Adding scripts from bag")
  if not isAlive(bag) then return end
  if(readyScriptUnderBag == "") then print("Bag.lua ещё не загружен") return end
  bag.setLuaScript(readyScriptUnderBag)
end

function SetObjMeta(bag, objGUID, locBoardObjectsPos, locBoardObjectsRot)
  local parametrs = {rotations = locBoardObjectsRot, positions = locBoardObjectsPos, objGUID = objGUID}
  bag.call("SetObjMetaBag", parametrs)
end

function ShowcaseMerchandise(_, _, id)
  local storeIndex = StringInNumber(id)
  local store = getObjectFromGUID(allStoresGUID[storeIndex] or "")
  if not isAlive(store) then
    broadcastToColor("Магазин #"..tostring(storeIndex).." не найден.", "Black")
    return
  end

  -- Нет ли разложенных вещей
  if(next(allObjectsItemGUID)) then
    broadcastToColor("На доске уже разложены предметы.", "Black")
    return
  end

  local allObjMeta = store.call("GetObjectMetaBag") or {}
  if(#allObjMeta == 0) then
    broadcastToColor("В магазине нет товаров.", "Black")
    return
  end

  -- что реально лежит в мешке
  local inBag = {}
  for _, obj in ipairs(store.getObjects()) do
    if obj ~= nil then inBag[obj.getGUID()] = true end
  end

  local pool = {}
  for i = 1, #allObjMeta do
    if inBag[allObjMeta[i][1]] then table.insert(pool, i) end
  end
  if(#pool == 0) then
    broadcastToColor("Все товары уже разложены.", "Black")
    return
  end

  -- честное перемешивание, без линейных проб и зацикливания
  for i = #pool, 2, -1 do
    local j = math.random(1, i)
    pool[i], pool[j] = pool[j], pool[i]
  end

  local percentItemShow = StringInNumber(self.UI.getAttribute("percent"..storeIndex, "text")) or 100
  local count = math.max(1, math.ceil(#pool*percentItemShow/100))
  local boardPos = self.getPosition()

  for k = 1, math.min(count, #pool) do
    local meta = allObjMeta[pool[k]]
    local objGUID = meta[1]

    local objPos = {}
    for digital in meta[2]:gmatch("%S+") do
      table.insert(objPos, tonumber(digital))
    end

    local objRot = {}
    for digital in meta[3]:gmatch("%S+") do
      table.insert(objRot, tonumber(digital))
    end

    local takeParametrs = {
      smooth = false,
      guid = objGUID,
      position = {x = objPos[1] + boardPos.x, y = objPos[2] + boardPos.y, z = objPos[3] + boardPos.z},
      rotation = {x = objRot[1], y = objRot[2], z = objRot[3]},
    }
    store.takeObject(takeParametrs)
    AddItemGuid(objGUID)
    ItemLeaveContainer(store, objGUID)
  end
end

function ItemLeaveContainer(container, guid)
    Wait.time(function()
        local item = getObjectFromGUID(guid)
        if not isAlive(item) then return end

        local itemCost = nil
        local notes = item.getGMNotes() or ""
        if(notes:find("cost:")) then
            local value = notes:match("cost:%s*(-?%d+%.?%d*)")
            itemCost = value and tonumber(value) or nil
        else
            local info = container.call("GetCostItem", item.getName())
            if(info ~= nil and info.itemCost ~= nil) then
                itemCost = info.itemCost
                if(info.descObj ~= nil and info.descObj ~= "") then
                    item.setDescription(info.descObj)
                end
            end
        end

        if(itemCost == nil or itemCost < 0) then
            print([[{ru}Предмету не задана стоимость(либо стоимость предмета ниже нуля) После задания стоимости пересоздайте магазин, дабы цена вступила в силу{en}The item has no value set (or the value of the item is below zero) After setting the value, recreate the store so that the price takes effect.]])
        else
          item.call("CreateButton", itemCost)
        end
    end, 0.5)
end

function HidecaseMerchandise(_, _, id)
  local store = getObjectFromGUID(allStoresGUID[StringInNumber(id)] or "")
  if not isAlive(store) then return end

  local allObjMeta = store.call("GetObjectMetaBag") or {}
  local known = {}
  for _, objMeta in ipairs(allObjMeta) do known[objMeta[1]] = true end

  local remaining = {}
  for _, objGUID in ipairs(allObjectsItemGUID) do
    local obj = getObjectFromGUID(objGUID)
    if isAlive(obj) and known[objGUID] then
      obj.call("EndTrade")
      store.putObject(obj)
    else
      -- предметы чужого магазина остаются на доске
      table.insert(remaining, objGUID)
    end
  end
  allObjectsItemGUID = remaining
  self.UI.setAttribute("discountField", "text", "")
end

function UpdateNameStore(player, input, id)
  if(player == nil or player.color ~= "Black") then return end
  self.UI.setAttribute(id, "text", input)
  local detachedBag = getObjectFromGUID(allStoresGUID[StringInNumber(id)] or "")
  if isAlive(detachedBag) then detachedBag.setName(input) end
end

function GiveDiscount(_, input)
  if(input == nil or input == "") then return end

  local numInput = tonumber(input)
  if(numInput == nil) then return end

  if(numInput > 0) then
    broadcastToColor("{ru}Стоимость предметов была увеличена на {en}The cost of the items has been increased by "..numInput.."%", "Black")
  else
    broadcastToColor("{ru}Стоимость предметов была уменьшена на {en}The cost of the items has been decreased by "..math.abs(numInput).."%", "Black")
  end

  for _,guid in ipairs(allObjectsItemGUID) do
    local item = getObjectFromGUID(guid)
    if isAlive(item) then
      item.call("GiveDiscountItem", {discount = numInput})
    else
      print("Error")
    end
  end
end

-- Полная пересборка строк: id всегда совпадает с индексом в allStoresGUID
function RebuildStoreRows()
    local xmlTable = self.UI.getXmlTable()
    local tableLayoutShop = findNodeById(xmlTable, "tableLayoutShop")
    if tableLayoutShop == nil then
        print("[Shop] в Shop.xml не найден узел id='tableLayoutShop'")
        return
    end

    tableLayoutShop.children = {}

    for storeId, storeGUID in ipairs(allStoresGUID) do
        local store = getObjectFromGUID(storeGUID)
        if isAlive(store) then
            table.insert(tableLayoutShop.children, BuildStoreNameRow(storeId, store.getName()))
            table.insert(tableLayoutShop.children, BuildStoreButtonRow(storeId))
        end
    end

    self.UI.setXmlTable(xmlTable)
    Wait.time(|| FitPanelHeight(#allStoresGUID), 0.2)
end

function BuildStoreNameRow(storeId, storeName)
    return {
      tag = "Row",
      attributes = {
        preferredHeight = ROW_HEIGHT
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
                id = "storename"..storeId,
                placeholder = "storename",
                text = storeName or "",
                color = "#1f1f1fda",
                textColor = "#ffffff",
                onEndEdit = "UpdateNameStore",
                tooltip = "Shop name",
                tooltipPosition = "Above",
                tooltipOffset = "90",
                tooltipWidth='180'
              }
            }
          },
        }
      }
    }
end

function BuildStoreButtonRow(storeId)
    local function makeButton(name, label, handler, extra)
        local attributes = {id = name..storeId, text = label, onClick = handler}
        for k, v in pairs(extra or {}) do attributes[k] = v end
        return {tag = "Button", attributes = attributes}
    end

    return {
      tag = "Row",
      attributes = {
        preferredHeight = ROW_HEIGHT
      },
      children = {
        {
          tag = "Cell",
          attributes = {
          },
          children = {
            makeButton("up", "↑", "ShowcaseMerchandise"),
            makeButton("down", "↓", "HidecaseMerchandise"),
            makeButton("add", "+", "AddNewItem", {
                tooltip = "Add new items to the store",
                tooltipPosition = "Right",
                tooltipOffset = "160",
                visibility = "Black"
            }),
            makeButton("percent", "100%", "PercentageSubjects", {
                tooltip = "Percentage of the number of items that will be laid out in random order",
                tooltipPosition = "Right",
                tooltipOffset = "60",
                visibility = "Black"
            }),
          },
        }
      }
    }
end

function FitPanelHeight(countStatisticIndex)
  if(countStatisticIndex > 3) then
    local cellSpacing = tonumber(self.UI.getAttribute("tableLayoutShop", "cellSpacing")) or ROW_SPACING
    local newHeightPanel = countStatisticIndex*ROW_HEIGHT*2 + countStatisticIndex*cellSpacing*2
    Wait.time(|| self.UI.setAttribute("tableLayoutShop", "height", newHeightPanel), 0.2)
  else
    self.UI.setAttribute("tableLayoutShop", "height", 510)
  end
end

function ValidateStores()
    local cleaned = {}
    for _, storeGUID in ipairs(allStoresGUID) do
        if isAlive(getObjectFromGUID(storeGUID)) then table.insert(cleaned, storeGUID) end
    end
    if(#cleaned ~= #allStoresGUID) then
        allStoresGUID = cleaned
        UpdateSave()
        RebuildStoreRows()
    end
end

function ValidateItems()
    local cleaned = {}
    for _, objGUID in ipairs(allObjectsItemGUID) do
        if isAlive(getObjectFromGUID(objGUID)) then table.insert(cleaned, objGUID) end
    end
    allObjectsItemGUID = cleaned
end

function AddItemGuid(guid)
    for _, v in ipairs(allObjectsItemGUID) do
        if(v == guid) then return end
    end
    table.insert(allObjectsItemGUID, guid)
end

-- Страховка: onObjectDestroy в объектном скрипте срабатывает не на все объекты
function StartHousekeeping()
    Wait.time(function()
        ValidateItems()
        ValidateStores()
    end, 5, -1)
end

function StringInNumber(str)
  return tonumber(str:gsub("%D", ""), 10)
end