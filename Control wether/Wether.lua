function onLoad()
    rainGUID = {"fd4407", "71e7f1"}
    snowGUID = {"536879", "13343d"}
end

function RainSwitch()
    for i = 1, 2 do
        local locObj = getObjectFromGUID(rainGUID[i])
        local curIndex = locObj.AssetBundle.getLoopingEffectIndex()
        curIndex = curIndex - 1
        if curIndex == -1 then curIndex = #locObj.AssetBundle.getLoopingEffects() - 1 end
        locObj.AssetBundle.playLoopingEffect(curIndex)
    end
end

function SnowSwitch()
    for i = 1, 2 do
        local locObj = getObjectFromGUID(snowGUID[i])
        local curIndex = locObj.AssetBundle.getLoopingEffectIndex()
        curIndex = curIndex - 1
        if curIndex == -1 then curIndex = #locObj.AssetBundle.getLoopingEffects() - 1 end
        locObj.AssetBundle.playLoopingEffect(curIndex)
    end
end