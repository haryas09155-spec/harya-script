---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/YeetAFriend.lua"))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Yeet A Friend",
   LoadingTitle = "Yeet A Friend Haryas Script",
   LoadingSubtitle = "by Haryas",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "YeetAFriendHub",
      FileName = "YeetAFriendConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "https://discord.gg/M6Pcqt3AR9", 
      RememberJoins = true
   },
   KeySystem = false
})

local Tabs = {
   Main = Window:CreateTab("Main", 4483362458),
   Player = Window:CreateTab("Player", 4483362458),
   Misc = Window:CreateTab("Misc", 4483362458)
}

-- Anti-AFK
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Variables
local speedConnection
local espConnections = {}
local godmodeEnabled = false
local superThrowEnabled = false

-- Get Rubux Pets (Fire remotes for pet spawning)
local getPetsSection = Tabs.Main:CreateSection("Get Rubux Pets")

local petToggle = Tabs.Main:CreateToggle({
   Name = "Get Rubux Pets (Auto)",
   CurrentValue = false,
   Flag = "GetPetsToggle",
   Callback = function(Value)
      if Value then
         spawn(function()
            while getconnections and getconnections(Tabs.Main.Flags.GetPetsToggle) do
               pcall(function()
                  ReplicatedStorage.Remotes.SpawnPet:FireServer("RubuxPet") -- Adjust remote name
                  ReplicatedStorage.Remotes.EquipPet:FireServer("RubuxPet")
               end)
               wait(1)
            end
         end)
      end
   end,
})

-- Super Throw (E Key)
local throwSection = Tabs.Main:CreateSection("Super Throw")
local superThrowToggle = Tabs.Main:CreateToggle({
   Name = "Super Throw (E Key)",
   CurrentValue = false,
   Flag = "SuperThrowToggle",
   Callback = function(Value)
      superThrowEnabled = Value
   end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
   if gameProcessed then return end
   if input.KeyCode == Enum.KeyCode.E and superThrowEnabled then
      pcall(function()
         local character = player.Character
         if character and character:FindFirstChild("HumanoidRootPart") then
            local target = character.HumanoidRootPart.Position + Vector3.new(math.random(-50,50), 50, math.random(-50,50))
            ReplicatedStorage.Remotes.YeetPlayer:FireServer(target * 100) -- Multiply distance for super throw
         end
      end)
   end
end)

-- Collect Stars
local collectSection = Tabs.Main:CreateSection("Auto Collect")
local collectToggle = Tabs.Main:CreateToggle({
   Name = "Collect Stars",
   CurrentValue = false,
   Flag = "CollectStarsToggle",
   Callback = function(Value)
      if Value then
         spawn(function()
            while collectToggle.Flags.CollectStarsToggle do
               pcall(function()
                  for _, star in pairs(workspace.Stars:GetChildren()) do
                     if star:IsA("BasePart") then
                        ReplicatedStorage.Remotes.CollectStar:FireServer(star)
                     end
                  end
               end)
               wait(0.1)
            end
         end)
      end
   end,
})

-- Auto Rebirth
local rebirthToggle = Tabs.Main:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirthToggle",
   Callback = function(Value)
      if Value then
         spawn(function()
            while rebirthToggle.Flags.AutoRebirthToggle do
               pcall(function()
                  ReplicatedStorage.Remotes.Rebirth:FireServer()
               end)
               wait(5)
            end
         end)
      end
   end,
})

-- Yeet All
local yeetAllToggle = Tabs.Main:CreateToggle({
   Name = "Yeet All Players",
   CurrentValue = false,
   Flag = "YeetAllToggle",
   Callback = function(Value)
      if Value then
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
               pcall(function()
                  ReplicatedStorage.Remotes.YeetPlayer:FireServer(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 100, 0))
               end)
            end
         end
         yeetAllToggle:Set(false)
      end
   end,
})

-- Player Mods
local speedSlider = Tabs.Player:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

Tabs.Player:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJumpToggle",
   Callback = function(Value)
      if Value then
         local conn
         conn = game:GetService("UserInputService").JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
               player.Character.Humanoid:ChangeState("Jumping")
            end
         end)
         Tabs.Player.Flags.InfiniteJumpToggle = conn
      else
         if typeof(Tabs.Player.Flags.InfiniteJumpToggle) == "RBXScriptConnection" then
            Tabs.Player.Flags.InfiniteJumpToggle:Disconnect()
         end
      end
   end,
})

-- Godmode
local godmodeToggle = Tabs.Player:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Flag = "GodmodeToggle",
   Callback = function(Value)
      godmodeEnabled = Value
      spawn(function()
         while godmodeEnabled do
            pcall(function()
               if player.Character and player.Character:FindFirstChild("Humanoid") then
                  player.Character.Humanoid.Health = 100
                  player.Character.Humanoid.MaxHealth = math.huge
               end
            end)
            wait(0.1)
         end
      end)
   end,
})

-- ESP Section
local espSection = Tabs.Player:CreateSection("ESP")
local espToggle = Tabs.Player:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      for _, connection in pairs(espConnections) do
         connection:Disconnect()
      end
      espConnections = {}
      
      if Value then
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
               local espConn = RunService.Heartbeat:Connect(function()
                  pcall(function()
                     if plr.Character and plr.Character:FindFirstChild("Head") then
                        local head = plr.Character.Head
                        local billboard = head:FindFirstChild("ESP") or Instance.new("BillboardGui")
                        billboard.Name = "ESP"
                        billboard.Parent = head
                        billboard.Size = UDim2.new(0, 100, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        
                        local text = billboard:FindFirstChild("ESPText") or Instance.new("TextLabel")
                        text.Name = "ESPText"
                        text.Parent = billboard
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.Text = plr.Name
                        text.TextColor3 = Color3.new(1, 0, 0)
                        text.TextStrokeTransparency = 0
                        text.TextScaled = true
                        text.Font = Enum.Font.SourceSansBold
                     end
                  end)
               end)
               table.insert(espConnections, espConn)
            end
         end
      end
   end,
})

-- Speed Hook (metatable protection bypass)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
   local method = getnamecallmethod()
   local args = {...}
   if method == "FireServer" and tostring(self) == "WalkSpeed" then
      return
   end
   return old(self, ...)
end)
setreadonly(mt, true)

-- Speed update connection
spawn(function()
   while wait() do
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = Tabs.Player.Flags.WalkSpeedSlider or 16
      end
   end
end)

-- Toggle UI Keybind
Rayfield:LoadConfiguration()

local ToggleUI = Tabs.Misc:CreateKeybind({
   Name = "Toggle UI",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "ToggleUIBind",
   Callback = function(Keybind)
      Rayfield:Toggle()
   end,
})

Tabs.Misc:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, player)
   end,
})

Rayfield:Notify({
   Title = "Yeet A Friend",
   Content = "Enjoy the script! Press K to toggle UI.And join discord https://discord.gg/M6Pcqt3AR9",
   Duration = 5,
   Image = 4483362458,
})
