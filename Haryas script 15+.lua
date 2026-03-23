---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/Haryas script 15+.lua"))()
repeat wait() until game:IsLoaded()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Haryas script Free 15+ Games", "DarkTheme")

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Haryas Script")

MainSection:NewToggle("Enable Key System", "Toggle key system", function(state)
    if state then
        Library:Notify("Haryas Script", "Key system enabled", 3)
    else
        Library:Notify("Haryas Script", "Key system disabled", 3)
    end
end)

MainSection:NewButton("Get Key", "Copy discord link", function()
    setclipboard("https://discord.gg/M63UaYpk9E")
    Library:Notify("Link Copied", "key in discord", 3)
end)

MainSection:NewButton("Get Key (Rinku)", "Copy Haryas_Script", function()
    setclipboard("Haryas_Script")
    Library:Notify("Key Copied", "Haryas_Script copied!", 3)
end)

MainSection:NewButton("Join Discord", "Copy discord invite", function()
    setclipboard("https://discord.gg/M63UaYpk9E")
    Library:Notify("Discord Copied", "Discord invite copied!", 3)
end)

MainSection:NewButton("Key", "Copy key link", function()
    setclipboard("https://discord.gg/M63UaYpk9E")
    Library:Notify("Link Copied", "key in discord", 3)
end)

MainSection:NewTextBox("Enter Key", "Paste your key here", function(txt)
    Library:Notify("Key Entered", "Validating: " .. txt, 4)
end)

MainSection:NewLabel("Supported Games:", "Jujutsu Infinite, Blox Fruits, Shindo Life, Rivals, Jailbreak, Dead Rails, The Forge +15!")

MainSection:NewToggle("Auto Farm", "Enable autofarm", function(state)
    -- Your autofarm code
end)

MainSection:NewToggle("ESP", "Enable ESP", function(state)
    -- Your ESP code
end)

MainSection:NewToggle("Speed Hack", "Enable speed", function(state)
    -- Your speed code
end)

Library:Notify("Haryas Hub Loaded", "gugu gagagag", 6)
