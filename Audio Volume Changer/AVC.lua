function onLoad()
    audioVolume = 0.1
end
function changeVolume(player, rapidly, id)
    audioVolume = tonumber(string.format("%.2f", rapidly))
    self.UI.setAttribute("im_fill", "width", 150*math.abs(audioVolume - 0.5))
    self.UI.setAttribute("im_fill", "position", "120 "..tostring(75*audioVolume).." -30")
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