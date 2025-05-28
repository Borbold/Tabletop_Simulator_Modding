local firstPoint = nil;
local secondPoint = nil;
local thirdPoint = nil;
local debuggingEnabled = true;

function onSave()
    saved_data = JSON.encode({
        wall_height = wallHeight,
        wall_offset = wallOffset
    });
    return saved_data;
end

function onLoad(saved_data)
    if saved_data ~= "" then
        local loaded_data = JSON.decode(saved_data);
        wallHeight = loaded_data.wall_height and loaded_data.wall_height or 1
        wallOffset = loaded_data.wall_offset and loaded_data.wall_offset or 0
    end
    enabled = 1
    buildContextMenu();
    refreshButtons();
    Wait.frames(stabilize, 1);
end

function onPickUp(player_color)
    destabilize();
end

function onDrop(player_color)
    stabilize();
end

function stabilize()
    local rb = self.getComponent("Rigidbody");
    rb.set("freezeRotation", true);
end

function destabilize()
    local rb = self.getComponent("Rigidbody");
    rb.set("freezeRotation", false);
end

function wallHeightUp()
    wallHeight = wallHeight + 0.25;
    if wallHeight > 5.0 then
        wallHeight = 5.0;
    end
    Wait.frames(refreshButtons, 1);
    print("Wall Height: " .. wallHeight .. " squares.");
end

function wallHeightDown()
    wallHeight = wallHeight - 0.25;
    if wallHeight < 0.25 then
        wallHeight = 0.25;
    end
    Wait.frames(refreshButtons, 1);
    print("Wall Height: " .. wallHeight .. " squares.");
end

function wallOffsetUp()
    wallOffset = wallOffset + 0.25;
    if wallOffset > 5.0 then
        wallOffset = 5.0;
    end
    Wait.frames(refreshButtons, 1);
    print("Wall Offset: " .. wallOffset);
end

function wallOffsetDown()
    wallOffset = wallOffset - 0.25;
    if wallOffset < 0.0 then
        wallOffset = 0.0;
    end
    Wait.frames(refreshButtons, 1);
    print("Wall Offset: " .. wallOffset);
end

function buildContextMenu()
    self.addContextMenuItem("Wall Height UP", wallHeightUp);
    self.addContextMenuItem("Wall Height DOWN", wallHeightDown);
    self.addContextMenuItem("Wall Offset UP", wallOffsetUp);
    self.addContextMenuItem("Wall Offset DOWN", wallOffsetDown);
end

local enumType = {
    "OFF", "NORMAL", "CHAIN", "SQUARE", "BLOCK"
}
function refreshButtons()
    self.UI.setAttribute("typeSpawn", "text", enumType[enabled])
end

function buttonClick_toggleEnabled()
    enabled = enabled + 1;
    if enabled > #enumType then
        enabled = 1
        firstPoint = nil
        secondPoint = nil
        thirdPoint = nil
    end
    refreshButtons()
end

function inputChange_height(player, input, id)
    if not stillEditing then
        if input == "" then
            input = "1"
        end
        wallHeight = tonumber(input)
        if wallHeight < 0.25 then
            wallHeight = 0.25
        end
        if wallHeight > 5.0 then
            wallHeight = 5.0
        end
        Wait.frames(refreshButtons, 1);
        print("Wall Height: " .. wallHeight .. " grid squares.");
    end
end

function inputChange_offset(player, input, id)
    if not stillEditing then
        if input == "" then
            input = "0"
        end
        wallOffset = tonumber(input)
        if wallOffset < 0.0 then
            wallOffset = 0.0
        end
        if wallOffset > 5.0 then
            wallOffset = 5.0
        end
        Wait.frames(refreshButtons, 1);
        print("Wall Vertical Offset: " .. wallOffset .. " grid squares.");
    end
end

function onPlayerPing(player, position)
    if enabled == 4 then
        -- Figure out which square the player pinged
        local gridX = math.ceil((position.x - Grid.offsetX) / Grid.sizeX) - 0.5;
        local gridY = math.ceil((position.z - Grid.offsetY) / Grid.sizeY) - 0.5;

        local startLoc = self.getPosition();
        local hitList = Physics.cast({
            origin       = self.getBounds().center,
            direction    = {0,-1,0},
            type         = 1,
            max_distance = 10,
            debug        = true,
        });
        for _, hitTable in ipairs(hitList) do
            -- Find the first object directly below the mini
            if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= self then
                startLoc = hitTable.point;
                break;
            else
                if (debuggingEnabled) then
                    print("Did not find object below ping.");
                end
            end
        end
        local startY = startLoc.y;
        -- Account for offset. Raise Y by that offset multiplied by the grid size.
        startY = startY + (wallOffset * Grid.sizeX);
        local startX = Grid.offsetX + (gridX * Grid.sizeX);
        local startZ = Grid.offsetY + (gridY * Grid.sizeY);
        local floorHeight = 0.1
        local newWall = spawnObject({
            type = "BlockSquare",
            position = {startX, startY + (floorHeight/2.0), startZ},
            rotation = {0, 0, 0},
            scale = {Grid.sizeX, floorHeight, Grid.sizeY},
            sound = false,
            snap_to_grid = false
        });
        newWall.setLock(true);
        newWall.setColorTint(self.getColorTint());
        firstPoint = nil;
        secondPoint = nil;
        thirdPoint = nil;
    elseif enabled == 5 then
        if firstPoint == nil then
            firstPoint = vector(position.x, 0, position.z);
            return
        end
        if secondPoint == nil then
            secondPoint = vector(position.x, 0, position.z);
            return
        end
        thirdPoint = vector(position.x, 0, position.z);
        local avgX = (firstPoint.x + secondPoint.x) / 2.0;
        local avgZ = (firstPoint.z + secondPoint.z) / 2.0;
        local startloc = self.getPosition();
        local hitList = Physics.cast({
            origin       = self.getBounds().center,
            direction    = {0,-1,0},
            type         = 1,
            max_distance = 10,
            debug        = false,
        });
        for _, hitTable in ipairs(hitList) do
            -- Find the first object directly below the mini
            if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= self then
                startloc = hitTable.point;
                break;
            else
                if (debuggingEnabled) then
                    print("Did not find object below spawner.");
                end
            end
        end
        local avgY = startloc.y;
        -- Account for offset. Raise Y by that offset multiplied by the grid size.
        avgY = avgY + (wallOffset * Grid.sizeX);
        local difX = secondPoint.x - firstPoint.x;
        local difZ = secondPoint.z - firstPoint.z;

        -- Length of the rectangle is the distance between first two points
        local length = firstPoint:distance(secondPoint);
        -- Width of the rectangle is the distance of third point from the line between first two points.
        local widthDenominator = math.sqrt(math.pow(secondPoint.x - firstPoint.x, 2) + math.pow(secondPoint.z - firstPoint.z, 2));
        local width =  math.abs(((secondPoint.x - firstPoint.x)*(firstPoint.z - thirdPoint.z)) - ((firstPoint.x - thirdPoint.x)*(secondPoint.z - firstPoint.z))) / widthDenominator;
        local directionWidth = (((secondPoint.x - firstPoint.x)*(firstPoint.z - thirdPoint.z)) - ((firstPoint.x - thirdPoint.x)*(secondPoint.z - firstPoint.z))) / widthDenominator;
        local vect = Vector.between(firstPoint, secondPoint):normalized();
        local angle = vect:heading('y');
        vect = vect:rotateOver('y', 90 * (directionWidth / math.abs(directionWidth))):scale(width);
        local boundryPoint = firstPoint:add(vect);
        local midPoint = Vector.between(boundryPoint, secondPoint):scale(0.5):add(boundryPoint);
        local newWall = spawnObject({
            type = "BlockSquare",
            position = {midPoint.x, avgY + (wallHeight * Grid.sizeX / 2.0), midPoint.z},
            rotation = {0, angle, 0},
            scale = {width, wallHeight * Grid.sizeX, length},
            sound = false,
            snap_to_grid = false
        });
        newWall.setLock(true);
        newWall.setColorTint(self.getColorTint());
        firstPoint = nil;
        secondPoint = nil;
        thirdPoint = nil;
    elseif enabled ~= 1 then
        if firstPoint == nil then
            firstPoint = vector(position.x, 0, position.z);
            return
        end
        secondPoint = vector(position.x, 0, position.z);
        local avgX = (firstPoint.x + secondPoint.x) / 2.0;
        local avgZ = (firstPoint.z + secondPoint.z) / 2.0;
        local startloc = self.getPosition();
        local hitList = Physics.cast({
            origin       = self.getBounds().center,
            direction    = {0,-1,0},
            type         = 1,
            max_distance = 10,
            debug        = false,
        });
        for _, hitTable in ipairs(hitList) do
            -- Find the first object directly below the mini
            if hitTable ~= nil and hitTable.point ~= nil and hitTable.hit_object ~= self then
                startloc = hitTable.point;
                break;
            else
                if (debuggingEnabled) then
                    print("Did not find object below spawner.");
                end
            end
        end
        local avgY = startloc.y;
        -- Account for offset. Raise Y by that offset multiplied by the grid size.
        avgY = avgY + (wallOffset * Grid.sizeX);
        local difX = secondPoint.x - firstPoint.x;
        local difZ = secondPoint.z - firstPoint.z;
        local dist = math.sqrt(math.pow(math.abs(difX), 2) + math.pow(math.abs(difZ), 2)) + 0.02;
        local angle = math.atan(difX / difZ) * 180.0 / math.pi;
        local newWall = spawnObject({
            type = "BlockSquare",
            position = {avgX, avgY + (wallHeight * Grid.sizeX / 2.0), avgZ},
            rotation = {0, angle, 0},
            scale = {0.1, wallHeight * Grid.sizeX, dist},
            sound = false,
            snap_to_grid = false
        });
        newWall.setLock(true);
        newWall.setColorTint(self.getColorTint());
        if enabled == 3 then
            firstPoint = secondPoint;
            secondPoint = nil;
            thirdPoint = nil;
        else
            firstPoint = nil;
            secondPoint = nil;
            thirdPoint = nil;
        end
    end
end