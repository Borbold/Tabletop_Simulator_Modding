function CreateButton(buyTooltip)
    self.createButton({
        click_function = "SelectItem", function_owner = self,
        position = {0.75, 0.15, 0.75}, height = 250, width = 250,
        color = {1, 0.9, 0.9, 1}, tooltip = buyTooltip
    })
    self.createButton({
        click_function = "ClearLuaScript", function_owner = self,
        position = {-0.75, 0.15, -0.75}, height = 250, width = 250,
        color = {1, 0, 0, 0.5}, tooltip = "Remove a script from this object"
    })
end
function ClearLuaScript(obj, color, altClick)
    if(color == "Black") then
        Wait.time(function()
            self.clearButtons() self.setLuaScript("")
            broadcastToColor("{ru}Скрипт удален.{en}The script is removed.", "Black")
        end, 1)
    end
end

function onLoad(savedData)
    itemCostDiscount = nil
    thingsInBasket, countItem, itemCost = {}, 0, -1
    
    if(self.getGMNotes():find("cost:")) then
        local findWord = "cost:"
        local gmnote = self.getGMNotes()
        local find = gmnote:find(findWord)
        itemCost = tonumber(gmnote:sub(find + #findWord + 1))
    else
        local loadedData = JSON.decode(savedData)
        itemCost = loadedData and loadedData.itemCost or -1
    end

    if(itemCost < 0) then
        print([[{ru}Предмету не задана стоимость(либо стоимость предмета ниже нуля) После задания стоимости пересоздайте магазин, дабы цена вступила в силу{en}The item has no value set (or the value of the item is below zero) After setting the value, recreate the store so that the price takes effect.]])
    else
        CreateButton("Buy for "..itemCost)
    end
end

function GiveDiscountItem(parametrs)
    itemCostDiscount = itemCost + itemCost*parametrs.discount/100
end

function EndTrade()
    thingsInBasket, countItem = {}, 0
    itemCostDiscount, coinPouch = nil, nil
end

function SetCoinPouchGUID(parametrs)
    local coinPouchGUID = parametrs.guid
    coinPouch = getObjectFromGUID(coinPouchGUID)
end

function SelectItem(obj, playerColor, altClick)
    if(altClick and countItem > 0) then
        if(CoinPouch) then
            coinPouch.call("UpdateCountMoney", {value = itemCostDiscount or itemCost})
            broadcastToColor("{ru}Вы отказались от товара{en}You refused the goods", playerColor)
            broadcastToColor("{ru}Сейчас у вас: {en}Now you have: " .. coinPouch.call("GetAvailableMoney"), playerColor)

            local delItem = thingsInBasket[countItem]
            destroyObject(delItem)
            table.remove(thingsInBasket, countItem)
            countItem = countItem - 1
        end
        return
    end
    if(coinPouch) then
        local availableMoney = coinPouch.call("GetAvailableMoney")
        if(coinPouch and itemCost <= availableMoney) then
            coinPouch.call("UpdateCountMoney", {value = -(itemCostDiscount or itemCost)})
            broadcastToColor("{ru}Вы приобрели товар{en}You have purchased an item", playerColor)
            broadcastToColor("{ru}У вас осталось: {en}You have some left: " .. coinPouch.call("GetAvailableMoney"), playerColor)

            SpawnNewItemObject()
        else
            broadcastToColor("{ru}Вам не хватает средств{en}You're short on funds", playerColor)
        end
    else
        broadcastToColor("{ru}А чем расплачиваться собрались?{en}What are you gonna pay with?", playerColor)
    end
end
function SpawnNewItemObject()
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
    table.insert(thingsInBasket, spawnItem)
    countItem = countItem + 1
end