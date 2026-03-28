-- =========================================================================
-- КОНСТАНТЫ И НАСТРОЙКИ
-- =========================================================================

-- Константы для объектов "FogOfWarTrigger"
local FOG_TRIGGER_CONFIG = {
    name = "FogOfWarTrigger",
    color = {r = 0.25, g = 0.25, b = 0.25, a = 0.1025644},
    commonProps = {
        Nickname = "",
        Description = "",
        GMNotes = "",
        LayoutGroupSortIndex = 0,
        Value = 0,
        Locked = true,
        Grid = true,
        Snap = true,
        IgnoreFoW = false,
        MeasureMovement = false,
        DragSelectable = true,
        Autoraise = true,
        Sticky = true,
        Tooltip = true,
        GridProjection = false,
        HideWhenFaceDown = false,
        Hands = false,
        FogColor = "Black",
        FogHidePointers = false,
        FogReverseHiding = false,
        FogSeethrough = false,
        LuaScript = "",
        LuaScriptState = "",
        XmlUI = ""
    }
}

-- Конфигурация для скрытия OneWorld Minimaps
local MINIMAP_CONFIG = {
    position = {x = 65.0, y = 65.0, z = 65.0},
    rotation = {x = 0.0, y = 0.0, z = 0.0},
    scale = {x = 3.0, y = 0.13, z = 3.0}
}

-- Конфигурация для скрытия OneWorld Hub
local HUB_CONFIG = {
    scale = {x = 12.00, y = 0.40, z = 10.20}
}

-- Конфигурация для спавна тумана войны
local FOW_CONFIG = {
    spawnHeight = 100,
    heightOffset = 9.88,
    height = 20,
    color = {r = 0.25, g = 0.25, b = 0.25, a = 0.1025644},
    fogOfWarProps = {
        HideGmPointer = false,
        HideObjects = true,
        ReHideObjects = false,
        Height = 0,
        RevealedLocations = {}
    }
}

-- Значения по умолчанию для границ карты
local DEFAULT_MAP_VARS = {
    position = {x = 0.0, y = 0.91, z = 0.0},
    bounds = {x = 88.07, y = 0.2, z = 52.02}
}

-- Имена объектов OneWorld
local OW_HUB_NAME = "OW_Hub"
local OW_MAP_NAME = "_OW_vBase"

-- =========================================================================
-- ОСНОВНЫЕ ФУНКЦИИ УПРАВЛЕНИЯ ТУМАНОМ ВОЙНЫ
-- =========================================================================

local function removeAllFogs()
    local counter = 0
    for _, obj in ipairs(getAllObjects()) do
        if obj and obj ~= self and obj.type == "FogOfWar" then
            obj.destruct()
            counter = counter + 1
        end
    end
    
    if counter > 0 then
        print("Removed " .. counter .. " fogs!")
    else
        print("No fogs found!")
    end
end

function buttonClick_spawnFOW()
    local mapVars = getMapVars(true)
    local thickness = mapVars.bounds.y
    local tempBounds = {
        x = mapVars.bounds.x,
        y = FOW_CONFIG.height,
        z = mapVars.bounds.z
    }
    
    local spawnData = {
        data = createFogOfWarData(),
        position = {mapVars.position.x, FOW_CONFIG.spawnHeight, mapVars.position.z},
        rotation = {0, 0, 0},
        scale = tempBounds,
        sound = false,
        callback_function = function(spawned_object)
            local finalPosition = {
                mapVars.position.x,
                mapVars.position.y + (thickness/2.0) + FOW_CONFIG.heightOffset,
                mapVars.position.z
            }
            spawned_object.setPositionSmooth(finalPosition)
        end
    }
    
    spawnObjectData(spawnData)
end

-- =========================================================================
-- ФУНКЦИИ ВЗАИМОДЕЙСТВИЯ С ONEWORLD
-- =========================================================================

local function hideOWMinimaps()
    print("Hiding OneWorld Minimaps!")
    
    local transform = {
        posX = MINIMAP_CONFIG.position.x,
        posY = MINIMAP_CONFIG.position.y,
        posZ = MINIMAP_CONFIG.position.z,
        rotX = MINIMAP_CONFIG.rotation.x,
        rotY = MINIMAP_CONFIG.rotation.y,
        rotZ = MINIMAP_CONFIG.rotation.z,
        scaleX = MINIMAP_CONFIG.scale.x,
        scaleY = MINIMAP_CONFIG.scale.y,
        scaleZ = MINIMAP_CONFIG.scale.z
    }
    
    spawnObjectData({
        data = createFogTriggerData(transform)
    })
end

local function hideOWHub()
    local owHub = getOneWorldHub()
    if not owHub then
        print("OneWorld is not available! Unable to spawn hidden zone.")
        return
    end
    
    local pos = owHub.getPosition()
    local rot = owHub.getRotation()
    
    print("Hiding OneWorld Hub!")
    
    local transform = {
        posX = pos.x,
        posY = pos.y,
        posZ = pos.z,
        rotX = rot.x,
        rotY = rot.y,
        rotZ = rot.z,
        scaleX = HUB_CONFIG.scale.x,
        scaleY = HUB_CONFIG.scale.y,
        scaleZ = HUB_CONFIG.scale.z
    }
    
    spawnObjectData({
        data = createFogTriggerData(transform)
    })
end

-- =========================================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- =========================================================================

local function findObjectByName(name)
    for _, obj in ipairs(getAllObjects()) do
        if obj and obj ~= self and obj.getName() == name then
            return obj
        end
    end
    return nil
end

function getOneWorldHub()
    return findObjectByName(OW_HUB_NAME)
end

local function getOneWorldMap()
    return findObjectByName(OW_MAP_NAME)
end

function getMapVars(debug)
    local oneWorldMap = getOneWorldMap()
    if oneWorldMap then
        local oneWorldBounds = oneWorldMap.getBounds()
        if oneWorldBounds.size.x > 10 then
            print("Using OneWorld map bounds.")
            return {
                position = oneWorldMap.getPosition(),
                bounds = oneWorldBounds.size
            }
        end
        
        if debug then
            print("A OneWorld map is not deployed! Using default bounds.")
        end
    elseif debug then
        print("OneWorld is not available! Using default bounds.")
    end
    
    return DEFAULT_MAP_VARS
end

function createFogTriggerData(transform)
    local data = {
        Name = FOG_TRIGGER_CONFIG.name,
        Transform = transform,
        ColorDiffuse = FOG_TRIGGER_CONFIG.color
    }
    
    -- Добавляем общие свойства
    for key, value in pairs(FOG_TRIGGER_CONFIG.commonProps) do
        data[key] = value
    end
    
    return data
end

function createFogOfWarData()
    local data = {
        Name = "FogOfWar",
        Transform = {
            posX = 0,
            posY = 0,
            posZ = 0,
            rotX = 0,
            rotY = 0,
            rotZ = 0,
            scaleX = 1,
            scaleY = 1,
            scaleZ = 1
        },
        ColorDiffuse = FOW_CONFIG.color,
        FogOfWar = FOW_CONFIG.fogOfWarProps
    }
    
    -- Добавляем общие свойства
    for key, value in pairs(FOG_TRIGGER_CONFIG.commonProps) do
        data[key] = value
    end
    
    return data
end

-- =========================================================================
-- ФУНКЦИИ ЖИЗНЕННОГО ЦИКЛА
-- =========================================================================

function onLoad(saved_data)
    self.addContextMenuItem("Remove All Fogs", removeAllFogs, true)
    self.addContextMenuItem("Hide OW Minimaps", hideOWMinimaps, true)
    self.addContextMenuItem("Hide OW Hub", hideOWHub, true)
end