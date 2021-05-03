function UpdateSave()
  local dataToSave = {
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  Wait.time(function()
    Wait.time(|| Confer(savedData), 0.2)
  end, 0.5)
end

function Confer(savedData)
  RebuildAssets()
  local loadedData = JSON.decode(savedData or "")
  ChangeUI()
end

function ChangeUI()
  UpdateSave()
end

function RebuildAssets()
  local backG = 'https://i.imgur.com/WQiHEAd.png'
  local assets = {
    {name = 'uiBackGroundW', url = backG},
  }
  self.UI.setCustomAssets(assets)
end