function onLoad()
    audioVolume = 0.1
end
function changeVolume(player, rapidly, id)
    audioVolume = tonumber(string.format("%.2f", rapidly))
    for _, audio in pairs(self.getComponents("AudioSource")) do
        audio.set("volume", audioVolume)
    end
end
function onObjectLoopingEffect()
    for _, audio in pairs(self.getComponents("AudioSource")) do
        audio.set("volume", audioVolume)
    end
end
function onObjectTriggerEffect()
    for _, audio in pairs(self.getComponents("AudioSource")) do
        audio.set("volume", audioVolume)
    end
end