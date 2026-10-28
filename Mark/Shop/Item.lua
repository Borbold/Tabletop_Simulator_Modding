itemCost, itemCostDiscount = nil, nil
thingsInBasket, countItem = {}, 0
coinPouch = nil

local BUTTON_SIZE   = 250    -- мировой размер кнопки
local BUTTON_MARGIN = 0.08   -- отступ кнопки от края предмета
local BUTTON_LIFT   = 0.1    -- подъём кнопки над поверхностью

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

-- Кнопка всегда в углу предмета и всегда одного мирового размера:
-- позиция берётся от габаритов, размер делится на масштаб объекта.
-- cornerSign = 1 — угол (+X +Z), cornerSign = -1 — противоположный.
local function createCornerButton(cornerSign, handler, tooltip, color)
    local scale = self.getScale()
    local sx = (scale.x ~= 0) and scale.x or 1
    local sz = (scale.z ~= 0) and scale.z or 1

    local bounds = self.getBoundsNormalized()
    local size = bounds and bounds.size or nil

    local halfX = ((size and size.x) or 1.5) * 0.5 + BUTTON_MARGIN
    local halfZ = ((size and size.z) or 1.5) * 0.5 + BUTTON_MARGIN
    local topY  = ((size and size.y) or 0) + BUTTON_LIFT
    local side  = BUTTON_SIZE / ((sx + sz) * 0.5)

    self.createButton({
        click_function = handler,
        function_owner = self,
        position = {halfX * cornerSign, topY, halfZ * cornerSign},
        width = side,
        height = side,
        color = color,
        tooltip = tooltip,
    })
end

function CreateButton(itemC)
    itemCost = tonumber(itemC)
    itemCostDiscount = nil
    if(itemCost == nil) then return end

    self.clearButtons()
    -- индекс 0 — кнопка покупки, её tooltip правят GiveDiscountItem и EndTrade
    createCornerButton(1, "SelectItem", "Buy for "..itemCost, {1, 0.9, 0.9, 1})
    createCornerButton(-1, "ClearLuaScript", "Remove a script from this object", {1, 0, 0, 0.5})
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

    -- локальная переменная переименована, чтобы не перекрывать функцию availableMoney()
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
end

function SelectItem(obj, playerColor, altClick)
    if(altClick) then
        RefundLast(playerColor)
    else
        Buy(playerColor)
    end
end