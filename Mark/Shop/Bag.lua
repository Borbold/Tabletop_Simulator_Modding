local DEFAULT_PRICE_URL =
    "https://raw.githubusercontent.com/Borbold/Sugule-shop/refs/heads/main/Test.txt"

allObjMeta = {}

local priceIndex, priceRaw = {}, ""

function UpdateSave()
    local dataToSave = {
        ["allObjMeta"] = allObjMeta
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end

local function stripTags(str)
    return (str or ""):gsub("%[[^%]]*%]", "")
end

-- Формат прайса:
--   Название предмета
--   строка описания (сколько угодно)
--   cost: 12.5
local function buildPriceIndex()
    priceIndex = {}
    if(priceRaw == "") then return end

    local name, desc = nil, {}
    for line in priceRaw:gmatch("[^\r\n]+") do
        local trimmed = line:gsub("^%s+", ""):gsub("%s+$", "")
        if(trimmed ~= "") then
            local costValue = trimmed:match("^cost:%s*(-?%d+%.?%d*)")
            if(costValue ~= nil and name ~= nil) then
                priceIndex[name] = {
                    itemCost = tonumber(costValue),
                    descObj = table.concat(desc, "\n"),
                }
                name, desc = nil, {}
            elseif(name == nil) then
                name, desc = trimmed, {}
            else
                table.insert(desc, trimmed)
            end
        end
    end
end

-- Поддерживаем и «сырой» текст, и ответ GitHub API с rawLines
local function extractPriceText(text)
    if(text == nil) then return "" end
    if(text:sub(1, 1) == "{") then
        local ok, data = pcall(JSON.decode, text)
        if(ok and data ~= nil and data.payload ~= nil
           and data.payload.blob ~= nil and data.payload.blob.rawLines ~= nil) then
            return table.concat(data.payload.blob.rawLines, "\n")
        end
    end
    return text
end

local function loadPriceList(attempt)
    attempt = attempt or 1
    local webSite = self.getGMNotes() ~= "" and self.getGMNotes() or DEFAULT_PRICE_URL

    WebRequest.get(webSite, function(request)
        if(request.is_error or request.text == nil) then
            if(attempt < 3) then
                Wait.time(|| loadPriceList(attempt + 1), 2)
            else
                print("[Shop] не удалось загрузить прайс: "..webSite)
            end
            return
        end

        priceRaw = extractPriceText(request.text)
        buildPriceIndex()

        local count = 0
        for _ in pairs(priceIndex) do count = count + 1 end
        print("[Shop] прайс загружен, позиций: "..count)
    end)
end

function onLoad(savedData)
    local loadedData = (savedData ~= nil and savedData ~= "") and JSON.decode(savedData) or nil
    allObjMeta = loadedData and loadedData.allObjMeta or {}

    priceIndex, priceRaw = {}, ""
    loadPriceList()
end

function SetObjMetaBag(parametrs)
    if(parametrs == nil or parametrs.objGUID == nil) then return end
    for i = 1, #parametrs.objGUID do
        local pos, rot = parametrs.positions[i], parametrs.rotations[i]
        if(pos ~= nil and rot ~= nil) then
            table.insert(allObjMeta, {
                parametrs.objGUID[i],
                string.format("%.3f %.3f %.3f", pos.x, pos.y, pos.z),
                string.format("%.3f %.3f %.3f", rot.x, rot.y, rot.z),
                self.getGUID(),
            })
        end
    end
    UpdateSave()
end

function GetObjectMetaBag()
    return allObjMeta
end

function GetPriceListSize()
    local count = 0
    for _ in pairs(priceIndex) do count = count + 1 end
    return count
end

-- nil, если позиции нет в прайсе — вызывающая сторона обязана это проверить
function GetCostItem(nameItem)
    local entry = priceIndex[stripTags(nameItem)]
    if(entry == nil or entry.itemCost == nil) then return nil end
    return {itemCost = entry.itemCost, descObj = entry.descObj}
end