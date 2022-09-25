Script.Load("lua/BetterUI/GUI/GUICustomizeHUD.lua")

local function SyncContentsSize(self, size)
    self:SetContentsSize(size) 
end

local function SyncParentContentsSizeToLayout(self)
    local parent = self:GetParent():GetParent():GetParent()
    assert(parent)
    
    parent:HookEvent(self, "OnSizeChanged", SyncContentsSize)
end

local function CreateHeadingGroup(paramsTable)
    RequireType({"table", "nil"}, paramsTable.params, "paramsTable.params", 2) 

    return {
        name = paramsTable.name,
        class = GUIMenuExpandableGroup,
        params = CombineParams(paramsTable.params or {}, { expansionMargin = 4 }),
        properties = {
            { "Label", paramsTable.label }
        },
        children = {
            {
                name = "layout",
                class = GUIListLayout,
                params = {
                    orientation = "vertical",
                },
                properties = {
                    { "FrontPadding", 32 },
                    { "BackPadding", 32 },
                    { "Spacing", 15 },
                },
                postInit = { SyncParentContentsSizeToLayout },
                children = paramsTable.children
            }
        }
    }
end

local function CreateCheckboxOption(option)
    return {
        name = option.name,
        sort = option.sort or string.format("Z%s", option.name),
        class = OP_TT_Checkbox,
        params = {
            optionPath = option.name,
            optionType = "bool",
            default = option.default,

            tooltip = option.tooltip,
            tooltipIcon = option.tooltipIcon,

            immediateUpdate = option.immediateUpdate
        },
        properties = { 
            { "Label", string.upper(option.label) }
        },
    }
end

local function ConfigureHud()
    local MainMenu = GetMainMenu and GetMainMenu()
    if not MainMenu then
        print("BetterUI: Failed to get MainMenu")
        return
    end

    if PlayerUI_GetCanTeamCustomiseHud() then
        if MainMenu.Close then
            MainMenu:Close()
        end

        GetGUIManager():CreateGUIScript("GUICustomizeHUD")
    else
        MainMenu:DisplayPopupMessage("HUD Customization is not supported for this team", "Better UI")
    end
end

local function ResetPopup()
    CreateGUIObject("popup", GUIMenuPopupSimpleMessage, nil, {
        title = "Reset HUD Layout",
        message = "Reset all HUD elements to default?",
        buttonConfig = {
            -- Confirm
            {
                name = "betterUI_confirmReset",
                params = { label = "YES, RESET" },
                callback = function(popup)
                    popup:Close()
                    PlayerUI_ResetHUDToDefault()
                end
            },

            -- Cancel
            GUIPopupDialog.CancelButton
        }
    })
end

local function ClearPopup()
    CreateGUIObject("popup", GUIMenuPopupSimpleMessage, nil, {
        title = "Clear HUD Layout",
        message = "Clear all HUD elements?",
        buttonConfig = {
            -- Confirm
            {
                name = "betterUI_confirmClear",
                params = { label = "YES, CLEAR" },
                callback = function(popup)
                    popup:Close()
                    PlayerUI_ClearHUD()
                end
            },

            -- Cancel
            GUIPopupDialog.CancelButton
        }
    })
end

local function CreateBetterUIMenu()
    -- Data for each heading group
    local headingEntries = {
        marine = {
            CreateCheckboxOption {
                name = "betterui_hudLines",
                label = "HUD Lines",
                default = true,
                tooltip = "Controls the visibility of the HUD lines",
                immediateUpdate = function(self, value)
                    if Client and Client.BetterUI_SetMarineLines then
                        Client.BetterUI_SetMarineLines(value)
                        SafePlayerHUDRefreshVisibility()
                    end
                end
            },
            CreateCheckboxOption {
                name = "betterui_marinePoisonFeedback",
                label = "Poison Feedback",
                default = true,
                tooltip = "Controls the visibility of the Marine poison feedback in the bottom of the screen",
                immediateUpdate = function(self, value)
                    if Client and Client.BetterUI_SetMarinePoison then
                        Client.BetterUI_SetMarinePoison(value)
                        SafePlayerHUDRefreshVisibility()
                    end
                end
            }
        },

        alien = {
        },
    }

    local menu = {}

    for i,v in pairs(headingEntries) do
        local heading = string.upper(i)
        table.insert(menu, CreateHeadingGroup {
            name = string.format("betterui%sOptions", heading),
            label = heading,
            children = v
        })
    end

    -- Add the customise hud button
    table.insert(menu, {
        name = "BetterUIConfigureHud",
        class = GUIMenuButton,
        properties = {
            { "Label", "Configure HUD" }
        },
        postInit = {
            function (self)
                self:HookEvent(self, "OnPressed", ConfigureHud)
            end
        }
    })

    -- Add reset hud button
    table.insert(menu, {
        name = "BetterUIResetHud",
        class = GUIMenuButton,
        properties = {
            { "Label", "Reset HUD" }
        },
        postInit = {
            function (self)
                self:HookEvent(self, "OnPressed", ResetPopup)
            end
        }
    })

    -- Add clear hud button
    table.insert(menu, {
        name = "BetterUIClearHud",
        class = GUIMenuButton,
        properties = {
            { "Label", "Clear HUD" }
        },
        postInit = {
            function (self)
                self:HookEvent(self, "OnPressed", ClearPopup)
            end
        }
    })

    return menu
end

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
            contents = CreateBetterUIMenu()
            -- contents = {
            --     {
            --         name = "BetterUIConfigure",
            --         class = GUIMenuButton,
            --         properties = {
            --             {"Label", "Configure HUD"}
            --         },
            --         postInit = {
            --             function (self)
            --                 self:HookEvent(self, "OnPressed", function()
            --                     local MainMenu = GetMainMenu and GetMainMenu()
            --                     if MainMenu then
            --                         local player = Client.GetLocalPlayer()
            --                         if player and player.GetTeamNumber and (player:GetTeamNumber() == kTeam1Index or player:GetTeamNumber() == kTeam2Index) then
            --                             if MainMenu.Close then
            --                                 MainMenu:Close()
            --                             end

            --                             GetGUIManager():CreateGUIScript("GUICustomizeHUD")
            --                         else
            --                             MainMenu:DisplayPopupMessage("BetterUI is not supported for this team", "Better UI")
            --                         end
            --                     end
            --                 end)
            --             end
            --         }
            --     }
            -- }
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
