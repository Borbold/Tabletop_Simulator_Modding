local CameraFollow = [[
-- =========================================================
--  Levitating Camera Follow
--  Управление: 5/2 — вперёд/назад, 1/3 — влево/вправо
--              4/6 — подъём/спуск, 1 — вернуться за камеру, 0 — выход
-- =========================================================
local cfg = {
    moveSpeed   = 6.0,    -- горизонтальная скорость, ед/с
    ascendSpeed = 3.0,    -- вертикальная скорость, ед/с
    accel       = 25.0,   -- разгон/торможение, ед/с^2 (меньше = более "воздушно")
    hoverHeight = 0.35,   -- высота парения над поверхностью
    hoverGain   = 4.0,    -- жёсткость удержания высоты
    hoverBob    = 0.05,   -- амплитуда покачивания (0 = выключить)
    bobSpeed    = 2.2,
}

local lookScreenIndex, exitScreenIndex = 1, 10
local ascendIndex, descendIndex = 6, 4
local upIndex, leftIndex, downIndex, rightIndex = 2, 3, 5, 1

local held = { up = false, left = false, down = false,
               right = false, ascend = false, descend = false }

local controllingPlayerColor, prevCPC
local rotateY, bobPhase = 0, 0
local levitating, bobEnabled, moveSound = true, true, false
local offsetHeight, offsetFront, offsetBackwards, offsetRotate = 2, 0, 0, 0
local rb, indexMove

-- ---------------- утилиты ----------------
local function dt() return (Time and Time.delta_time) or 0.016 end
local function clamp(v, lo, hi) return v < lo and lo or (v > hi and hi or v) end
local function approach(cur, tgt, maxd)
    if cur < tgt then return math.min(cur + maxd, tgt) end
    if cur > tgt then return math.max(cur - maxd, tgt) end
    return cur
end

-- высота поверхности под объектом (рейкаст вниз)
local function groundHeight()
    local hits = Physics.cast({
        origin = self.getBounds().center, direction = {0, -1, 0},
        type = 1, max_distance = 20, debug = false,
    })
    for _, h in ipairs(hits) do
        if h.hit_object ~= self then return h.point.y end
    end
end

-- физика: пока управляем — фиксируем поворот; при левитации снимаем вес
local function applyPhysics()
    rb = rb or (self.getComponent and self.getComponent("Rigidbody") or nil)
    if not rb then return end
    local controlled = controllingPlayerColor ~= nil
    rb.set("freezeRotation", controlled)
    rb.set("useGravity", not (controlled and levitating))
end

-- ---------------- сохранение ----------------
function UpdateSave()
    self.script_state = JSON.encode({
        offsetHeight = offsetHeight, offsetFront = offsetFront,
        offsetBackwards = offsetBackwards,
        levitating = levitating, bobEnabled = bobEnabled,
    })
end

function onLoad(savedData)
    local d = JSON.decode(savedData or "")
    if d then
        offsetHeight    = d.offsetHeight or offsetHeight
        offsetFront     = d.offsetFront or offsetFront
        offsetBackwards = d.offsetBackwards or offsetBackwards
        levitating      = d.levitating ~= false
        bobEnabled      = d.bobEnabled ~= false
    end

    controllingPlayerColor, prevCPC = nil, nil
    rotateY, bobPhase, moveSound = 0, 0, false

    if self.AssetBundle then
        indexMove = -1
        local fx = self.AssetBundle.getLoopingEffects()
        if fx then
            for i, v in ipairs(fx) do if v == "Move" then indexMove = i end end
        end
    end

    self.addContextMenuItem("Set Camera", SetCamera)
    self.addContextMenuItem("Levitating", toggleLevitating, true)
    self.addContextMenuItem("Hover Bob", toggleBob, true)
    self.addContextMenuItem("UpHeight", UpHeight, true)
    self.addContextMenuItem("DownHeight", DownHeight, true)
    self.addContextMenuItem("BackFront", BackFront, true)
    self.addContextMenuItem("ForwardFront", ForwardFront, true)
    self.addContextMenuItem("PlusBackwards", PlusBackwards, true)
    self.addContextMenuItem("MinusBackwards", MinusBackwards, true)
    self.addContextMenuItem("Rotate", Rotate, true)

    Wait.frames(applyPhysics, 1)
end

-- ---------------- камера ----------------
function SetCamera(playerColor)
    if prevCPC == nil then
        Player[playerColor].broadcast("Вы управляете миниатюрой.")
        Player[playerColor].broadcast("Выход — 0. Подъём и спуск — 3 и 2.")
    end
    Player[playerColor].attachCameraToObject({
        object = self,
        offset = { x = offsetFront, y = offsetHeight, z = offsetBackwards },
    })
    SetPlayer(playerColor)
    applyPhysics()
    UpdateSave()
end

function SetPlayer(color)
    if controllingPlayerColor ~= nil and color ~= nil then return end
    controllingPlayerColor = color
    prevCPC = color
end

function UpHeight(color)        offsetHeight    = offsetHeight    + 0.25 SetCamera(color) end
function DownHeight(color)      offsetHeight    = offsetHeight    - 0.25 SetCamera(color) end
function BackFront(color)       offsetFront     = offsetFront     + 0.25 SetCamera(color) end
function ForwardFront(color)    offsetFront     = offsetFront     - 0.25 SetCamera(color) end
function PlusBackwards(color)   offsetBackwards = offsetBackwards + 0.25 SetCamera(color) end
function MinusBackwards(color)  offsetBackwards = offsetBackwards - 0.25 SetCamera(color) end
function Rotate(color)
    offsetRotate = offsetRotate + 90
    local l = upIndex
    upIndex, leftIndex, downIndex, rightIndex = leftIndex, downIndex, rightIndex, l
    SetCamera(color)
end

function toggleLevitating() levitating = not levitating applyPhysics() UpdateSave() end
function toggleBob()        bobEnabled = not bobEnabled UpdateSave() end
-- ---------------- ввод ----------------
local function ExitControl(color)
    local obj = self.clone()
    Player[color].attachCameraToObject({ object = obj })
    obj.destruct()
    Player[color].setCameraMode("ThirdPerson")

    controllingPlayerColor, prevCPC = nil, nil
    for k in pairs(held) do held[k] = false end
    if moveSound and self.AssetBundle then
        self.AssetBundle.stopLoopingEffect() moveSound = false
    end
    levitating = true
    applyPhysics()
    self.setRotation({ x = 0, y = rotateY, z = 0 })

    -- вернуть родной скрипт миниатюры, если он был
    local prev = self.getVar("cf_prev_script")
    if prev and prev ~= "" then
        self.setVar("cf_prev_script", "")
        self.setLuaScript(prev)
    end
end

function onScriptingButtonDown(index, color)
    if index == lookScreenIndex and prevCPC == color and controllingPlayerColor == nil then
        SetCamera(color)
    end
    if color ~= controllingPlayerColor then return end

    if index == upIndex then held.up = true
    elseif index == leftIndex then held.left = true
    elseif index == downIndex then held.down = true
    elseif index == rightIndex then held.right = true
    elseif index == ascendIndex then held.ascend = true
    elseif index == descendIndex then held.descend = true
    elseif index == exitScreenIndex then ExitControl(color)
    end
end

function onScriptingButtonUp(index, color)
    if color ~= controllingPlayerColor then return end
    if index == upIndex then held.up = false
    elseif index == leftIndex then held.left = false
    elseif index == downIndex then held.down = false
    elseif index == rightIndex then held.right = false
    elseif index == ascendIndex then held.ascend = false
    elseif index == descendIndex then held.descend = false
    end
end
-- ---------------- основной цикл ----------------
function onUpdate()
    if controllingPlayerColor == nil then return end
    local d = dt()
    if rb and rb.get("isKinematic") then rb.set("isKinematic", false) end

    -- рыскание: базис не зависит от наклона объекта
    rotateY = Player[controllingPlayerColor]:getPointerRotation() + offsetRotate
    local forward = Vector(0, 0, 1):rotateOver("y", rotateY)
    local right   = Vector(1, 0, 0):rotateOver("y", rotateY)

    -- цель по горизонтали
    local tvx, tvz = 0, 0
    if held.up then
        tvx = tvx + forward.x * cfg.moveSpeed
        tvz = tvz + forward.z * cfg.moveSpeed
    end
    if held.down then
        tvx = tvx - forward.x * cfg.moveSpeed
        tvz = tvz - forward.z * cfg.moveSpeed
    end
    if held.right then
        tvx = tvx + right.x * cfg.moveSpeed
        tvz = tvz + right.z * cfg.moveSpeed
    end
    if held.left then
        tvx = tvx - right.x * cfg.moveSpeed
        tvz = tvz - right.z * cfg.moveSpeed
    end

    -- цель по вертикали: ввод либо удержание высоты
    local tvy = 0
    if held.ascend then
        tvy = cfg.ascendSpeed
    elseif held.descend then
        tvy = -cfg.ascendSpeed
    elseif levitating then
        local gy = groundHeight()
        if gy then
            bobPhase = bobEnabled and (bobPhase + d * cfg.bobSpeed) or 0
            local bob = bobEnabled and math.sin(bobPhase) * cfg.hoverBob or 0
            local b = self.getBounds()
            local err = (gy + cfg.hoverHeight + b.size.y * 0.5 + bob) - b.center.y
            tvy = clamp(err * cfg.hoverGain, -cfg.ascendSpeed, cfg.ascendSpeed)
        end
    end

    -- плавный разгон вместо мгновенной установки скорости
    local v, step = self.getVelocity(), cfg.accel * d
    self.setVelocity({
        x = approach(v.x, tvx, step),
        y = approach(v.y, tvy, step),
        z = approach(v.z, tvz, step),
    })

    self.setRotation({ x = 0, y = rotateY, z = 0 })

    -- звук движения: один старт и один стоп, а не перезапуск каждый кадр
    if indexMove and indexMove ~= -1 then
        local moving = (tvx ~= 0 or tvz ~= 0)
        if moving and not moveSound then
            self.AssetBundle.playLoopingEffect(indexMove)
            moveSound = true
        elseif not moving and moveSound then
            self.AssetBundle.stopLoopingEffect()
            moveSound = false
        end
    end
end
]]

function onCollisionEnter(info)
    local obj = info.collision_object
    if not obj then return end
    if obj.getPosition().y < self.getPosition().y then return end

    local script = obj.getLuaScript()
    if script == CameraFollow then return end          -- не перезаписываем себя

    if script ~= "" then obj.setVar("cf_prev_script", script) end
    obj.setLuaScript(CameraFollow)
    print("[CameraFollow] injected: " .. obj.getName())
end