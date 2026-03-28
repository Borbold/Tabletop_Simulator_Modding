-- =========================================================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И КОНСТАНТЫ
-- =========================================================================

-- Состояние сохраненных линий
local linesSaved = false
local oneWorldLines = {}

-- Настройки
local debuggingEnabled = true

-- Константы для OneWorld
local OW_MAP_NAME = "_OW_vBase"
local DEFAULT_MAP_BOUNDS = {x = 88.07, y = 1, z = 52.02}

-- =========================================================================
-- ФУНКЦИИ ЖИЗНЕННОГО ЦИКЛА
-- =========================================================================

function onLoad(saved_data)
    -- Инициализация состояния
    linesSaved = false
    oneWorldLines = {}
    
    -- Загрузка сохраненных данных
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        linesSaved = loaded_data.linesSaved or false
        oneWorldLines = loaded_data.oneWorldLines or {}
    end
    
    -- Построение контекстного меню
    rebuildContextMenu()
end

function onObjectDestroy(destroy_obj)
    -- При уничтожении объекта восстанавливаем исходные линии
    if destroy_obj == self and linesSaved and #oneWorldLines > 0 then
        local currentLines = getValidVectorLines(false)
        Global.setVectorLines(currentLines)
    end
end

-- =========================================================================
-- ФУНКЦИИ УПРАВЛЕНИЯ СОХРАНЕННЫМИ ЛИНИЯМИ
-- =========================================================================

local function saveLines()
    local validLines = getValidVectorLines(true)
    if not validLines or #validLines == 0 then
        print("No drawn lines to save! Only lines within the map area are saved.")
        return
    end
    
    -- Сохранение линий
    oneWorldLines = validLines
    linesSaved = true
    
    -- Обновление состояния
    updateScriptState()
    print("Drawn lines saved! Only lines within the map area are saved.")
    rebuildContextMenu()
end

local function revertToSave()
    if not linesSaved or #oneWorldLines == 0 then
        print("No saved lines to revert to!")
        return
    end
    
    -- Получение текущих линий (не сохраненных)
    local currentLines = getValidVectorLines(false)
    
    -- Добавление сохраненных линий к текущим
    for _, line in ipairs(oneWorldLines) do
        table.insert(currentLines, line)
    end
    
    -- Обновление глобальных линий
    Global.setVectorLines(currentLines)
    print("Reverted to saved lines!")
end

local function resetLineSaver()
    if not linesSaved then
        print("No saved lines to reset!")
        return
    end
    
    -- Сброс сохраненных линий
    oneWorldLines = {}
    linesSaved = false
    
    -- Обновление состояния
    updateScriptState()
    print("LineSaver reset! Saved lines forgotten!")
    rebuildContextMenu()
end

-- =========================================================================
-- ФУНКЦИИ ИНТЕРФЕЙСА ПОЛЬЗОВАТЕЛЯ
-- =========================================================================

function rebuildContextMenu()
    self.clearContextMenu()
    
    -- Добавление пункта меню для сохранения линий
    local saveStatus = linesSaved and "[X]" or "[ ]"
    self.addContextMenuItem(string.format("%s Save Lines", saveStatus), saveLines)
    
    -- Добавление дополнительных пунктов, если есть сохраненные линии
    if linesSaved and #oneWorldLines > 0 then
        self.addContextMenuItem("Revert To Save", revertToSave)
        self.addContextMenuItem("Reset LineSaver", resetLineSaver)
    end
end

-- =========================================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- =========================================================================

function updateScriptState()
    self.script_state = JSON.encode({
        linesSaved = linesSaved,
        oneWorldLines = oneWorldLines
    })
end

local function getOneWorldMap()
    for _, obj in ipairs(getAllObjects()) do
        if obj and obj ~= self and obj.getName() == OW_MAP_NAME then
            return obj
        end
    end
    return nil
end

local function getMapBounds(debug)
    local oneWorldMap = getOneWorldMap()
    if oneWorldMap then
        local oneWorldBounds = oneWorldMap.getBounds()
        if oneWorldBounds.size.x > 10 then
            if debuggingEnabled then
                print("Using OneWorld map bounds.")
            end
            return oneWorldBounds.size
        end
        
        if debug or debuggingEnabled then
            print("A OneWorld map is not deployed! Using default bounds.")
        end
    elseif debug or debuggingEnabled then
        print("OneWorld is not available! Using default bounds.")
    end
    
    return DEFAULT_MAP_BOUNDS
end

function getValidVectorLines(internal)
    local globalLines = Global.getVectorLines()
    if not globalLines then return {} end
    
    -- Получение границ карты
    local lineBounds = getMapBounds(true)
    local minX, minZ = lineBounds.x / -2.0, lineBounds.z / -2.0
    local maxX, maxZ = lineBounds.x / 2.0, lineBounds.z / 2.0
    
    local validLines = {}
    
    -- Проверка каждой линии
    for i = 1, #globalLines do
        local currentLine = globalLines[i]
        local saveLine = false
        
        -- Проверка каждой точки линии
        for li = 1, #currentLine.points do
            local currentPoint = currentLine.points[li]
            if currentPoint.x > minX and
               currentPoint.x < maxX and
               currentPoint.z > minZ and
               currentPoint.z < maxZ then
                saveLine = true
                break
            end
        end
        
        -- Добавление линии, если она соответствует условию
        if internal == saveLine then
            table.insert(validLines, currentLine)
        end
    end
    
    return validLines
end