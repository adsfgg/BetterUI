Script.Load("lua/BetterUI/GUI/GUICustomizeHUD.lua")
local player = Client.GetLocalPlayer()
if kInGame then
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
                        {"Label", "Configure HUD"}
                    },
                    postInit = {
                        function (self)
                            self:HookEvent(self, "OnPressed", function()
                                local MainMenu = GetMainMenu and GetMainMenu()
                                if MainMenu then
                                    local player = Client.GetLocalPlayer()
                                    if player and player.GetTeamNumber and (player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index) then
                                        if MainMenu.Close then
                                            MainMenu:Close()
                                        end

                                        GetGUIManager():CreateGUIScript("GUICustomizeHUD")
                                    else
                                        MainMenu:DisplayPopupMessage("BetterUI is not supported for this team", "Better UI")
                                    end
                                end
                            end)
                        end
                    }
                }
            }
        })
    })
else
    table.insert(gModsCategories, {
        categoryName = "BetterUI",
        entryConfig = {
            name = "BetterUIModEntry",
            class = GUIMenuCategoryDisplayBoxEntry,
            params = {
                label = "BetterUI"
            }
        },
        contentsConfig = {
            name = "betteruiDisabledTooltipHolder",
            class = GUIObject,
            postInit = ModsMenuUtils.SyncToParentSize,
            children = {
                {
                    name = "betteruiDisabledTooltip",
                    class = GUIText,
                    params = {
                        text = "HUD can only be customised in-game",
                        fontFamily = "Agency",
                        fontSize = 48,
                        color = MenuStyle.kOptionHeadingColor,
                        align = "center",
                    }
                }
            }
        }
    })
end
