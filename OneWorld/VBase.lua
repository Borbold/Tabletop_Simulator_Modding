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

function Round(num)
    local mult = 10 ^ 2
    return math.ceil(num * mult) / mult
end