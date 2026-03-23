---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/Haryas script 15+.lua"))()
repeat wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Haryas script Free 15+ Games",
   LoadingTitle = "Haryas Script",
   LoadingSubtitle = "by Haryas",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "haryashub",
      FileName = "haryasconfig"
   },
   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/M63UaYpk9E", 
      RememberJoins = true
   },
   KeySystem = true
})

local Tab = Window:CreateTab("Main", 4483362458)

-- Key system toggle
local KeyToggle = Tab:CreateToggle({
   Name = "Enable Key System",
   CurrentValue = true,
   Flag = "KeySystemToggle",
   Callback = function(Value)
      -- Add your key system logic here when toggle changes
      if Value then
         Rayfield:Notify({
            Title = "Haryas Script",
            Content = "Key system enabled",
            Duration = 3,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "Haryas Script", 
            Content = "Key system disabled",
            Duration = 3,
            Image = 4483362458,
         })
      end
   end,
})

local Button1 = Tab:CreateButton({
   Name = "Get Key",
   Callback = function()
      setclipboard("https://discord.gg/M63UaYpk9E")
      Rayfield:Notify({
         Title = "Link Copied",
         Content = "key in discord",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

local Button2 = Tab:CreateButton({
   Name = "Get Key (Rinku)", 
   Callback = function()
      setclipboard("Haryas_Script")
      Rayfield:Notify({
         Title = "Key Copied",
         Content = "Haryas_Script copied to clipboard", 
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

local Button3 = Tab:CreateButton({
   Name = "Join Discord",
   Callback = function()
      setclipboard("https://discord.gg/M63UaYpk9E")
      Rayfield:Notify({
         Title = "Discord Copied",
         Content = "Discord invite copied to clipboard",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

local Button4 = Tab:CreateButton({
   Name = "Key",
   Callback = function()
      setclipboard("https://discord.gg/M63UaYpk9E")
      Rayfield:Notify({
         Title = "Link Copied",
         Content = "key in discord",
         Duration = 3,
         Image = 4483362458,
      })
   end,
})

local KeyInput = Tab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Paste your key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      -- Add your key validation logic here
      Rayfield:Notify({
         Title = "Key Entered",
         Content = "Validating key: " .. Text,
         Duration = 4,
         Image = 4483362458,
      })
   end,
})

-- Game support list
Tab:CreateParagraph({Title = "Supported Games", Content = "Jujutsu Infinite, Blox Fruits, Shindo Life, Rivals, Jailbreak, Dead Rails, 99 Nights in the Forest, The Forge, and more!"})

-- Additional toggles for common features
local AutoFarmToggle = Tab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      -- Add your autofarm logic here
   end,
})

local ESPToggle = Tab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESPToggle", 
   Callback = function(Value)
      -- Add your ESP logic here
   end,
})

local SpeedToggle = Tab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      -- Add your speed hack logic here
   end,
})

Rayfield:Notify({
   Title = "Haryas Hub Loaded",
   Content = "gugu gagagag",
   Duration = 6.5,
   Image = 4483362458,
})
