---loadstring(game:HttpGet("https://raw.githubusercontent.com/haryas09155-spec/harya-script/main/sharkbite2.lau"))()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
	Name = "Yeet a Friend",
	LoadingTitle = "Yeet a Friend Haryas script",
	LoadingSubtitle = "by Haryas",
	Theme = "Default",
	ToggleUIKeybind = "K",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "YeetConfig"
	},
	Discord = {
		Enabled = false,
		Invite = "",
		RememberJoins = true
	},
	KeySystem = false
})

local MainTab = Window:CreateTab("Main Hacks", 4483362458)
print("MainTab created")

MainTab:CreateSection("Auto Farm")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Toggles
local toggles = {}

-- Update character
local function getCharacter()
   return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- 1. INFINITE RUBUX/PETS
MainTab:CreateToggle({
   Name = "Infinite Rubux & Pets",
   CurrentValue = false,
   Callback = function(value)
      toggles.Infinite = value
      if value then
         spawn(function()
            while toggles.Infinite do
               for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                  if remote:IsA("RemoteEvent") then
                     local name = remote.Name:lower()
                     if name:find("rubux") or name:find("money") or name:find("pet") or name:find("claim") then
                        pcall(function() remote:FireServer(999999999) end)
                     end
                  end
               end
               wait(0.5)
            end
         end)
      end
   end,
})

-- 2. AUTO COLLECT
MainTab:CreateToggle({
   Name = "Auto Collect Stars",
   CurrentValue = false,
   Callback = function(value)
      toggles.Collect = value
      if value then
         spawn(function()
            while toggles.Collect do
               local char = getCharacter()
               local hrp = char:FindFirstChild("HumanoidRootPart")
               if hrp then
                  for _, obj in pairs(Workspace:GetChildren()) do
                     if obj:IsA("BasePart") and (obj.Name:lower():find("star") or obj.Name:lower():find("coin")) then
                        pcall(function()
                           firetouchinterest(hrp, obj, 0)
                           firetouchinterest(hrp, obj, 1)
                        end)
                     end
                  end
               end
               wait(0.3)
            end
         end)
      end
   end,
})

-- 3. AUTO REBIRTH
MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Callback = function(value)
      toggles.Rebirth = value
      if value then
         spawn(function()
            while toggles.Rebirth do
               for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                  if remote:IsA("RemoteEvent") and remote.Name:lower():find("rebirth") then
                     pcall(function() remote:FireServer() end)
                  end
               end
               wait(4)
            end
         end)
      end
   end,
})

-- 4. SUPER YEET
MainTab:CreateToggle({
   Name = "Super Yeet (E Key)",
   CurrentValue = false,
   Callback = function(value)
      toggles.Yeet = value
   end,
})

game:GetService("UserInputService").InputBegan:Connect(function(input)
   if toggles.Yeet and input.KeyCode == Enum.KeyCode.E then
      local char = getCharacter()
      local hrp = char.HumanoidRootPart
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            local target = player.Character:FindFirstChild("HumanoidRootPart")
            if target and (target.Position - hrp.Position).Magnitude < 50 then
               local bv = Instance.new("BodyVelocity")
               bv.MaxForce = Vector3.new(40000,40000,40000)
               bv.Velocity = Vector3.new(0,200,0)
               bv.Parent = target
               game:GetService("Debris"):AddItem(bv, 2)
            end
         end
      end
   end
end)

-- 5. GODMODE
MainTab:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Callback = function(value)
      local char = getCharacter()
      local hum = char:FindFirstChild("Humanoid")
      if value then
         hum.MaxHealth = math.huge
         hum.Health = math.huge
      else
         hum.MaxHealth = 100
         hum.Health = 100
      end
   end,
})

-- 6. SPEED SLIDER
MainTab:CreateSlider({
   Name = "Speed",
   Range = {16, 300},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(value)
      local char = getCharacter()
      local hum = char:FindFirstChild("Humanoid")
      hum.WalkSpeed = value
   end,
})

-- 7. YEET ALL BUTTON
MainTab:CreateButton({
   Name = "YEET EVERYONE",
   Callback = function()
      local char = getCharacter()
      local hrp = char.HumanoidRootPart
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            local target = player.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Velocity = Vector3.new(math.random(-100,100), 300, math.random(-100,100))
            bv.Parent = target
            game.Debris:AddItem(bv, 3)
         end
      end
   end,
})

-- 8. ESP
MainTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(value)
      if value then
         for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
               local esp = Instance.new("Highlight", player.Character)
               esp.FillColor = Color3.new(1,0,0)
               esp.OutlineColor = Color3.new(1,1,1)
            end
         end
      else
         for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Highlight") then obj:Destroy() end
         end
      end
   end,
})

print("Yeet A Friend script fully loaded!")

Rayfield:Notify({
   Title = "✅ SCRIPT WORKING",
   Content = "All features active!\nE = Super Yeet\nRightControl = Toggle UI",
   Duration = 5
})
