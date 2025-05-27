move_const_gridTargetScale = 0.3
move_const_sectionMultiplier = 5
move_const_sectionMultiplier_metric = 1.5
move_startLocation = nil
move_currentLocation = nil
move_currentAdjacentLocations = nil
move_allLocations = {}
move_drawLocations = {}
move_lastTargetLoc = nil
move_numDiagonals = 0

function getDistance()
    local multiplier = move_const_sectionMultiplier
    if metricMode == true then
        multiplier = move_const_sectionMultiplier_metric
    end
    local totalDistance = (#move_allLocations - 1) * multiplier
    if alternateDiag == true then
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
    if player == true then
        local miniHighlight = move_targetObject.getVar("miniHighlight")
        if miniHighlight == "highlightWhite" then
            colorTint = Color.White
        elseif miniHighlight == "highlightBrown" then
            colorTint = Color.Brown
        elseif miniHighlight == "highlightRed" then
            colorTint = Color.Red
        elseif miniHighlight == "highlightOrange" then
            colorTint = Color.Orange
        elseif miniHighlight == "highlightYellow" then
            colorTint = Color.Yellow
        elseif miniHighlight == "highlightGreen" then
            colorTint = Color.Green
        elseif miniHighlight == "highlightTeal" then
            colorTint = Color.Teal
        elseif miniHighlight == "highlightBlue" then
            colorTint = Color.Blue
        elseif miniHighlight == "highlightPurple" then
            colorTint = Color.Purple
        elseif miniHighlight == "highlightPink" then
            colorTint = Color.Pink
        elseif miniHighlight == "highlightBlack" then
            colorTint = Color.Black
        end
    else
        colorTint = Color.White
    end
    return colorTint
end

function updateCurrentLocation(newLocation)
    -- find Y of the floor directly below the mini's center point at the target location
    -- use that as the new location
    newLocation = Vector(newLocation.x, move_targetObject.getBounds().center.y, newLocation.z)
    local hitList = Physics.cast({
        origin       = newLocation,
        direction    = {0,-1,0},
        type         = 1,
        max_distance = 10,
        debug        = false,
    })
    for _, hitTable in ipairs(hitList) do
        -- Find the first object directly below the mini
        if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= mtoken then
            newLocation = hitTable.point
            newLocation.y = newLocation.y + 0.2
            break
        else
            if debuggingEnabled == true then
                print("Did not find object below mini.")
            end
        end
    end
    -- Ensure the first point starts below the move token
    if #move_allLocations < 1 then
        newLocation.y = self.getPosition().y
    end
    table.insert(move_allLocations, newLocation)
    table.insert(move_drawLocations, self.positionToLocal(newLocation))
    move_currentAdjacentLocations = getAdjacentLocations(newLocation.x, newLocation.z)
    --pingAdjacents()
    move_currentLocation = newLocation
    --print(newLocation)
    if #move_drawLocations > 1 then
        self.setVectorLines({{
            points = move_drawLocations,
            color = getTargetColor()
        }})
    else
        self.setVectorLines({})
    end
    if #self.getButtons() > 0 then
        self.editButton({index = 0, label = tostring(getDistance())})
    end
end

function pingAdjacents()
    for _, player in ipairs(Player.getPlayers()) do
        for i,point in ipairs(move_currentAdjacentLocations) do
            local pinger = Vector(point.x, self.getPosition().y, point.y)
            --print(pinger)
            player.pingTable(pinger)
        end
        break
    end
end

function onUpdate()
    if move_startLocation == nil then
        move_startLocation = self.getPosition()
        local fontSize = 600
        if metricMode then
            fontSize = 500
        end
        self.createButton({
            click_function = "onLoad",
            function_owner = self,
            label = "00",
            position = {x=0, y=0.1, z=0},
            width = 0,
            height = 0,
            font_size = fontSize
        })
        local gd = getGridDims()
        if gd.width < gd.height then
            self.setScale({
                x= gd.width / 2.2,
                y= 0.2,
                z= gd.width / 2.2
            })
        else
            self.setScale({
                x= gd.height / 2.2,
                y= 0.2,
                z= gd.height / 2.2
            })
        end
        updateCurrentLocation(move_startLocation)
    end
    if move_targetObject == nil or move_targetObject.held_by_color == nil then
        destroyObject(self)
        return
    end
    local targetLoc = move_targetObject.getPosition()
    if move_lastTargetLoc ~= nil and targetLoc:distance(move_lastTargetLoc) < 0.05 then
        --print("nomove")
        return
    end
    local targetSameHeight = targetLoc.set
    local acceptDistance = getAcceptDistance()
    if #move_allLocations > 1 and
       math.abs(targetLoc.x - move_startLocation.x) < acceptDistance
       and math.abs(targetLoc.z - move_startLocation.z) < acceptDistance then
        resetMoves()
    end
    -- the target has moved
    -- see if it's outside the bounding box/circle
    if Grid.type == 2 or Grid.type == 3 then
        -- we are using hex grids, use a circle from start to determine bounding
        local maxDistance = getFirstAdjacentLocation():distance(move_currentLocation)
        local currentDistance = targetLoc:distance(move_currentLocation)
        if currentDistance > maxDistance then
            -- we are outside the bounding circle, move to closest adjacent
            updateCurrentLocation(getClosestAdjacentLocation(targetLoc))
        end
    else
        -- we are using square grids, use the square bounding box
        local gd = getGridDims()
        if targetLoc.x < move_currentLocation.x - gd.width or
           targetLoc.x > move_currentLocation.x + gd.width or
           targetLoc.z < move_currentLocation.z - gd.height or
           targetLoc.z > move_currentLocation.z + gd.height then
            -- we are outside the bounding box, move to closest adjacent
            updateCurrentLocation(getClosestAdjacentLocation(targetLoc))
        end
    end
    --see if it's nearby an adjacent location
    for i,point in ipairs(move_currentAdjacentLocations) do
        local testPoint = Vector(point.x, targetLoc.y, point.y)
        if testPoint:distance(targetLoc) < acceptDistance then
            if point.isDiagonal == true then
                move_numDiagonals = move_numDiagonals + 1
                --print("diagonals: " .. move_numDiagonals)
            end
            updateCurrentLocation(testPoint)
        end
    end
    move_lastTargetLoc = targetLoc
end

function getFirstAdjacentLocation()
    for i,point in ipairs(move_currentAdjacentLocations) do
        return Vector(point.x, self.getPosition().y, point.y)
    end
end

function getClosestAdjacentLocation(testLocation)
    local closestAdjacent = getFirstAdjacentLocation()
    local closestDistance = closestAdjacent:distance(testLocation)
    for i,point in ipairs(move_currentAdjacentLocations) do
        local testAdjacent = Vector(point.x, testLocation.y, point.y)
        local testDistance = testAdjacent:distance(testLocation)
        if testDistance < closestDistance then
            closestAdjacent = testAdjacent
            closestDistance = testDistance
        end
    end
    return closestAdjacent
end

function getAcceptDistance()
    local gd = getGridDims()
    if gd.width < gd.height then
        return move_const_gridTargetScale * gd.width
    else
        return move_const_gridTargetScale * gd.height
    end
end

function getGridDims()
    if Grid.type == 1 then
        return {
            width = Grid.sizeX,
            height = Grid.sizeY
        }
    elseif Grid.type == 2 then
        return {
            width = Grid.sizeX * 0.75,
            height = Grid.sizeY * math.sqrt(3) / 2.0
        }
    elseif Grid.type == 3 then
        return {
            width = Grid.sizeX * math.sqrt(3) / 2.0,
            height = Grid.sizeY * 0.75
        }
    end
    print("INVALID GRID FORMAT")
    return nil
end

function getAdjacentLocations(currentX, currentY)
    local gd = getGridDims()
    local adjacents = {}
    if Grid.type == 1 then
        table.insert(adjacents, {
            x = currentX,
            y = currentY + gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX + gd.width,
            y = currentY + gd.height,
            isDiagonal = true
        })
        table.insert(adjacents, {
            x = currentX + gd.width,
            y = currentY,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX + gd.width,
            y = currentY - gd.height,
            isDiagonal = true
        })
        table.insert(adjacents, {
            x = currentX,
            y = currentY - gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - gd.width,
            y = currentY - gd.height,
            isDiagonal = true
        })
        table.insert(adjacents, {
            x = currentX - gd.width,
            y = currentY,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - gd.width,
            y = currentY + gd.height,
            isDiagonal = true
        })
    elseif Grid.type == 2 then
        table.insert(adjacents, {
            x = currentX,
            y = currentY + gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX + gd.width,
            y = currentY + (gd.height / 2.0),
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX + gd.width,
            y = currentY - (gd.height / 2.0),
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX,
            y = currentY - gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - gd.width,
            y = currentY - (gd.height / 2.0),
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - gd.width,
            y = currentY + (gd.height / 2.0),
            isDiagonal = false
        })
    elseif Grid.type == 3 then
        table.insert(adjacents, {
            x = currentX + (gd.width / 2.0),
            y = currentY + gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX + gd.width,
            y = currentY,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX + (gd.width / 2.0),
            y = currentY - gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - (gd.width / 2.0),
            y = currentY - gd.height,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - gd.width,
            y = currentY,
            isDiagonal = false
        })
        table.insert(adjacents, {
            x = currentX - (gd.width / 2.0),
            y = currentY + gd.height,
            isDiagonal = false
        })
    end
    return adjacents
end