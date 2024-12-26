function onLoad()
    oneWorld = getObjectFromGUID(self.getGMNotes())
end
-- Build --
function CreateBugBuild(bag)
    oneWorld.setVar("iBag", bag)
    bag.lock() iBag = bag
    Build()
end

function Build()
    local bagObjects = iBag.getObjects()
    prs = oneWorld.getVar("aBase").getLuaScript()
    if prs == "" or not bagObjects[1] then return end
    prs = string.gsub(prs, string.char(10), string.char(44))
    local pX, pY, pZ, rX, rY, rZ, n
    do
        ss = ""
        local index, dc, o = 1, 0, {}
        Wait.condition(function()
            Wait.time(function() oneWorld.setVar("prs", prs) oneWorld.setVar("ss", ss) Wait.time(|| PickLocks(), 0.2) end, 0.2)
        end,
        function()
            if(index <= #bagObjects) then
                n = string.find(prs, "-"..bagObjects[index].guid..",")
                if n then
                    n = n + 8
                    pX, n = SnipIt(n) pY, n = SnipIt(n) pZ, n = SnipIt(n)
                    rX, n = SnipIt(n) rY, n = SnipIt(n) rZ, n = SnipIt(n)
                    local t = {
                        guid = bagObjects[index].guid, position = {pX, pY, pZ}, rotation = {rX, rY, rZ},
                        callback = "UnderPack", callback_owner = self, smooth = false
                    }
                    iBag.takeObject(t)
                end
                index = index + 1
            end
            return index >= #bagObjects
        end)
    end
end
function UnderPack(obj)
    ss = ss..obj.guid obj.lock()
    if(obj.hasTag("noInteract")) then obj.interactable = false else obj.interactable = true end
end

function SnipIt(id)
    local e = string.find(prs, string.char(44), id)
    return string.sub(prs, id, e - 1), e + 1
end

function PickLocks()
    broadcastToAll("Finished Building.", {0.943, 0.745, 0.14})
    if iBag then
        iBag.destruct()
        oneWorld.setVar("iBag", nil)
    end
    Wait.time(|| oneWorld.call("SetUI"), 0.1)
end
----------

-- Pack --
function DoPack(a)
    ss = oneWorld.getVar("ss")
    for i = 0, string.len(ss)/6 - 1 do
        a.putObject(getObjectFromGUID(string.sub(ss, i*6 + 1, i*6 + 6)))
    end
    oneWorld.getVar("aBase").setDescription(a.guid)
    iBag = a
    local z2 = 1
    Wait.time(|| Pack(z2), 0.2, 5)
end
function Pack(z2)
    if ss == "" then
        Wait.stopAll()
        Wait.time(|| EndPack(), 0.2)
    end
    local i, g
    for i = 0, string.len(ss)/6 - 1 do  g = string.sub(ss, i*6 + 1, i*6 + 6)
        if not getObjectFromGUID(g) then ss = string.sub(ss, 1, i*6)..string.sub(ss, i*6 + 7) end
    end
    if ss == "" then return end
    z2 = z2 + 1
    if z2/10 == math.modf(z2/10) then
        broadcastToAll("Pass"..(z2/10).."...", {0.943, 0.745, 0.14})
    end
    if z2 > 68 then
        broadcastToAll("Manual Inspection Required.", {0.943, 0.745, 0.14})
        for i = 0, string.len(ss)/6 - 1 do
            g = string.sub(ss, i*6 + 1, i*6 + 6)
            getObjectFromGUID(g).resting = true
            getObjectFromGUID(g).setPosition({0, 3, 0})
        end
        ss = ""
    end
end
function EndPack()
    if iBag then
        self.putObject(iBag)
        iBag = nil
    end
    oneWorld.call("JotBase")
    oneWorld.call("StowBase")
    oneWorld.call("NoBase")
    oneWorld.call("SetUIText")
    oneWorld.setVar("ss", ss)
    broadcastToAll("Packing Complete.", {0.943, 0.745, 0.14})
    Wait.time(|| oneWorld.call("SetUI"), 0.1)
end
----------

-- Export --
function Export(bag)
    local eBase = oneWorld.getVar("aBase").clone({position = {-7, -23, -4}})
    bag.setName("OW"..string.sub(eBase.getName(), 3))
    local s, n = eBase.getLuaScript(), 0
    while n + 5 < string.len(s) do
        local g = string.sub(s, n + 3, n + 8)
        if getObjectFromGUID(g) then bag.putObject(getObjectFromGUID(g)) end
        n = string.find(s, string.char(10), n + 3)
    end
    local sizes = oneWorld.getVar("tSizeVPlates")[oneWorld.getVar("aBase").getGUID()] or {1.85, 1, 1.85}
    s = string.format("%s,{%f;1;%f},%d,%d,2,%d", eBase.getGUID(), sizes[1], sizes[3], oneWorld.getVar("r1"), oneWorld.getVar("r3"), oneWorld.getVar("r90"))
    bag.setDescription(s) eBase.setDescription(bag.getGUID()) bag.putObject(eBase)
    oneWorld.setVar("iBag", nil)
    Wait.time(|| oneWorld.call("SetUI"), 0.1)
end
----------