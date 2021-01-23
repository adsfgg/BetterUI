local oldSendKeyEvent = GUIScoreboard.SendKeyEvent
function GUIScoreboard:SendKeyEvent(key, down)
    local val = oldSendKeyEvent(self, key, down)

    if GetIsBinding(key, "Scoreboard") then
        if self.visible then
            self.nextUpdateTime = Shared.GetTime()
            self.updateInterval = 0
        end
    end

    return val
end