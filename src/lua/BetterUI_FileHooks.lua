-- GUI
ModLoader.SetupFileHook("lua/GUINotifications.lua", "lua/BetterUI/GUI/GUINotifications.lua", "replace")
ModLoader.SetupFileHook("lua/GUIScoreboard.lua", "lua/BetterUI/GUI/GUIScoreboard.lua", "post")

-- HUD
ModLoader.SetupFileHook("lua/Hud/Marine/GUIMarineHUD.lua", "lua/BetterUI/HUD/Marine/GUIMarineHUD.lua", "replace")
ModLoader.SetupFileHook("lua/Hud/Marine/GUIExoHUD.lua", "lua/BetterUI/HUD/Marine/GUIExoHUD.lua", "replace")
ModLoader.SetupFileHook("lua/GUIAlienHUD.lua", "lua/BetterUI/HUD/Alien/GUIAlienHUD.lua", "replace")

-- Rest
ModLoader.SetupFileHook("lua/Alien_Client.lua", "lua/BetterUI/Alien_Client.lua", "post")
ModLoader.SetupFileHook("lua/ClientUI.lua", "lua/BetterUI/ClientUI.lua", "replace")
ModLoader.SetupFileHook("lua/Marine_Client.lua", "lua/BetterUI/Marine_Client.lua", "post")
ModLoader.SetupFileHook("lua/menu2/NavBar/Screens/Options/Mods/ModsMenuData.lua", "lua/BetterUI/ModsMenuData.lua", "post")
ModLoader.SetupFileHook("lua/NS2ConsoleCommands_Client.lua", "lua/BetterUI/NS2ConsoleCommands_Client.lua", "post")
ModLoader.SetupFileHook("lua/Player_Client.lua", "lua/BetterUI/Player_Client.lua", "post")