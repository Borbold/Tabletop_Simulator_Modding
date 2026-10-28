itemCost, itemCostDiscount = nil, nil
thingsInBasket, countItem = {}, 0
coinPouch = nil

local function isAlive(obj)
    return obj ~= nil and tostring(obj) ~= "null"
end

local function price()
    return itemCostDiscount or itemCost
end

local function availableMoney()
    if not isAlive(coinPouch) then return nil end
    local ok, value = pcall(function() return coinPouch.call("GetAvailableMoney") end)
    if not ok then return nil end
    return tonumber(value)
end

function CreateButton(itemC)
    itemCost = tonumber(itemC)
    itemCostDiscount = nil
    if(itemCost == nil) then return end

    -- getCustomObject() может быть nil у не-кастомных объектов
    local custom = self.getCustomObject()
    local thickness = custom and custom["thickness"]
    local offsetY = (thickness and thickness + 0.05) or 0.15

    self.clearButtons()
    self.createButton({
        click_function = "SelectItem", function_owner = self,
        position = {0.75, offsetY, 0.75}, height = 250, width = 250,
        color = {1, 0.9, 0.9, 1}, tooltip = "Buy for "..itemCost
    })
    self.createButton({
        click_function = "ClearLuaScript", function_owner = self,
        position = {-0.75, offsetY, -0.75}, height = 250, width = 250,
        color = {1, 0, 0, 0.5}, tooltip = "Remove a script from this object"
    })
end

function ClearLuaScript(obj, color, altClick)
    if(color == "Black") then
        Wait.time(function()
            if not isAlive(self) then return end
            self.clearButtons() self.setLuaScript("")
            broadcastToColor("{ru}Скрипт удален.{en}The script is removed.", "Black")
        end, 1)
    end
end

function onLoad()
    thingsInBasket, countItem = {}, 0
    coinPouch, itemCostDiscount = nil, nil
end

-- params.discount — процент, может прийти строкой
function GiveDiscountItem(parametrs)
    if(itemCost == nil or parametrs == nil) then return end
    local percent = tonumber(parametrs.discount) or 0
    itemCostDiscount = math.floor((itemCost + itemCost*percent/100)*100 + 0.5)/100
    self.editButton({index = 0, tooltip = "Buy for "..itemCostDiscount})
end

function EndTrade()
    thingsInBasket, countItem = {}, 0
    itemCostDiscount = nil
    if(itemCost ~= nil) then
        self.editButton({index = 0, tooltip = "Buy for "..itemCost})
    end
end

function SetCoinPouchGUID(parametrs)
    if(parametrs == nil) then return end
    local coinPouchGUID = parametrs.guid
    if(coinPouchGUID == nil or coinPouchGUID == "") then
        coinPouch = nil
    else
        coinPouch = getObjectFromGUID(coinPouchGUID)
    end
end

local function SpawnNewItemObject(paid)
    local selfPosition = coinPouch.getPosition()
    local spawnParametrs = {
        json = self.getJSON(),
        position = {x = selfPosition.x - 2.5, y = selfPosition.y + countItem + 2, z = selfPosition.z},
        scale = {x = 1, y = 1, z = 1},
        sound = false,
        snap_to_grid = true,
    }
    local spawnItem = spawnObjectJSON(spawnParametrs)
    spawnItem.setLuaScript("")
    -- храним ровно уплаченную сумму вместе с копией
    table.insert(thingsInBasket, {obj = spawnItem, paid = paid})
    countItem = countItem + 1
end

local function RefundLast(playerColor)
    if(countItem <= 0) then
        broadcastToColor("{ru}Корзина пуста{en}The basket is empty", playerColor)
        return
    end
    if not isAlive(coinPouch) then
        broadcastToColor("{ru}Нет кошелька для возврата{en}No pouch to refund to", playerColor)
        return
    end

    local entry = thingsInBasket[countItem]
    if(entry == nil) then return end

    coinPouch.call("UpdateCountMoney", {value = entry.paid})
    if isAlive(entry.obj) then destroyObject(entry.obj) end
    table.remove(thingsInBasket, countItem)
    countItem = countItem - 1

    broadcastToColor("{ru}Вы отказались от товара{en}You refused the goods", playerColor)
    broadcastToColor("{ru}Сейчас у вас: {en}Now you have: "..tostring(availableMoney() or "?"), playerColor)
end

local function Buy(playerColor)
    if not isAlive(coinPouch) then
        broadcastToColor("{ru}А чем расплачиваться собрались?{en}What are you gonna pay with?", playerColor)
        return
    end

    local cost = price()
    if(cost == nil) then return end

    local availableMoney = availableMoney()
    if(availableMoney == nil) then
        broadcastToColor("{ru}Кошелёк не отвечает{en}The pouch is not responding", playerColor)
        return
    end

    -- проверяем по той же цене, по которой списываем
    if(cost > availableMoney) then
        broadcastToColor("{ru}Вам не хватает средств{en}You're short on funds", playerColor)
        return
    end

    coinPouch.call("UpdateCountMoney", {value = -cost})
    broadcastToColor("{ru}Вы приобрели товар{en}You have purchased an item", playerColor)
    broadcastToColor("{ru}У вас осталось: {en}You have some left: "..tostring(availableMoney() or "?"), playerColor)
    SpawnNewItemObject(cost)
end

function SelectItem(obj, playerColor, altClick)
    if(altClick) then
        RefundLast(playerColor)
    else
        Buy(playerColor)
    end
end