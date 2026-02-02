function onLoad()
    sciptLinkPlate = [[
lh, pCol, sX, sY = nil, nil, nil, nil
function onDropped()
    local selfScale = self.getScale()
    sX, sY = math.ceil(selfScale.x*180), math.ceil(selfScale.z*180)
end
function onPickedUp()
    pCol = self.held_by_color
    if math.abs(Player[pCol].lift_height - 0.03) > 0.005 then
        lh = Player[pCol].lift_height
    end
    Player[pCol].lift_height = 0.03
end
local function returnLiftHeight()
    if pCol and lh then
        Player[pCol].lift_height = lh
        pCol, lh = nil, nil
    end
end
function onCollisionEnter() returnLiftHeight() end
function onDestroy() returnLiftHeight() end
]]
    CONFIG = JSON.encode({
        OBJECT_NAMES = {
            VBASE = "_OW_vBase",
            WBASE = "_OW_wBase",
            MBAG = "_OW_mBaG",
            ABAG = "_OW_aBaG"
        },
        BAG_NAMES = {
            DEFAULT = "Same_Name_Here",
        },
        ZONE_PREFIX = "SBx_",
        UI_COLORS = {
            YELLOW = {0.94, 0.75, 0.14},
            GRAY = {0.7, 0.7, 0.7},
            GREEN = {0.29, 0.62, 0.12}
        },
        POSITIONS = {
            VBASE_ENABLED_Y = 0.91,
            WBASE_OFFSET_Y = 0.11,
            WBASE_OFFSET_Z_FACTOR = 0.77
        }
    })
end

function round(num)
    local mult = 10 ^ 2
    return math.ceil(num * mult) / mult
end

function parseStringInWords(data)
    local words = {}
    for word in data.pString:gmatch(data.rStr) do
        table.insert(words, word)
    end
    return words
end

function setObjectsInteractable(data)
    for _, obj in ipairs(data.objects) do
        if obj then
            obj.interactable = data.isInteractable
            if data.isLocked then
                obj.lock()
            else
                obj.unlock()
            end
        end
    end
end

function setNewLink(data)
    local w, h = 450/4.5, 270/2.65
    local lX, lZ, sX, sY = data.locP.x, data.locP.z, data.collisionObj.getVar("sX"), data.collisionObj.getVar("sY")
    local x, z = round(lX*h), round(lZ*w)
    if(data.oneWorld.getVar("r90") == 1 and self.getRotation().z == 180) then
        x = x*(-1)
    end
    local lnk = data.oneWorld.getVar("lnk")
    lnk = lnk ~= nil and lnk ~= "" and lnk.."," or ""
    local newLnk = string.format("%s(%f;%f)(%f;%f)@%s", lnk, x, z, sX, sY, data.collisionObj.getDescription())
    data.oneWorld.setVar("lnk", newLnk)
end