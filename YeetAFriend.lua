---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/YeetAFriend.lua"))()
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Yeet A Friend Hub",
   LoadingTitle = "Yeet A Friend Haryas script",
   LoadingSubtitle = "by Haryas",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "YeetAFriendV2",
      FileName = "Config"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local FarmTab = Window:CreateTab("Auto Farm", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game-specific remotes (common in Yeet A Friend)
local Remotes = {
   Rebirth = ReplicatedStorage:FindFirstChild("ReplicatedStorage"):WaitForChild("RemoteEvent", 5) or ReplicatedStorage:FindFirstChild("RebirthRemote"),
   ClaimPet = ReplicatedStorage:FindFirstChild("ClaimPet"),
   CollectStar = ReplicatedStorage:FindFirstChild("CollectStar"),
   ThrowPlayer = ReplicatedStorage:FindFirstChild("ThrowPlayer"),
   HatchEgg = ReplicatedStorage:FindFirstChild("HatchEgg"),
   EquipBestPets = ReplicatedStorage:FindFirstChild("EquipBestPets")
}

-- Dynamically find remotes
local function findRemote(namePattern)
   for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
      if obj:IsA("RemoteEvent") and string.find(obj.Name:lower(), namePattern:lower()) then
         return obj
      end
   end
   return nil
end

-- 1. Get Rubux Pets (Free Pets)
local RubuxPetsSection = MainTab:CreateSection("Free Rubux Pets")

local FreePetsToggle = MainTab:CreateToggle({
   Name = "Get All Rubux Pets",
   CurrentValue = false,
   Callback = function(Value)
      spawn(function()
         while Value do
            pcall(function()
               -- Fire common pet claiming remotes
               local claimRemote = findRemote("claim") or findRemote("pet") or Remotes.ClaimPet
               if claimRemote then claimRemote:FireServer() end
               
               -- Hatch all eggs
               local hatchRemote = findRemote("hatch") or Remotes.HatchEgg
               if hatchRemote then hatchRemote:FireServer("All") end
               
               -- Equip best pets
               local equipRemote = findRemote("equip") or Remotes.EquipBestPets
               if equipRemote then equipRemote:FireServer() end
            end)
            wait(2)
         end
      end)
   end,
})

-- 2. Super Throw
local ThrowSection = MainTab:CreateSection("Super Throw")

local SuperThrowToggle = MainTab:CreateToggle({
   Name = "Super Throw (E Key)",
   CurrentValue = false,
   Callback = function(Value)
      SuperThrowEnabled = Value
   end,
})

-- 3. Collect Stars
local StarsSection = FarmTab:CreateSection("Auto Collect")

local AutoStarsToggle = FarmTab:CreateToggle({
   Name = "Collect All Stars",
   CurrentValue = false,
   Callback = function(Value)
      spawn(function()
         while Value do
            pcall(function()
               -- Collect via remote
               local starRemote = findRemote("star") or Remotes.CollectStar
               if starRemote then starRemote:FireServer() end
               
               -- Collect map objects
               for _, obj in pairs(workspace:GetChildren()) do
                  if obj.Name:lower():find("star") and obj:IsA("Part") then
                     firetouchinterest(HumanoidRootPart, obj, 0)
                     firetouchinterest(HumanoidRootPart, obj, 1)
                  end
               end
            end)
            wait(0.5)
         end
      end)
   end,
})

-- 4. Auto Rebirth
local RebirthSection = FarmTab:CreateSection("Auto Rebirth")

local AutoRebirthToggle = FarmTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(Value)
      spawn(function()
         while Value do
            pcall(function()
               local rebirthRemote = findRemote("rebirth") or Remotes.Rebirth
               if rebirthRemote then 
                  rebirthRemote:FireServer()
               end
            end)
            wait(3)
         end
      end)
   end,
})

-- Super Throw Implementation (Enhanced)
local SuperThrowEnabled = false
UserInputService.InputBegan:Connect(function(input)
   if SuperThrowEnabled and input.KeyCode == Enum.KeyCode.E then
      pcall(function()
         local closestPlayer = nil
         local closestDist = math.huge
         
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               local dist = (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
               if dist < closestDist and dist < 50 then
                  closestDist = dist
                  closestPlayer = player
               end
            end
         end
         
         if closestPlayer then
            local target = closestPlayer.Character.HumanoidRootPart
            
            -- Extreme fling force
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(4e5, 4e5, 4e5)
            bv.Velocity = HumanoidRootPart.CFrame.LookVector * 200 + Vector3.new(0, 250, 0)
            bv.Parent = target
            
            -- Additional angular velocity for spin
            local ang = Instance.new("BodyAngularVelocity")
            ang.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
            ang.AngularVelocity = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
            ang.Parent = target
            
            game.Debris:AddItem(bv, 2)
            game.Debris:AddItem(ang, 2)
            
            -- Fire throw remote if exists
            local throwRemote = findRemote("throw") or Remotes.ThrowPlayer
            if throwRemote then throwRemote:FireServer(closestPlayer) end
         end
      end)
   end
end)

-- Auto Stats (Common feature)
local StatsSection = FarmTab:CreateSection("Auto Stats")

local AutoStatsToggle = FarmTab:CreateToggle({
   Name = "Auto Buy Max Stats",
   CurrentValue = false,
   Callback = function(Value)
      spawn(function()
         while Value do
            pcall(function()
               -- Common stat upgrade pattern
               for i = 1, 10 do
                  ReplicatedStorage:FindFirstChild("UpgradeStat"):FireServer(i, 999999)
               end
            end)
            wait(1)
         end
      end)
   end,
})

-- Player Features
local SpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 1000},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      if Character:FindFirstChild("Humanoid") then
         Character.Humanoid.WalkSpeed = Value
      end
   end,
})

local JumpSlider = PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 10,
   CurrentValue = 100,
   Callback = function(Value)
      if Character:FindFirstChild("Humanoid") then
         Character.Humanoid.JumpPower = Value
      end
   end,
})

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(newChar)
   Character = newChar
   HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
   newChar.Humanoid.WalkSpeed = SpeedSlider.CurrentValue
   newChar.Humanoid.JumpPower = JumpSlider.CurrentValue
end)

-- Notifications
Rayfield:Notify({
   Title = "Yeet A Friend Hub Loaded",
   Content = "✅ Free Pets, Super Throw (E), Auto Farm, Auto Rebirth\nDynamic remote detection active",
   Duration = 6.5,
   Image = 4483362458,
})
