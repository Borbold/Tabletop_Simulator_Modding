toggleMeasure, pickedUp = 0, 0
lastPickedUpObjects = {}
pickedUpColor = nil
finalDistance = 1

local function distanceUpdate()
    if toggleMeasure == 0 then
        return
    end

    if pickedUpColor == nil then return end
    playerLastObject = lastPickedUpObjects[pickedUpColor .. ""]
    if playerLastObject == nil then
        return
    end

    -- grab the current position of the stick
    -- if it's not being held, use the saved stick position
    pointA = self.getPosition()
    if pickedUp == 0 then
        pointA = positionVector
    end

    pointB = playerLastObject.getPosition()
    local objBounds = playerLastObject.getBounds()
    pointB.y = objBounds.center.y - (objBounds.size.y/2.0)

    mdiff = pointA - pointB
    finalDistance = 0
    minDistance = 10000
    if alternateDiag then
        xDistance = math.abs(mdiff.x)
        if xDistance < minDistance then
            minDistance = xDistance
        end
        xDisGrid = math.floor(xDistance / Grid.sizeX + 0.5)
        zDistance = math.abs(mdiff.z)
        if zDistance < minDistance then
            minDistance = zDistance
        end
        yDisGrid = math.floor(zDistance / Grid.sizeY + 0.5)
        if xDisGrid > yDisGrid then
            finalDistance = math.floor(xDisGrid + yDisGrid/2.0) * 5.0
        else
            finalDistance = math.floor(yDisGrid + xDisGrid/2.0) * 5.0
        end
    else
        xDistance = math.abs(mdiff.x)
        if xDistance < minDistance then
            minDistance = xDistance
        end
        zDistance = math.abs(mdiff.z)
        if zDistance < minDistance then
            minDistance = zDistance
        end
        if zDistance > xDistance then
            xDistance = zDistance
        end
        xDistance = xDistance * (5.0 / Grid.sizeX)
        finalDistance = (math.floor((xDistance + 2.5) / 5.0) * 5)
    end

    self.UI.setAttribute("distance", "text", finalDistance)

    if pickedUpColor ~= nil then
        -- Drawing the line between pole and selected object
        newStartPoint = self.positionToLocal({pointA[1],pointA[2],pointA[3]})
        newEndPoint = self.positionToLocal({pointB[1],pointB[2]+0.1,pointB[3]})

        if savedStartPoint ~= nil and
            savedEndPoint ~= nil and
            savedStartPoint[1] == newStartPoint[1] and
            savedStartPoint[2] == newStartPoint[2] and
            savedStartPoint[3] == newStartPoint[3] and
            savedEndPoint[1] == newEndPoint[1] and
            savedEndPoint[2] == newEndPoint[2] and
            savedEndPoint[3] == newEndPoint[3] then
            return
        end

        savedStartPoint = newStartPoint
        savedEndPoint = newEndPoint

        newVectorLines = {}
        table.insert(newVectorLines, {
            points    = { newStartPoint, newEndPoint },
            color     = self.getColorTint(),
            thickness = 0.1023,
            rotation  = {0,0,0},
        })
        self.setVectorLines(newVectorLines)
    end
end

local function rebuildContextMenu()
    self.clearContextMenu()
    if enableCalibration == true then
        self.addContextMenuItem("[X] Calibration", toggleEnableCalibration)
        self.addContextMenuItem(string.format("%s Vertex Mode", vertexMode and "[X]" or "[ ]"), toggleEnableVertexMode)
    else
        self.addContextMenuItem("[ ] Calibration", toggleEnableCalibration)
    end
    self.addContextMenuItem(string.format("%s Alt. Diagonals", alternateDiag and "[X]" or "[ ]"), toggleEnableVertexMode)
end

function onSave()
    return JSON.encode({
        enableCalibration = enableCalibration,
        vertexMode = vertexMode,
        alternateDiag = alternateDiag
    })
end

function onLoad(save_state)
    savedStartPoint, savedEndPoint = nil, nil
    if save_state ~= "" then
        local saved_data = JSON.decode(save_state)
        alternateDiag = saved_data.alternateDiag and saved_data.alternateDiag or false
        enableCalibration = saved_data.enableCalibration and saved_data.enableCalibration or false
        vertexMode = saved_data.vertexMode and saved_data.vertexMode or false
    end

    rotationVector, positionVector = self.getRotation(), self.getPosition()
    className = "MeasurementTool"

    rebuildContextMenu()
    self.setVectorLines({})

end

function toggleEnableVertexMode()
    vertexMode = not vertexMode
    rebuildContextMenu()
end

function toggleEnableCalibration()
    enableCalibration = not enableCalibration
    self.UI.setAttribute("calibration", "active", enableCalibration)
    rebuildContextMenu()
end

function toggleAlternateDiag()
    alternateDiag = not alternateDiag
    rebuildContextMenu()
end

local idWT = 0
function onPickUp(player_color)
    idWT = Wait.time(|| distanceUpdate(), 0.2, -1)
end

function onCollisionEnter(player_color)
    rotationVector, positionVector = self.getRotation(), self.getPosition()
    pickedUp = 0
    Wait.stop(idWT)
    Wait.time(|| self.UI.setAttribute("distance", "text", ""), 1)
end

function onObjectPickUp(player_color, targetObj)
    if targetObj == self then
        pickedUpColor = player_color
        toggleMeasure = 1
        pickedUp = 1
    end

    if targetObj != nil and targetObj != self then
        -- if the last player to touch the stick picked up something else, remove measurements
        if player_color == pickedUpColor then
            toggleMeasure = 0
            self.setVectorLines({})
        end
        colorName = player_color .. ""
        lastPickedUpObjects[colorName] = targetObj
    end
end

function calibrationFunction(player, input, id)
    if playerLastObject and input ~= "" then
        pointA = self.getPosition()
        pointB = playerLastObject.getPosition()
        mdiff = pointA - pointB

        calibrationDistance = tonumber(input)
        mDistance = math.abs(mdiff.x)
        zDistance = math.abs(mdiff.z)
        if zDistance > mDistance then
            mDistance = zDistance
        end
        gridSize = (5.0 / (calibrationDistance / mDistance));

        Grid.sizeX = gridSize
        Grid.sizeY = gridSize
        displacement = (gridSize / 2.0)
        if vertexMode then
            displacement = 0
        end
        Grid.offsetX = pointA[1] - displacement
        Grid.offsetY = pointA[3] - displacement
    end
end
