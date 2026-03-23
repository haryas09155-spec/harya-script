---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/sharkbite2.lua"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Sharkbite 2",
	LoadingTitle = "Sharkbite 2 Haryas script",
	LoadingSubtitle = "by Haryas",
	Theme = "Default",
	ToggleUIKeybind = "K",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "SharkConfig"
	},
	Discord = {
		Enabled = true,
		Invite = "https://discord.gg/M6Pcqt3AR9",
		RememberJoins = true
	},
	KeySystem = false
})

local Tab = Window:CreateTab("Main", nil)

Tab:CreateToggle({
   Name = "Enable Key System",
   CurrentValue = false,
   Flag = "KeySystemToggle",
   Callback = function(Value)
      if Value then
         Rayfield:Notify({
            Title = "Haryas Script",
            Content = "Key system enabled",
            Duration = 3,
         })
      else
         Rayfield:Notify({
            Title = "Haryas Script",
            Content = "Key system disabled",
            Duration = 3,
         })
      end
   end,
})

Tab:CreateButton({
   Name = "Get Key",
   Callback = function()
      setclipboard("https://discord.gg/M63UaYpk9E")
      Rayfield:Notify({
         Title = "Link Copied",
         Content = "key in discord",
         Duration = 3,
      })
   end,
})

Tab:CreateButton({
   Name = "Get Key (Rinku)",
   Callback = function()
      setclipboard("Haryas_Script")
      Rayfield:Notify({
         Title = "Key Copied",
         Content = "Haryas_Script copied to clipboard",
         Duration = 3,
      })
   end,
})

Tab:CreateButton({
   Name = "Join Discord",
   Callback = function()
      setclipboard("https://discord.gg/M63UaYpk9E")
      Rayfield:Notify({
         Title = "Discord Copied",
         Content = "Discord invite copied to clipboard",
         Duration = 3,
      })
   end,
})

Tab:CreateButton({
   Name = "Key",
   Callback = function()
      setclipboard("https://discord.gg/M63UaYpk9E")
      Rayfield:Notify({
         Title = "Link Copied",
         Content = "key in discord",
         Duration = 3,
      })
   end,
})

Tab:CreateInput({
   Name = "Enter Key",
   PlaceholderText = "Paste your key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      Rayfield:Notify({
         Title = "Key Entered",
         Content = "Validating key: " .. Text,
         Duration = 4,
      })
   end,
})

Tab:CreateParagraph({
   Title = "Supported Games",
   Content = "Jujutsu Infinite, Blox Fruits, Shindo Life, Rivals, Jailbreak, Dead Rails, 99 Nights in the Forest, The Forge, and more!"
})

Tab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      -- Add your autofarm logic here
   end,
})

Tab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      -- Add your ESP logic here
   end,
})

Tab:CreateToggle({
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
})
