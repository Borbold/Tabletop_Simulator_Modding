itemCost, itemCostDiscount = nil, nil
thingsInBasket, countItem = {}, 0
coinPouch = nil

local BUTTON_SIZE   = 250    -- размер кнопки
local BUTTON_OUT    = -0.2   -- вынос кнопки за угол предмета (мировые единицы)
local BUTTON_LIFT   = 0.05   -- подъём кнопки над предметом

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

local function SaveItemState()
    self.script_state = JSON.encode({
        ["itemCost"] = itemCost,
        ["stockLeft"] = stockLeft,
        ["pouchGUID"] = isAlive(coinPouch) and coinPouch.getGUID() or nil,
    })
end

-- Угол предмета: считаем в мировых координатах, затем переводим в локальные
-- (снимаем поворот и масштаб). cornerSign = 1 — угол (+X +Z), -1 — противоположный.
local function cornerLocalPosition(cornerSign)
    local bounds = self.getBounds()
    local rot    = self.getRotation()
    local scale  = self.getScale()

    local sx = (scale.x ~= 0) and scale.x or 1
    local sy = (scale.y ~= 0) and scale.y or 1
    local sz = (scale.z ~= 0) and scale.z or 1

    local worldCorner = bounds.center + Vector(
        (bounds.size.x * 0.5 + BUTTON_OUT) * cornerSign,
         bounds.size.y * 0.5 + BUTTON_LIFT,
        (bounds.size.z * 0.5 + BUTTON_OUT) * cornerSign)

    local offset = worldCorner - self.getPosition()
    offset = offset:rotateOver("y", -rot.y)

    return {offset.x / sx, offset.y / sy, offset.z / sz}
end

local function createCornerButton(cornerSign, handler, tooltip, color)
    local scale = self.getScale()
    local sx = (scale.x ~= 0) and scale.x or 1
    local sz = (scale.z ~= 0) and scale.z or 1
    local side = BUTTON_SIZE / ((sx + sz) * 0.5)

    self.createButton({
        click_function = handler,
        function_owner = self,
        position = cornerLocalPosition(cornerSign),
        width = side,
        height = side,
        color = color,
        tooltip = tooltip,
    })
end

function CreateButton(data)
    itemCost = tonumber(data.c)
    itemCostDiscount = nil
    if(itemCost == nil) then return end

    stockLeft = tonumber(data.s)
    if stockLeft == nil then
        local m = (self.getGMNotes() or ""):match("stock:%s*(%d+)")
        stockLeft = m and tonumber(m) or 1
    end
    if stockLeft <= 0 then return end

    self.clearButtons()
    -- индекс 0 — кнопка покупки, её tooltip правят GiveDiscountItem и EndTrade
    createCornerButton(1, "SelectItem", "Buy for "..itemCost, {1, 0.9, 0.9, 1})
    --createCornerButton(-1, "ClearLuaScript", "Remove a script from this object", {1, 0, 0, 0.5})
    SaveItemState()
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

function onLoad(savedData)
    thingsInBasket, countItem = {}, 0
    coinPouch, itemCostDiscount, stockLeft = nil, nil, nil

    local data = (savedData ~= nil and savedData ~= "") and JSON.decode(savedData) or nil
    if data ~= nil then
        itemCost = tonumber(data.itemCost)
        stockLeft = tonumber(data.stockLeft)
        if data.pouchGUID ~= nil then
            local pouch = getObjectFromGUID(data.pouchGUID)
            if isAlive(pouch) then coinPouch = pouch end
        end
    end

    if itemCost == nil then return end
    -- getBounds() в onLoad может вернуть нули, ждём кадр
    Wait.frames(function()
        if not isAlive(self) then return end
        self.clearButtons()
        if stockLeft == nil or stockLeft > 0 then
            createCornerButton(1, "SelectItem", "Buy for "..price(), {1, 0.9, 0.9, 1})
        end
    end, 2)
end

-- params.discount — процент, может прийти строкой
function GiveDiscountItem(parametrs)
    if(itemCost == nil or parametrs == nil) then return end
    local percent = tonumber(parametrs.discount) or 0
    itemCostDiscount = math.floor((itemCost + itemCost*percent/100)*100 + 0.5)/100
    self.editButton({index = 0, tooltip = "Buy for "..itemCostDiscount})
    SaveItemState()
end

function EndTrade()
    thingsInBasket, countItem = {}, 0
    itemCostDiscount = nil
    if(itemCost ~= nil) then
        self.editButton({index = 0, tooltip = "Buy for "..itemCost})
        createCornerButton(1, "SelectItem", "Buy for "..itemCost, {1, 0.9, 0.9, 1})
    end
    SaveItemState()
end

function SetCoinPouchGUID(parametrs)
    if(parametrs == nil) then return end
    local coinPouchGUID = parametrs.guid
    if(coinPouchGUID == nil or coinPouchGUID == "") then
        coinPouch = nil
    else
        coinPouch = getObjectFromGUID(coinPouchGUID)
    end
    SaveItemState()
end

local function SpawnNewItemObject(paid)
    local selfPosition = coinPouch.getPosition()
    local selfScale    = self.getScale()
    local sx = (selfScale.x ~= 0) and selfScale.x or 1
    local sy = (selfScale.y ~= 0) and selfScale.y or 1
    local sz = (selfScale.z ~= 0) and selfScale.z or 1

    local spawnParametrs = {
        json = self.getJSON(),
        position = {x = selfPosition.x, y = selfPosition.y + 2 + countItem * sy, z = selfPosition.z - coinPouch.getBounds().size.z - 2.5 * sz},
        -- масштаб покупаемого предмета, а не сброс в 1
        scale = {x = sx, y = sy, z = sz},
        sound = false,
        snap_to_grid = true,
    }
    local spawnItem = spawnObjectJSON(spawnParametrs)
    spawnItem.setLuaScript("")
    -- храним ровно уплаченную сумму вместе с копией
    table.insert(thingsInBasket, {obj = spawnItem, paid = paid, source = self})
    countItem = countItem + 1
end

local function RefundItem(playerColor)
    if(countItem <= 0) then
        broadcastToColor("{ru}Корзина пуста{en}The basket is empty", playerColor)
        return
    end

    local entryIndex = nil
    for i = #thingsInBasket, 1, -1 do
        if thingsInBasket[i].source == self then entryIndex = i break end
    end
    if entryIndex == nil then
        broadcastToColor("{ru}Этот предмет ещё не куплен{en}This item has not been bought yet", playerColor)
        return
    end

    if not isAlive(coinPouch) then
        broadcastToColor("{ru}Нет кошелька для возврата{en}No pouch to refund to", playerColor)
        return
    end

    local entry = table.remove(thingsInBasket, entryIndex)
    countItem = #thingsInBasket
    coinPouch.call("UpdateCountMoney", {value = entry.paid})
    if isAlive(entry.obj) then destroyObject(entry.obj) end

    broadcastToColor("{ru}Вы отказались от товара{en}You refused the goods", playerColor)
    broadcastToColor("{ru}Сейчас у вас: {en}Now you have: "..tostring(availableMoney() or "?"), playerColor)
end

local function Buy(playerColor)
    if not isAlive(coinPouch) then
        broadcastToColor("{ru}А чем расплачиваться собрались?{en}What are you gonna pay with?", playerColor)
        return
    end

    local cost = price()
    if(cost == nil) then
        broadcastToColor("{ru}У предмета не задана цена{en}This item has no price set", playerColor)
        return
    end

    local money = availableMoney()
    if(money == nil) then
        broadcastToColor("{ru}Кошелёк не отвечает{en}The pouch is not responding", playerColor)
        return
    end

    -- проверяем по той же цене, по которой списываем
    if(cost > money) then
        broadcastToColor("{ru}Вам не хватает средств{en}You're short on funds", playerColor)
        return
    end

    coinPouch.call("UpdateCountMoney", {value = -cost})
    broadcastToColor("{ru}Вы приобрели товар{en}You have purchased an item", playerColor)
    broadcastToColor("{ru}У вас осталось: {en}You have some left: "..tostring(availableMoney() or "?"), playerColor)
    SpawnNewItemObject(cost)
    stockLeft = (stockLeft or 1) - 1
    SaveItemState()
    if stockLeft <= 0 then
        self.clearButtons()
        broadcastToColor("{ru}Это был последний экземпляр{en}That was the last one", playerColor)
    end
end

function SelectItem(obj, playerColor, altClick)
    if(altClick) then
        RefundItem(playerColor)
    else
        Buy(playerColor)
    end
end