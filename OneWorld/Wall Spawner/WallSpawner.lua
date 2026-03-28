-- =========================================================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И КОНСТАНТЫ
-- =========================================================================

-- Текущие параметры стен
local wallHeight = 1.0
local wallOffset = 0.0

-- Точки для создания стен
local firstPoint = nil
local secondPoint = nil
local thirdPoint = nil

-- Настройки
local debuggingEnabled = true

local typeNames = {"OFF", "NORMAL", "CHAIN", "SQUARE", "BLOCK"}
-- Типы создания стен
local WALL_TYPES = {
    OFF = 1,
    NORMAL = 2,
    CHAIN = 3,
    SQUARE = 4,
    BLOCK = 5
}
local currentWallType = WALL_TYPES.OFF

-- Пределы значений
local MIN_HEIGHT = 0.25
local MAX_HEIGHT = 5.0
local MIN_OFFSET = -1.0
local MAX_OFFSET = 5.0
local HEIGHT_STEP = 0.25
local OFFSET_STEP = 0.25
local WALL_THICKNESS = 0.1
local EXTRA_LENGTH = 0.02

-- =========================================================================
-- ФУНКЦИИ ИНТЕРФЕЙСА ПОЛЬЗОВАТЕЛЯ
-- =========================================================================

local function buildContextMenu()
    self.addContextMenuItem("Wall Height UP", function() adjustWallHeight(HEIGHT_STEP) end)
    self.addContextMenuItem("Wall Height DOWN", function() adjustWallHeight(-HEIGHT_STEP) end)
    self.addContextMenuItem("Wall Offset UP", function() adjustWallOffset(OFFSET_STEP) end)
    self.addContextMenuItem("Wall Offset DOWN", function() adjustWallOffset(-OFFSET_STEP) end)
end

local function refreshButtons()
    self.UI.setAttribute("typeSpawn", "text", typeNames[currentWallType])
end

local function toggleWallType()
    currentWallType = currentWallType + 1
    if currentWallType > #typeNames then
        currentWallType = WALL_TYPES.OFF
        resetPoints()
    end
    refreshButtons()
end

-- =========================================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- =========================================================================

local function resetPoints()
    firstPoint = nil
    secondPoint = nil
    thirdPoint = nil
end

local function getGroundPosition()
    local startLoc = self.getPosition()
    local hitList = Physics.cast({
        origin = self.getBounds().center,
        direction = {0, -1, 0},
        type = 1,
        max_distance = 10,
        debug = debuggingEnabled
    })
    
    for _, hitTable in ipairs(hitList) do
        if hitTable and hitTable.point and hitTable.hit_object ~= self then
            return hitTable.point
        end
    end
    
    if debuggingEnabled then
        print("Did not find object below spawner.")
    end
    return startLoc
end

local function createWall(position, rotation, scale)
    local newWall = spawnObject({
        type = "BlockSquare",
        position = position,
        rotation = rotation,
        scale = scale,
        sound = false,
        snap_to_grid = false
    })
    
    newWall.setLock(true)
    newWall.setColorTint(self.getColorTint())
    return newWall
end

-- =========================================================================
-- ФУНКЦИИ УПРАВЛЕНИЯ СОСТОЯНИЕМ
-- =========================================================================

local function stabilize()
    local rb = self.getComponent("Rigidbody")
    if rb then
        rb.set("freezeRotation", true)
    end
end

local function destabilize()
    local rb = self.getComponent("Rigidbody")
    if rb then
        rb.set("freezeRotation", false)
    end
end

-- =========================================================================
-- ФУНКЦИИ ЖИЗНЕННОГО ЦИКЛА
-- =========================================================================

function onSave()
    return JSON.encode({
        wall_height = wallHeight,
        wall_offset = wallOffset
    })
end

function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data)
        wallHeight = loaded_data.wall_height or wallHeight
        wallOffset = loaded_data.wall_offset or wallOffset
    end
    
    buildContextMenu()
    refreshButtons()
    Wait.frames(stabilize, 1)
end

function onPickUp(player_color)
    destabilize()
end

function onDrop(player_color)
    stabilize()
end

-- =========================================================================
-- ФУНКЦИИ ОБРАБОТКИ ИЗМЕНЕНИЯ ПАРАМЕТРОВ
-- =========================================================================

local function adjustWallHeight(delta)
    wallHeight = math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, wallHeight + delta))
    Wait.frames(refreshButtons, 1)
    print("Wall Height: " .. wallHeight .. " squares.")
end

local function adjustWallOffset(delta)
    wallOffset = math.max(MIN_OFFSET, math.min(MAX_OFFSET, wallOffset + delta))
    Wait.frames(refreshButtons, 1)
    print("Wall Offset: " .. wallOffset)
end

local function setWallHeight(value)
    if not value or value == "" then
        value = "1"
    end
    
    wallHeight = tonumber(value)
    wallHeight = math.max(MIN_HEIGHT, math.min(MAX_HEIGHT, wallHeight))
    Wait.frames(refreshButtons, 1)
    print("Wall Height: " .. wallHeight .. " grid squares.")
end

local function setWallOffset(value)
    if not value or value == "" then
        value = "0"
    end
    
    wallOffset = tonumber(value)
    wallOffset = math.max(MIN_OFFSET, math.min(MAX_OFFSET, wallOffset))
    Wait.frames(refreshButtons, 1)
    print("Wall Vertical Offset: " .. wallOffset .. " grid squares.")
end

-- =========================================================================
-- ОСНОВНЫЕ ФУНКЦИИ СОЗДАНИЯ СТЕН
-- =========================================================================

local function createSquareWall(position)
    local gridX = math.ceil((position.x - Grid.offsetX) / Grid.sizeX) - 0.5
    local gridY = math.ceil((position.z - Grid.offsetY) / Grid.sizeY) - 0.5
    
    local groundPos = getGroundPosition()
    local startY = groundPos.y + (wallOffset * Grid.sizeX)
    local startX = Grid.offsetX + (gridX * Grid.sizeX)
    local startZ = Grid.offsetY + (gridY * Grid.sizeY)
    
    local floorHeight = 0.1
    local wallPos = {
        startX, 
        startY + (floorHeight / 2.0), 
        startZ
    }
    local wallScale = {
        Grid.sizeX, 
        floorHeight, 
        Grid.sizeY
    }
    
    createWall(wallPos, {0, 0, 0}, wallScale)
    resetPoints()
end

local function createRectangularWall(point1, point2, point3)
    -- Вычисляем центр прямоугольника
    local avgX = (point1.x + point2.x) / 2.0
    local avgZ = (point1.z + point2.z) / 2.0
    
    -- Получаем позицию земли и учитываем смещение
    local groundPos = getGroundPosition()
    local avgY = groundPos.y + (wallOffset * Grid.sizeX)
    
    -- Вычисляем размеры прямоугольника
    local length = point1:distance(point2)
    
    local widthDenominator = math.sqrt(math.pow(point2.x - point1.x, 2) + math.pow(point2.z - point1.z, 2))
    local width = math.abs(((point2.x - point1.x) * (point1.z - point3.z)) - ((point1.x - point3.x) * (point2.z - point1.z))) / widthDenominator
    
    local directionWidth = (((point2.x - point1.x) * (point1.z - point3.z)) - ((point1.x - point3.x) * (point2.z - point1.z))) / widthDenominator
    
    -- Вычисляем угол поворота
    local vect = Vector.between(point1, point2):normalized()
    local angle = vect:heading('y')
    
    -- Вычисляем центральную точку прямоугольника
    vect = vect:rotateOver('y', 90 * (directionWidth / math.abs(directionWidth))):scale(width)
    local boundryPoint = point1:add(vect)
    local midPoint = Vector.between(boundryPoint, point2):scale(0.5):add(boundryPoint)
    
    -- Создаем стену
    local wallPos = {
        midPoint.x, 
        avgY + (wallHeight * Grid.sizeX / 2.0), 
        midPoint.z
    }
    local wallScale = {
        width, 
        wallHeight * Grid.sizeX, 
        length
    }
    
    createWall(wallPos, {0, angle, 0}, wallScale)
    resetPoints()
end

local function createLinearWall(point1, point2, isChain)
    -- Вычисляем центр линии
    local avgX = (point1.x + point2.x) / 2.0
    local avgZ = (point1.z + point2.z) / 2.0
    
    -- Получаем позицию земли и учитываем смещение
    local groundPos = getGroundPosition()
    local avgY = groundPos.y + (wallOffset * Grid.sizeX)
    
    -- Вычисляем размеры стены
    local difX = point2.x - point1.x
    local difZ = point2.z - point1.z
    local dist = math.sqrt(math.pow(math.abs(difX), 2) + math.pow(math.abs(difZ), 2)) + EXTRA_LENGTH
    
    -- Вычисляем угол поворота
    local angle = math.atan(difX / difZ) * 180.0 / math.pi
    
    -- Создаем стену
    local wallPos = {
        avgX, 
        avgY + (wallHeight * Grid.sizeX / 2.0), 
        avgZ
    }
    local wallScale = {
        WALL_THICKNESS, 
        wallHeight * Grid.sizeX, 
        dist
    }
    
    createWall(wallPos, {0, angle, 0}, wallScale)
    
    -- Если это режим цепи, сохраняем вторую точку для следующей стены
    if isChain then
        firstPoint = secondPoint
        secondPoint = nil
        thirdPoint = nil
    else
        resetPoints()
    end
end

-- =========================================================================
-- ОСНОВНАЯ ФУНКЦИЯ ОБРАБОТКИ ВЗАИМОДЕЙСТВИЯ
-- =========================================================================

function onPlayerPing(player, position)
    if currentWallType == WALL_TYPES.SQUARE then
        createSquareWall(position)
    elseif currentWallType == WALL_TYPES.BLOCK then
        if not firstPoint then
            firstPoint = vector(position.x, 0, position.z)
            return
        end
        if not secondPoint then
            secondPoint = vector(position.x, 0, position.z)
            return
        end
        thirdPoint = vector(position.x, 0, position.z)
        createRectangularWall(firstPoint, secondPoint, thirdPoint)
    elseif currentWallType ~= WALL_TYPES.OFF then
        if not firstPoint then
            firstPoint = vector(position.x, 0, position.z)
            return
        end
        secondPoint = vector(position.x, 0, position.z)
        local isChain = (currentWallType == WALL_TYPES.CHAIN)
        createLinearWall(firstPoint, secondPoint, isChain)
    end
end

-- =========================================================================
-- ФУНКЦИИ ОБРАТНОГО ВЫЗОВА ДЛЯ ИНТЕРФЕЙСА
-- =========================================================================

function buttonClick_toggleEnabled()
    toggleWallType()
end

function inputChange_height(player, input, id)
    setWallHeight(input)
end

function inputChange_offset(player, input, id)
    setWallOffset(input)
end