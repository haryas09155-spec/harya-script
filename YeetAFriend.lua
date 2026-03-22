
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Yeet A Friend | Toggle Hacks ✅",
   LoadingTitle = "Loading Toggle System...",
   LoadingSubtitle = "All Hacks Toggleable",
   ConfigurationSaving = {Enabled = true, FolderName = "YeetToggles", FileName = "Hacks"},
   KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local toggles = {
   InfiniteRubux = false,
   Godmode = false,
   YeetAll = false,
   AutoFarm = false,
   SuperSpeed = false,
   Noclip = false,
   ESP = false,
   AutoRebirth = false,
   FreePets = false
}

local connections = {}

-- Character handler
local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function getHRP() return getChar():FindFirstChild("HumanoidRootPart") end

-- Dynamic remote finder
local function findRemote(pattern)
   for _, obj in pairs(RS:GetDescendants()) do
      if obj:IsA("RemoteEvent") and string.find(obj.Name:lower(), pattern:lower()) then
         return obj
      end
   end
end

-- // HACK 1: INFINITE RUBUX/PETS/STATS
local BypassTab = Window:CreateTab("💰 Infinite Bypass", 4483362458)
BypassTab:CreateToggle({
   Name = "Infinite Rubux/Pets/Stats",
   CurrentValue = false,
   Callback = function(value)
      toggles.InfiniteRubux = value
      Rayfield:Notify({Title = "Infinite Bypass", Content = value and "✅ ENABLED" or "❌ DISABLED", Duration = 2})
      
      if value then
         connections.Infinite = game:GetService("RunService").Heartbeat:Connect(function()
            if toggles.InfiniteRubux then
               pcall(function()
                  for _, remote in pairs(RS:GetDescendants()) do
                     if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("rubux") or name:find("money") or name:find("coin") or name:find("gem") or name:find("pet") then
                           remote:FireServer(999999999)
                        elseif name:find("stats") or name:find("upgrade") then
                           for i = 1, 10 do remote:FireServer(i, 999999999) end
                        elseif name:find("hatch") then remote:FireServer("Rainbow", 999) end
                     end
                  end
               end)
            end
         end)
      else
         if connections.Infinite then connections.Infinite:Disconnect() end
      end
   end
})

-- // HACK 2: GODMODE + NOCLIP
local GodTab = Window:CreateTab("🛡️ Godmode", 4483362458)
GodTab:CreateToggle({
   Name = "Godmode + Noclip",
   CurrentValue = false,
   Callback = function(value)
      toggles.Godmode = value
      Rayfield:Notify({Title = "Godmode", Content = value and "✅ INVINCIBLE" or "❌ VULNERABLE", Duration = 2})
      
      if value then
         local char = getChar()
         local hum = char:FindFirstChildOfClass("Humanoid")
         hum.MaxHealth = math.huge
         hum.Health = math.huge
         
         connections.Noclip = RunService.Stepped:Connect(function()
            if toggles.Godmode then
               for _, part in pairs(getChar():GetChildren()) do
                  if part:IsA("BasePart") then part.CanCollide = false end
               end
            end
         end)
      else
         if connections.Noclip then connections.Noclip:Disconnect() end
         pcall(function()
            local hum = getChar():FindFirstChildOfClass("Humanoid")
            hum.MaxHealth = 100
            hum.Health = 100
         end)
      end
   end
})

-- // HACK 3: SUPER YEET (Hold E)
local YeetTab = Window:CreateTab("💥 Super Yeet", 4483362458)
YeetTab:CreateToggle({
   Name = "Super Yeet (Hold E)",
   CurrentValue = false,
   Callback = function(value)
      toggles.YeetAll = value
      Rayfield:Notify({Title = "Super Yeet", Content = value and "✅ HOLD E TO YEET" or "❌ DISABLED", Duration = 2})
   end
})

-- Yeet input handler
UserInputService.InputBegan:Connect(function(input)
   if toggles.YeetAll and input.KeyCode == Enum.KeyCode.E then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LP and player.Character then
            local target = player.Character:FindFirstChild("HumanoidRootPart")
            if target and (target.Position - getHRP().Position).Magnitude < 100 then
               local bv = Instance.new("BodyVelocity")
               bv.MaxForce = Vector3.new(40000, 40000, 40000)
               bv.Velocity = Vector3.new(math.random(-100,100), 200, math.random(-100,100))
               bv.Parent = target
               game.Debris:AddItem(bv, 2)
            end
         end
      end
   end
end)

-- // HACK 4: FULL AUTO FARM
local FarmTab = Window:CreateTab("🤖 Auto Farm", 4483362458)
FarmTab:CreateToggle({
   Name = "Auto Farm Everything",
   CurrentValue = false,
   Callback = function(value)
      toggles.AutoFarm = value
      Rayfield:Notify({Title = "Auto Farm", Content = value and "✅ COLLECTING..." or "❌ STOPPED", Duration = 2})
      
      if value then
         connections.AutoFarm = RunService.Heartbeat:Connect(function()
            if toggles.AutoFarm then
               -- Collect map items
               for _, obj in pairs(WS:GetChildren()) do
                  if obj:IsA("BasePart") and (obj.Name:lower():find("star") or obj.Name:lower():find("coin")) then
                     firetouchinterest(getHRP(), obj, 0)
                     wait()
                     firetouchinterest(getHRP(), obj, 1)
                  end
               end
               
               -- Fire collect remotes
               pcall(function()
                  local collect = findRemote("collect") or findRemote("claim")
                  if collect then collect:FireServer() end
               end)
            end
         end)
      else
         if connections.AutoFarm then connections.AutoFarm:Disconnect() end
      end
   end
})

-- // HACK 5: AUTO REBIRTH
FarmTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(value)
      toggles.AutoRebirth = value
      Rayfield:Notify({Title = "Auto Rebirth", Content = value and "✅ REBIRTHING..." or "❌ STOPPED", Duration = 2})
      
      spawn(function()
         while toggles.AutoRebirth do
            pcall(function()
               local rebirth = findRemote("rebirth") or RS:FindFirstChild("RebirthRemote")
               if rebirth then rebirth:FireServer() end
            end)
            wait(3)
         end
      end)
   end
})

-- // HACK 6: SUPER SPEED
local SpeedTab = Window:CreateTab("⚡ Speed", 4483362458)
local SpeedToggle = SpeedTab:CreateToggle({
   Name = "Super Speed (Toggle)",
   CurrentValue = false,
   Callback = function(value)
      toggles.SuperSpeed = value
      local speed = value and 200 or 16
      pcall(function()
         getChar().Humanoid.WalkSpeed = speed
      end)
      Rayfield:Notify({Title = "Speed", Content = value and "⚡ 200x SPEED" or "🐌 NORMAL", Duration = 2})
   end
})

-- Speed persistence
LP.CharacterAdded:Connect(function(char)
   if toggles.SuperSpeed then
      char:WaitForChild("Humanoid").WalkSpeed = 200
   end
end)

-- // HACK 7: PLAYER ESP
local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)
ESPTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(value)
      toggles.ESP = value
      if value then
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
               local highlight = Instance.new("Highlight", player.Character)
               highlight.FillColor = Color3.new(1, 0, 0)
               highlight.OutlineColor = Color3.new(1, 1, 1)
            end
         end
      else
         for _, obj in pairs(WS:GetDescendants()) do
            if obj:IsA("Highlight") then obj:Destroy() end
         end
      end
      Rayfield:Notify({Title = "ESP", Content = value and "👁️ PLAYERS VISIBLE" or "❌ HIDDEN", Duration = 2})
   end
})

-- // MASTER TOGGLE - Enable/Disable ALL
local MasterTab = Window:CreateTab("🎮 Master Control", 4483362458)
MasterTab:CreateButton({
   Name = "ENABLE ALL HACKS",
   Callback = function()
      for k,v in pairs(toggles) do toggles[k] = true end
      Rayfield:Notify({Title = "ALL HACKS", Content = "✅ FULLY ENABLED", Duration = 3, Image = 4483362458})
   end
})

MasterTab:CreateButton({
   Name = "DISABLE ALL HACKS",
   Callback = function()
      for k,v in pairs(toggles) do toggles[k] = false end
      Rayfield:Notify({Title = "ALL HACKS", Content = "❌ FULLY DISABLED", Duration = 3, Image = 4483362458})
   end
})

-- Status notifications
Rayfield:Notify({
   Title = "🚀 Yeet A Friend Toggle Hub",
   Content = "✅ All hacks toggleable with status\n📱 Check each tab for ENABLE/DISABLE\n🎮 Master controls at bottom",
   Duration = 8,
   Image = 4483362458
})
