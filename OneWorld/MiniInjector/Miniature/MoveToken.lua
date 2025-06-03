local function initializeMoveToken()
    move_startLocation = self.getPosition()
    self.createButton({
        label = "00",
        position = {x=0, y=0.1, z=0},
        width = 0,
        height = 0,
        font_size = metricMode and 500 or 600
    })

    local gd = getGridDims()
    self.setScale({
        x = math.min(gd.width, gd.height) / 2.2,
        y = 0.2,
        z = math.min(gd.width, gd.height) / 2.2
    })

    updateCurrentLocation(move_startLocation)
end

local function isTargetWithinBounds(targetLoc)
    local acceptDistance = getAcceptDistance()
    return #move_allLocations > 1 and
           math.abs(targetLoc.x - move_startLocation.x) < acceptDistance and
           math.abs(targetLoc.z - move_startLocation.z) < acceptDistance
end

local function isTargetOutsideBounds(targetLoc)
    local gd = getGridDims()
    if Grid.type == 2 or Grid.type == 3 then
        local maxDistance = getFirstAdjacentLocation():distance(move_currentLocation)
        return targetLoc:distance(move_currentLocation) > maxDistance
    else
        return targetLoc.x < move_currentLocation.x - gd.width or
               targetLoc.x > move_currentLocation.x + gd.width or
               targetLoc.z < move_currentLocation.z - gd.height or
               targetLoc.z > move_currentLocation.z + gd.height
    end
end

local function isTargetNearAdjacentLocation(targetLoc)
    for i, point in ipairs(move_currentAdjacentLocations) do
        local testPoint = Vector(point.x, targetLoc.y, point.y)
        if testPoint:distance(targetLoc) < getAcceptDistance() then
            if point.isDiagonal then
                move_numDiagonals = move_numDiagonals + 1
            end
            return true
        end
    end
    return false
end

local function getNearestAdjacentLocation(targetLoc)
    local closestAdjacent = getFirstAdjacentLocation()
    local closestDistance = closestAdjacent:distance(targetLoc)
    for i, point in ipairs(move_currentAdjacentLocations) do
        local testAdjacent = Vector(point.x, targetLoc.y, point.y)
        local testDistance = testAdjacent:distance(targetLoc)
        if testDistance < closestDistance then
            closestAdjacent = testAdjacent
            closestDistance = testDistance
        end
    end
    return closestAdjacent
end

local function updateInformation()
    if move_startLocation == nil then
        initializeMoveToken()
    end

    if move_targetObject == nil or move_targetObject.held_by_color == nil then
        destroyObject(self)
        return
    end

    local targetLoc = move_targetObject.getPosition()
    if move_lastTargetLoc ~= nil and targetLoc:distance(move_lastTargetLoc) < 0.05 then
        return
    end

    if isTargetWithinBounds(targetLoc) then
        resetMoves()
    end

    if isTargetOutsideBounds(targetLoc) then
        updateCurrentLocation(getClosestAdjacentLocation(targetLoc))
    end

    if isTargetNearAdjacentLocation(targetLoc) then
        updateCurrentLocation(getNearestAdjacentLocation(targetLoc))
    end

    move_lastTargetLoc = targetLoc
end

function onLoad()
    move_startLocation, move_currentLocation = nil, nil
    move_currentAdjacentLocations, move_lastTargetLoc = nil, nil
    move_allLocations, move_drawLocations = {}, {}
    move_numDiagonals = 0
    Wait.time(|| updateInformation(), 0.1, -1)
end

function getDistance()
    local move_const_sectionMultiplier_metric, move_const_sectionMultiplier = 1.5, 5
    local multiplier = metricMode and move_const_sectionMultiplier_metric or move_const_sectionMultiplier
    local totalDistance = (#move_allLocations - 1) * multiplier
    if alternateDiag then
        totalDistance = totalDistance + (math.floor(move_numDiagonals / 2.0) * multiplier)
    end
    return totalDistance
end

function resetMoves()
    move_allLocations = {}
    move_drawLocations = {}
    move_numDiagonals = 0
    updateCurrentLocation(move_startLocation)
end

function getTargetColor()
    local player = move_targetObject.getVar("player")
    local colorTint = move_targetObject.getColorTint()
    if player then
        local miniHighlight = move_targetObject.getVar("miniHighlight")
        colorTint = getHighlightColor(miniHighlight) or Color.White
    else
        colorTint = Color.White
    end
    return colorTint
end

function getHighlightColor(miniHighlight)
    local highlightColors = {
        highlightWhite = Color.White,
        highlightBrown = Color.Brown,
        highlightRed = Color.Red,
        highlightOrange = Color.Orange,
        highlightYellow = Color.Yellow,
        highlightGreen = Color.Green,
        highlightTeal = Color.Teal,
        highlightBlue = Color.Blue,
        highlightPurple = Color.Purple,
        highlightPink = Color.Pink,
        highlightBlack = Color.Black
    }
    return highlightColors[miniHighlight]
end

function updateCurrentLocation(newLocation)
    newLocation = Vector(newLocation.x, move_targetObject.getBounds().center.y, newLocation.z)
    local hitList = Physics.cast({
        origin = newLocation,
        direction = {0, -move_targetObject.getBounds().center.y, 0},
        type = 1,
        max_distance = 10,
        debug = false,
    })

    for _, hitTable in ipairs(hitList) do
        if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= self then
            newLocation = hitTable.point
            newLocation.y = newLocation.y + 0.2
            break
        elseif debuggingEnabled then
            print("Did not find object below mini.")
        end
    end

    if #move_allLocations < 1 then
        newLocation.y = self.getPosition().y
    end

    table.insert(move_allLocations, newLocation)
    table.insert(move_drawLocations, self.positionToLocal(newLocation))
    move_currentAdjacentLocations = getAdjacentLocations(newLocation.x, newLocation.z)
    move_currentLocation = newLocation

    if #move_drawLocations > 1 then
        self.setVectorLines({{points = move_drawLocations, color = getTargetColor()}})
    else
        self.setVectorLines({})
    end

    if #self.getButtons() > 0 then
        self.editButton({index = 0, label = tostring(getDistance())})
    end
end

function pingAdjacents()
    for _, player in ipairs(Player.getPlayers()) do
        for i, point in ipairs(move_currentAdjacentLocations) do
            local pinger = Vector(point.x, self.getPosition().y, point.y)
            player.pingTable(pinger)
        end
        break
    end
end

function getFirstAdjacentLocation()
    for i, point in ipairs(move_currentAdjacentLocations) do
        return Vector(point.x, self.getPosition().y, point.y)
    end
end

function getAcceptDistance()
    local move_const_gridTargetScale = 0.3
    local gd = getGridDims()
    return move_const_gridTargetScale * math.min(gd.width, gd.height)
end

function getGridDims()
    if Grid.type == 1 then
        return {width = Grid.sizeX, height = Grid.sizeY}
    elseif Grid.type == 2 then
        return {width = Grid.sizeX * 0.75, height = Grid.sizeY * math.sqrt(3) / 2.0}
    elseif Grid.type == 3 then
        return {width = Grid.sizeX * math.sqrt(3) / 2.0, height = Grid.sizeY * 0.75}
    end
    print("INVALID GRID FORMAT")
    return nil
end

function getAdjacentLocations(currentX, currentY)
    local gd = getGridDims()
    local adjacents = {}

    if Grid.type == 1 then
        adjacents = {
            {x = currentX, y = currentY + gd.height, isDiagonal = false},
            {x = currentX + gd.width, y = currentY + gd.height, isDiagonal = true},
            {x = currentX + gd.width, y = currentY, isDiagonal = false},
            {x = currentX + gd.width, y = currentY - gd.height, isDiagonal = true},
            {x = currentX, y = currentY - gd.height, isDiagonal = false},
            {x = currentX - gd.width, y = currentY - gd.height, isDiagonal = true},
            {x = currentX - gd.width, y = currentY, isDiagonal = false},
            {x = currentX - gd.width, y = currentY + gd.height, isDiagonal = true}
        }
    elseif Grid.type == 2 then
        adjacents = {
            {x = currentX, y = currentY + gd.height, isDiagonal = false},
            {x = currentX + gd.width, y = currentY + (gd.height / 2.0), isDiagonal = false},
            {x = currentX + gd.width, y = currentY - (gd.height / 2.0), isDiagonal = false},
            {x = currentX, y = currentY - gd.height, isDiagonal = false},
            {x = currentX - gd.width, y = currentY - (gd.height / 2.0), isDiagonal = false},
            {x = currentX - gd.width, y = currentY + (gd.height / 2.0), isDiagonal = false}
        }
    elseif Grid.type == 3 then
        adjacents = {
            {x = currentX + (gd.width / 2.0), y = currentY + gd.height, isDiagonal = false},
            {x = currentX + gd.width, y = currentY, isDiagonal = false},
            {x = currentX + (gd.width / 2.0), y = currentY - gd.height, isDiagonal = false},
            {x = currentX - (gd.width / 2.0), y = currentY - gd.height, isDiagonal = false},
            {x = currentX - gd.width, y = currentY, isDiagonal = false},
            {x = currentX - (gd.width / 2.0), y = currentY + gd.height, isDiagonal = false}
        }
    end

    return adjacents
end