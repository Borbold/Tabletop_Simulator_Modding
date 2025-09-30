function UpdateSave()
    local dataToSave = {
      ["inventoryGUID"] = inventoryGUID
    }
    local savedData = JSON.encode(dataToSave)
    self.script_state = savedData
end