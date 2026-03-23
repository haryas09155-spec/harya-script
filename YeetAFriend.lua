---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/YeetAFriend.lua"))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Yeet A Friend Haryas script",
   LoadingTitle = "Loading Yeet A Friend Haryas script",
   LoadingSubtitle = "by Haryas",
   ConfigurationSaving = {Enabled = true, FolderName = "YeetAFriend", FileName = "Config"},
   Discord = {Enabled = true, Invite = "https://discord.gg/M6Pcqt3AR9", RememberJoins = true},
   KeySystem = false
})

local Tabs = {
   Main = Window:CreateTab("Main", 4483362458),
   Player = Window:CreateTab("Player", 4483362458),
   Misc = Window:CreateTab("Misc", 4483362458)
}

-- Services
local Players, ReplicatedStorage, RunService, UserInputService = 
game:GetService("Players"), game:GetService("ReplicatedStorage"), 
game:GetService("RunService"), game:GetService("UserInputService")

local player = Players.LocalPlayer
local loops = {} -- Track all toggle loops

-- Anti-AFK
spawn(function()
   while wait(60) do
      local vu = game:GetService("VirtualUser")
      vu:CaptureController()
      vu:ClickButton2(Vector2.new())
   end
end)

-- Function to safely stop loops
local function stopLoop(name)
   if loops[name] then
      loops[name]:Disconnect()
      loops[name] = nil
   end
end

-- Get Rubux Pets
Tabs.Main:CreateToggle({
   Name = "Get Rubux Pets",
   CurrentValue = false,
   Flag = "PetsToggle",
   Callback = function(value)
      stopLoop("Pets")
      if value then
         loops.Pets = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
               -- Common pet remote names - adjust if needed
               local remotes = {"SpawnPet", "EquipPet", "PurchasePet"}
               for _, remoteName in pairs(remotes) do
                  if ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild(remoteName) then
                     ReplicatedStorage.Remotes[remoteName]:FireServer("Rubux")
                  end
               end
            end)
         end)
      end
   end,
})

-- Super Throw E
local superThrowEnabled = false
Tabs.Main:CreateToggle({
   Name = "Super Throw (E Key)",
   CurrentValue = false,
   Flag = "SuperThrow",
   Callback = function(value)
      superThrowEnabled = value
   end,
})

UserInputService.InputBegan:Connect(function(input)
   if input.KeyCode == Enum.KeyCode.E and superThrowEnabled then
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         local direction = char.HumanoidRootPart.CFrame.LookVector * 500 + Vector3.new(0, 100, 0)
         pcall(function()
            ReplicatedStorage.Remotes.YeetPlayer:FireServer(direction)
            -- Try common yeet remote names
            local yeetRemotes = {"Yeet", "ThrowPlayer", "LaunchPlayer"}
            for _, name in pairs(yeetRemotes) do
               if ReplicatedStorage.Remotes:FindFirstChild(name) then
                  ReplicatedStorage.Remotes[name]:FireServer(direction)
               end
            end
         end)
      end
   end
end)

-- Collect Stars
Tabs.Main:CreateToggle({
   Name = "Auto Collect Stars", 
   CurrentValue = false,
   Flag = "CollectToggle",
   Callback = function(value)
      stopLoop("Collect")
      if value then
         loops.Collect = RunService.Heartbeat:Connect(function()
            pcall(function()
               if workspace:FindFirstChild("Stars") then
                  for _, star in pairs(workspace.Stars:GetChildren()) do
                     if star:IsA("BasePart") then
                        local collectRemote = ReplicatedStorage.Remotes:FindFirstChild("CollectStar") or 
                                             ReplicatedStorage.Remotes:FindFirstChild("Collect")
                        if collectRemote then collectRemote:FireServer(star) end
                     end
                  end
               end
            end)
         end)
      end
   end,
})

-- Auto Rebirth
Tabs.Main:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "RebirthToggle",
   Callback = function(value)
      stopLoop("Rebirth")
      if value then
         loops.Rebirth = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
               local rebirthRemote = ReplicatedStorage.Remotes:FindFirstChild("Rebirth") or 
                                    ReplicatedStorage.Remotes:FindFirstChild("RebirthRequest")
               if rebirthRemote then rebirthRemote:FireServer() end
            end)
         end)
      end
   end,
})

-- Yeet All (one-shot)
Tabs.Main:CreateButton({
   Name = "Yeet All Players",
   Callback = function()
      for _, plr in pairs(Players:GetPlayers()) do
         if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local direction = Vector3.new(math.random(-100,100), 200, math.random(-100,100))
            pcall(function()
               ReplicatedStorage.Remotes.YeetPlayer:FireServer(direction)
            end)
         end
      end
   end,
})

-- Walkspeed with proper hook
local speedConnection
Tabs.Player:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(value)
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = value
      end
   end,
})

-- Speed loop
spawn(function()
   while wait(0.1) do
      local speed = Window.Flags.SpeedSlider or 16
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.WalkSpeed = speed
      end
   end
end)

-- Godmode
Tabs.Player:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Flag = "GodmodeToggle",
   Callback = function(value)
      stopLoop("Godmode")
      if value then
         loops.Godmode = RunService.Heartbeat:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
               local hum = player.Character.Humanoid
               hum.MaxHealth = math.huge
               hum.Health = math.huge
            end
         end)
      end
   end,
})

-- ESP
local espObjects = {}
Tabs.Player:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(value)
      -- Clean up existing ESP
      for _, obj in pairs(espObjects) do
         if obj and obj.Parent then obj:Destroy() end
      end
      espObjects = {}
      
      if value then
         for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
               spawn(function()
                  repeat wait() until plr.Character
                  local char = plr.Character
                  local head = char:WaitForChild("Head")
                  
                  local billboard = Instance.new("BillboardGui")
                  billboard.Name = "ESP"
                  billboard.Parent = head
                  billboard.Size = UDim2.new(0, 200, 0, 50)
                  billboard.StudsOffset = Vector3.new(0, 3, 0)
                  
                  local text = Instance.new("TextLabel")
                  text.Parent = billboard
                  text.Size = UDim2.new(1, 0, 1, 0)
                  text.BackgroundTransparency = 1
                  text.Text = plr.Name.." ["..math.floor((plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude).."m]"
                  text.TextColor3 = Color3.new(1, 0, 0)
                  text.TextStrokeTransparency = 0
                  text.TextScaled = true
                  text.Font = 2
                  
                  table.insert(espObjects, billboard)
                  
                  -- Update distance
                  spawn(function()
                     while char.Parent and espObjects do
                        if text.Parent then
                           local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                           text.Text = plr.Name.." ["..math.floor(dist).."m]"
                        end
                        wait(0.5)
                     end
                  end)
               end)
            end
         end
      end
   end,
})

-- Infinite Jump
Tabs.Player:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "JumpToggle",
   Callback = function(value)
      if value then
         loops.Jump = UserInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
               player.Character.Humanoid:ChangeState(3)
            end
         end)
      else
         stopLoop("Jump")
      end
   end,
})

-- UI Toggle
Tabs.Misc:CreateKeybind({
   Name = "Toggle UI (K)",
   CurrentKeybind = "K",
   HoldToInteract = false,
   Flag = "UIToggle",
   Callback = function()
      Rayfield:Toggle()
   end,
})

Rayfield:Notify({
   Title = "Fixed! ✅",
   Content = "All toggles now work properly (enable/disable). Press K to toggle UI.",
   Duration = 4.5,
})

print("Yeet A Friend Hub v2 - Fixed Toggles Loaded!")
