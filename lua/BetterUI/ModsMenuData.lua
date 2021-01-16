table.insert(gModsCategories, {
    categoryName = "BetterUI",
    entryConfig = {
        name = "BetterUIModEntry",
        class = GUIMenuCategoryDisplayBoxEntry,
        params = {
            label = "Better UI"
        },
    },
    contentsConfig = ModsMenuUtils.CreateBasicModsMenuContents({
        layoutName = "BetterUIOptions",
        contents = {
            {
                name = "BetterUIConfigure",
                class = GUIMenuButton,
                properties = {
                    {"Label", "Configure UI and HUD Settings"}
                },
                postInit = {
                    function (self)
                        self:HookEvent(self, "OnPressed", function()
                            local MainMenu = GetMainMenu and GetMainMenu()
                            if kInGame then
                                local MainMenu = GetMainMenu and GetMainMenu()
                                if MainMenu and MainMenu.Close then
                                    MainMenu:Close()
                                end

                                PlayerUI_SetBetterUIEnabled()
                            else
                                MainMenu:DisplayPopupMessage("This option can only be used in game", "Better UI") 
                            end
                        end)
                    end
                }
            }
        }
    })
})
