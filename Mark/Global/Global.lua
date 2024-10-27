function PanelOne(player)
    if(self.UI.getAttribute("panelTool", "active") == "false") then
        self.UI.show("panelTool")
        self.UI.setAttribute("panelTool", "visibility", player.color)
    else
        self.UI.hide("panelTool")
    end
end